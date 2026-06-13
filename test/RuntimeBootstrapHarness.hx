import codexhx.protocol.app.AppProtocol;
import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.runtime.app.bootstrap.BootstrapCapabilities;
import codexhx.runtime.app.bootstrap.BootstrapClientInfo;
import codexhx.runtime.app.bootstrap.BootstrapConfigWarning;
import codexhx.runtime.app.bootstrap.BootstrapInitializeParams;
import codexhx.runtime.app.bootstrap.BootstrapInitializeResponse;
import codexhx.runtime.app.bootstrap.BootstrapMode;
import codexhx.runtime.app.bootstrap.BootstrapStartupMetadata;
import codexhx.runtime.app.bootstrap.CodexBootstrapSession;
import haxe.json.Value;
import sys.io.File;

class RuntimeBootstrapHarness {
    static function main():Void {
        final root = fixtureRoot();
        validBootstrapCases(root);
        invalidBootstrapCases(root);
        initializeIsNotGenericAppRequest();
    }

    static function validBootstrapCases(root:Value):Void {
        final cases = arrayField(root, "valid");
        assertEquals("2", Std.string(cases.length));
        for (caseValue in cases) {
            final outcome = bootstrapCase(caseValue);
            assertTrue(outcome.ok, "expected valid bootstrap case");
            final expect = objectField(caseValue, "expect");
            assertEquals(stringField(expect, "serverVersion", ""), outcome.report.serverVersion);
            assertEquals(stringField(expect, "summary", ""), outcome.report.summary);
            assertEquals(stringField(expect, "initializedNotification", ""), outcome.report.initializedNotificationJson);
            final contains = stringField(expect, "initializeRequestContains", "");
            if (contains.length > 0) {
                assertContains(outcome.report.initializeRequestJson, contains);
                assertContains(outcome.report.initializeRequestJson, "\"clientInfo\"");
                assertContains(outcome.report.initializeRequestJson, "\"optOutNotificationMethods\"");
            } else {
                assertEquals("", outcome.report.initializeRequestJson);
            }
            assertContains(outcome.report.initializeResponseJson, "\"codexHome\"");
            assertContains(outcome.report.startupMetadataJson, "\"model\"");
        }
    }

    static function invalidBootstrapCases(root:Value):Void {
        final cases = arrayField(root, "invalid");
        assertEquals("2", Std.string(cases.length));
        for (caseValue in cases) {
            final outcome = bootstrapCase(caseValue);
            assertFalse(outcome.ok, "expected invalid bootstrap case");
            assertEquals(stringField(caseValue, "expectCode", ""), outcome.code);
        }
    }

    static function initializeIsNotGenericAppRequest():Void {
        final parsed = CodexJson.parse("{\"id\":\"bootstrap-init-as-app-request\",\"kind\":\"request\",\"method\":\"initialize\",\"message\":{\"jsonrpc\":\"2.0\",\"id\":\"initialize\",\"method\":\"initialize\",\"params\":{\"clientInfo\":{\"name\":\"codex_vscode\",\"version\":\"0.1.0\"}}}}");
        final result = AppProtocol.parseFixtureItem(expectParse(parsed));
        assertFalse(result.ok, "initialize must remain outside generic app request parsing");
        assertEquals("unsupported_method", result.errorCode);
    }

    static function bootstrapCase(value:Value):codexhx.runtime.app.bootstrap.BootstrapValidationOutcome {
        return CodexBootstrapSession.bootstrap(
            modeField(value, "mode"),
            stringField(value, "requestId", "initialize"),
            initializeParams(value),
            initializeResponse(objectField(value, "response")),
            startupMetadata(objectField(value, "startup"))
        );
    }

    static function initializeParams(value:Value):BootstrapInitializeParams {
        return new BootstrapInitializeParams(
            clientInfo(objectField(value, "clientInfo")),
            true,
            capabilities(objectField(value, "capabilities"))
        );
    }

    static function clientInfo(value:Value):BootstrapClientInfo {
        final titleValue = optionalField(value, "title");
        return switch titleValue {
            case JString(title):
                new BootstrapClientInfo(stringField(value, "name", ""), true, title, stringField(value, "version", ""));
            case JNull:
                new BootstrapClientInfo(stringField(value, "name", ""), false, "", stringField(value, "version", ""));
            case _:
                throw "expected clientInfo.title string or null";
        }
    }

