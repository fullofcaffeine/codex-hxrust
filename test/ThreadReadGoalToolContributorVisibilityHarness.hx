import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.runtime.app.threadread.ThreadReadGoalToolContributorVisibilityPolicy;
import codexhx.runtime.app.threadread.ThreadReadGoalToolContributorVisibilityReport;
import codexhx.runtime.app.threadread.ThreadReadGoalToolContributorVisibilityRequest;
import haxe.json.Value;
import sys.io.File;

class ThreadReadGoalToolContributorVisibilityHarness {
	static function main():Void {
		final root = fixtureRoot();
		final cases = arrayField(root, "cases");
		final report = ThreadReadGoalToolContributorVisibilityPolicy.buildCases(requests(cases));
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
			assertEquals(boolText(boolField(expect, "toolsAvailableForThread", false)), boolText(outcome.toolsAvailableForThread));
			assertEquals(boolText(boolField(expect, "toolsVisible", false)), boolText(outcome.toolsVisible));
			assertEquals(stringField(expect, "threadId", ""), outcome.threadId);
			assertEquals(Std.string(intField(expect, "returnedToolCount", 0)), Std.string(outcome.returnedToolCount));
			assertEquals(stringField(expect, "stableOrder", ""), outcome.stableOrder);
			assertContains(outcome.summary(), stringField(expect, "summaryContains", ""));
			assertTools(arrayField(expect, "tools"), outcome.tools);
			i = i + 1;
		}
	}

	static function requests(values:Array<Value>):Array<ThreadReadGoalToolContributorVisibilityRequest> {
		final out:Array<ThreadReadGoalToolContributorVisibilityRequest> = [];
		for (value in values) {
			final request = objectField(objectValue(value), "request");
			out.push(new ThreadReadGoalToolContributorVisibilityRequest(
				boolField(request, "runtimeAvailable", false),
				boolField(request, "runtimeEnabled", false),
				boolField(request, "toolsAvailableForThread", false),
				stringField(request, "threadId", ""),
				boolField(request, "stateDbAvailable", false),
				boolField(request, "accountingStateAvailable", false),
				boolField(request, "analyticsAvailable", false),
				boolField(request, "eventEmitterAvailable", false),
				boolField(request, "metricsAvailable", false)
			));
		}
		return out;
	}

	static function assertTools(expect:Array<Value>, actual:Array<codexhx.runtime.app.threadread.ThreadReadGoalToolExecutorDescriptor>):Void {
		assertEquals(Std.string(expect.length), Std.string(actual.length));
		var i = 0;
		while (i < expect.length) {
			final item = objectValue(expect[i]);
			final tool = actual[i];
			assertEquals(stringField(item, "kind", ""), tool.kind);
			assertEquals(stringField(item, "toolNamespace", ""), tool.toolNamespace);
			assertEquals(stringField(item, "toolName", ""), tool.toolName);
			assertEquals(stringField(item, "threadId", ""), tool.threadId);
			assertEquals(boolText(boolField(item, "stateDbAttached", false)), boolText(tool.stateDbAttached));
			assertEquals(boolText(boolField(item, "accountingStateAttached", false)), boolText(tool.accountingStateAttached));
			assertEquals(boolText(boolField(item, "analyticsAttached", false)), boolText(tool.analyticsAttached));
			assertEquals(boolText(boolField(item, "eventEmitterAttached", false)), boolText(tool.eventEmitterAttached));
			assertEquals(boolText(boolField(item, "metricsAttached", false)), boolText(tool.metricsAttached));
			assertEquals(Std.string(intField(item, "orderIndex", -1)), Std.string(tool.orderIndex));
			i = i + 1;
		}
	}

	static function assertReport(root:Value, report:ThreadReadGoalToolContributorVisibilityReport):Void {
		final expect = objectField(root, "expectReport");
		assertEquals(Std.string(intField(expect, "caseCount", 0)), Std.string(report.outcomes.length));
		assertEquals(Std.string(intField(expect, "visibleCount", 0)), Std.string(report.visibleCount()));
		assertEquals(Std.string(intField(expect, "skippedCount", 0)), Std.string(report.skippedCount()));
		assertEquals(Std.string(intField(expect, "returnedToolCount", 0)), Std.string(report.returnedToolCount()));
		assertContains(report.summary(), stringField(expect, "summaryContains", ""));
	}

	static function fixtureRoot():Value {
		return expectParse(CodexJson.parse(File.getContent("fixtures/hxrust/thread-read-goal-tool-contributor-visibility.v1.json")));
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
