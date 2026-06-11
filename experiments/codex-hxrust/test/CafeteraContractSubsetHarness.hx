import codexhx.adapters.cafex.CafeteraContractSubsetReport;
import codexhx.protocol.json.CodexJson;
import sys.FileSystem;
import sys.io.File;

class CafeteraContractSubsetHarness {
    static inline final reportPath = "generated/reports/cafetera-contract-subset.v1.json";
    static inline final fixturePath = "fixtures/cafex/cafetera-contract-subset-report.v1.json";

    static function main():Void {
        final report = CafeteraContractSubsetReport.reportJson();
        validatesReportShape(report);
        writeReport(report);
        assertEquals(StringTools.trim(File.getContent(fixturePath)), StringTools.trim(report));
    }

    static function validatesReportShape(report:String):Void {
        final parsed = CodexJson.parse(report);
        if (!parsed.ok) throw parsed.errorCode + " at " + parsed.errorPath + ": " + parsed.errorMessage;

        assertContains(report, "\"schema\": \"codex-hxrust.cafetera-contract-subset-report.v1\"");
        assertContains(report, "\"productionReplacement\": false");
        assertContains(report, "\"replacementClaim\": \"none\"");
        assertContains(report, "\"passed\": 4");
        assertContains(report, "\"failed\": 0");
        assertContains(report, "\"gaps\": 5");
        assertContains(report, "\"classification\": \"fixture_pass\"");
        assertContains(report, "\"classification\": \"unsupported_full_cafetera_cli\"");
        assertContains(report, "\"classification\": \"unsupported_live_tui_runtime\"");
        assertContains(report, "\"classification\": \"unsupported_native_restart_cutover\"");
        assertContains(report, "\"classification\": \"unsupported_mode_apply_runtime\"");
        assertContains(report, "\"classification\": \"unsupported_live_model_runtime\"");
    }

    static function writeReport(report:String):Void {
        ensureDir("generated");
        ensureDir("generated/reports");
        File.saveContent(reportPath, report + "\n");
    }

    static function ensureDir(path:String):Void {
        if (!FileSystem.exists(path)) FileSystem.createDirectory(path);
    }

    static function assertContains(haystack:String, needle:String):Void {
        if (haystack.indexOf(needle) < 0) throw "expected report to contain `" + needle + "`";
    }

    static function assertEquals(expected:String, actual:String):Void {
        if (expected != actual) throw "expected `" + expected + "`, got `" + actual + "`";
    }
}
