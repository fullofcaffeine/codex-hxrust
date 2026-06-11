import codexhx.config.ConfigProfile;
import codexhx.config.ConfigProfileParseOutcome;
import codexhx.config.ConfigProfileParser;
import sys.io.File;

class ConfigProfileHarness {
    static function main():Void {
        parsesFixture();
        rejectsInvalidProfileNames();
        redactsSecretDiagnostics();
    }

    static function parsesFixture():Void {
        final text = File.getContent("fixtures/hxrust/config-profile-basic.v1.json");
        final outcome = expectParse(ConfigProfileParser.parse(text));
        assertEquals("codex-hxrust.config-profile.v1", outcome.schema);
        assertEquals("dev-fast", outcome.profileName);
        assertEquals("gpt-5.2-codex", outcome.model);
        assertEquals("openai", outcome.modelProviderId);
        assertEquals("high", outcome.reasoningEffort);
        assertEquals("on-request", outcome.approvalPolicy);
        assertEquals("workspace-write", outcome.sandboxMode);
        assertTrue(outcome.webSearchEnabled, "web search should parse");
        assertFalse(outcome.imageGenerationEnabled, "image generation should parse");
        assertEquals("1", Std.string(outcome.writableRoots.length));
        assertEquals("/tmp/codex-hxrust", outcome.writableRoots[0]);
        assertEquals("2", Std.string(outcome.unsupportedFields.length));
        assertEquals("cafexJailProfile", outcome.unsupportedFields[0]);
        assertEquals("unsupportedBestEffort", outcome.unsupportedFields[1]);
    }

    static function rejectsInvalidProfileNames():Void {
        final outcome = ConfigProfileParser.parse("{\"profileName\":\"../bad\",\"model\":\"gpt-5\",\"approvalPolicy\":\"never\",\"sandboxMode\":\"read-only\"}");
        assertFalse(outcome.ok, "path-like profile name must fail");
        assertEquals("invalid_profile_name", outcome.errorCode);
    }

    static function redactsSecretDiagnostics():Void {
        final text = File.getContent("fixtures/hxrust/config-profile-basic.v1.json");
        final profile = expectParse(ConfigProfileParser.parse(text));
        final diagnostic = profile.diagnosticJson();
        assertTrue(profile.secretsPresent, "fixture should include a secret field");
        assertContains(diagnostic, "\"secretPreview\":\"[redacted]\"");
        assertContains(diagnostic, "\"unsupportedFields\":[\"cafexJailProfile\",\"unsupportedBestEffort\"]");
        assertDoesNotContain(diagnostic, "sk-test-secret");
    }

    static function expectParse(outcome:ConfigProfileParseOutcome):ConfigProfile {
        if (!outcome.ok) throw outcome.errorCode + " at " + outcome.errorPath + ": " + outcome.errorMessage;
        return outcome.profile;
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

    static function assertContains(haystack:String, needle:String):Void {
        if (haystack.indexOf(needle) < 0) throw "expected `" + haystack + "` to contain `" + needle + "`";
    }

    static function assertDoesNotContain(haystack:String, needle:String):Void {
        if (haystack.indexOf(needle) >= 0) throw "expected `" + haystack + "` not to contain `" + needle + "`";
    }
}
