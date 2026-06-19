import codexhx.adapters.cafex.CafActiveLaneEnv;
import codexhx.adapters.cafex.CafActiveLaneWriter;
import codexhx.adapters.cafex.CafNativeLiveStatus;
import codexhx.adapters.cafex.CafReceiptWriteOutcome;
import sys.FileSystem;
import sys.io.File;

class CafActiveLaneHarness {
	static inline final nativePid = 4242;
	static inline final writtenAt = "2026-06-10T00:00:05Z";

	static function main():Void {
		absentEnvSkipsActiveLaneWrite();
		writesActiveLaneFixture();
		writesActiveLaneWithoutNativeStatus();
		rejectsMismatchedPid();
		rejectsMismatchedRunIds();
	}

	static function absentEnvSkipsActiveLaneWrite():Void {
		final outcome = CafActiveLaneWriter.maybeWriteActiveLane(CafActiveLaneEnv.empty(), "conversation-missing", null, nativePid, writtenAt);
		assertSkipped(outcome, "missing_active_lane_path");
	}

	static function writesActiveLaneFixture():Void {
		final baseDir = "generated/caf-active-lane/main";
		final path = baseDir + "/nested/active-lane.json";
		resetDir(baseDir);
		final env = envFor(path, "4242", "codex-active-lane-test", "");
		final status = new CafNativeLiveStatus("gpt-5.5", "xhigh", "plan", "2026-06-10T00:00:04Z", "session_start");

		final outcome = CafActiveLaneWriter.maybeWriteActiveLane(env, "conversation-active-lane-test", status, nativePid, writtenAt);
		assertWritten(outcome, path);
		assertEquals(File.getContent("fixtures/cafex/caf-active-lane.v1.json"), File.getContent(path));
	}

	static function writesActiveLaneWithoutNativeStatus():Void {
		final baseDir = "generated/caf-active-lane/no-status";
		final path = baseDir + "/active-lane.json";
		resetDir(baseDir);
		final env = envFor(path, "4242", "", "codex-active-lane-test");

		final outcome = CafActiveLaneWriter.maybeWriteActiveLane(env, "conversation-active-lane-test", null, nativePid, writtenAt);
		assertWritten(outcome, path);
		assertEquals(File.getContent("fixtures/cafex/caf-active-lane-no-native-status.v1.json"), File.getContent(path));
	}

	static function rejectsMismatchedPid():Void {
		final baseDir = "generated/caf-active-lane/pid-mismatch";
		final path = baseDir + "/active-lane.json";
		resetDir(baseDir);
		final outcome = CafActiveLaneWriter.maybeWriteActiveLane(envFor(path, "4243", "codex-active-lane-test", ""), "conversation-active-lane-test", null,
			nativePid, writtenAt);
		assertSkipped(outcome, "owner_pid_mismatch");
		assertFalse(FileSystem.exists(path), "pid mismatch must not write active-lane truth");
	}

	static function rejectsMismatchedRunIds():Void {
		final baseDir = "generated/caf-active-lane/run-mismatch";
		final path = baseDir + "/active-lane.json";
		resetDir(baseDir);
		final outcome = CafActiveLaneWriter.maybeWriteActiveLane(envFor(path, "4242", "run-a", "run-b"), "conversation-active-lane-test", null, nativePid,
			writtenAt);
		assertSkipped(outcome, "run_id_mismatch");
		assertFalse(FileSystem.exists(path), "run id mismatch must not write active-lane truth");
	}

	static function envFor(path:String, ownerPid:String, runId:String, successorRunId:String):CafActiveLaneEnv {
		return new CafActiveLaneEnv(path, runId, successorRunId, ownerPid, "generation-active-lane-test",
			".cafetera/client/wakes/codex/codex-active-lane-test/requests", ".cafetera/client/wakes/codex/codex-active-lane-test/receipts",
			".cafetera/client/codex/pending-input.v1.json");
	}

	static function resetDir(baseDir:String):Void {
		ensureDir("generated");
		ensureDir("generated/caf-active-lane");
		ensureDir(baseDir);
		deleteIfExists(baseDir + "/active-lane.json");
		deleteIfExists(baseDir + "/nested/active-lane.json");
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
		assertTrue(outcome.ok, "active lane write should succeed");
		assertTrue(outcome.wrote, "active lane should be written");
		assertEquals(path, outcome.path);
	}

	static function assertSkipped(outcome:CafReceiptWriteOutcome, reason:String):Void {
		assertTrue(outcome.ok, "skip is a successful no-op");
		assertFalse(outcome.wrote, "active lane should not be written");
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
}
