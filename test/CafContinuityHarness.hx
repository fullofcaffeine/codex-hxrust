import codexhx.adapters.cafex.CafContinuityEnv;
import codexhx.adapters.cafex.CafContinuityEnvParseOutcome;
import codexhx.adapters.cafex.CafReceiptWriteOutcome;
import codexhx.adapters.cafex.CafReceiptWriter;
import sys.FileSystem;
import sys.io.File;

class CafContinuityHarness {
	static function main():Void {
		parsesResumeMetadata();
		parsesFreshMetadata();
		writesReceiptsFromParsedMetadata();
		rejectsInvalidMetadata();
	}

	static function parsesResumeMetadata():Void {
		final parsed = expectMetadata(CafContinuityEnv.parse("generated/cafex-continuity/resume/session.json", "generated/cafex-continuity/resume/turn.json",
			" codex-restart-successor-1 ", " session-predecessor-1 "));
		assertEquals(StringTools.trim(File.getContent("fixtures/cafex/caf-continuity-metadata-resume.v1.json")), parsed.metadataJson());
	}

	static function parsesFreshMetadata():Void {
		final parsed = expectMetadata(CafContinuityEnv.parse("generated/cafex-continuity/fresh/session.json", "generated/cafex-continuity/fresh/turn.json",
			"codex-restart-successor-2", ""));
		assertEquals(StringTools.trim(File.getContent("fixtures/cafex/caf-continuity-metadata-fresh.v1.json")), parsed.metadataJson());
	}

	static function writesReceiptsFromParsedMetadata():Void {
		final resumeDir = "generated/cafex-continuity/resume";
		final freshDir = "generated/cafex-continuity/fresh";
		resetDir(resumeDir);
		resetDir(freshDir);

		final resume = expectMetadata(CafContinuityEnv.parse(resumeDir + "/session.json", resumeDir + "/turn.json", "codex-restart-successor-1",
			"session-predecessor-1"));
		final sessionWrite = CafReceiptWriter.maybeWriteSessionReceipt(resume.toReceiptEnv(), "session-resumed-continuity", resume.receiptSource,
			"2026-06-10T00:00:04Z");
		assertWritten(sessionWrite, resumeDir + "/session.json");
		assertEquals(File.getContent("fixtures/cafex/caf-continuity-session-receipt.v1.json"), File.getContent(resumeDir + "/session.json"));

		final fresh = expectMetadata(CafContinuityEnv.parse(freshDir + "/session.json", freshDir + "/turn.json", "codex-restart-successor-2", ""));
		final turnWrite = CafReceiptWriter.maybeWriteTurnReceipt(fresh.toReceiptEnv(), "session-fresh-continuity", "turn-continuity-1", fresh.receiptSource,
			"2026-06-10T00:00:05Z");
		assertWritten(turnWrite, freshDir + "/turn.json");
		assertEquals(File.getContent("fixtures/cafex/caf-continuity-turn-receipt-fresh.v1.json"), File.getContent(freshDir + "/turn.json"));
	}

	static function rejectsInvalidMetadata():Void {
		assertRejected(CafContinuityEnv.parse("", "", "", ""), "missing_successor_run_id");
		assertRejected(CafContinuityEnv.parse("", "", "bad/run", ""), "invalid_successor_run_id");
		assertRejected(CafContinuityEnv.parse("", "", "codex-restart-successor-1", "bad predecessor"), "invalid_predecessor_session_id");
	}

	static function resetDir(path:String):Void {
		ensureDir("generated");
		ensureDir("generated/cafex-continuity");
		ensureDir(path);
		deleteIfExists(path + "/session.json");
		deleteIfExists(path + "/turn.json");
	}

	static function ensureDir(path:String):Void {
		if (!FileSystem.exists(path))
			FileSystem.createDirectory(path);
	}

	static function deleteIfExists(path:String):Void {
		if (FileSystem.exists(path))
			FileSystem.deleteFile(path);
	}

	static function expectMetadata(outcome:CafContinuityEnvParseOutcome):CafContinuityEnv {
		if (!outcome.ok)
			throw outcome.errorCode + ": " + outcome.errorMessage;
		return outcome.metadata;
	}

	static function assertRejected(outcome:CafContinuityEnvParseOutcome, errorCode:String):Void {
		assertFalse(outcome.ok, "metadata should be rejected");
		assertEquals(errorCode, outcome.errorCode);
	}

	static function assertWritten(outcome:CafReceiptWriteOutcome, path:String):Void {
		assertTrue(outcome.ok, "receipt write should succeed");
		assertTrue(outcome.wrote, "receipt should be written");
		assertEquals(path, outcome.path);
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
}
