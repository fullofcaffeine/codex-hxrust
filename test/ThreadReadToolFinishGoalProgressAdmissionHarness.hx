import codexhx.protocol.goals.ThreadGoal;
import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.runtime.app.threadread.ThreadReadActiveGoalProgressAccountingOutcome;
import codexhx.runtime.app.threadread.ThreadReadActiveGoalProgressAccountingPolicy;
import codexhx.runtime.app.threadread.ThreadReadActiveGoalProgressAccountingRequest;
import codexhx.runtime.app.threadread.ThreadReadGoalAccountingDbOutcomeKind;
import codexhx.runtime.app.threadread.ThreadReadGoalAccountingDisposition;
import codexhx.runtime.app.threadread.ThreadReadToolCallOutcomeKind;
import codexhx.runtime.app.threadread.ThreadReadToolFinishGoalProgressAdmissionPolicy;
import codexhx.runtime.app.threadread.ThreadReadToolFinishGoalProgressAdmissionReport;
import codexhx.runtime.app.threadread.ThreadReadToolFinishGoalProgressAdmissionRequest;
import haxe.json.Value;
import sys.io.File;

class ThreadReadToolFinishGoalProgressAdmissionHarness {
	static function main():Void {
		final root = fixtureRoot();
		final cases = arrayField(root, "cases");
		final report = ThreadReadToolFinishGoalProgressAdmissionPolicy.buildCases(requests(cases));
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
			assertEquals(stringField(expect, "turnId", ""), outcome.turnId);
			assertEquals(stringField(expect, "callId", ""), outcome.callId);
			assertEquals(stringField(expect, "toolNamespace", ""), outcome.toolNamespace);
			assertEquals(stringField(expect, "toolName", ""), outcome.toolName);
			assertEquals(stringField(expect, "outcomeKind", ""), outcome.outcomeKind);
			assertEquals(boolText(boolField(expect, "completedSuccess", false)), boolText(outcome.completedSuccess));
			assertEquals(boolText(boolField(expect, "failedHandlerExecuted", false)), boolText(outcome.failedHandlerExecuted));
			assertEquals(boolText(boolField(expect, "toolAttemptCounts", false)), boolText(outcome.toolAttemptCounts));
			assertEquals(boolText(boolField(expect, "updateGoalSelfTool", false)), boolText(outcome.updateGoalSelfTool));
			assertEquals(boolText(boolField(expect, "admitted", false)), boolText(outcome.admitted));
			assertEquals(boolText(boolField(expect, "accountingAttempted", false)), boolText(outcome.accountingAttempted));
			assertEquals(stringField(expect, "accountingMode", ""), outcome.accountingMode);
			assertEquals(stringField(expect, "budgetLimitedDisposition", ""), outcome.budgetLimitedDisposition);
			assertEquals(stringField(expect, "accountingEventId", ""), outcome.accountingEventId);
			assertEquals(boolText(boolField(expect, "accountingOk", false)), boolText(outcome.accountingOk));
			assertEquals(stringField(expect, "accountingCode", ""), outcome.accountingCode);
			assertEquals(boolText(boolField(expect, "progressReturned", false)), boolText(outcome.progressReturned));
			assertEquals(boolText(boolField(expect, "budgetLimitedProgress", false)), boolText(outcome.budgetLimitedProgress));
			assertEquals(boolText(boolField(expect, "warningLogged", false)), boolText(outcome.warningLogged));
			assertContains(outcome.summary(), stringField(expect, "summaryContains", ""));
			i = i + 1;
		}
	}

	static function requests(values:Array<Value>):Array<ThreadReadToolFinishGoalProgressAdmissionRequest> {
		final out:Array<ThreadReadToolFinishGoalProgressAdmissionRequest> = [];
		for (value in values) {
			final request = objectField(objectValue(value), "request");
			out.push(new ThreadReadToolFinishGoalProgressAdmissionRequest(
				boolField(request, "runtimeAvailable", false),
				boolField(request, "runtimeEnabled", false),
				stringField(request, "turnId", ""),
				stringField(request, "callId", ""),
				stringField(request, "toolNamespace", ""),
				stringField(request, "toolName", ""),
				outcomeKind(stringField(request, "outcomeKind", "")),
				boolField(request, "completedSuccess", false),
				boolField(request, "failedHandlerExecuted", false),
				accountingOutcome(valueField(request, "accounting"))
			));
		}
		return out;
	}

	static function accountingOutcome(value:Value):ThreadReadActiveGoalProgressAccountingOutcome {
		return switch value {
			case JNull: null;
			case _:
				ThreadReadActiveGoalProgressAccountingPolicy.build(accountingRequest(objectValue(value)));
		}
	}

	static function accountingRequest(request:Value):ThreadReadActiveGoalProgressAccountingRequest {
		return new ThreadReadActiveGoalProgressAccountingRequest(
			stringField(request, "turnId", ""),
			stringField(request, "eventId", ""),
			boolField(request, "progressSnapshotAvailable", false),
			stringField(request, "snapshotExpectedGoalId", ""),
			intField(request, "snapshotTimeDeltaSeconds", 0),
			intField(request, "snapshotTokenDelta", 0),
			stringField(request, "previousStatus", ""),
			dbOutcomeKind(stringField(request, "dbOutcomeKind", "")),
			stringField(request, "dbErrorCode", ""),
			goalValue(valueField(request, "updatedGoal")),
			stringField(request, "updatedGoalId", ""),
			disposition(stringField(request, "disposition", "keep_active"))
		);
	}

	static function outcomeKind(value:String):ThreadReadToolCallOutcomeKind {
		return switch value {
			case "completed": ThreadReadToolCallOutcomeKind.Completed;
			case "failed": ThreadReadToolCallOutcomeKind.Failed;
			case "blocked": ThreadReadToolCallOutcomeKind.Blocked;
			case "aborted": ThreadReadToolCallOutcomeKind.Aborted;
			case _: throw "invalid tool outcome kind: " + value;
		}
	}

	static function dbOutcomeKind(value:String):ThreadReadGoalAccountingDbOutcomeKind {
		return switch value {
			case "updated": ThreadReadGoalAccountingDbOutcomeKind.Updated;
			case "unchanged": ThreadReadGoalAccountingDbOutcomeKind.Unchanged;
			case "error": ThreadReadGoalAccountingDbOutcomeKind.Error;
			case _: throw "invalid db outcome kind: " + value;
		}
	}

	static function disposition(value:String):ThreadReadGoalAccountingDisposition {
		return switch value {
			case "keep_active": ThreadReadGoalAccountingDisposition.KeepActive;
			case "clear_active": ThreadReadGoalAccountingDisposition.ClearActive;
			case _: throw "invalid accounting disposition: " + value;
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

	static function assertReport(root:Value, report:ThreadReadToolFinishGoalProgressAdmissionReport):Void {
		final expect = objectField(root, "expectReport");
		assertEquals(Std.string(intField(expect, "caseCount", 0)), Std.string(report.outcomes.length));
		assertEquals(Std.string(intField(expect, "admittedCount", 0)), Std.string(report.admittedCount()));
		assertEquals(Std.string(intField(expect, "skippedCount", 0)), Std.string(report.skippedCount()));
		assertEquals(Std.string(intField(expect, "accountingAttemptedCount", 0)), Std.string(report.accountingAttemptedCount()));
		assertEquals(Std.string(intField(expect, "warningCount", 0)), Std.string(report.warningCount()));
		assertEquals(Std.string(intField(expect, "budgetLimitedProgressCount", 0)), Std.string(report.budgetLimitedProgressCount()));
		assertContains(report.summary(), stringField(expect, "summaryContains", ""));
	}

	static function fixtureRoot():Value {
		return expectParse(CodexJson.parse(File.getContent("fixtures/hxrust/thread-read-tool-finish-goal-progress-admission.v1.json")));
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
