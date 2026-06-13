import codexhx.protocol.ThreadId;
import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.runtime.app.threadread.ThreadReadTurnItemKind;
import codexhx.runtime.app.threadread.ThreadReadTurnItemSummary;
import codexhx.runtime.app.threadread.ThreadReadTurnItemsView;
import codexhx.runtime.app.threadread.ThreadReadTurnSortDirection;
import codexhx.runtime.app.threadread.ThreadReadTurnStatus;
import codexhx.runtime.app.threadread.ThreadReadTurnSummary;
import codexhx.runtime.app.threadread.ThreadReadTurnsPageReport;
import codexhx.runtime.app.threadread.ThreadReadTurnsPageRequest;
import codexhx.runtime.app.threadread.ThreadReadTurnsPager;
import haxe.json.Value;
import sys.io.File;

class ThreadReadTurnsPageHarness {
	static function main():Void {
		final root = fixtureRoot();
		final turns = turnsFromFixture(arrayField(root, "turns"));
		final requests = arrayField(root, "requests");
		final report = ThreadReadTurnsPager.pageCases(turns, requestsFromFixture(root, requests));
		assertReport(root, report);
		assertEquals(Std.string(requests.length), Std.string(report.outcomes.length));

		var i = 0;
		while (i < requests.length) {
			final expect = objectField(objectValue(requests[i]), "expect");
			final outcome = report.outcomes[i];
			assertEquals(boolText(boolField(expect, "ok", false)), boolText(outcome.ok));
			assertEquals(stringField(expect, "code", ""), outcome.code);
			final page = outcome.page;
			final dataCount = page == null ? 0 : page.data.length;
			final nextCursor = page == null ? "" : page.nextCursor;
			final backwardsCursor = page == null ? "" : page.backwardsCursor;
			assertEquals(Std.string(intField(expect, "dataCount", 0)), Std.string(dataCount));
			assertEquals(stringField(expect, "nextCursor", ""), nextCursor);
			assertEquals(stringField(expect, "backwardsCursor", ""), backwardsCursor);
			final needle = stringField(expect, "summaryContains", "");
			if (needle.length > 0) assertContains(outcome.summary(), needle);
			i = i + 1;
		}
	}

	static function turnsFromFixture(values:Array<Value>):Array<ThreadReadTurnSummary> {
		final out:Array<ThreadReadTurnSummary> = [];
		for (value in values) {
			final object = objectValue(value);
			final items:Array<ThreadReadTurnItemSummary> = [];
			for (itemValue in arrayField(object, "items")) {
				final item = objectValue(itemValue);
				items.push(new ThreadReadTurnItemSummary(
					cast stringField(item, "kind", ""),
					stringField(item, "text", "")
				));
			}
			out.push(new ThreadReadTurnSummary(
				stringField(object, "id", ""),
				cast stringField(object, "status", ""),
				items
			));
		}
		return out;
	}

	static function requestsFromFixture(root:Value, values:Array<Value>):Array<ThreadReadTurnsPageRequest> {
		final out:Array<ThreadReadTurnsPageRequest> = [];
		final threadId = stringField(root, "threadId", "");
		for (value in values) {
			final object = objectValue(value);
			out.push(new ThreadReadTurnsPageRequest(
				ThreadId.fromString(threadId),
				stringField(object, "cursor", ""),
				intField(object, "limit", -1),
				cast stringField(object, "sortDirection", "desc"),
				cast stringField(object, "itemsView", "summary")
			));
		}
		return out;
	}

	static function assertReport(root:Value, report:ThreadReadTurnsPageReport):Void {
		final expect = objectField(root, "expectReport");
		assertEquals(Std.string(intField(expect, "requestCount", 0)), Std.string(report.outcomes.length));
		assertEquals(Std.string(intField(expect, "okCount", 0)), Std.string(report.okCount()));
		assertEquals(Std.string(intField(expect, "failureCount", 0)), Std.string(report.failureCount()));
		assertContains(report.summary(), stringField(expect, "summaryContains", ""));
	}

	static function fixtureRoot():Value {
		return expectParse(CodexJson.parse(File.getContent("fixtures/hxrust/thread-read-turns-page.v1.json")));
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
