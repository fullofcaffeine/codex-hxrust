import codexhx.protocol.JsonScalar;
import codexhx.protocol.json.CodexJson;
import codexhx.tools.sandbox.SandboxGateRequest;
import codexhx.tools.sandbox.SandboxPermissionGate;
import sys.FileSystem;
import sys.io.File;

class SandboxGateHarness {
    static inline final fixturePath = "fixtures/hxrust/sandbox-gate-output.v1.jsonl";
    static inline final reportPath = "generated/reports/sandbox-gate.v1.jsonl";

    static function main():Void {
        final lines:Array<String> = [];
        lines.push(caseLine("unsupported_platform", decision("linux", "read-only", "read", "src/Main.hx", false)));
        lines.push(caseLine("read_allowed", decision("fixture-posix", "read-only", "read", "src/Main.hx", false)));
        lines.push(caseLine("workspace_write_allowed", decision("fixture-posix", "workspace-write", "workspace-write", "generated/report.json", false)));
        lines.push(caseLine("read_only_write_denied", decision("fixture-posix", "read-only", "workspace-write", "generated/report.json", false)));
        lines.push(caseLine("exec_delegated_denied", decision("fixture-posix", "workspace-write", "exec", "tools/run.sh", false)));
        lines.push(caseLine("network_denied", decision("fixture-posix", "workspace-write", "network", "api.openai.com", false)));
        lines.push(caseLine("danger_full_access_denied", decision("fixture-posix", "danger-full-access", "read", "src/Main.hx", false)));
        lines.push(caseLine("external_sandbox_unverified", decision("fixture-posix", "external-sandbox", "read", "src/Main.hx", false)));
        lines.push(caseLine("bypass_denied", decision("fixture-posix", "workspace-write", "read", "src/Main.hx", true)));
        lines.push(caseLine("unsafe_path_denied", decision("fixture-posix", "workspace-write", "read", "../escape", false)));

        final output = lines.join("\n") + "\n";
        for (line in lines) {
            final parsed = CodexJson.parse(line);
            if (!parsed.ok) throw parsed.errorCode + " at " + parsed.errorPath + ": " + parsed.errorMessage;
        }
        assertEquals(File.getContent(fixturePath), output);
        writeReport(output);
    }

    static function decision(platform:String, mode:String, operation:String, path:String, bypass:Bool):String {
        return SandboxPermissionGate.decide(new SandboxGateRequest(platform, mode, operation, path, bypass)).json();
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
        if (!FileSystem.exists(path)) FileSystem.createDirectory(path);
    }

    static function assertEquals(expected:String, actual:String):Void {
        if (expected != actual) throw "expected `" + expected + "`, got `" + actual + "`";
    }
}
