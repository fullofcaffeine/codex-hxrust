import codexhx.protocol.goals.ThreadGoal;
import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.runtime.app.threadread.ThreadReadGetGoalToolDbOutcomeKind;
import codexhx.runtime.app.threadread.ThreadReadGetGoalToolPolicy;
import codexhx.runtime.app.threadread.ThreadReadGetGoalToolReport;
import codexhx.runtime.app.threadread.ThreadReadGetGoalToolRequest;
import haxe.json.Value;
import sys.io.File;

class ThreadReadGetGoalToolHarness {
	static function main():Void {
		final root = fixtureRoot();
		final cases = arrayField(root, "cases");
		final report = ThreadReadGetGoalToolPolicy.buildCases(requests(cases));
		assertReport(root, report);
		assertEquals(Std.string(cases.length), Std.string(report.outcomes.length));

		var i = 0;
		while (i < cases.length) {
			final expect = objectField(objectValue(cases[i]), "expect");
			final outcome = report.outcomes[i];
			assertEquals(boolText(boolField(expect, "ok", false)), boolText(outcome.ok));
			assertEquals(stringField(expect, "code", ""), outcome.code);
			assertEquals(stringField(expect, "threadId", ""), outcome.threadId);
			assertEquals(boolText(boolField(expect, "argumentsAccepted", false)), boolText(outcome.argumentsAccepted));
			assertEquals(boolText(boolField(expect, "readAttempted", false)), boolText(outcome.readAttempted));
			assertEquals(stringField(expect, "dbOutcomeKind", ""), outcome.dbOutcomeKind);
			assertEquals(stringField(expect, "functionCallErrorKind", ""), outcome.functionCallErrorKind);
			assertEquals(stringField(expect, "errorMessage", ""), outcome.errorMessage);
			assertEquals(boolText(boolField(expect, "goalPresent", false)), boolText(outcome.goalPresent));
			assertEquals(boolText(boolField(expect, "hasRemainingTokens", false)), boolText(outcome.hasRemainingTokens));
			assertEquals(Std.string(intField(expect, "remainingTokens", 0)), Std.string(outcome.remainingTokens));
			assertEquals(boolText(boolField(expect, "hasCompletionBudgetReport", false)), boolText(outcome.hasCompletionBudgetReport));
			assertEquals(boolText(boolField(expect, "stateMutated", false)), boolText(outcome.stateMutated));
			assertEquals(boolText(boolField(expect, "eventsEmitted", false)), boolText(outcome.eventsEmitted));
			assertGoal(valueField(expect, "goal"), outcome.response == null ? null : outcome.response.goal);
			assertContains(outcome.summary(), stringField(expect, "summaryContains", ""));
			i = i + 1;
		}
	}

	static function requests(values:Array<Value>):Array<ThreadReadGetGoalToolRequest> {
		final out:Array<ThreadReadGetGoalToolRequest> = [];
		for (value in values) {
			final request = objectField(objectValue(value), "request");
			out.push(new ThreadReadGetGoalToolRequest(stringField(request, "threadId", ""), stringField(request, "argumentsJson", ""),
				dbOutcomeKind(stringField(request, "dbOutcomeKind", "")), stringField(request, "dbErrorMessage", ""), goalValue(valueField(request, "goal"))));
		}
		return out;
	}

	static function dbOutcomeKind(value:String):ThreadReadGetGoalToolDbOutcomeKind {
		return switch value {
			case "found": ThreadReadGetGoalToolDbOutcomeKind.Found;
			case "missing": ThreadReadGetGoalToolDbOutcomeKind.Missing;
			case "error": ThreadReadGetGoalToolDbOutcomeKind.Error;
			case _: throw "invalid get_goal db outcome kind: " + value;
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

	static function assertGoal(expect:Value, actual:ThreadGoal):Void {
		switch expect {
			case JNull:
				if (actual != null)
					throw "expected null goal";
			case _:
				if (actual == null)
					throw "expected goal";
				final expectedGoal = goalValue(expect);
				assertEquals(expectedGoal.appJson(), actual.appJson());
		}
	}

	static function assertReport(root:Value, report:ThreadReadGetGoalToolReport):Void {
		final expect = objectField(root, "expectReport");
		assertEquals(Std.string(intField(expect, "caseCount", 0)), Std.string(report.outcomes.length));
		assertEquals(Std.string(intField(expect, "successCount", 0)), Std.string(report.successCount()));
		assertEquals(Std.string(intField(expect, "errorCount", 0)), Std.string(report.errorCount()));
		assertEquals(Std.string(intField(expect, "goalPresentCount", 0)), Std.string(report.goalPresentCount()));
		assertEquals(Std.string(intField(expect, "readAttemptedCount", 0)), Std.string(report.readAttemptedCount()));
		assertContains(report.summary(), stringField(expect, "summaryContains", ""));
	}

	static function fixtureRoot():Value {
		return expectParse(CodexJson.parse(File.getContent("fixtures/hxrust/thread-read-get-goal-tool.v1.json")));
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
