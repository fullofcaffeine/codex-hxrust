import codexhx.protocol.ThreadId;
import codexhx.protocol.TurnId;
import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.runtime.app.threadread.ThreadReadTurnItemsListReport;
import codexhx.runtime.app.threadread.ThreadReadTurnItemsListRequest;
import codexhx.runtime.app.threadread.ThreadReadTurnItemsListRuntime;
import haxe.json.Value;
import sys.io.File;

class ThreadReadTurnItemsListHarness {
	static function main():Void {
		final root = fixtureRoot();
		final requests = arrayField(root, "requests");
		final report = ThreadReadTurnItemsListRuntime.runCases(requestsFromFixture(requests));
		assertReport(root, report);
		assertEquals(Std.string(requests.length), Std.string(report.outcomes.length));

		var i = 0;
		while (i < requests.length) {
			final expect = objectField(objectValue(requests[i]), "expect");
			final outcome = report.outcomes[i];
			assertEquals(boolText(boolField(expect, "ok", false)), boolText(outcome.ok));
			assertEquals(stringField(expect, "code", ""), outcome.code);
			assertEquals(stringField(expect, "threadId", ""), outcome.threadId);
			assertEquals(stringField(expect, "turnId", ""), outcome.turnId);
			final needle = stringField(expect, "summaryContains", "");
			if (needle.length > 0) assertContains(outcome.summary(), needle);
			i = i + 1;
		}
	}

	static function requestsFromFixture(values:Array<Value>):Array<ThreadReadTurnItemsListRequest> {
		final out:Array<ThreadReadTurnItemsListRequest> = [];
		for (value in values) {
			final object = objectValue(value);
			out.push(new ThreadReadTurnItemsListRequest(
				ThreadId.fromString(stringField(object, "threadId", "")),
				TurnId.fromString(stringField(object, "turnId", "")),
				stringField(object, "cursor", ""),
				intField(object, "limit", -1),
				cast stringField(object, "sortDirection", "asc")
			));
		}
		return out;
	}

	static function assertReport(root:Value, report:ThreadReadTurnItemsListReport):Void {
		final expect = objectField(root, "expectReport");
		assertEquals(Std.string(intField(expect, "requestCount", 0)), Std.string(report.outcomes.length));
		assertEquals(Std.string(intField(expect, "unsupportedCount", 0)), Std.string(report.unsupportedCount()));
		assertEquals(Std.string(intField(expect, "failureCount", 0)), Std.string(report.failureCount()));
		assertContains(report.summary(), stringField(expect, "summaryContains", ""));
	}

	static function fixtureRoot():Value {
		return expectParse(CodexJson.parse(File.getContent("fixtures/hxrust/thread-read-turn-items-list-runtime.v1.json")));
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

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function assertEquals(expected:String, actual:String):Void {
		if (expected != actual) throw "expected " + expected + " but got " + actual;
	}

	static function assertContains(haystack:String, needle:String):Void {
		if (needle.length > 0 && haystack.indexOf(needle) < 0) throw "expected to find " + needle + " in " + haystack;
	}
}
