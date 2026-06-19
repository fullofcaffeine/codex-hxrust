import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.runtime.model.request.ModelRequestEnvelopeRequest;
import codexhx.runtime.model.stream.ModelStreamFixtureEvent;
import codexhx.runtime.model.stream.ModelStreamFixtureEventKind;
import codexhx.runtime.model.stream.ModelStreamRoutePolicy;
import codexhx.runtime.model.stream.ModelStreamRouteReport;
import codexhx.runtime.model.stream.ModelStreamRouteRequest;
import haxe.json.Value;
import sys.io.File;

class ModelStreamRouteHarness {
	static function main():Void {
		final root = fixtureRoot("fixtures/hxrust/model-stream-route.v1.json");
		final envelopeRoot = fixtureRoot(stringField(root, "envelopeFixture", "fixtures/hxrust/model-request-envelope.v1.json"));
		final cases = arrayField(root, "cases");
		final report = ModelStreamRoutePolicy.buildCases(requests(cases, envelopeRoot));
		assertReport(root, report);
		assertEquals(Std.string(cases.length), Std.string(report.outcomes.length));

		var i = 0;
		while (i < cases.length) {
			final testCase = objectValue(cases[i]);
			final expect = objectField(testCase, "expect");
			final outcome = report.outcomes[i];
			final secretProbe = stringField(testCase, "secretProbe", "");
			assertEquals(boolText(boolField(expect, "ok", false)), boolText(outcome.ok));
			assertEquals(stringField(expect, "code", ""), outcome.code);
			assertEquals(stringField(expect, "requestId", ""), outcome.requestId);
			assertEquals(stringField(expect, "envelopeCode", ""), outcome.envelopeCode);
			assertEquals(stringField(expect, "providerId", ""), outcome.providerId);
			assertEquals(stringField(expect, "selectedModelId", ""), outcome.selectedModelId);
			assertEquals(stringField(expect, "lastModelRequestId", ""), outcome.lastModelRequestId);
			assertEquals(stringField(expect, "lastModelResponseId", ""), outcome.lastModelResponseId);
			assertEquals(boolText(boolField(expect, "completed", false)), boolText(outcome.completed));
			assertEquals(boolText(boolField(expect, "failed", false)), boolText(outcome.failed));
			assertEquals(boolText(boolField(expect, "cancelled", false)), boolText(outcome.cancelled));
			assertEquals(Std.string(intField(expect, "itemsAdded", 0)), Std.string(outcome.itemsAdded));
			assertEquals(Std.string(intField(expect, "totalTokens", 0)), Std.string(outcome.totalTokens));
			assertContains(outcome.summary(), stringField(expect, "summaryContains", ""));
			if (secretProbe.length > 0)
				assertNotContains(outcome.summary(), secretProbe);
			i = i + 1;
		}
	}

	public static function requests(values:Array<Value>, envelopeRoot:Value):Array<ModelStreamRouteRequest> {
		final out:Array<ModelStreamRouteRequest> = [];
		for (value in values) {
			final testCase = objectValue(value);
			final envelopeId = stringField(testCase, "envelopeFixtureId", "");
			out.push(new ModelStreamRouteRequest(stringField(testCase, "requestId", ""), envelopeRequestById(envelopeRoot, envelopeId),
				stringField(testCase, "upstreamRequestId", ""), events(arrayField(testCase, "events")), stringField(testCase, "secretProbe", "")));
		}
		return out;
	}

	public static function envelopeRequestById(root:Value, id:String):ModelRequestEnvelopeRequest {
		for (value in arrayField(root, "cases")) {
			final testCase = objectValue(value);
			if (stringField(testCase, "id", "") == id)
				return ModelRequestEnvelopeHarness.requests([testCase])[0];
		}
		throw "missing envelope fixture case: " + id;
	}

	public static function events(values:Array<Value>):Array<ModelStreamFixtureEvent> {
		final out:Array<ModelStreamFixtureEvent> = [];
		for (value in values) {
			final event = objectValue(value);
			out.push(new ModelStreamFixtureEvent(eventKind(stringField(event, "kind", "")), stringField(event, "itemId", ""),
				stringField(event, "responseId", ""), stringField(event, "upstreamRequestId", ""), stringField(event, "errorCode", ""),
				stringField(event, "errorMessage", ""), intField(event, "inputTokens", 0), intField(event, "outputTokens", 0),
				intField(event, "cachedInputTokens", 0), intField(event, "reasoningOutputTokens", 0), intField(event, "totalTokens", 0),
				boolField(event, "endTurn", false)));
		}
		return out;
	}

	static function eventKind(value:String):ModelStreamFixtureEventKind {
		return switch value {
			case "created": ModelStreamFixtureEventKind.Created;
			case "output_item_done": ModelStreamFixtureEventKind.OutputItemDone;
			case "completed": ModelStreamFixtureEventKind.Completed;
			case "provider_error": ModelStreamFixtureEventKind.ProviderError;
			case "stream_closed": ModelStreamFixtureEventKind.StreamClosed;
			case "consumer_dropped": ModelStreamFixtureEventKind.ConsumerDropped;
			case _: throw "invalid model stream event kind: " + value;
		}
	}

	static function assertReport(root:Value, report:ModelStreamRouteReport):Void {
		final expect = objectField(root, "expectReport");
		assertEquals(Std.string(intField(expect, "caseCount", 0)), Std.string(report.outcomes.length));
		assertEquals(Std.string(intField(expect, "successCount", 0)), Std.string(report.successCount()));
		assertEquals(Std.string(intField(expect, "errorCount", 0)), Std.string(report.errorCount()));
		assertEquals(Std.string(intField(expect, "cancelledCount", 0)), Std.string(report.cancelledCount()));
		assertEquals(Std.string(intField(expect, "envelopeDeniedCount", 0)), Std.string(report.envelopeDeniedCount()));
		assertContains(report.summary(), stringField(expect, "summaryContains", ""));
	}

	static function fixtureRoot(path:String):Value {
		return expectParse(CodexJson.parse(File.getContent(path)));
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

	static function assertContains(value:String, needle:String):Void {
		if (needle.length == 0)
			return;
		if (value.indexOf(needle) < 0)
			throw "expected to find `" + needle + "` in `" + value + "`";
	}

	static function assertNotContains(value:String, needle:String):Void {
		if (value.indexOf(needle) >= 0)
			throw "expected not to find `" + needle + "` in `" + value + "`";
	}

	static function assertEquals(expected:String, actual:String):Void {
		if (expected != actual)
			throw "expected `" + expected + "` but got `" + actual + "`";
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
