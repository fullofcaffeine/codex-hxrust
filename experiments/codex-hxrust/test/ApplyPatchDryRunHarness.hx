import codexhx.protocol.JsonScalar;
import codexhx.protocol.json.CodexJson;
import codexhx.tools.patch.ApplyPatchDryRun;
import sys.FileSystem;
import sys.io.File;

class ApplyPatchDryRunHarness {
    static inline final fixturePath = "fixtures/hxrust/apply-patch-dry-run-output.v1.jsonl";
    static inline final reportPath = "generated/reports/apply-patch-dry-run.v1.jsonl";

    static function main():Void {
        final validPatch = File.getContent("fixtures/hxrust/apply-patch-dry-run-input.v1.patch");
        final lines:Array<String> = [];
        lines.push(caseLine("valid_dry_run", ApplyPatchDryRun.run(validPatch, false).json()));
        lines.push(caseLine("mutation_disabled", ApplyPatchDryRun.run(validPatch, true).json()));
        lines.push(caseLine("invalid_header", ApplyPatchDryRun.run("*** Add File: x\n+bad\n*** End Patch\n", false).json()));
        lines.push(caseLine("unsafe_path", ApplyPatchDryRun.run("*** Begin Patch\n*** Add File: ../escape.txt\n+bad\n*** End Patch\n", false).json()));

        final output = lines.join("\n") + "\n";
        for (line in lines) {
            final parsed = CodexJson.parse(line);
            if (!parsed.ok) throw parsed.errorCode + " at " + parsed.errorPath + ": " + parsed.errorMessage;
        }
        assertEquals(File.getContent(fixturePath), output);
        writeReport(output);
    }

    static function caseLine(name:String, outputJson:String):String {
        final parsed = CodexJson.parse(outputJson);
        if (!parsed.ok) throw parsed.errorCode + " at " + parsed.errorPath + ": " + parsed.errorMessage;
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
