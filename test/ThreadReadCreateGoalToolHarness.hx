import codexhx.protocol.goals.ThreadGoal;
import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.runtime.app.threadread.ThreadReadCreateGoalToolInsertOutcomeKind;
import codexhx.runtime.app.threadread.ThreadReadCreateGoalToolPolicy;
import codexhx.runtime.app.threadread.ThreadReadCreateGoalToolPreviewOutcomeKind;
import codexhx.runtime.app.threadread.ThreadReadCreateGoalToolReport;
import codexhx.runtime.app.threadread.ThreadReadCreateGoalToolRequest;
import haxe.json.Value;
import sys.io.File;

class ThreadReadCreateGoalToolHarness {
	static function main():Void {
		final root = fixtureRoot();
		final cases = arrayField(root, "cases");
		final report = ThreadReadCreateGoalToolPolicy.buildCases(requests(cases));
		assertReport(root, report);
		assertEquals(Std.string(cases.length), Std.string(report.outcomes.length));

		var i = 0;
		while (i < cases.length) {
			final expect = objectField(objectValue(cases[i]), "expect");
			final outcome = report.outcomes[i];
			assertEquals(boolText(boolField(expect, "ok", false)), boolText(outcome.ok));
			assertEquals(stringField(expect, "code", ""), outcome.code);
			assertEquals(stringField(expect, "threadId", ""), outcome.threadId);
			assertEquals(stringField(expect, "turnId", ""), outcome.turnId);
			assertEquals(boolText(boolField(expect, "argumentsAccepted", false)), boolText(outcome.argumentsAccepted));
			assertEquals(stringField(expect, "objectiveTrimmed", ""), outcome.objectiveTrimmed);
			assertEquals(boolText(boolField(expect, "hasTokenBudget", false)), boolText(outcome.hasTokenBudget));
			assertEquals(Std.string(intField(expect, "tokenBudget", 0)), Std.string(outcome.tokenBudget));
			assertEquals(boolText(boolField(expect, "insertAttempted", false)), boolText(outcome.insertAttempted));
			assertEquals(stringField(expect, "insertOutcomeKind", ""), outcome.insertOutcomeKind);
			assertEquals(boolText(boolField(expect, "previewAttempted", false)), boolText(outcome.previewAttempted));
			assertEquals(stringField(expect, "previewOutcomeKind", ""), outcome.previewOutcomeKind);
			assertEquals(boolText(boolField(expect, "previewWarningLogged", false)), boolText(outcome.previewWarningLogged));
			assertEquals(boolText(boolField(expect, "accountingMarked", false)), boolText(outcome.accountingMarked));
			assertEquals(boolText(boolField(expect, "metricsRecorded", false)), boolText(outcome.metricsRecorded));
			assertEquals(boolText(boolField(expect, "analyticsCreated", false)), boolText(outcome.analyticsCreated));
			assertEquals(boolText(boolField(expect, "eventEmitted", false)), boolText(outcome.eventEmitted));
			assertEquals(stringField(expect, "functionCallErrorKind", ""), outcome.functionCallErrorKind);
			assertEquals(stringField(expect, "errorMessage", ""), outcome.errorMessage);
			assertEquals(boolText(boolField(expect, "goalPresent", false)), boolText(outcome.goalPresent));
			assertEquals(boolText(boolField(expect, "hasRemainingTokens", false)), boolText(outcome.hasRemainingTokens));
			assertEquals(Std.string(intField(expect, "remainingTokens", 0)), Std.string(outcome.remainingTokens));
			assertEquals(boolText(boolField(expect, "hasCompletionBudgetReport", false)), boolText(outcome.hasCompletionBudgetReport));
			assertGoal(valueField(expect, "goal"), outcome.response == null ? null : outcome.response.goal);
			assertContains(outcome.summary(), stringField(expect, "summaryContains", ""));
			i = i + 1;
		}
	}

	static function requests(values:Array<Value>):Array<ThreadReadCreateGoalToolRequest> {
		final out:Array<ThreadReadCreateGoalToolRequest> = [];
		for (value in values) {
			final request = objectField(objectValue(value), "request");
			out.push(new ThreadReadCreateGoalToolRequest(
				stringField(request, "threadId", ""),
				stringField(request, "turnId", ""),
				stringField(request, "argumentsJson", ""),
				insertOutcomeKind(stringField(request, "insertOutcomeKind", "")),
				stringField(request, "insertErrorMessage", ""),
				previewOutcomeKind(stringField(request, "previewOutcomeKind", "")),
				stringField(request, "previewErrorMessage", ""),
				goalValue(valueField(request, "insertedGoal"))
			));
		}
		return out;
	}

	static function insertOutcomeKind(value:String):ThreadReadCreateGoalToolInsertOutcomeKind {
		return switch value {
			case "inserted": ThreadReadCreateGoalToolInsertOutcomeKind.Inserted;
			case "unfinished_goal": ThreadReadCreateGoalToolInsertOutcomeKind.UnfinishedGoal;
			case "error": ThreadReadCreateGoalToolInsertOutcomeKind.Error;
			case _: throw "invalid create_goal insert outcome kind: " + value;
		}
	}

	static function previewOutcomeKind(value:String):ThreadReadCreateGoalToolPreviewOutcomeKind {
		return switch value {
			case "updated": ThreadReadCreateGoalToolPreviewOutcomeKind.Updated;
			case "unchanged": ThreadReadCreateGoalToolPreviewOutcomeKind.Unchanged;
			case "error": ThreadReadCreateGoalToolPreviewOutcomeKind.Error;
			case "not_attempted": ThreadReadCreateGoalToolPreviewOutcomeKind.NotAttempted;
			case _: throw "invalid create_goal preview outcome kind: " + value;
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

	static function assertGoal(expect:Value, actual:ThreadGoal):Void {
		switch expect {
			case JNull:
				if (actual != null) throw "expected null goal";
			case _:
				if (actual == null) throw "expected goal";
				final expectedGoal = goalValue(expect);
				assertEquals(expectedGoal.appJson(), actual.appJson());
		}
	}

	static function assertReport(root:Value, report:ThreadReadCreateGoalToolReport):Void {
		final expect = objectField(root, "expectReport");
		assertEquals(Std.string(intField(expect, "caseCount", 0)), Std.string(report.outcomes.length));
		assertEquals(Std.string(intField(expect, "successCount", 0)), Std.string(report.successCount()));
		assertEquals(Std.string(intField(expect, "errorCount", 0)), Std.string(report.errorCount()));
		assertEquals(Std.string(intField(expect, "previewWarningCount", 0)), Std.string(report.previewWarningCount()));
		assertEquals(Std.string(intField(expect, "eventEmittedCount", 0)), Std.string(report.eventEmittedCount()));
		assertEquals(Std.string(intField(expect, "insertAttemptedCount", 0)), Std.string(report.insertAttemptedCount()));
		assertContains(report.summary(), stringField(expect, "summaryContains", ""));
	}

	static function fixtureRoot():Value {
		return expectParse(CodexJson.parse(File.getContent("fixtures/hxrust/thread-read-create-goal-tool.v1.json")));
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
