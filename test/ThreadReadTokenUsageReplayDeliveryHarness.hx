import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.runtime.app.threadread.ThreadReadTokenUsageBreakdown;
import codexhx.runtime.app.threadread.ThreadReadTokenUsageInfo;
import codexhx.runtime.app.threadread.ThreadReadTokenUsageOwnerOutcome;
import codexhx.runtime.app.threadread.ThreadReadTokenUsageOwnerReason;
import codexhx.runtime.app.threadread.ThreadReadTokenUsageReplayBuilder;
import codexhx.runtime.app.threadread.ThreadReadTokenUsageReplayDeliveryOperation;
import codexhx.runtime.app.threadread.ThreadReadTokenUsageReplayDeliveryPolicy;
import codexhx.runtime.app.threadread.ThreadReadTokenUsageReplayDeliveryReport;
import codexhx.runtime.app.threadread.ThreadReadTokenUsageReplayDeliveryRequest;
import codexhx.runtime.app.threadread.ThreadReadTokenUsageReplayOutcome;
import codexhx.runtime.app.threadread.ThreadReadTokenUsageReplayRequest;
import haxe.json.Value;
import sys.io.File;

class ThreadReadTokenUsageReplayDeliveryHarness {
	static function main():Void {
		final root = fixtureRoot();
		final cases = arrayField(root, "cases");
		final report = ThreadReadTokenUsageReplayDeliveryPolicy.planCases(requests(cases));
		assertReport(root, report);
		assertEquals(Std.string(cases.length), Std.string(report.outcomes.length));

		var i = 0;
		while (i < cases.length) {
			final expect = objectField(objectValue(cases[i]), "expect");
			final outcome = report.outcomes[i];
			assertEquals(boolText(boolField(expect, "ok", false)), boolText(outcome.ok));
			assertEquals(stringField(expect, "code", ""), outcome.code);
			assertEquals(boolText(boolField(expect, "delivered", false)), boolText(outcome.delivered));
			assertEquals(boolText(boolField(expect, "skipped", false)), boolText(outcome.skipped));
			assertEquals(stringField(expect, "sequence", ""), outcome.sequence);
			assertEquals(Std.string(intField(expect, "targetedConnectionCount", 0)), Std.string(outcome.targetedConnectionCount));
			assertEquals(stringField(expect, "connectionId", ""), outcome.connectionId);
			assertEquals(boolText(boolField(expect, "broadcast", false)), boolText(outcome.broadcast));
			final needle = stringField(expect, "summaryContains", "");
			if (needle.length > 0)
				assertContains(outcome.summary(), needle);
			i = i + 1;
		}
	}

	static function requests(values:Array<Value>):Array<ThreadReadTokenUsageReplayDeliveryRequest> {
		final out:Array<ThreadReadTokenUsageReplayDeliveryRequest> = [];
		for (value in values) {
			final caseObject = objectValue(value);
			out.push(new ThreadReadTokenUsageReplayDeliveryRequest(cast stringField(caseObject, "operation", ""),
				boolField(caseObject, "includeTurns", false), boolField(caseObject, "responseReady", false), stringField(caseObject, "connectionId", ""),
				payload(stringField(caseObject, "payload", "valid"))));
		}
		return out;
	}

	static function payload(kind:String):ThreadReadTokenUsageReplayOutcome {
		final usage = kind == "missing_usage" ? null : usageInfo();
		final request = ThreadReadTokenUsageReplayRequest.fromRaw(threadId(),
			ThreadReadTokenUsageOwnerOutcome.selected("turn-owner", 0, ThreadReadTokenUsageOwnerReason.ExplicitOwner), usage);
		return ThreadReadTokenUsageReplayBuilder.build(request);
	}

	static function threadId():String {
		return "01890f3d-8f3a-7a9b-9f0d-000000000123";
	}

	static function usageInfo():ThreadReadTokenUsageInfo {
		return new ThreadReadTokenUsageInfo(new ThreadReadTokenUsageBreakdown(150, 120, 20, 30, 10), new ThreadReadTokenUsageBreakdown(90, 70, 15, 20, 5),
			true, 200000);
	}

	static function assertReport(root:Value, report:ThreadReadTokenUsageReplayDeliveryReport):Void {
		final expect = objectField(root, "expectReport");
		assertEquals(Std.string(intField(expect, "caseCount", 0)), Std.string(report.outcomes.length));
		assertEquals(Std.string(intField(expect, "deliveredCount", 0)), Std.string(report.deliveredCount()));
		assertEquals(Std.string(intField(expect, "skippedCount", 0)), Std.string(report.skippedCount()));
		assertEquals(Std.string(intField(expect, "failureCount", 0)), Std.string(report.failureCount()));
		assertContains(report.summary(), stringField(expect, "summaryContains", ""));
	}

	static function fixtureRoot():Value {
		return expectParse(CodexJson.parse(File.getContent("fixtures/hxrust/thread-read-token-usage-replay-delivery.v1.json")));
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
