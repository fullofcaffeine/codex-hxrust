import codexhx.protocol.goals.ThreadGoal;
import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.runtime.app.threadread.ThreadReadStoredGoalLookupOutcomeKind;
import codexhx.runtime.app.threadread.ThreadReadTurnStartCollaborationMode;
import codexhx.runtime.app.threadread.ThreadReadTurnStartGoalAccountingPolicy;
import codexhx.runtime.app.threadread.ThreadReadTurnStartGoalAccountingReport;
import codexhx.runtime.app.threadread.ThreadReadTurnStartGoalAccountingRequest;
import haxe.json.Value;
import sys.io.File;

class ThreadReadTurnStartGoalAccountingHarness {
	static function main():Void {
		final root = fixtureRoot();
		final cases = arrayField(root, "cases");
		final report = ThreadReadTurnStartGoalAccountingPolicy.buildCases(requests(cases));
		assertReport(root, report);
		assertEquals(Std.string(cases.length), Std.string(report.outcomes.length));

		var i = 0;
		while (i < cases.length) {
			final expect = objectField(objectValue(cases[i]), "expect");
			final outcome = report.outcomes[i];
			assertEquals(boolText(boolField(expect, "ok", false)), boolText(outcome.ok));
			assertEquals(stringField(expect, "code", ""), outcome.code);
			assertEquals(boolText(boolField(expect, "runtimeAvailable", false)), boolText(outcome.runtimeAvailable));
			assertEquals(boolText(boolField(expect, "runtimeEnabled", false)), boolText(outcome.runtimeEnabled));
			assertEquals(boolText(boolField(expect, "startTurnCalled", false)), boolText(outcome.startTurnCalled));
			assertEquals(boolText(boolField(expect, "accountTokens", false)), boolText(outcome.accountTokens));
			assertEquals(boolText(boolField(expect, "clearCurrentTurnGoalCalled", false)), boolText(outcome.clearCurrentTurnGoalCalled));
			assertEquals(boolText(boolField(expect, "storedGoalLookupAttempted", false)), boolText(outcome.storedGoalLookupAttempted));
			assertEquals(stringField(expect, "storedGoalLookupOutcomeKind", ""), outcome.storedGoalLookupOutcomeKind);
			assertEquals(boolText(boolField(expect, "storedGoalMarkedActive", false)), boolText(outcome.storedGoalMarkedActive));
			assertEquals(stringField(expect, "currentTurnGoalId", ""), outcome.currentTurnGoalId);
			assertEquals(stringField(expect, "wallClockActiveGoalId", ""), outcome.wallClockActiveGoalId);
			assertEquals(boolText(boolField(expect, "budgetLimitReportCleared", false)), boolText(outcome.budgetLimitReportCleared));
			assertEquals(boolText(boolField(expect, "stateLookupError", false)), boolText(outcome.stateLookupError));
			assertContains(outcome.summary(), stringField(expect, "summaryContains", ""));
			i = i + 1;
		}
	}

	static function requests(values:Array<Value>):Array<ThreadReadTurnStartGoalAccountingRequest> {
		final out:Array<ThreadReadTurnStartGoalAccountingRequest> = [];
		for (value in values) {
			final request = objectField(objectValue(value), "request");
			out.push(new ThreadReadTurnStartGoalAccountingRequest(
				boolField(request, "runtimeAvailable", false),
				boolField(request, "runtimeEnabled", false),
				stringField(request, "turnId", ""),
				collaborationMode(stringField(request, "collaborationMode", "default")),
				intField(request, "tokenUsageAtTurnStart", 0),
				lookupOutcomeKind(stringField(request, "storedGoalLookupOutcomeKind", "")),
				stringField(request, "storedGoalLookupErrorCode", ""),
				goalValue(valueField(request, "storedGoal")),
				stringField(request, "storedGoalId", ""),
				stringField(request, "budgetLimitReportedGoalId", "")
			));
		}
		return out;
	}

	static function collaborationMode(value:String):ThreadReadTurnStartCollaborationMode {
		return switch value {
			case "default": ThreadReadTurnStartCollaborationMode.Default;
			case "plan": ThreadReadTurnStartCollaborationMode.Plan;
			case _: throw "invalid collaboration mode: " + value;
		}
	}

	static function lookupOutcomeKind(value:String):ThreadReadStoredGoalLookupOutcomeKind {
		return switch value {
			case "found": ThreadReadStoredGoalLookupOutcomeKind.Found;
			case "missing": ThreadReadStoredGoalLookupOutcomeKind.Missing;
			case "error": ThreadReadStoredGoalLookupOutcomeKind.Error;
			case _: throw "invalid stored goal lookup outcome kind: " + value;
		}
	}

	static function goalValue(value:Value):ThreadGoal {
		return switch value {
			case JNull: null;
			case _:
				final parsed = ThreadGoal.parseApp(value);
				if (!parsed.ok) throw "invalid goal fixture: " + parsed.errorCode;
				parsed.value;
		}
	}

	static function assertReport(root:Value, report:ThreadReadTurnStartGoalAccountingReport):Void {
		final expect = objectField(root, "expectReport");
		assertEquals(Std.string(intField(expect, "caseCount", 0)), Std.string(report.outcomes.length));
		assertEquals(Std.string(intField(expect, "markedActiveCount", 0)), Std.string(report.markedActiveCount()));
		assertEquals(Std.string(intField(expect, "skippedCount", 0)), Std.string(report.skippedCount()));
		assertEquals(Std.string(intField(expect, "startTurnCount", 0)), Std.string(report.startTurnCount()));
		assertEquals(Std.string(intField(expect, "planClearedCount", 0)), Std.string(report.planClearedCount()));
		assertEquals(Std.string(intField(expect, "stateLookupErrorCount", 0)), Std.string(report.stateLookupErrorCount()));
		assertContains(report.summary(), stringField(expect, "summaryContains", ""));
	}

	static function fixtureRoot():Value {
		return expectParse(CodexJson.parse(File.getContent("fixtures/hxrust/thread-read-turn-start-goal-accounting.v1.json")));
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
