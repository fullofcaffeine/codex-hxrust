import codexhx.adapters.cafex.CafBridgeProcessOutcome;
import codexhx.adapters.cafex.CafBridgeProcessor;
import sys.FileSystem;
import sys.io.File;

class CafBridgeHarness {
    static inline final writtenAt = "2026-06-10T00:00:02Z";

    static function main():Void {
        missingRequestDirectoryIsNoop();
        consumesBridgeFixtures();
        rejectsInvalidReceiptDirectory();
    }

    static function missingRequestDirectoryIsNoop():Void {
        final outcome = CafBridgeProcessor.processOnce("generated/cafex-bridge/missing", "generated/cafex-bridge/missing-receipts", writtenAt);
        assertOutcome(outcome, true, 0, 0);
    }

    static function consumesBridgeFixtures():Void {
        final baseDir = "generated/cafex-bridge/main";
        final requestsDir = baseDir + "/requests";
        final receiptsDir = baseDir + "/receipts";
        resetDir(baseDir);
        ensureDir(requestsDir);

        copyFixture("caf-effort-request.v1.json", requestsDir + "/effort-1.json");
        copyFixture("caf-effort-invalid-request.v1.json", requestsDir + "/effort-invalid.json");
        copyFixture("caf-wake-request.v1.json", requestsDir + "/wake-1.json");
        copyFixture("caf-mode-unsupported-request.v1.json", requestsDir + "/mode-unsupported.json");
        copyFixture("caf-goal-apply-request.v1.json", requestsDir + "/goal-1.json");
        copyFixture("caf-goal-clear-request.v1.json", requestsDir + "/goal-clear.json");
        copyFixture("caf-goal-invalid-request.v1.json", requestsDir + "/goal-invalid.json");
        copyFixture("caf-queue-reconcile-request.v1.json", requestsDir + "/queue-reconcile-1.json");
        File.saveContent(requestsDir + "/ignored.json", "{\n  \"schema\": \"caf-client-session.v1\",\n  \"requestId\": \"ignored\"\n}\n");

        final first = CafBridgeProcessor.processOnce(requestsDir, receiptsDir, writtenAt);
        assertOutcome(first, true, 8, 1);
        assertReceipt("caf-effort-receipt.v1.json", receiptsDir + "/effort-1.json");
        assertReceipt("caf-effort-invalid-receipt.v1.json", receiptsDir + "/effort-invalid.json");
        assertReceipt("caf-wake-receipt.v1.json", receiptsDir + "/wake-1.json");
        assertReceipt("caf-mode-unsupported-receipt.v1.json", receiptsDir + "/mode-unsupported.json");
        assertReceipt("caf-goal-apply-receipt.v1.json", receiptsDir + "/goal-1.json");
        assertReceipt("caf-goal-clear-receipt.v1.json", receiptsDir + "/goal-clear.json");
        assertReceipt("caf-goal-invalid-receipt.v1.json", receiptsDir + "/goal-invalid.json");
        assertReceipt("caf-queue-reconcile-receipt.v1.json", receiptsDir + "/queue-reconcile-1.json");
        assertFalse(FileSystem.exists(receiptsDir + "/ignored.json"), "unknown Caf schema should not write a receipt");

        final second = CafBridgeProcessor.processOnce(requestsDir, receiptsDir, writtenAt);
        assertOutcome(second, true, 0, 9);
        assertReceipt("caf-effort-receipt.v1.json", receiptsDir + "/effort-1.json");
    }

    static function rejectsInvalidReceiptDirectory():Void {
        final baseDir = "generated/cafex-bridge/not-directory";
        resetDir(baseDir);
        ensureDir(baseDir + "/requests");
        if (FileSystem.exists(baseDir + "/receipts")) {
            FileSystem.deleteDirectory(baseDir + "/receipts");
        }
        File.saveContent(baseDir + "/receipts", "not a directory");
        copyFixture("caf-effort-request.v1.json", baseDir + "/requests/effort-1.json");

        final outcome = CafBridgeProcessor.processOnce(baseDir + "/requests", baseDir + "/receipts", writtenAt);
        assertFalse(outcome.ok, "receipt directory file should fail");
        assertEquals("receipt_write_failed", outcome.errorCode);
    }

    static function copyFixture(name:String, target:String):Void {
        File.saveContent(target, File.getContent("fixtures/cafex/" + name));
    }

    static function assertReceipt(fixture:String, actualPath:String):Void {
        assertTrue(FileSystem.exists(actualPath), actualPath + " should exist");
        assertEquals(File.getContent("fixtures/cafex/" + fixture), File.getContent(actualPath));
    }

    static function resetDir(baseDir:String):Void {
        ensureDir("generated");
        ensureDir("generated/cafex-bridge");
        ensureDir(baseDir);
        deleteIfExists(baseDir + "/receipts");
        ensureDir(baseDir + "/requests");
        ensureDir(baseDir + "/receipts");
        deleteIfExists(baseDir + "/requests/effort-1.json");
        deleteIfExists(baseDir + "/requests/effort-invalid.json");
        deleteIfExists(baseDir + "/requests/wake-1.json");
        deleteIfExists(baseDir + "/requests/mode-unsupported.json");
        deleteIfExists(baseDir + "/requests/goal-1.json");
        deleteIfExists(baseDir + "/requests/goal-clear.json");
        deleteIfExists(baseDir + "/requests/goal-invalid.json");
        deleteIfExists(baseDir + "/requests/queue-reconcile-1.json");
        deleteIfExists(baseDir + "/requests/ignored.json");
        deleteIfExists(baseDir + "/receipts/effort-1.json");
        deleteIfExists(baseDir + "/receipts/effort-invalid.json");
        deleteIfExists(baseDir + "/receipts/wake-1.json");
        deleteIfExists(baseDir + "/receipts/mode-unsupported.json");
        deleteIfExists(baseDir + "/receipts/goal-1.json");
        deleteIfExists(baseDir + "/receipts/goal-clear.json");
        deleteIfExists(baseDir + "/receipts/goal-invalid.json");
        deleteIfExists(baseDir + "/receipts/queue-reconcile-1.json");
        deleteIfExists(baseDir + "/receipts/ignored.json");
    }

    static function ensureDir(path:String):Void {
        if (!FileSystem.exists(path)) FileSystem.createDirectory(path);
    }

    static function deleteIfExists(path:String):Void {
        if (FileSystem.exists(path) && !FileSystem.isDirectory(path)) FileSystem.deleteFile(path);
    }

    static function assertOutcome(outcome:CafBridgeProcessOutcome, ok:Bool, processed:Int, skipped:Int):Void {
        assertEquals(ok ? "true" : "false", outcome.ok ? "true" : "false");
        assertEquals(Std.string(processed), Std.string(outcome.processed));
        assertEquals(Std.string(skipped), Std.string(outcome.skipped));
    }

    static function assertEquals(expected:String, actual:String):Void {
        if (expected != actual) throw "expected `" + expected + "`, got `" + actual + "`";
    }

    static function assertTrue(value:Bool, message:String):Void {
        if (!value) throw message;
    }

    static function assertFalse(value:Bool, message:String):Void {
        if (value) throw message;
    }
}
