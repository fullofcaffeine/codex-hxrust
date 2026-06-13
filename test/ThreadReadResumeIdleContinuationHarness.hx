import codexhx.protocol.goals.ThreadGoal;
import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.runtime.app.threadread.ThreadReadResumeGoalSnapshotOutcome;
import codexhx.runtime.app.threadread.ThreadReadResumeIdleContinuationPolicy;
import codexhx.runtime.app.threadread.ThreadReadResumeIdleContinuationReport;
import codexhx.runtime.app.threadread.ThreadReadResumeIdleContinuationRequest;
import codexhx.runtime.app.threadread.ThreadReadTokenUsageReplayDeliveryOperation;
import haxe.json.Value;
import sys.io.File;

class ThreadReadResumeIdleContinuationHarness {
	static function main():Void {
		final root = fixtureRoot();
		final cases = arrayField(root, "cases");
		final report = ThreadReadResumeIdleContinuationPolicy.planCases(requests(cases));
		assertReport(root, report);
		assertEquals(Std.string(cases.length), Std.string(report.outcomes.length));

		var i = 0;
		while (i < cases.length) {
			final expect = objectField(objectValue(cases[i]), "expect");
			final outcome = report.outcomes[i];
			assertEquals(boolText(boolField(expect, "ok", false)), boolText(outcome.ok));
			assertEquals(stringField(expect, "code", ""), outcome.code);
			assertEquals(boolText(boolField(expect, "idleHookEmitted", false)), boolText(outcome.idleHookEmitted));
			assertEquals(boolText(boolField(expect, "goalContinuationRequested", false)), boolText(outcome.goalContinuationRequested));
			assertEquals(boolText(boolField(expect, "turnStarted", false)), boolText(outcome.turnStarted));
			assertEquals(boolText(boolField(expect, "activeGoalCleared", false)), boolText(outcome.activeGoalCleared));
			assertEquals(boolText(boolField(expect, "skipped", false)), boolText(outcome.skipped));
			assertEquals(stringField(expect, "sequence", ""), outcome.sequence);
			final needle = stringField(expect, "summaryContains", "");
			if (needle.length > 0) assertContains(outcome.summary(), needle);
			i = i + 1;
		}
	}

	static function requests(values:Array<Value>):Array<ThreadReadResumeIdleContinuationRequest> {
		final out:Array<ThreadReadResumeIdleContinuationRequest> = [];
		for (value in values) {
			final caseObject = objectValue(value);
			final operation:ThreadReadTokenUsageReplayDeliveryOperation = cast stringField(caseObject, "operation", "");
			final status = optionalStringField(caseObject, "goalStatus");
			out.push(new ThreadReadResumeIdleContinuationRequest(
				operation,
				snapshotOutcome(operation, stringField(caseObject, "snapshot", "")),
				boolField(caseObject, "activeTurnPresent", false),
				boolField(caseObject, "triggerMailboxPending", false),
				boolField(caseObject, "toolsVisible", false),
				boolField(caseObject, "threadManagerAvailable", false),
				boolField(caseObject, "liveThreadAvailable", false),
				boolField(caseObject, "automaticStartAccepted", false),
				goal(status)
			));
		}
		return out;
	}

	static function snapshotOutcome(
		operation:ThreadReadTokenUsageReplayDeliveryOperation,
		kind:String
	):ThreadReadResumeGoalSnapshotOutcome {
		if (kind == "updated_delivered") {
			return ThreadReadResumeGoalSnapshotOutcome.updated(
				operation,
				"response->thread/tokenUsage/updated->thread/goal/updated",
				"emit_idle_lifecycle",
				"none",
				"stored goal snapshot delivered with status=active"
			);
		}
		if (kind == "updated_loaded_after_pending") {
			return ThreadReadResumeGoalSnapshotOutcome.updated(
				operation,
				"response->thread/tokenUsage/updated->thread/goal/updated",
				"emit_idle_lifecycle",
				"after_goal_snapshot",
				"stored goal snapshot delivered with status=active"
			);
		}
		if (kind == "updated_no_token_usage") {
			return ThreadReadResumeGoalSnapshotOutcome.updated(
				operation,
				"response->thread/goal/updated",
				"snapshot_only",
				"none",
				"stored goal snapshot delivered"
			);
		}
		if (kind == "cleared_no_goal") {
			return ThreadReadResumeGoalSnapshotOutcome.cleared(
				operation,
				"response->thread/goal/cleared",
				"none"
			);
		}
		if (kind == "goals_disabled") {
			return ThreadReadResumeGoalSnapshotOutcome.makeSkipped(
				operation,
				"skipped_goals_feature_disabled",
				"response->thread/tokenUsage/updated",
				"goals feature disabled; upstream returns before snapshot and idle continuation"
			);
		}
		if (kind == "fork_skip") {
			return ThreadReadResumeGoalSnapshotOutcome.makeSkipped(
				operation,
				"skipped_fork_has_no_resume_goal_snapshot",
				"response->thread/tokenUsage/updated",
				"upstream fork delivery replays token usage but does not emit a resume goal snapshot"
			);
		}
		return ThreadReadResumeGoalSnapshotOutcome.failure(
			operation,
			"response_not_ready",
			"resume goal snapshot must be ordered after the JSON-RPC response"
		);
	}

	static function goal(status:String):ThreadGoal {
		if (status.length == 0) return null;
		return new ThreadGoal(
			threadId(),
			"keep polishing",
			status,
			true,
			100000,
			1200,
			300,
			200000,
			200100
		);
	}

	static function threadId():String {
		return "01890f3d-8f3a-7a9b-9f0d-000000000789";
	}

	static function assertReport(root:Value, report:ThreadReadResumeIdleContinuationReport):Void {
		final expect = objectField(root, "expectReport");
		assertEquals(Std.string(intField(expect, "caseCount", 0)), Std.string(report.outcomes.length));
		assertEquals(Std.string(intField(expect, "idleHookCount", 0)), Std.string(report.idleHookCount()));
		assertEquals(Std.string(intField(expect, "continuationRequestCount", 0)), Std.string(report.continuationRequestCount()));
		assertEquals(Std.string(intField(expect, "turnStartedCount", 0)), Std.string(report.turnStartedCount()));
		assertEquals(Std.string(intField(expect, "activeGoalClearedCount", 0)), Std.string(report.activeGoalClearedCount()));
		assertEquals(Std.string(intField(expect, "skippedCount", 0)), Std.string(report.skippedCount()));
		assertEquals(Std.string(intField(expect, "failureCount", 0)), Std.string(report.failureCount()));
		assertContains(report.summary(), stringField(expect, "summaryContains", ""));
	}

	static function fixtureRoot():Value {
		return expectParse(CodexJson.parse(File.getContent("fixtures/hxrust/thread-read-resume-idle-continuation.v1.json")));
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
