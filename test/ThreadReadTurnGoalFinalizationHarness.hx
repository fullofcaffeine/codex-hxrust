import codexhx.protocol.goals.ThreadGoal;
import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.runtime.app.threadread.ThreadReadActiveGoalProgressAccountingOutcome;
import codexhx.runtime.app.threadread.ThreadReadActiveGoalProgressAccountingPolicy;
import codexhx.runtime.app.threadread.ThreadReadActiveGoalProgressAccountingRequest;
import codexhx.runtime.app.threadread.ThreadReadGoalAccountingDbOutcomeKind;
import codexhx.runtime.app.threadread.ThreadReadGoalAccountingDisposition;
import codexhx.runtime.app.threadread.ThreadReadTurnGoalFinalizationKind;
import codexhx.runtime.app.threadread.ThreadReadTurnGoalFinalizationPolicy;
import codexhx.runtime.app.threadread.ThreadReadTurnGoalFinalizationReport;
import codexhx.runtime.app.threadread.ThreadReadTurnGoalFinalizationRequest;
import haxe.json.Value;
import sys.io.File;

class ThreadReadTurnGoalFinalizationHarness {
	static function main():Void {
		final root = fixtureRoot();
		final cases = arrayField(root, "cases");
		final report = ThreadReadTurnGoalFinalizationPolicy.buildCases(requests(cases));
		assertReport(root, report);
		assertEquals(Std.string(cases.length), Std.string(report.outcomes.length));

		var i = 0;
		while (i < cases.length) {
			final expect = objectField(objectValue(cases[i]), "expect");
			final outcome = report.outcomes[i];
			assertEquals(boolText(boolField(expect, "ok", false)), boolText(outcome.ok));
			assertEquals(stringField(expect, "code", ""), outcome.code);
			assertEquals(stringField(expect, "kind", ""), outcome.kind);
			assertEquals(boolText(boolField(expect, "runtimeAvailable", false)), boolText(outcome.runtimeAvailable));
			assertEquals(boolText(boolField(expect, "runtimeEnabled", false)), boolText(outcome.runtimeEnabled));
			assertEquals(boolText(boolField(expect, "accountingAttempted", false)), boolText(outcome.accountingAttempted));
			assertEquals(stringField(expect, "accountingMode", ""), outcome.accountingMode);
			assertEquals(stringField(expect, "budgetLimitedDisposition", ""), outcome.budgetLimitedDisposition);
			assertEquals(stringField(expect, "eventId", ""), outcome.eventId);
			assertEquals(boolText(boolField(expect, "accountingOk", false)), boolText(outcome.accountingOk));
			assertEquals(stringField(expect, "accountingCode", ""), outcome.accountingCode);
			assertEquals(boolText(boolField(expect, "progressReturned", false)), boolText(outcome.progressReturned));
			assertEquals(boolText(boolField(expect, "activeGoalCleared", false)), boolText(outcome.activeGoalCleared));
			assertEquals(boolText(boolField(expect, "finishTurnCalled", false)), boolText(outcome.finishTurnCalled));
			assertEquals(boolText(boolField(expect, "turnStatePreserved", false)), boolText(outcome.turnStatePreserved));
			assertEquals(boolText(boolField(expect, "warningLogged", false)), boolText(outcome.warningLogged));
			assertContains(outcome.summary(), stringField(expect, "summaryContains", ""));
			i = i + 1;
		}
	}

	static function requests(values:Array<Value>):Array<ThreadReadTurnGoalFinalizationRequest> {
		final out:Array<ThreadReadTurnGoalFinalizationRequest> = [];
		for (value in values) {
			final request = objectField(objectValue(value), "request");
			out.push(new ThreadReadTurnGoalFinalizationRequest(
				finalizationKind(stringField(request, "kind", "")),
				boolField(request, "runtimeAvailable", false),
				boolField(request, "runtimeEnabled", false),
				stringField(request, "turnId", ""),
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
			disposition(stringField(request, "disposition", "clear_active"))
		);
	}

	static function finalizationKind(value:String):ThreadReadTurnGoalFinalizationKind {
		return switch value {
			case "turn_stop": ThreadReadTurnGoalFinalizationKind.TurnStop;
			case "turn_abort": ThreadReadTurnGoalFinalizationKind.TurnAbort;
			case _: throw "invalid turn finalization kind: " + value;
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

	static function assertReport(root:Value, report:ThreadReadTurnGoalFinalizationReport):Void {
		final expect = objectField(root, "expectReport");
		assertEquals(Std.string(intField(expect, "caseCount", 0)), Std.string(report.outcomes.length));
		assertEquals(Std.string(intField(expect, "finalizedCount", 0)), Std.string(report.finalizedCount()));
		assertEquals(Std.string(intField(expect, "skippedCount", 0)), Std.string(report.skippedCount()));
		assertEquals(Std.string(intField(expect, "accountingErrorCount", 0)), Std.string(report.accountingErrorCount()));
		assertEquals(Std.string(intField(expect, "warningCount", 0)), Std.string(report.warningCount()));
		assertEquals(Std.string(intField(expect, "activeGoalClearedCount", 0)), Std.string(report.activeGoalClearedCount()));
		assertContains(report.summary(), stringField(expect, "summaryContains", ""));
	}

	static function fixtureRoot():Value {
		return expectParse(CodexJson.parse(File.getContent("fixtures/hxrust/thread-read-turn-goal-finalization.v1.json")));
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
