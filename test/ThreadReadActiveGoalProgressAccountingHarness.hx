import codexhx.protocol.goals.ThreadGoal;
import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.runtime.app.threadread.ThreadReadActiveGoalProgressAccountingPolicy;
import codexhx.runtime.app.threadread.ThreadReadActiveGoalProgressAccountingReport;
import codexhx.runtime.app.threadread.ThreadReadActiveGoalProgressAccountingRequest;
import codexhx.runtime.app.threadread.ThreadReadGoalAccountingDbOutcomeKind;
import codexhx.runtime.app.threadread.ThreadReadGoalAccountingDisposition;
import haxe.json.Value;
import sys.io.File;

class ThreadReadActiveGoalProgressAccountingHarness {
	static function main():Void {
		final root = fixtureRoot();
		final cases = arrayField(root, "cases");
		final report = ThreadReadActiveGoalProgressAccountingPolicy.buildCases(requests(cases));
		assertReport(root, report);
		assertEquals(Std.string(cases.length), Std.string(report.outcomes.length));

		var i = 0;
		while (i < cases.length) {
			final expect = objectField(objectValue(cases[i]), "expect");
			final outcome = report.outcomes[i];
			assertEquals(boolText(boolField(expect, "ok", false)), boolText(outcome.ok));
			assertEquals(stringField(expect, "code", ""), outcome.code);
			assertEquals(boolText(boolField(expect, "progressSnapshotAvailable", false)), boolText(outcome.progressSnapshotAvailable));
			assertEquals(boolText(boolField(expect, "dbCallAttempted", false)), boolText(outcome.dbCallAttempted));
			assertEquals(stringField(expect, "dbOutcomeKind", ""), outcome.dbOutcomeKind);
			assertEquals(boolText(boolField(expect, "progressUpdated", false)), boolText(outcome.progressUpdated));
			assertEquals(boolText(boolField(expect, "progressReturned", false)), boolText(outcome.progressReturned));
			assertEquals(stringField(expect, "goalId", ""), outcome.goalId);
			assertEquals(stringField(expect, "status", ""), outcome.status);
			assertEquals(boolText(boolField(expect, "turnLastUsageUpdated", false)), boolText(outcome.turnLastUsageUpdated));
			assertEquals(Std.string(intField(expect, "wallClockAccountedSeconds", 0)), Std.string(outcome.wallClockAccountedSeconds));
			assertEquals(Std.string(intField(expect, "tokenDeltaAccounted", 0)), Std.string(outcome.tokenDeltaAccounted));
			assertEquals(boolText(boolField(expect, "activeGoalCleared", false)), boolText(outcome.activeGoalCleared));
			assertEquals(boolText(boolField(expect, "budgetLimitReportCleared", false)), boolText(outcome.budgetLimitReportCleared));
			assertEquals(boolText(boolField(expect, "threadGoalUpdatedEmitted", false)), boolText(outcome.threadGoalUpdatedEmitted));
			assertEquals(boolText(boolField(expect, "terminalMetricRecorded", false)), boolText(outcome.terminalMetricRecorded));
			assertContains(outcome.summary(), stringField(expect, "summaryContains", ""));
			i = i + 1;
		}
	}

	static function requests(values:Array<Value>):Array<ThreadReadActiveGoalProgressAccountingRequest> {
		final out:Array<ThreadReadActiveGoalProgressAccountingRequest> = [];
		for (value in values) {
			final request = objectField(objectValue(value), "request");
			out.push(new ThreadReadActiveGoalProgressAccountingRequest(stringField(request, "turnId", ""), stringField(request, "eventId", ""),
				boolField(request, "progressSnapshotAvailable", false), stringField(request, "snapshotExpectedGoalId", ""),
				intField(request, "snapshotTimeDeltaSeconds", 0), intField(request, "snapshotTokenDelta", 0), stringField(request, "previousStatus", ""),
				dbOutcomeKind(stringField(request, "dbOutcomeKind", "")), stringField(request, "dbErrorCode", ""),
				goalValue(valueField(request, "updatedGoal")), stringField(request, "updatedGoalId", ""),
				disposition(stringField(request, "disposition", "keep_active"))));
		}
		return out;
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
				if (!parsed.ok)
					throw "invalid goal fixture: " + parsed.errorCode;
				parsed.value;
		}
	}

	static function assertReport(root:Value, report:ThreadReadActiveGoalProgressAccountingReport):Void {
		final expect = objectField(root, "expectReport");
		assertEquals(Std.string(intField(expect, "caseCount", 0)), Std.string(report.outcomes.length));
		assertEquals(Std.string(intField(expect, "updatedCount", 0)), Std.string(report.updatedCount()));
		assertEquals(Std.string(intField(expect, "unchangedCount", 0)), Std.string(report.unchangedCount()));
		assertEquals(Std.string(intField(expect, "missingSnapshotCount", 0)), Std.string(report.missingSnapshotCount()));
		assertEquals(Std.string(intField(expect, "failureCount", 0)), Std.string(report.failureCount()));
		assertEquals(Std.string(intField(expect, "emittedCount", 0)), Std.string(report.emittedCount()));
		assertEquals(Std.string(intField(expect, "activeGoalClearedCount", 0)), Std.string(report.activeGoalClearedCount()));
		assertContains(report.summary(), stringField(expect, "summaryContains", ""));
	}

	static function fixtureRoot():Value {
		return expectParse(CodexJson.parse(File.getContent("fixtures/hxrust/thread-read-active-goal-progress-accounting.v1.json")));
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
