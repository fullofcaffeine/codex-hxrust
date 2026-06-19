import codexhx.adapters.cafex.CafReceiptEnv;
import codexhx.adapters.cafex.CafReceiptWriteOutcome;
import codexhx.adapters.cafex.CafReceiptWriter;
import sys.FileSystem;
import sys.io.File;

class CafReceiptHarness {
	static function main():Void {
		absentEnvSkipsReceiptWrites();
		writesSessionReceiptFixture();
		writesTurnReceiptFixture();
		overwritesDuplicateReceiptPath();
		rejectsUnsupportedSessionSource();
	}

	static function absentEnvSkipsReceiptWrites():Void {
		final baseDir = "generated/cafex-receipts/absent";
		resetDir(baseDir);
		final env = new CafReceiptEnv(baseDir + "/session.json", baseDir + "/turn.json", "", "");

		final session = CafReceiptWriter.maybeWriteSessionReceipt(env, "session-absent", "resume", "2026-06-10T00:00:00Z");
		assertSkipped(session, "missing_successor_run_id");
		assertFalse(FileSystem.exists(baseDir + "/session.json"), "session receipt should not be written without run id");

		final noPath = CafReceiptWriter.maybeWriteTurnReceipt(CafReceiptEnv.empty(), "session-absent", "turn-absent", "startup", "2026-06-10T00:00:00Z");
		assertSkipped(noPath, "missing_turn_receipt_path");
	}

	static function writesSessionReceiptFixture():Void {
		final baseDir = "generated/cafex-receipts/session";
		resetDir(baseDir);
		final path = baseDir + "/nested/session.json";
		final env = new CafReceiptEnv(path, "", "codex-session-ready-test", "session-predecessor-1");
		final written = CafReceiptWriter.maybeWriteSessionReceipt(env, "session-resumed-1", "resume", "2026-06-10T00:00:00Z");
		assertWritten(written, path);
		assertEquals(File.getContent("fixtures/cafex/caf-session-receipt-resume.v1.json"), File.getContent(path));
	}

	static function writesTurnReceiptFixture():Void {
		final baseDir = "generated/cafex-receipts/turn";
		resetDir(baseDir);
		final path = baseDir + "/nested/turn.json";
		final env = new CafReceiptEnv("", path, "codex-turn-start-test", "");
		final written = CafReceiptWriter.maybeWriteTurnReceipt(env, "session-fresh-1", "turn-1", "startup", "2026-06-10T00:00:01Z");
		assertWritten(written, path);
		assertEquals(File.getContent("fixtures/cafex/caf-turn-receipt-startup.v1.json"), File.getContent(path));
	}

	static function overwritesDuplicateReceiptPath():Void {
		final baseDir = "generated/cafex-receipts/duplicate";
		resetDir(baseDir);
		final path = baseDir + "/session.json";
		final env = new CafReceiptEnv(path, "", "codex-duplicate-test", "");
		assertWritten(CafReceiptWriter.maybeWriteSessionReceipt(env, "session-duplicate", "startup", "2026-06-10T00:00:02Z"), path);
		assertWritten(CafReceiptWriter.maybeWriteSessionReceipt(env, "session-duplicate", "startup", "2026-06-10T00:00:03Z"), path);
		final content = File.getContent(path);
		assertContains(content, "\"writtenAt\": \"2026-06-10T00:00:03Z\"");
		assertNotContains(content, "2026-06-10T00:00:02Z");
	}

	static function rejectsUnsupportedSessionSource():Void {
		final env = new CafReceiptEnv("generated/cafex-receipts/bad/session.json", "", "codex-bad-source", "");
		final outcome = CafReceiptWriter.maybeWriteSessionReceipt(env, "session-bad", "fork", "2026-06-10T00:00:00Z");
		assertFalse(outcome.ok, "unsupported source should fail");
		assertEquals("unsupported_session_source", outcome.errorCode);
	}

	static function resetDir(baseDir:String):Void {
		ensureDir("generated");
		ensureDir("generated/cafex-receipts");
		ensureDir(baseDir);
		deleteIfExists(baseDir + "/session.json");
		deleteIfExists(baseDir + "/turn.json");
		deleteIfExists(baseDir + "/nested/session.json");
		deleteIfExists(baseDir + "/nested/turn.json");
		if (FileSystem.exists(baseDir + "/nested")) {
			FileSystem.deleteDirectory(baseDir + "/nested");
		}
	}

	static function ensureDir(path:String):Void {
		if (!FileSystem.exists(path))
			FileSystem.createDirectory(path);
	}

	static function deleteIfExists(path:String):Void {
		if (FileSystem.exists(path))
			FileSystem.deleteFile(path);
	}

	static function assertWritten(outcome:CafReceiptWriteOutcome, path:String):Void {
		assertTrue(outcome.ok, "receipt write should succeed");
		assertTrue(outcome.wrote, "receipt should be written");
		assertEquals(path, outcome.path);
	}

	static function assertSkipped(outcome:CafReceiptWriteOutcome, reason:String):Void {
		assertTrue(outcome.ok, "skip is a successful no-op");
		assertFalse(outcome.wrote, "receipt should not be written");
		assertEquals(reason, outcome.skippedReason);
	}

	static function assertEquals(expected:String, actual:String):Void {
		if (expected != actual)
			throw "expected `" + expected + "`, got `" + actual + "`";
	}

	static function assertTrue(value:Bool, message:String):Void {
		if (!value)
			throw message;
	}

	static function assertFalse(value:Bool, message:String):Void {
		if (value)
			throw message;
	}

	static function assertContains(haystack:String, needle:String):Void {
		if (haystack.indexOf(needle) < 0)
			throw "expected `" + haystack + "` to contain `" + needle + "`";
	}

	static function assertNotContains(haystack:String, needle:String):Void {
		if (haystack.indexOf(needle) >= 0)
			throw "expected `" + haystack + "` not to contain `" + needle + "`";
	}
}
