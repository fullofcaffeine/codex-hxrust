import codexhx.protocol.goals.ThreadGoal;
import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.runtime.app.threadread.ThreadReadResumeGoalSnapshotPolicy;
import codexhx.runtime.app.threadread.ThreadReadResumeGoalSnapshotReport;
import codexhx.runtime.app.threadread.ThreadReadResumeGoalSnapshotRequest;
import codexhx.runtime.app.threadread.ThreadReadTokenUsageReplayDeliveryOperation;
import codexhx.runtime.app.threadread.ThreadReadTokenUsageReplayDeliveryOutcome;
import haxe.json.Value;
import sys.io.File;

class ThreadReadResumeGoalSnapshotHarness {
	static function main():Void {
		final root = fixtureRoot();
		final cases = arrayField(root, "cases");
		final report = ThreadReadResumeGoalSnapshotPolicy.planCases(requests(cases));
		assertReport(root, report);
		assertEquals(Std.string(cases.length), Std.string(report.outcomes.length));

		var i = 0;
		while (i < cases.length) {
			final expect = objectField(objectValue(cases[i]), "expect");
			final outcome = report.outcomes[i];
			assertEquals(boolText(boolField(expect, "ok", false)), boolText(outcome.ok));
			assertEquals(stringField(expect, "code", ""), outcome.code);
			assertEquals(boolText(boolField(expect, "snapshotDelivered", false)), boolText(outcome.snapshotDelivered));
			assertEquals(boolText(boolField(expect, "goalUpdated", false)), boolText(outcome.goalUpdated));
			assertEquals(boolText(boolField(expect, "goalCleared", false)), boolText(outcome.goalCleared));
			assertEquals(boolText(boolField(expect, "skipped", false)), boolText(outcome.skipped));
			assertEquals(stringField(expect, "notificationMethod", ""), outcome.notificationMethod);
			assertEquals(stringField(expect, "sequence", ""), outcome.sequence);
			assertEquals(stringField(expect, "continuationIntent", ""), outcome.continuationIntent);
			assertEquals(stringField(expect, "pendingRequestsReplayPoint", ""), outcome.pendingRequestsReplayPoint);
			final needle = stringField(expect, "summaryContains", "");
			if (needle.length > 0) assertContains(outcome.summary(), needle);
			i = i + 1;
		}
	}

	static function requests(values:Array<Value>):Array<ThreadReadResumeGoalSnapshotRequest> {
		final out:Array<ThreadReadResumeGoalSnapshotRequest> = [];
		for (value in values) {
			final caseObject = objectValue(value);
			final operation:ThreadReadTokenUsageReplayDeliveryOperation = cast stringField(caseObject, "operation", "");
			out.push(new ThreadReadResumeGoalSnapshotRequest(
				operation,
				boolField(caseObject, "responseReady", false),
				boolField(caseObject, "goalsFeatureEnabled", false),
				boolField(caseObject, "stateDbAvailable", false),
				boolField(caseObject, "pendingRequestsReplayAfterSnapshot", false),
				tokenUsageDelivery(operation, stringField(caseObject, "tokenUsageDelivery", "")),
				goal(optionalStringField(caseObject, "goalStatus"))
			));
		}
		return out;
	}

	static function tokenUsageDelivery(
		operation:ThreadReadTokenUsageReplayDeliveryOperation,
		kind:String
	):ThreadReadTokenUsageReplayDeliveryOutcome {
		if (kind == "delivered") return ThreadReadTokenUsageReplayDeliveryOutcome.makeDelivered(operation, "conn-resume-goal");
		if (kind == "skipped_no_payload") {
			return ThreadReadTokenUsageReplayDeliveryOutcome.makeSkipped(
				operation,
				"skipped_no_payload",
				"no restored token usage notification payload was available"
			);
		}
		return ThreadReadTokenUsageReplayDeliveryOutcome.failure(
			operation,
			"response_not_ready",
			"restored token usage replay must be ordered after the JSON-RPC response"
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
		return "01890f3d-8f3a-7a9b-9f0d-000000000456";
	}

	static function assertReport(root:Value, report:ThreadReadResumeGoalSnapshotReport):Void {
		final expect = objectField(root, "expectReport");
		assertEquals(Std.string(intField(expect, "caseCount", 0)), Std.string(report.outcomes.length));
		assertEquals(Std.string(intField(expect, "snapshotCount", 0)), Std.string(report.snapshotCount()));
		assertEquals(Std.string(intField(expect, "updatedCount", 0)), Std.string(report.updatedCount()));
		assertEquals(Std.string(intField(expect, "clearedCount", 0)), Std.string(report.clearedCount()));
		assertEquals(Std.string(intField(expect, "skippedCount", 0)), Std.string(report.skippedCount()));
		assertEquals(Std.string(intField(expect, "failureCount", 0)), Std.string(report.failureCount()));
		assertContains(report.summary(), stringField(expect, "summaryContains", ""));
	}

	static function fixtureRoot():Value {
		return expectParse(CodexJson.parse(File.getContent("fixtures/hxrust/thread-read-resume-goal-snapshot.v1.json")));
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
