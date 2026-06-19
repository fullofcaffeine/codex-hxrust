import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.runtime.app.threadread.ThreadReadActiveTurnMergeReport;
import codexhx.runtime.app.threadread.ThreadReadActiveTurnMergeRequest;
import codexhx.runtime.app.threadread.ThreadReadActiveTurnMerger;
import codexhx.runtime.app.threadread.ThreadReadTurnItemSummary;
import codexhx.runtime.app.threadread.ThreadReadTurnSummary;
import haxe.json.Value;
import sys.io.File;

class ThreadReadActiveTurnMergeHarness {
	static function main():Void {
		final root = fixtureRoot();
		final baseTurns = turnsFromFixture(arrayField(root, "baseTurns"));
		final cases = arrayField(root, "cases");
		final report = ThreadReadActiveTurnMerger.mergeCases(baseTurns, requestsFromFixture(cases));
		assertReport(root, report);
		assertEquals(Std.string(cases.length), Std.string(report.outcomes.length));

		var i = 0;
		while (i < cases.length) {
			final expect = objectField(objectValue(cases[i]), "expect");
			final outcome = report.outcomes[i];
			assertEquals(boolText(boolField(expect, "ok", false)), boolText(outcome.ok));
			assertEquals(stringField(expect, "code", ""), outcome.code);
			assertEquals(stringField(expect, "threadStatus", ""), outcome.threadStatus);
			assertEquals(Std.string(intField(expect, "turnCount", 0)), Std.string(outcome.turns.length));
			final needle = stringField(expect, "summaryContains", "");
			if (needle.length > 0)
				assertContains(outcome.summary(), needle);
			i = i + 1;
		}
	}

	static function requestsFromFixture(values:Array<Value>):Array<ThreadReadActiveTurnMergeRequest> {
		final out:Array<ThreadReadActiveTurnMergeRequest> = [];
		for (value in values) {
			final object = objectValue(value);
			final activeTurnValue = optionalField(object, "activeTurn");
			final activeTurn = switch activeTurnValue {
				case JObject(_, _): turnFromFixture(activeTurnValue);
				case JNull: null;
				case _: throw "expected activeTurn object or null";
			}
			out.push(new ThreadReadActiveTurnMergeRequest(cast stringField(object, "loadedStatus", ""), boolField(object, "hasLiveRunningThread", false),
				activeTurn));
		}
		return out;
	}

	static function turnsFromFixture(values:Array<Value>):Array<ThreadReadTurnSummary> {
		final out:Array<ThreadReadTurnSummary> = [];
		for (value in values) {
			out.push(turnFromFixture(value));
		}
		return out;
	}

	static function turnFromFixture(value:Value):ThreadReadTurnSummary {
		final object = objectValue(value);
		final items:Array<ThreadReadTurnItemSummary> = [];
		for (itemValue in arrayField(object, "items")) {
			final item = objectValue(itemValue);
			items.push(new ThreadReadTurnItemSummary(cast stringField(item, "kind", ""), stringField(item, "text", "")));
		}
		return new ThreadReadTurnSummary(stringField(object, "id", ""), cast stringField(object, "status", ""), items);
	}

	static function assertReport(root:Value, report:ThreadReadActiveTurnMergeReport):Void {
		final expect = objectField(root, "expectReport");
		assertEquals(Std.string(intField(expect, "caseCount", 0)), Std.string(report.outcomes.length));
		assertEquals(Std.string(intField(expect, "okCount", 0)), Std.string(report.okCount()));
		assertEquals(Std.string(intField(expect, "failureCount", 0)), Std.string(report.failureCount()));
		assertContains(report.summary(), stringField(expect, "summaryContains", ""));
	}

	static function fixtureRoot():Value {
		return expectParse(CodexJson.parse(File.getContent("fixtures/hxrust/thread-read-active-turn-merge.v1.json")));
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
			case JNull: throw "missing field";
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
		if (needle.length > 0 && haystack.indexOf(needle) < 0)
			throw "expected to find " + needle + " in " + haystack;
	}
}
