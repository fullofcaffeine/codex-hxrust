import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.protocol.json.JsonValueCodec;
import codexhx.runtime.app.RuntimeClientOutcome;
import codexhx.runtime.app.transport.FixtureLiveTransport;
import haxe.json.Value;
import sys.io.File;

class RuntimeTransportHarness {
    static function main():Void {
        final root = fixtureRoot();
        final scenarios = arrayField(root, "scenarios");
        assertEquals("3", Std.string(scenarios.length));
        for (scenario in scenarios) {
            runScenario(objectValue(scenario));
        }
    }

    static function runScenario(scenario:Value):Void {
        final transport = new FixtureLiveTransport(intField(scenario, "queueCapacity", 8));
        final actions = arrayField(scenario, "actions");
        for (actionValue in actions) {
            runAction(transport, objectValue(actionValue));
        }
        assertEquals(Std.string(intField(scenario, "expectPending", 0)), Std.string(transport.pendingCount()));
        assertEquals(boolString(boolField(scenario, "expectClosed", false)), boolString(transport.isClosed()));
    }

    static function runAction(transport:FixtureLiveTransport, action:Value):Void {
        final actionType = stringField(action, "type", "");
        switch actionType {
            case "sendRequest":
                assertOutcome(transport.sendRequest(
                    stringField(action, "requestId", ""),
                    stringField(action, "method", ""),
                    JsonValueCodec.encode(valueField(action, "params"))
                ), stringField(action, "expectCode", ""));
            case "completeResponse":
                assertOutcome(transport.completeResponse(
                    stringField(action, "requestId", ""),
                    stringField(action, "method", ""),
                    JsonValueCodec.encode(valueField(action, "result"))
                ), stringField(action, "expectCode", ""));
            case "failResponse":
                assertOutcome(transport.failResponse(
                    stringField(action, "requestId", ""),
                    stringField(action, "method", ""),
                    JsonValueCodec.encode(valueField(action, "error"))
                ), stringField(action, "expectCode", ""));
            case "cancelRequest":
                assertOutcome(transport.cancelRequest(
                    stringField(action, "requestId", ""),
                    stringField(action, "method", ""),
                    stringField(action, "reason", "")
                ), stringField(action, "expectCode", ""));
            case "notification":
                assertOutcome(transport.receiveNotification(
                    stringField(action, "method", ""),
                    JsonValueCodec.encode(valueField(action, "params"))
                ), stringField(action, "expectCode", ""));
            case "disconnect":
                assertOutcome(transport.disconnect(stringField(action, "message", "")), stringField(action, "expectCode", ""));
            case "drain":
                final drained = transport.drainEventSummaries().join("\n");
                for (needle in stringArrayField(action, "expectContains")) {
                    assertContains(drained, needle);
                }
            case _:
                throw "unsupported transport action: " + actionType;
        }
    }

    static function fixtureRoot():Value {
        return expectParse(CodexJson.parse(File.getContent("fixtures/hxrust/runtime-transport.v1.json")));
    }

    static function assertOutcome(outcome:RuntimeClientOutcome, code:String):Void {
        assertEquals(code, outcome.code);
    }

    static function valueField(object:Value, name:String):Value {
        final found = optionalField(object, name);
        return switch found {
            case JNull: throw "missing field: " + name;
            case _: found;
        }
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

    static function intField(object:Value, name:String, fallback:Int):Int {
        return switch optionalField(object, name) {
            case JNumber(value): Std.int(value);
            case JNull: fallback;
            case _: throw "expected int field: " + name;
        }
    }

    static function boolField(object:Value, name:String, fallback:Bool):Bool {
        return switch optionalField(object, name) {
            case JBool(value): value;
            case JNull: fallback;
            case _: throw "expected bool field: " + name;
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

    static function boolString(value:Bool):String {
        return value ? "true" : "false";
    }

    static function assertEquals(expected:String, actual:String):Void {
        if (expected != actual) throw "expected " + expected + " but got " + actual;
    }

    static function assertContains(haystack:String, needle:String):Void {
        if (haystack.indexOf(needle) < 0) throw "expected to find " + needle + " in " + haystack;
    }
}
