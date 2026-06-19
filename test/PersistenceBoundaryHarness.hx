import codexhx.protocol.PathLikeId;
import codexhx.protocol.SessionId;
import codexhx.protocol.ThreadId;
import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.runtime.app.persistence.PersistenceBoundaryRequest;
import codexhx.runtime.app.persistence.ThreadPersistenceMetadata;
import haxe.json.Value;
import sys.io.File;

class PersistenceBoundaryHarness {
	static function main():Void {
		final root = fixtureRoot();
		final cases = arrayField(root, "cases");
		assertEquals("4", Std.string(cases.length));
		for (caseValue in cases) {
			runCase(objectValue(caseValue));
		}
	}

	static function runCase(caseValue:Value):Void {
		final request = requestFromCase(caseValue);
		final outcome = request.evaluate();
		final expect = objectField(caseValue, "expect");
		assertEquals(boolText(boolField(expect, "ok", false)), boolText(outcome.ok));
		assertEquals(stringField(expect, "code", ""), outcome.code);
		assertEquals(stringField(expect, "nativeFeatures", ""), outcome.nativeFeatureSummary());
		final summaryNeedle = stringField(expect, "summaryContains", "");
		if (summaryNeedle.length > 0)
			assertContains(outcome.summary, summaryNeedle);
	}

	static function requestFromCase(caseValue:Value):PersistenceBoundaryRequest {
		final metadata = objectField(caseValue, "metadata");
		final native = objectField(caseValue, "native");
		return new PersistenceBoundaryRequest(cast stringField(caseValue, "backend", ""),
			new ThreadPersistenceMetadata(ThreadId.fromString(stringField(metadata, "threadId", "")),
				SessionId.fromString(stringField(metadata, "sessionId", "")), PathLikeId.fromString(stringField(metadata, "rolloutPath", "")),
				intField(metadata, "historyItemCount", 0), intField(metadata, "persistedItemCount", 0), stringArrayField(metadata, "rolloutItemKinds"),
				boolField(metadata, "includeHistory", false), boolField(metadata, "archived", false), boolField(metadata, "goalStateRequested", false)),
			boolField(native, "stateDb", false), boolField(native, "logDb", false), boolField(native, "reconcileRollout", false),
			boolField(native, "persistThread", false));
	}

	static function fixtureRoot():Value {
		return expectParse(CodexJson.parse(File.getContent("fixtures/hxrust/persistence-boundary.v1.json")));
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
				case JString(text):
					out.push(text);
				case _:
					throw "expected string array field";
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
					if (keys[i] == name)
						return values[i];
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
		if (!outcome.ok)
			throw outcome.errorCode + " at " + outcome.errorPath + ": " + outcome.errorMessage;
		return outcome.value;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function assertEquals(expected:String, actual:String):Void {
		if (expected != actual)
			throw "expected " + expected + " but got " + actual;
	}

	static function assertContains(haystack:String, needle:String):Void {
		if (haystack.indexOf(needle) < 0)
			throw "expected to find " + needle + " in " + haystack;
	}
}
