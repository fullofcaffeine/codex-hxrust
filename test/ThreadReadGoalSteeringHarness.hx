import codexhx.protocol.goals.ThreadGoal;
import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.runtime.app.threadread.ThreadReadGoalSteeringBuilder;
import codexhx.runtime.app.threadread.ThreadReadGoalSteeringItemKind;
import codexhx.runtime.app.threadread.ThreadReadGoalSteeringReport;
import codexhx.runtime.app.threadread.ThreadReadGoalSteeringRequest;
import codexhx.runtime.app.threadread.ThreadReadResumeIdleContinuationOutcome;
import codexhx.runtime.app.threadread.ThreadReadTokenUsageReplayDeliveryOperation;
import haxe.json.Value;
import sys.io.File;

class ThreadReadGoalSteeringHarness {
	static function main():Void {
		final root = fixtureRoot();
		final cases = arrayField(root, "cases");
		final report = ThreadReadGoalSteeringBuilder.buildCases(requests(cases));
		assertReport(root, report);
		assertEquals(Std.string(cases.length), Std.string(report.outcomes.length));

		var i = 0;
		while (i < cases.length) {
			final expect = objectField(objectValue(cases[i]), "expect");
			final outcome = report.outcomes[i];
			assertEquals(boolText(boolField(expect, "ok", false)), boolText(outcome.ok));
			assertEquals(stringField(expect, "code", ""), outcome.code);
			assertEquals(boolText(boolField(expect, "emitted", false)), boolText(outcome.emitted));
			assertEquals(boolText(boolField(expect, "skipped", false)), boolText(outcome.skipped));
			if (outcome.item == null) {
				assertEquals(stringField(expect, "source", ""), "");
				assertEquals(stringField(expect, "fragmentKind", ""), "");
			} else {
				assertEquals(stringField(expect, "source", ""), outcome.item.source);
				assertEquals(stringField(expect, "fragmentKind", ""), outcome.item.fragmentKind);
			}
			assertPromptContains(outcome.item == null ? "" : outcome.item.prompt, arrayField(expect, "promptContains"));
			assertPromptNotContains(outcome.item == null ? "" : outcome.item.prompt, arrayField(expect, "promptNotContains"));
			final needle = stringField(expect, "summaryContains", "");
			if (needle.length > 0)
				assertContains(outcome.summary(), needle);
			i = i + 1;
		}
	}

	static function requests(values:Array<Value>):Array<ThreadReadGoalSteeringRequest> {
		final out:Array<ThreadReadGoalSteeringRequest> = [];
		for (value in values) {
			final caseObject = objectValue(value);
			final kind:ThreadReadGoalSteeringItemKind = cast stringField(caseObject, "kind", "");
			final goalStatus = optionalStringField(caseObject, "goalStatus");
			out.push(new ThreadReadGoalSteeringRequest(kind, goal(goalStatus, stringField(caseObject, "goalVariant", "")),
				continuationOutcome(stringField(caseObject, "continuationDecision", "")), boolField(caseObject, "objectiveChanged", false)));
		}
		return out;
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
		return "01890f3d-8f3a-7a9b-9f0d-000000001026";
	}

	static function assertReport(root:Value, report:ThreadReadGoalSteeringReport):Void {
		final expect = objectField(root, "expectReport");
		assertEquals(Std.string(intField(expect, "caseCount", 0)), Std.string(report.outcomes.length));
		assertEquals(Std.string(intField(expect, "emittedCount", 0)), Std.string(report.emittedCount()));
		assertEquals(Std.string(intField(expect, "skippedCount", 0)), Std.string(report.skippedCount()));
		assertEquals(Std.string(intField(expect, "failureCount", 0)), Std.string(report.failureCount()));
		assertContains(report.summary(), stringField(expect, "summaryContains", ""));
	}

	static function assertPromptContains(prompt:String, values:Array<Value>):Void {
		for (value in values) {
			assertContains(prompt, stringValue(value));
		}
	}

	static function assertPromptNotContains(prompt:String, values:Array<Value>):Void {
		for (value in values) {
			final needle = stringValue(value);
			if (needle.length > 0 && prompt.indexOf(needle) >= 0)
				throw "expected not to find " + needle + " in " + prompt;
		}
	}

	static function fixtureRoot():Value {
		return expectParse(CodexJson.parse(File.getContent("fixtures/hxrust/thread-read-goal-steering.v1.json")));
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

	static function stringValue(value:Value):String {
		return switch value {
			case JString(text): text;
			case _: throw "expected string value";
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
