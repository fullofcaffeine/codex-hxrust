import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.runtime.app.threadread.ThreadReadTokenUsageOwnerReport;
import codexhx.runtime.app.threadread.ThreadReadTokenUsageOwnerRequest;
import codexhx.runtime.app.threadread.ThreadReadTokenUsageOwnerResolver;
import codexhx.runtime.app.threadread.ThreadReadTokenUsageTurnOwnerHint;
import codexhx.runtime.app.threadread.ThreadReadTurnSummary;
import haxe.json.Value;
import sys.io.File;

class ThreadReadTokenUsageOwnerHarness {
	static function main():Void {
		final root = fixtureRoot();
		final cases = arrayField(root, "cases");
		final report = ThreadReadTokenUsageOwnerResolver.resolveCases(requests(cases));
		assertReport(root, report);
		assertEquals(Std.string(cases.length), Std.string(report.outcomes.length));

		var i = 0;
		while (i < cases.length) {
			final expect = objectField(objectValue(cases[i]), "expect");
			final outcome = report.outcomes[i];
			assertEquals(boolText(boolField(expect, "ok", false)), boolText(outcome.ok));
			assertEquals(stringField(expect, "code", ""), outcome.code);
			assertEquals(stringField(expect, "turnId", ""), outcome.turnId);
			assertEquals(Std.string(intField(expect, "turnIndex", -1)), Std.string(outcome.turnIndex));
			assertEquals(stringField(expect, "reason", ""), outcome.reason);
			final needle = stringField(expect, "summaryContains", "");
			if (needle.length > 0)
				assertContains(outcome.summary(), needle);
			i = i + 1;
		}
	}

	static function requests(values:Array<Value>):Array<ThreadReadTokenUsageOwnerRequest> {
		final out:Array<ThreadReadTokenUsageOwnerRequest> = [];
		for (value in values) {
			final caseObject = objectValue(value);
			final turns:Array<ThreadReadTurnSummary> = [];
			for (turnValue in arrayField(caseObject, "turns")) {
				turns.push(turn(objectValue(turnValue)));
			}
			out.push(new ThreadReadTokenUsageOwnerRequest(turns, ownerHint(caseObject)));
		}
		return out;
	}

	static function turn(value:Value):ThreadReadTurnSummary {
		return new ThreadReadTurnSummary(stringField(value, "id", ""), cast stringField(value, "status", ""), []);
	}

	static function ownerHint(caseObject:Value):Null<ThreadReadTokenUsageTurnOwnerHint> {
		final value = optionalField(caseObject, "ownerHint");
		return switch value {
			case JObject(_, _):
				ThreadReadTokenUsageTurnOwnerHint.fromRaw(stringField(value, "id", ""), intField(value, "position", 0), hasField(value, "position"));
			case JNull:
				null;
			case _:
				throw "expected ownerHint object";
		}
	}

	static function assertReport(root:Value, report:ThreadReadTokenUsageOwnerReport):Void {
		final expect = objectField(root, "expectReport");
		assertEquals(Std.string(intField(expect, "caseCount", 0)), Std.string(report.outcomes.length));
		assertEquals(Std.string(intField(expect, "okCount", 0)), Std.string(report.okCount()));
		assertEquals(Std.string(intField(expect, "failureCount", 0)), Std.string(report.failureCount()));
		assertContains(report.summary(), stringField(expect, "summaryContains", ""));
	}

	static function fixtureRoot():Value {
		return expectParse(CodexJson.parse(File.getContent("fixtures/hxrust/thread-read-token-usage-owner.v1.json")));
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

	static function hasField(object:Value, name:String):Bool {
		return switch object {
			case JObject(keys, _):
				var i = 0;
				while (i < keys.length) {
					if (keys[i] == name)
						return true;
					i = i + 1;
				}
				false;
			case _:
				throw "expected object while checking field: " + name;
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
