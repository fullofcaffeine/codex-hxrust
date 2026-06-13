import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.runtime.app.threadread.ThreadReadTokenUsageBreakdown;
import codexhx.runtime.app.threadread.ThreadReadTokenUsageInfo;
import codexhx.runtime.app.threadread.ThreadReadTokenUsageOwnerOutcome;
import codexhx.runtime.app.threadread.ThreadReadTokenUsageOwnerReason;
import codexhx.runtime.app.threadread.ThreadReadTokenUsageReplayBuilder;
import codexhx.runtime.app.threadread.ThreadReadTokenUsageReplayReport;
import codexhx.runtime.app.threadread.ThreadReadTokenUsageReplayRequest;
import haxe.json.Value;
import sys.io.File;

class ThreadReadTokenUsageReplayHarness {
	static function main():Void {
		final root = fixtureRoot();
		final cases = arrayField(root, "cases");
		final report = ThreadReadTokenUsageReplayBuilder.buildCases(requests(cases));
		assertReport(root, report);
		assertEquals(Std.string(cases.length), Std.string(report.outcomes.length));

		var i = 0;
		while (i < cases.length) {
			final expect = objectField(objectValue(cases[i]), "expect");
			final outcome = report.outcomes[i];
			assertEquals(boolText(boolField(expect, "ok", false)), boolText(outcome.ok));
			assertEquals(stringField(expect, "code", ""), outcome.code);
			assertEquals(Std.string(intField(expect, "totalTokens", 0)), Std.string(outcome.totalTokens()));
			assertEquals(Std.string(intField(expect, "lastTokens", 0)), Std.string(outcome.lastTokens()));
			final expectedThreadId = stringField(expect, "threadId", "");
			final expectedTurnId = stringField(expect, "turnId", "");
			final expectedContextWindow = stringField(expect, "modelContextWindow", "");
			final expectedJson = stringField(expect, "jsonContains", "");
			if (outcome.notification == null) {
				assertEquals("", expectedThreadId);
				assertEquals("", expectedTurnId);
				assertEquals("", expectedContextWindow);
			} else {
				assertEquals(expectedThreadId, outcome.notification.threadId);
				assertEquals(expectedTurnId, outcome.notification.turnId);
				assertEquals(expectedContextWindow, outcome.notification.tokenUsage.modelContextWindowText());
				if (expectedJson.length > 0) assertContains(outcome.notification.toJson(), expectedJson);
			}
			final needle = stringField(expect, "summaryContains", "");
			if (needle.length > 0) assertContains(outcome.summary(), needle);
			i = i + 1;
		}
	}

	static function requests(values:Array<Value>):Array<Null<ThreadReadTokenUsageReplayRequest>> {
		final out:Array<Null<ThreadReadTokenUsageReplayRequest>> = [];
		for (value in values) {
			final caseObject = objectValue(value);
			out.push(ThreadReadTokenUsageReplayRequest.fromRaw(
				stringField(caseObject, "threadId", ""),
				ownerOutcome(objectField(caseObject, "owner")),
				tokenUsage(caseObject)
			));
		}
		return out;
	}

	static function ownerOutcome(value:Value):ThreadReadTokenUsageOwnerOutcome {
		if (boolField(value, "ok", false)) {
			return ThreadReadTokenUsageOwnerOutcome.selected(
				stringField(value, "turnId", ""),
				intField(value, "turnIndex", -1),
				cast stringField(value, "reason", "")
			);
		}
		return ThreadReadTokenUsageOwnerOutcome.failure(
			stringField(value, "code", "owner_failed"),
			cast stringField(value, "reason", ThreadReadTokenUsageOwnerReason.EmptyThread),
			"owner resolution failed"
		);
	}

	static function tokenUsage(caseObject:Value):Null<ThreadReadTokenUsageInfo> {
		final value = optionalField(caseObject, "tokenUsage");
		return switch value {
			case JObject(_, _):
				final total = breakdown(objectField(value, "total"));
				final last = breakdown(objectField(value, "last"));
				final modelValue = optionalField(value, "modelContextWindow");
				switch modelValue {
					case JNumber(window):
						new ThreadReadTokenUsageInfo(total, last, true, Std.int(window));
					case JNull:
						new ThreadReadTokenUsageInfo(total, last, false, 0);
					case _:
						throw "expected nullable modelContextWindow";
				}
			case JNull:
				null;
			case _:
				throw "expected tokenUsage object";
		}
	}

	static function breakdown(value:Value):ThreadReadTokenUsageBreakdown {
		return new ThreadReadTokenUsageBreakdown(
			intField(value, "totalTokens", 0),
			intField(value, "inputTokens", 0),
			intField(value, "cachedInputTokens", 0),
			intField(value, "outputTokens", 0),
			intField(value, "reasoningOutputTokens", 0)
		);
	}

	static function assertReport(root:Value, report:ThreadReadTokenUsageReplayReport):Void {
		final expect = objectField(root, "expectReport");
		assertEquals(Std.string(intField(expect, "caseCount", 0)), Std.string(report.outcomes.length));
		assertEquals(Std.string(intField(expect, "okCount", 0)), Std.string(report.okCount()));
		assertEquals(Std.string(intField(expect, "failureCount", 0)), Std.string(report.failureCount()));
		assertContains(report.summary(), stringField(expect, "summaryContains", ""));
	}

	static function fixtureRoot():Value {
		return expectParse(CodexJson.parse(File.getContent("fixtures/hxrust/thread-read-token-usage-replay.v1.json")));
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