    static function capabilities(value:Value):BootstrapCapabilities {
        return new BootstrapCapabilities(
            boolField(value, "experimentalApi", false),
            boolField(value, "requestAttestation", false),
            stringArrayField(value, "optOutNotificationMethods")
        );
    }

    static function initializeResponse(value:Value):BootstrapInitializeResponse {
        return new BootstrapInitializeResponse(
            stringField(value, "userAgent", ""),
            stringField(value, "codexHome", ""),
            stringField(value, "platformFamily", ""),
            stringField(value, "platformOs", "")
        );
    }

    static function startupMetadata(value:Value):BootstrapStartupMetadata {
        final account = objectField(value, "account");
        final model = objectField(value, "model");
        final warnings:Array<BootstrapConfigWarning> = [];
        for (warning in arrayField(value, "configWarnings")) {
            final warningObject = objectValue(warning);
            warnings.push(new BootstrapConfigWarning(
                stringField(warningObject, "summary", ""),
                stringField(warningObject, "details", ""),
                stringField(warningObject, "path", "")
            ));
        }
        return new BootstrapStartupMetadata(
            nullableStringField(account, "authMode"),
            nullableStringField(account, "planType"),
            nullableStringField(account, "email"),
            stringField(model, "id", ""),
            stringField(model, "provider", ""),
            warnings
        );
    }

    static function fixtureRoot():Value {
        return expectParse(CodexJson.parse(File.getContent("fixtures/hxrust/runtime-bootstrap.v1.json")));
    }

    static function modeField(object:Value, name:String):BootstrapMode {
        return cast stringField(object, name, "");
    }

    static function objectField(object:Value, name:String):Value {
        return objectValue(valueField(object, name));
    }

    static function arrayField(object:Value, name:String):Array<Value> {
        return switch valueField(object, name) {
            case JArray(values): values;
            case _: throw "expected array field: " + name;
        }
    }

    static function stringArrayField(object:Value, name:String):Array<String> {
        final out:Array<String> = [];
        for (value in arrayField(object, name)) {
            switch value {
                case JString(text): out.push(text);
                case _: throw "expected string array field: " + name;
            }
        }
        return out;
    }

    static function stringField(object:Value, name:String, fallback:String):String {
        return switch optionalField(object, name) {
            case JString(value): value;
            case JNull: fallback;
            case _: throw "expected string field: " + name;
        }
    }

    static function nullableStringField(object:Value, name:String):String {
        return switch optionalField(object, name) {
            case JString(value): value;
            case JNull: "";
            case _: throw "expected nullable string field: " + name;
        }
    }

    static function boolField(object:Value, name:String, fallback:Bool):Bool {
        return switch optionalField(object, name) {
            case JBool(value): value;
            case JNull: fallback;
            case _: throw "expected bool field: " + name;
        }
    }

    static function valueField(object:Value, name:String):Value {
        final value = optionalField(object, name);
        return switch value {
            case JNull: throw "missing field: " + name;
            case _: value;
        }
    }

    static function optionalField(object:Value, name:String):Value {
        return switch object {
            case JObject(keys, values):
                var i = 0;
                while (i < keys.length && i < values.length) {
                    if (keys[i] == name) return values[i];
                    i = i + 1;
                }
                JNull;
            case _:
                throw "expected object while reading field: " + name;
        }
    }

    static function objectValue(value:Value):Value {
        return switch value {
            case JObject(_, _): value;
            case _: throw "expected object";
        }
    }

    static function expectParse(outcome:JsonParseOutcome):Value {
        if (!outcome.ok) throw outcome.errorCode + " at " + outcome.errorPath + ": " + outcome.errorMessage;
        return outcome.value;
    }

    static function assertEquals(expected:String, actual:String):Void {
        if (expected != actual) throw "expected " + expected + " but got " + actual;
    }

    static function assertTrue(value:Bool, message:String):Void {
        if (!value) throw message;
    }

    static function assertFalse(value:Bool, message:String):Void {
        if (value) throw message;
    }

    static function assertContains(haystack:String, needle:String):Void {
        if (haystack.indexOf(needle) < 0) throw "expected to find " + needle + " in " + haystack;
    }
}
