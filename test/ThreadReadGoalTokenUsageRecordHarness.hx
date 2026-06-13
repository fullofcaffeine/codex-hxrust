import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.runtime.app.threadread.ThreadReadGoalTokenUsageRecordPolicy;
import codexhx.runtime.app.threadread.ThreadReadGoalTokenUsageRecordReport;
import codexhx.runtime.app.threadread.ThreadReadGoalTokenUsageRecordRequest;
import codexhx.runtime.app.threadread.ThreadReadTokenUsageBreakdown;
import haxe.json.Value;
import sys.io.File;

class ThreadReadGoalTokenUsageRecordHarness {
	static function main():Void {
		final root = fixtureRoot();
		final cases = arrayField(root, "cases");
		final report = ThreadReadGoalTokenUsageRecordPolicy.buildCases(requests(cases));
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
			assertEquals(stringField(expect, "turnStoreLevelId", ""), outcome.turnStoreLevelId);
			assertEquals(stringField(expect, "currentTurnId", ""), outcome.currentTurnId);
			assertEquals(boolText(boolField(expect, "recordAttempted", false)), boolText(outcome.recordAttempted));
			assertEquals(boolText(boolField(expect, "turnKnown", false)), boolText(outcome.turnKnown));
			assertEquals(boolText(boolField(expect, "accountTokens", false)), boolText(outcome.accountTokens));
			assertEquals(boolText(boolField(expect, "currentUsageUpdated", false)), boolText(outcome.currentUsageUpdated));
			assertEquals(boolText(boolField(expect, "recorded", false)), boolText(outcome.recorded));
			assertEquals(Std.string(intField(expect, "turnDelta", 0)), Std.string(outcome.turnDelta));
			assertEquals(Std.string(intField(expect, "threadUnflushedDelta", 0)), Std.string(outcome.threadUnflushedDelta));
			assertEquals(Std.string(intField(expect, "goalChargeDelta", 0)), Std.string(outcome.goalChargeDelta));
			assertEquals(boolText(boolField(expect, "ignoredReasoningOutputTokens", false)), boolText(outcome.ignoredReasoningOutputTokens));
			assertEquals(boolText(boolField(expect, "ignoredTotalTokens", false)), boolText(outcome.ignoredTotalTokens));
			assertContains(outcome.summary(), stringField(expect, "summaryContains", ""));
			i = i + 1;
		}
	}

	static function requests(values:Array<Value>):Array<ThreadReadGoalTokenUsageRecordRequest> {
		final out:Array<ThreadReadGoalTokenUsageRecordRequest> = [];
		for (value in values) {
			final request = objectField(objectValue(value), "request");
			out.push(new ThreadReadGoalTokenUsageRecordRequest(
				stringField(request, "turnStoreLevelId", ""),
				stringField(request, "currentTurnId", ""),
				boolField(request, "runtimeAvailable", false),
				boolField(request, "runtimeEnabled", false),
				boolField(request, "turnKnown", false),
				boolField(request, "accountTokens", false),
				usageField(request, "previousCurrentUsage"),
				usageField(request, "lastAccountedUsage"),
				usageField(request, "totalUsage"),
				intField(request, "otherUnflushedTokenDelta", 0)
			));
		}
		return out;
	}

	static function usageField(object:Value, name:String):ThreadReadTokenUsageBreakdown {
		final value = objectField(object, name);
		return new ThreadReadTokenUsageBreakdown(
			intField(value, "totalTokens", 0),
			intField(value, "inputTokens", 0),
			intField(value, "cachedInputTokens", 0),
			intField(value, "outputTokens", 0),
			intField(value, "reasoningOutputTokens", 0)
		);
	}

	static function assertReport(root:Value, report:ThreadReadGoalTokenUsageRecordReport):Void {
		final expect = objectField(root, "expectReport");
		assertEquals(Std.string(intField(expect, "caseCount", 0)), Std.string(report.outcomes.length));
		assertEquals(Std.string(intField(expect, "recordedCount", 0)), Std.string(report.recordedCount()));
		assertEquals(Std.string(intField(expect, "skippedCount", 0)), Std.string(report.skippedCount()));
		assertEquals(Std.string(intField(expect, "currentUsageUpdatedCount", 0)), Std.string(report.currentUsageUpdatedCount()));
		assertEquals(Std.string(intField(expect, "ignoredReasoningCount", 0)), Std.string(report.ignoredReasoningCount()));
		assertEquals(Std.string(intField(expect, "ignoredTotalCount", 0)), Std.string(report.ignoredTotalCount()));
		assertContains(report.summary(), stringField(expect, "summaryContains", ""));
	}

	static function fixtureRoot():Value {
		return expectParse(CodexJson.parse(File.getContent("fixtures/hxrust/thread-read-goal-token-usage-record.v1.json")));
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
