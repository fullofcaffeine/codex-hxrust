import codexhx.protocol.goals.ThreadGoal;
import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.runtime.app.threadread.ThreadReadBudgetLimitGoalSteeringPolicy;
import codexhx.runtime.app.threadread.ThreadReadBudgetLimitGoalSteeringReport;
import codexhx.runtime.app.threadread.ThreadReadBudgetLimitGoalSteeringRequest;
import haxe.json.Value;
import sys.io.File;

class ThreadReadBudgetLimitGoalSteeringHarness {
	static function main():Void {
		final root = fixtureRoot();
		final cases = arrayField(root, "cases");
		final report = ThreadReadBudgetLimitGoalSteeringPolicy.buildCases(requests(cases));
		assertReport(root, report);
		assertEquals(Std.string(cases.length), Std.string(report.outcomes.length));

		var i = 0;
		while (i < cases.length) {
			final expect = objectField(objectValue(cases[i]), "expect");
			final outcome = report.outcomes[i];
			assertEquals(boolText(boolField(expect, "ok", false)), boolText(outcome.ok));
			assertEquals(stringField(expect, "code", ""), outcome.code);
			assertEquals(boolText(boolField(expect, "progressAccounted", false)), boolText(outcome.progressAccounted));
			assertEquals(boolText(boolField(expect, "budgetLimited", false)), boolText(outcome.budgetLimited));
			assertEquals(boolText(boolField(expect, "reportMarked", false)), boolText(outcome.reportMarked));
			assertEquals(boolText(boolField(expect, "duplicateReportSkipped", false)), boolText(outcome.duplicateReportSkipped));
			assertEquals(boolText(boolField(expect, "steeringItemEmitted", false)), boolText(outcome.steeringItemEmitted));
			assertEquals(boolText(boolField(expect, "injectionAttempted", false)), boolText(outcome.injectionAttempted));
			assertEquals(boolText(boolField(expect, "injected", false)), boolText(outcome.injected));
			assertEquals(boolText(boolField(expect, "skipped", false)), boolText(outcome.skipped));
			assertEquals(stringField(expect, "injectionCode", ""), outcome.injectionCode);
			assertContains(outcome.itemSummary, stringField(expect, "itemSummaryContains", ""));
			assertContains(outcome.summary(), stringField(expect, "summaryContains", ""));
			i = i + 1;
		}
	}

	static function requests(values:Array<Value>):Array<ThreadReadBudgetLimitGoalSteeringRequest> {
		final out:Array<ThreadReadBudgetLimitGoalSteeringRequest> = [];
		for (value in values) {
			final caseObject = objectValue(value);
			final progress = objectField(caseObject, "progress");
			final host = objectField(caseObject, "host");
			out.push(new ThreadReadBudgetLimitGoalSteeringRequest(boolField(progress, "ok", false), boolField(progress, "available", false),
				stringField(progress, "errorCode", ""), goalValue(valueField(progress, "goal")), stringField(progress, "goalId", ""),
				boolField(progress, "budgetLimitAlreadyReported", false), boolField(host, "threadManagerAvailable", false),
				boolField(host, "liveThreadAvailable", false), boolField(host, "activeTurnRunning", false)));
		}
		return out;
	}

	static function goalValue(value:Value):ThreadGoal {
		return switch value {
			case JNull: null;
			case _:
				final parsed = ThreadGoal.parseApp(value);
				if (!parsed.ok)
					throw "invalid goal fixture: " + parsed.errorCode;
				parsed.value;
		}
	}

	static function assertReport(root:Value, report:ThreadReadBudgetLimitGoalSteeringReport):Void {
		final expect = objectField(root, "expectReport");
		assertEquals(Std.string(intField(expect, "caseCount", 0)), Std.string(report.outcomes.length));
		assertEquals(Std.string(intField(expect, "injectedCount", 0)), Std.string(report.injectedCount()));
		assertEquals(Std.string(intField(expect, "skippedCount", 0)), Std.string(report.skippedCount()));
		assertEquals(Std.string(intField(expect, "failureCount", 0)), Std.string(report.failureCount()));
		assertEquals(Std.string(intField(expect, "reportMarkedCount", 0)), Std.string(report.reportMarkedCount()));
		assertEquals(Std.string(intField(expect, "duplicateCount", 0)), Std.string(report.duplicateCount()));
		assertContains(report.summary(), stringField(expect, "summaryContains", ""));
	}

	static function fixtureRoot():Value {
		return expectParse(CodexJson.parse(File.getContent("fixtures/hxrust/thread-read-budget-limit-goal-steering.v1.json")));
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
		return optionalField(object, name);
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
