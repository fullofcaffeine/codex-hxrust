import codexhx.protocol.JsonScalar;
import codexhx.protocol.json.CodexJson;
import codexhx.tools.process.ProcessExecOutcome;
import codexhx.tools.process.ProcessExecPolicy;
import codexhx.tools.process.ProcessExecRunner;
import sys.FileSystem;
import sys.io.File;

class ProcessExecHarness {
	static inline final sandboxDir = "generated/process-exec-sandbox";
	static inline final fixturePath = "fixtures/hxrust/process-exec-output.v1.jsonl";
	static inline final reportPath = "generated/reports/process-exec.v1.jsonl";

	static function main():Void {
		resetSandbox();

		final deniedScript = sandboxDir + "/denied.sh";
		final successScript = sandboxDir + "/approved-success.sh";
		final failureScript = sandboxDir + "/approved-failure.sh";
		final truncationScript = sandboxDir + "/approved-truncation.sh";
		final deniedMarker = sandboxDir + "/denied.marker";
		final approvedMarker = sandboxDir + "/approved.marker";

		writeScript(deniedScript, "printf denied > " + deniedMarker + "\nprintf denied-ran\n");
		writeScript(successScript, "printf approved > " + approvedMarker + "\nprintf exec-ok\n");
		writeScript(failureScript, "printf fail-out\nprintf fail-err >&2\nexit 7\n");
		writeScript(truncationScript, "printf abcdef\nprintf uvwxyz >&2\n");

		final lines:Array<String> = [];

		final denied = ProcessExecRunner.run("sh", [deniedScript], ProcessExecPolicy.denyAll(80, 80));
		assertFalse(FileSystem.exists(deniedMarker), "denied command must not execute");
		lines.push(caseLine("denied_default", FileSystem.exists(deniedMarker), denied));

		final success = ProcessExecRunner.run("sh", [successScript], ProcessExecPolicy.allowExact("sh", [successScript], 80, 80));
		assertTrue(FileSystem.exists(approvedMarker), "approved command should execute in sandbox");
		lines.push(caseLine("approved_success", FileSystem.exists(approvedMarker), success));

		final failure = ProcessExecRunner.run("sh", [failureScript], ProcessExecPolicy.allowExact("sh", [failureScript], 80, 80));
		assertEquals("7", Std.string(failure.exitCode));
		assertEquals("nonzero", failure.exitStatus);
		lines.push(caseLine("approved_nonzero", false, failure));

		final truncation = ProcessExecRunner.run("sh", [truncationScript], ProcessExecPolicy.allowExact("sh", [truncationScript], 3, 3));
		assertTrue(truncation.stdout.truncated, "stdout should be truncated");
		assertTrue(truncation.stderr.truncated, "stderr should be truncated");
		lines.push(caseLine("approved_truncation", false, truncation));

		final invalid = ProcessExecRunner.run("", [], ProcessExecPolicy.denyAll(80, 80));
		lines.push(caseLine("invalid_command", false, invalid));

		final output = lines.join("\n") + "\n";
		for (line in lines) {
			final parsed = CodexJson.parse(line);
			if (!parsed.ok)
				throw parsed.errorCode + " at " + parsed.errorPath + ": " + parsed.errorMessage;
		}
		assertEquals(File.getContent(fixturePath), output);
		writeReport(output);
	}

	static function resetSandbox():Void {
		ensureDir("generated");
		ensureDir(sandboxDir);
		deleteIfExists(sandboxDir + "/denied.sh");
		deleteIfExists(sandboxDir + "/approved-success.sh");
		deleteIfExists(sandboxDir + "/approved-failure.sh");
		deleteIfExists(sandboxDir + "/approved-truncation.sh");
		deleteIfExists(sandboxDir + "/denied.marker");
		deleteIfExists(sandboxDir + "/approved.marker");
	}

	static function writeScript(path:String, body:String):Void {
		File.saveContent(path, "#!/bin/sh\n" + body);
	}

	static function caseLine(name:String, markerExists:Bool, outcome:ProcessExecOutcome):String {
		return "{\"case\":"
			+ JsonScalar.quote(name)
			+ ",\"markerExists\":"
			+ bool(markerExists)
			+ ",\"output\":"
			+ outcome.json()
			+ "}";
	}

	static function writeReport(output:String):Void {
		ensureDir("generated/reports");
		File.saveContent(reportPath, output);
	}

	static function ensureDir(path:String):Void {
		if (!FileSystem.exists(path))
			FileSystem.createDirectory(path);
	}

	static function deleteIfExists(path:String):Void {
		if (FileSystem.exists(path))
			FileSystem.deleteFile(path);
	}

	static function bool(value:Bool):String {
		if (value)
			return "true";
		return "false";
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
