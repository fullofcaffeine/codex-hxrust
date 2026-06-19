import codexhx.protocol.goals.ThreadGoal;
import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.runtime.app.threadread.ThreadReadActiveTurnGoalSteeringInjectionPolicy;
import codexhx.runtime.app.threadread.ThreadReadActiveTurnGoalSteeringInjectionReport;
import codexhx.runtime.app.threadread.ThreadReadActiveTurnGoalSteeringInjectionRequest;
import codexhx.runtime.app.threadread.ThreadReadGoalSteeringBuilder;
import codexhx.runtime.app.threadread.ThreadReadGoalSteeringItemKind;
import codexhx.runtime.app.threadread.ThreadReadGoalSteeringOutcome;
import codexhx.runtime.app.threadread.ThreadReadGoalSteeringRequest;
import codexhx.runtime.app.threadread.ThreadReadResumeIdleContinuationOutcome;
import haxe.json.Value;
import sys.io.File;

class ThreadReadActiveTurnGoalSteeringInjectionHarness {
	static function main():Void {
		final root = fixtureRoot();
		final cases = arrayField(root, "cases");
		final report = ThreadReadActiveTurnGoalSteeringInjectionPolicy.buildCases(requests(cases));
		assertReport(root, report);
		assertEquals(Std.string(cases.length), Std.string(report.outcomes.length));

		var i = 0;
		while (i < cases.length) {
			final expect = objectField(objectValue(cases[i]), "expect");
			final outcome = report.outcomes[i];
			assertEquals(boolText(boolField(expect, "ok", false)), boolText(outcome.ok));
			assertEquals(stringField(expect, "code", ""), outcome.code);
			assertEquals(boolText(boolField(expect, "injected", false)), boolText(outcome.injected));
			assertEquals(boolText(boolField(expect, "skipped", false)), boolText(outcome.skipped));
			assertEquals(boolText(boolField(expect, "threadLookupAttempted", false)), boolText(outcome.threadLookupAttempted));
			assertEquals(boolText(boolField(expect, "injectIfRunningAttempted", false)), boolText(outcome.injectIfRunningAttempted));
			assertEquals(boolText(boolField(expect, "activeTurnRunning", false)), boolText(outcome.activeTurnRunning));
			assertEquals(boolText(boolField(expect, "pendingInputExtended", false)), boolText(outcome.pendingInputExtended));
			assertEquals(boolText(boolField(expect, "returnedItemUnchanged", false)), boolText(outcome.returnedItemUnchanged));
			assertEquals(boolText(boolField(expect, "injectedItemUnchanged", false)), boolText(outcome.injectedItemUnchanged));
			assertContains(outcome.itemSummary, stringField(expect, "itemSummaryContains", ""));
			assertContains(outcome.summary(), stringField(expect, "summaryContains", ""));
			i = i + 1;
		}
	}

	static function requests(values:Array<Value>):Array<ThreadReadActiveTurnGoalSteeringInjectionRequest> {
		final out:Array<ThreadReadActiveTurnGoalSteeringInjectionRequest> = [];
		for (value in values) {
			final caseObject = objectValue(value);
			final host = objectField(caseObject, "host");
			out.push(new ThreadReadActiveTurnGoalSteeringInjectionRequest(steeringOutcome(objectField(caseObject, "steering")),
				boolField(host, "threadManagerAvailable", false), boolField(host, "liveThreadAvailable", false), boolField(host, "activeTurnRunning", false)));
		}
		return out;
	}

	static function steeringOutcome(value:Value):ThreadReadGoalSteeringOutcome {
		final kind:ThreadReadGoalSteeringItemKind = cast stringField(value, "kind", "");
		return ThreadReadGoalSteeringBuilder.build(new ThreadReadGoalSteeringRequest(kind,
			goal(optionalStringField(value, "goalStatus"), stringField(value, "goalVariant", "")), continuationOutcome(),
			boolField(value, "objectiveChanged", false)));
	}

	static function continuationOutcome():ThreadReadResumeIdleContinuationOutcome {
		return null;
	}

	static function goal(status:String, variant:String):ThreadGoal {
		if (status.length == 0 || variant == "missing")
			return null;
		if (variant == "budgeted_escaped") {
			return new ThreadGoal(threadId(), "Ship <Codex> & keep quality", status, true, 5000, 1200, 300, 200000, 200100);
		}
		if (variant == "unbounded") {
			return new ThreadGoal(threadId(), "Keep polishing", status, false, 0, 1200, 300, 200000, 200100);
		}
		return new ThreadGoal(threadId(), "Keep polishing", status, true, 5000, 1200, 300, 200000, 200100);
	}

	static function threadId():String {
		return "01890f3d-8f3a-7a9b-9f0d-000000001029";
	}

	static function assertReport(root:Value, report:ThreadReadActiveTurnGoalSteeringInjectionReport):Void {
		final expect = objectField(root, "expectReport");
		assertEquals(Std.string(intField(expect, "caseCount", 0)), Std.string(report.outcomes.length));
		assertEquals(Std.string(intField(expect, "injectedCount", 0)), Std.string(report.injectedCount()));
		assertEquals(Std.string(intField(expect, "skippedCount", 0)), Std.string(report.skippedCount()));
		assertEquals(Std.string(intField(expect, "failureCount", 0)), Std.string(report.failureCount()));
		assertEquals(Std.string(intField(expect, "returnedUnchangedCount", 0)), Std.string(report.returnedUnchangedCount()));
		assertEquals(Std.string(intField(expect, "injectedUnchangedCount", 0)), Std.string(report.injectedUnchangedCount()));
		assertContains(report.summary(), stringField(expect, "summaryContains", ""));
	}

	static function fixtureRoot():Value {
		return expectParse(CodexJson.parse(File.getContent("fixtures/hxrust/thread-read-active-turn-goal-steering-injection.v1.json")));
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

	static function optionalStringField(object:Value, name:String):String {
		return switch optionalField(object, name) {
			case JString(value): value;
			case JNull: "";
			case _: throw "expected nullable string field: " + name;
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
		if (needle.length > 0 && haystack.indexOf(needle) < 0)
			throw "expected to find " + needle + " in " + haystack;
	}
}
