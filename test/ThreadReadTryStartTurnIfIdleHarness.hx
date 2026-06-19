import codexhx.protocol.goals.ThreadGoal;
import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.runtime.app.threadread.ThreadReadGoalSteeringBuilder;
import codexhx.runtime.app.threadread.ThreadReadGoalSteeringItemKind;
import codexhx.runtime.app.threadread.ThreadReadGoalSteeringOutcome;
import codexhx.runtime.app.threadread.ThreadReadGoalSteeringRequest;
import codexhx.runtime.app.threadread.ThreadReadResumeIdleContinuationOutcome;
import codexhx.runtime.app.threadread.ThreadReadTokenUsageReplayDeliveryOperation;
import codexhx.runtime.app.threadread.ThreadReadTryStartTurnIfIdleActiveTaskKind;
import codexhx.runtime.app.threadread.ThreadReadTryStartTurnIfIdlePolicy;
import codexhx.runtime.app.threadread.ThreadReadTryStartTurnIfIdleRejectionReason;
import codexhx.runtime.app.threadread.ThreadReadTryStartTurnIfIdleReport;
import codexhx.runtime.app.threadread.ThreadReadTryStartTurnIfIdleRequest;
import haxe.json.Value;
import sys.io.File;

class ThreadReadTryStartTurnIfIdleHarness {
	static function main():Void {
		final root = fixtureRoot();
		final cases = arrayField(root, "cases");
		final report = ThreadReadTryStartTurnIfIdlePolicy.buildCases(requests(cases));
		assertReport(root, report);
		assertEquals(Std.string(cases.length), Std.string(report.outcomes.length));

		var i = 0;
		while (i < cases.length) {
			final expect = objectField(objectValue(cases[i]), "expect");
			final outcome = report.outcomes[i];
			assertEquals(boolText(boolField(expect, "ok", false)), boolText(outcome.ok));
			assertEquals(stringField(expect, "code", ""), outcome.code);
			assertEquals(boolText(boolField(expect, "accepted", false)), boolText(outcome.accepted));
			assertEquals(boolText(boolField(expect, "rejected", false)), boolText(outcome.rejected));
			assertEquals(stringField(expect, "reason", ""), outcome.reason);
			assertEquals(boolText(boolField(expect, "reservationCreated", false)), boolText(outcome.reservationCreated));
			assertEquals(boolText(boolField(expect, "reservationCleared", false)), boolText(outcome.reservationCleared));
			assertEquals(boolText(boolField(expect, "pendingInputInjected", false)), boolText(outcome.pendingInputInjected));
			assertEquals(boolText(boolField(expect, "regularTaskStarted", false)), boolText(outcome.regularTaskStarted));
			assertEquals(boolText(boolField(expect, "returnedItemUnchanged", false)), boolText(outcome.returnedItemUnchanged));
			assertContains(outcome.returnedItemSummary, stringField(expect, "returnedItemSummaryContains", ""));
			assertContains(outcome.summary(), stringField(expect, "summaryContains", ""));
			i = i + 1;
		}
	}

	static function requests(values:Array<Value>):Array<ThreadReadTryStartTurnIfIdleRequest> {
		final out:Array<ThreadReadTryStartTurnIfIdleRequest> = [];
		for (value in values) {
			final caseObject = objectValue(value);
			final host = objectField(caseObject, "host");
			out.push(new ThreadReadTryStartTurnIfIdleRequest(steeringOutcome(objectField(caseObject, "steering")), boolField(host, "inputEmpty", false),
				boolField(host, "pendingTriggerTurnBeforeReservation", false), boolField(host, "collaborationPlanModeBeforeReservation", false),
				activeTaskKind(stringField(host, "activeTaskKind", "none")), boolField(host, "pendingTriggerTurnAfterReservation", false),
				boolField(host, "collaborationPlanModeAfterTurnContext", false), boolField(host, "pendingTriggerTurnAfterTurnContext", false),
				boolField(host, "reservationLostBeforeStart", false)));
		}
		return out;
	}

	static function steeringOutcome(value:Value):ThreadReadGoalSteeringOutcome {
		final kind:ThreadReadGoalSteeringItemKind = cast stringField(value, "kind", "");
		return ThreadReadGoalSteeringBuilder.build(new ThreadReadGoalSteeringRequest(kind,
			goal(optionalStringField(value, "goalStatus"), stringField(value, "goalVariant", "")),
			continuationOutcome(stringField(value, "continuationDecision", "")), boolField(value, "objectiveChanged", false)));
	}

	static function activeTaskKind(value:String):ThreadReadTryStartTurnIfIdleActiveTaskKind {
		if (value == "regular")
			return ThreadReadTryStartTurnIfIdleActiveTaskKind.Regular;
		if (value == "review")
			return ThreadReadTryStartTurnIfIdleActiveTaskKind.Review;
		return ThreadReadTryStartTurnIfIdleActiveTaskKind.None;
	}

	static function continuationOutcome(kind:String):ThreadReadResumeIdleContinuationOutcome {
		if (kind == "started") {
			return ThreadReadResumeIdleContinuationOutcome.makeStarted(ThreadReadTokenUsageReplayDeliveryOperation.Resume,
				"response->thread/goal/updated->thread/idle->goal/continue->turn/start");
		}
		if (kind == "rejected") {
			return ThreadReadResumeIdleContinuationOutcome.makeRejected(ThreadReadTokenUsageReplayDeliveryOperation.Resume,
				"response->thread/goal/updated->thread/idle->goal/continue");
		}
		if (kind == "snapshot_only") {
			return ThreadReadResumeIdleContinuationOutcome.makeIdleOnly(ThreadReadTokenUsageReplayDeliveryOperation.Resume, "snapshot_only_goal_not_active",
				"response->thread/goal/updated->thread/idle", true, "goal status paused clears active goal accounting and does not continue");
		}
		if (kind == "failure") {
			return ThreadReadResumeIdleContinuationOutcome.failure(ThreadReadTokenUsageReplayDeliveryOperation.Resume, "snapshot_not_settled",
				"resume idle lifecycle waits for response and goal snapshot ordering to settle");
		}
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
		if (variant == "over_budget") {
			return new ThreadGoal(threadId(), "Finish & verify > speculate", status, true, 5000, 6200, 300, 200000, 200100);
		}
		return new ThreadGoal(threadId(), "Keep polishing", status, true, 5000, 1200, 300, 200000, 200100);
	}

	static function threadId():String {
		return "01890f3d-8f3a-7a9b-9f0d-000000001027";
	}

	static function assertReport(root:Value, report:ThreadReadTryStartTurnIfIdleReport):Void {
		final expect = objectField(root, "expectReport");
		assertEquals(Std.string(intField(expect, "caseCount", 0)), Std.string(report.outcomes.length));
		assertEquals(Std.string(intField(expect, "acceptedCount", 0)), Std.string(report.acceptedCount()));
		assertEquals(Std.string(intField(expect, "rejectedCount", 0)), Std.string(report.rejectedCount()));
		assertEquals(Std.string(intField(expect, "noopCount", 0)), Std.string(report.noopCount()));
		assertEquals(Std.string(intField(expect, "failureCount", 0)), Std.string(report.failureCount()));
		assertEquals(Std.string(intField(expect, "returnedUnchangedCount", 0)), Std.string(report.returnedUnchangedCount()));
		assertContains(report.summary(), stringField(expect, "summaryContains", ""));
	}

	static function fixtureRoot():Value {
		return expectParse(CodexJson.parse(File.getContent("fixtures/hxrust/thread-read-try-start-turn-if-idle.v1.json")));
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
