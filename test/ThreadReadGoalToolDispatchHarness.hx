import codexhx.protocol.goals.ThreadGoal;
import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.runtime.app.threadread.ThreadReadCreateGoalToolInsertOutcomeKind;
import codexhx.runtime.app.threadread.ThreadReadCreateGoalToolPreviewOutcomeKind;
import codexhx.runtime.app.threadread.ThreadReadCreateGoalToolRequest;
import codexhx.runtime.app.threadread.ThreadReadGetGoalToolDbOutcomeKind;
import codexhx.runtime.app.threadread.ThreadReadGetGoalToolRequest;
import codexhx.runtime.app.threadread.ThreadReadGoalToolDispatchPolicy;
import codexhx.runtime.app.threadread.ThreadReadGoalToolDispatchReport;
import codexhx.runtime.app.threadread.ThreadReadGoalToolDispatchRequest;
import codexhx.runtime.app.threadread.ThreadReadGoalToolKind;
import codexhx.runtime.app.threadread.ThreadReadUpdateGoalToolAccountingOutcomeKind;
import codexhx.runtime.app.threadread.ThreadReadUpdateGoalToolMetricsReadOutcomeKind;
import codexhx.runtime.app.threadread.ThreadReadUpdateGoalToolRequest;
import codexhx.runtime.app.threadread.ThreadReadUpdateGoalToolUpdateOutcomeKind;
import haxe.json.Value;
import sys.io.File;

class ThreadReadGoalToolDispatchHarness {
	static function main():Void {
		final root = fixtureRoot();
		final cases = arrayField(root, "cases");
		final report = ThreadReadGoalToolDispatchPolicy.buildCases(requests(cases));
		assertReport(root, report);
		assertEquals(Std.string(cases.length), Std.string(report.outcomes.length));

		var i = 0;
		while (i < cases.length) {
			final expect = objectField(objectValue(cases[i]), "expect");
			final outcome = report.outcomes[i];
			assertEquals(stringField(expect, "toolName", ""), outcome.toolName);
			assertEquals(boolText(boolField(expect, "specMatchesDispatch", false)), boolText(outcome.specMatchesDispatch));
			assertEquals(stringField(expect, "requiredFields", ""), outcome.spec.requiredCsv());
			assertEquals(stringField(expect, "statusEnum", ""), outcome.spec.statusEnumCsv());
			assertEquals(boolText(boolField(expect, "strict", true)), boolText(outcome.spec.strict));
			assertEquals(boolText(boolField(expect, "closedParameters", false)), boolText(outcome.spec.closedParameters));
			assertEquals(stringField(expect, "responseShape", ""), outcome.responseShape);
			assertEquals(boolText(boolField(expect, "ok", false)), boolText(outcome.ok));
			assertEquals(stringField(expect, "code", ""), outcome.code);
			assertEquals(stringField(expect, "threadId", ""), outcome.threadId);
			assertEquals(stringField(expect, "turnId", ""), outcome.turnId);
			assertEquals(stringField(expect, "callId", ""), outcome.callId);
			assertEquals(stringField(expect, "functionCallErrorKind", ""), outcome.functionCallErrorKind);
			assertEquals(boolText(boolField(expect, "goalPresent", false)), boolText(outcome.goalPresent));
			assertEquals(boolText(boolField(expect, "hasRemainingTokens", false)), boolText(outcome.hasRemainingTokens));
			assertEquals(Std.string(intField(expect, "remainingTokens", 0)), Std.string(outcome.remainingTokens));
			assertEquals(boolText(boolField(expect, "hasCompletionBudgetReport", false)), boolText(outcome.hasCompletionBudgetReport));
			assertEquals(boolText(boolField(expect, "eventEmitted", false)), boolText(outcome.eventEmitted));
			assertContains(outcome.summary(), stringField(expect, "summaryContains", ""));
			i = i + 1;
		}
	}

	static function requests(values:Array<Value>):Array<ThreadReadGoalToolDispatchRequest> {
		final out:Array<ThreadReadGoalToolDispatchRequest> = [];
		for (value in values) {
			final request = objectField(objectValue(value), "request");
			final kind = toolKind(stringField(request, "toolName", ""));
			out.push(switch kind {
				case ThreadReadGoalToolKind.Get:
					ThreadReadGoalToolDispatchRequest.get(getRequest(objectField(request, "get")));
				case ThreadReadGoalToolKind.Create:
					ThreadReadGoalToolDispatchRequest.create(createRequest(objectField(request, "create")));
				case ThreadReadGoalToolKind.Update:
					ThreadReadGoalToolDispatchRequest.update(updateRequest(objectField(request, "update")));
			});
		}
		return out;
	}

	static function getRequest(request:Value):ThreadReadGetGoalToolRequest {
		return new ThreadReadGetGoalToolRequest(stringField(request, "threadId", ""), stringField(request, "argumentsJson", ""),
			dbOutcomeKind(stringField(request, "dbOutcomeKind", "")), stringField(request, "dbErrorMessage", ""), goalValue(valueField(request, "goal")));
	}

