import codexhx.diagnostics.DiagnosticFailureReport;
import codexhx.diagnostics.DiagnosticField;
import codexhx.diagnostics.DiagnosticLogEvent;
import codexhx.diagnostics.DiagnosticRedactor;
import codexhx.protocol.JsonScalar;
import codexhx.protocol.json.CodexJson;
import sys.FileSystem;
import sys.io.File;

class DiagnosticsHarness {
	static inline final fixturePath = "fixtures/hxrust/diagnostics-output.v1.jsonl";
	static inline final reportPath = "generated/reports/diagnostics.v1.jsonl";

	static function main():Void {
		final redactor = new DiagnosticRedactor(["openaiApiKey", "token"]);
		final lines:Array<String> = [];

		final log = new DiagnosticLogEvent("warn", "provider_config_loaded", "fixtures/hxrust/config-profile-basic.v1.json", [
			new DiagnosticField("model", "gpt-5.2-codex"),
			new DiagnosticField("openaiApiKey", "sk-test-secret"),
			new DiagnosticField("token", "token-secret"),
			new DiagnosticField("requestId", "req-diagnostics-1")
		]).json(redactor);
		assertDoesNotContain(log, "sk-test-secret");
		assertDoesNotContain(log, "token-secret");
		assertContains(log, "\"fixtureId\":\"fixtures/hxrust/config-profile-basic.v1.json\"");
		lines.push(caseLine("redacted_log", log));

		final failure = new DiagnosticFailureReport("failure-diagnostics-1", "process_exit_nonzero", "process exited with non-zero status", [
			"fixtures/hxrust/process-exec-output.v1.jsonl",
			"fixtures/hxrust/sandbox-gate-output.v1.jsonl"
		], true).json();
		assertContains(failure, "\"fixtureIds\":[\"fixtures/hxrust/process-exec-output.v1.jsonl\",\"fixtures/hxrust/sandbox-gate-output.v1.jsonl\"]");
		lines.push(caseLine("failure_report", failure));

		final output = lines.join("\n") + "\n";
		for (line in lines) {
			final parsed = CodexJson.parse(line);
			if (!parsed.ok)
				throw parsed.errorCode + " at " + parsed.errorPath + ": " + parsed.errorMessage;
		}
		assertEquals(File.getContent(fixturePath), output);
		writeReport(output);
	}

	static function caseLine(name:String, outputJson:String):String {
		return "{\"case\":" + JsonScalar.quote(name) + ",\"output\":" + outputJson + "}";
	}

	static function writeReport(output:String):Void {
		ensureDir("generated");
		ensureDir("generated/reports");
		File.saveContent(reportPath, output);
	}

	static function ensureDir(path:String):Void {
		if (!FileSystem.exists(path))
			FileSystem.createDirectory(path);
	}

	static function assertEquals(expected:String, actual:String):Void {
		if (expected != actual)
			throw "expected `" + expected + "`, got `" + actual + "`";
	}

	static function assertContains(haystack:String, needle:String):Void {
		if (haystack.indexOf(needle) < 0)
			throw "expected `" + haystack + "` to contain `" + needle + "`";
	}

	static function assertDoesNotContain(haystack:String, needle:String):Void {
		if (haystack.indexOf(needle) >= 0)
			throw "expected `" + haystack + "` not to contain `" + needle + "`";
	}
}