	static function createRequest(request:Value):ThreadReadCreateGoalToolRequest {
		return new ThreadReadCreateGoalToolRequest(stringField(request, "threadId", ""), stringField(request, "turnId", ""),
			stringField(request, "argumentsJson", ""), insertOutcomeKind(stringField(request, "insertOutcomeKind", "")),
			stringField(request, "insertErrorMessage", ""), previewOutcomeKind(stringField(request, "previewOutcomeKind", "")),
			stringField(request, "previewErrorMessage", ""), goalValue(valueField(request, "insertedGoal")));
	}

	static function updateRequest(request:Value):ThreadReadUpdateGoalToolRequest {
		return new ThreadReadUpdateGoalToolRequest(stringField(request, "threadId", ""), stringField(request, "turnId", ""),
			stringField(request, "callId", ""), stringField(request, "argumentsJson", ""),
			accountingOutcomeKind(stringField(request, "accountingOutcomeKind", "")), stringField(request, "accountingErrorMessage", ""),
			metricsReadOutcomeKind(stringField(request, "metricsReadOutcomeKind", "")), stringField(request, "metricsReadErrorMessage", ""),
			stringField(request, "previousStatus", ""), updateOutcomeKind(stringField(request, "updateOutcomeKind", "")),
			stringField(request, "updateErrorMessage", ""), stringField(request, "clearedTurnId", ""), goalValue(valueField(request, "updatedGoal")));
	}

	static function toolKind(value:String):ThreadReadGoalToolKind {
		return switch value {
			case "get_goal": ThreadReadGoalToolKind.Get;
			case "create_goal": ThreadReadGoalToolKind.Create;
			case "update_goal": ThreadReadGoalToolKind.Update;
			case _: throw "invalid goal tool name: " + value;
		}
	}

	static function dbOutcomeKind(value:String):ThreadReadGetGoalToolDbOutcomeKind {
		return switch value {
			case "found": ThreadReadGetGoalToolDbOutcomeKind.Found;
			case "missing": ThreadReadGetGoalToolDbOutcomeKind.Missing;
			case "error": ThreadReadGetGoalToolDbOutcomeKind.Error;
			case _: throw "invalid get_goal db outcome kind: " + value;
		}
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

	static function accountingOutcomeKind(value:String):ThreadReadUpdateGoalToolAccountingOutcomeKind {
		return switch value {
			case "no_current_turn": ThreadReadUpdateGoalToolAccountingOutcomeKind.NoCurrentTurn;
			case "no_snapshot": ThreadReadUpdateGoalToolAccountingOutcomeKind.NoSnapshot;
			case "updated": ThreadReadUpdateGoalToolAccountingOutcomeKind.Updated;
			case "unchanged": ThreadReadUpdateGoalToolAccountingOutcomeKind.Unchanged;
			case "error": ThreadReadUpdateGoalToolAccountingOutcomeKind.Error;
			case _: throw "invalid update_goal accounting outcome kind: " + value;
		}
	}

	static function metricsReadOutcomeKind(value:String):ThreadReadUpdateGoalToolMetricsReadOutcomeKind {
		return switch value {
			case "found": ThreadReadUpdateGoalToolMetricsReadOutcomeKind.Found;
			case "missing": ThreadReadUpdateGoalToolMetricsReadOutcomeKind.Missing;
			case "error": ThreadReadUpdateGoalToolMetricsReadOutcomeKind.Error;
			case _: throw "invalid update_goal metrics outcome kind: " + value;
		}
	}

	static function updateOutcomeKind(value:String):ThreadReadUpdateGoalToolUpdateOutcomeKind {
		return switch value {
			case "updated": ThreadReadUpdateGoalToolUpdateOutcomeKind.Updated;
			case "missing": ThreadReadUpdateGoalToolUpdateOutcomeKind.Missing;
			case "error": ThreadReadUpdateGoalToolUpdateOutcomeKind.Error;
			case _: throw "invalid update_goal update outcome kind: " + value;
		}
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

	static function assertReport(root:Value, report:ThreadReadGoalToolDispatchReport):Void {
		final expect = objectField(root, "expectReport");
		assertEquals(Std.string(intField(expect, "caseCount", 0)), Std.string(report.outcomes.length));
		assertEquals(Std.string(intField(expect, "successCount", 0)), Std.string(report.successCount()));
		assertEquals(Std.string(intField(expect, "errorCount", 0)), Std.string(report.errorCount()));
		assertEquals(Std.string(intField(expect, "eventEmittedCount", 0)), Std.string(report.eventEmittedCount()));
		assertEquals(Std.string(intField(expect, "completionBudgetReportCount", 0)), Std.string(report.completionBudgetReportCount()));
		assertEquals(Std.string(intField(expect, "specMismatchCount", 0)), Std.string(report.specMismatchCount()));
		assertEquals(Std.string(intField(expect, "goalPresentCount", 0)), Std.string(report.goalPresentCount()));
		assertContains(report.summary(), stringField(expect, "summaryContains", ""));
	}

	static function fixtureRoot():Value {
		return expectParse(CodexJson.parse(File.getContent("fixtures/hxrust/thread-read-goal-tool-dispatch.v1.json")));
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
