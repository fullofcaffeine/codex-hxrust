import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.protocol.json.JsonValueCodec;
import codexhx.runtime.app.CodexRuntimeCommand;
import codexhx.runtime.app.CodexRuntimeEvent;
import codexhx.runtime.app.CodexRuntimeEventDelivery;
import codexhx.runtime.app.CodexRuntimeEventKind;
import codexhx.runtime.app.CodexRuntimeNotificationDelivery;
import codexhx.runtime.app.InMemoryAppServerClient;
import codexhx.runtime.app.RuntimeClientOutcome;
import haxe.json.Value;
import sys.io.File;

class RuntimeAppClientHarness {
	static function main():Void {
		classifiesNotificationsLikeUpstream();
		correlatesRequestsAndResponses();
		emitsLagMarkersForBestEffortDrops();
		blocksLosslessWhenConsumerCapacityIsFull();
	}

	static function classifiesNotificationsLikeUpstream():Void {
		assertTrue(CodexRuntimeNotificationDelivery.requiresDelivery("turn/completed"), "turn completion must be lossless");
		assertTrue(CodexRuntimeNotificationDelivery.requiresDelivery("thread/settings/updated"), "settings update must be lossless");
		assertTrue(CodexRuntimeNotificationDelivery.requiresDelivery("item/completed"), "item completion must be lossless");
		assertTrue(CodexRuntimeNotificationDelivery.requiresDelivery("item/agentMessage/delta"), "assistant deltas must be lossless");
		assertTrue(CodexRuntimeNotificationDelivery.requiresDelivery("item/plan/delta"), "plan deltas must be lossless");
		assertTrue(CodexRuntimeNotificationDelivery.requiresDelivery("item/reasoning/summaryTextDelta"), "reasoning summary deltas must be lossless");
		assertTrue(CodexRuntimeNotificationDelivery.requiresDelivery("item/reasoning/textDelta"), "reasoning text deltas must be lossless");
		assertFalse(CodexRuntimeNotificationDelivery.requiresDelivery("thread/status/changed"), "status changes are best-effort");
		assertFalse(CodexRuntimeNotificationDelivery.requiresDelivery("command/exec/outputDelta"), "command output deltas are best-effort");
	}

	static function correlatesRequestsAndResponses():Void {
		final root = fixtureRoot();
		final request = objectField(root, "request");
		final client = new InMemoryAppServerClient(4);
		final requestId = stringField(request, "requestId");
		final method = stringField(request, "method");
		final paramsJson = JsonValueCodec.encode(valueField(request, "params"));
		final resultJson = JsonValueCodec.encode(valueField(request, "result"));

		final accepted = client.send(CodexRuntimeCommand.appRequest(requestId, method, paramsJson));
		assertOutcome(accepted, true, "accepted");
		assertEquals("1", Std.string(accepted.pendingCount));
		assertContains(accepted.canonicalJson, "\"method\":\"turn/interrupt\"");

		final duplicate = client.send(CodexRuntimeCommand.appRequest(requestId, method, paramsJson));
		assertOutcome(duplicate, false, "duplicate_request_id");
		assertEquals("1", Std.string(duplicate.pendingCount));

		final invalid = client.send(CodexRuntimeCommand.appRequest("runtime-req-invalid", method, "{}"));
		assertOutcome(invalid, false, "invalid_request:missing_field");
		assertEquals("1", Std.string(invalid.pendingCount));

		final completed = client.complete(CodexRuntimeCommand.completeResponse(requestId, method, resultJson));
		assertOutcome(completed, true, "completed");
		assertEquals("0", Std.string(completed.pendingCount));
		assertEquals("1", Std.string(client.queuedCount()));

		final read = client.readEvent();
		assertTrue(read.ok, "expected response event");
		final event = read.event;
		assertEquals(CodexRuntimeEventKind.ClientResponse, event.kind);
		assertEquals(CodexRuntimeEventDelivery.Control, event.delivery);
		assertEquals(requestId, event.requestId);
		assertEquals(method, event.method);
		assertContains(event.payloadJson, "\"id\":\"runtime-req-1\"");

		final unknown = client.complete(CodexRuntimeCommand.completeResponse(requestId, method, resultJson));
		assertOutcome(unknown, false, "unknown_request_id");
	}

	static function emitsLagMarkersForBestEffortDrops():Void {
		final root = fixtureRoot();
		final bestStatus = notification(root, "best-thread-status");
		final bestCommand = notification(root, "best-command-output");
		final losslessDelta = notification(root, "lossless-agent-delta");
		final client = new InMemoryAppServerClient(2);

		assertOutcome(client.receiveNotification(stringField(bestStatus, "method"), JsonValueCodec.encode(valueField(bestStatus, "params"))), true, "queued");
		assertOutcome(client.receiveNotification(stringField(bestCommand, "method"), JsonValueCodec.encode(valueField(bestCommand, "params"))), true, "queued");

		final dropped = client.receiveNotification(stringField(bestStatus, "method"), JsonValueCodec.encode(valueField(bestStatus, "params")));
		assertOutcome(dropped, true, "best_effort_dropped");
		assertEquals("1", Std.string(client.skippedCount()));

		final drainedBestEffort = client.drainEventSummaries().join("\n");
		assertContains(drainedBestEffort, "serverNotification:bestEffort:thread/status/changed");
		assertContains(drainedBestEffort, "serverNotification:bestEffort:command/exec/outputDelta");

		final queuedLossless = client.receiveNotification(stringField(losslessDelta, "method"), JsonValueCodec.encode(valueField(losslessDelta, "params")));
		assertOutcome(queuedLossless, true, "queued");
		assertEquals("2", Std.string(client.queuedCount()));
		assertEquals("0", Std.string(client.skippedCount()));

		final summaries = client.drainEventSummaries().join("\n");
		assertContains(summaries, ":lagged:bestEffort:::");
		assertContains(summaries, "lagged:1");
		assertContains(summaries, "serverNotification:lossless:item/agentMessage/delta");
	}

	static function blocksLosslessWhenConsumerCapacityIsFull():Void {
		final root = fixtureRoot();
		final losslessDelta = notification(root, "lossless-agent-delta");
		final client = new InMemoryAppServerClient(1);

		final first = client.receiveNotification(stringField(losslessDelta, "method"), JsonValueCodec.encode(valueField(losslessDelta, "params")));
		assertOutcome(first, true, "queued");

		final blocked = client.receiveNotification(stringField(losslessDelta, "method"), JsonValueCodec.encode(valueField(losslessDelta, "params")));
		assertOutcome(blocked, false, "lossless_backpressure");
		assertEquals("1", Std.string(client.queuedCount()));
	}

	static function fixtureRoot():Value {
		return expectParse(CodexJson.parse(File.getContent("fixtures/hxrust/runtime-app-client.v1.json")));
	}

	static function notification(root:Value, id:String):Value {
		final values = arrayField(root, "notifications");
		for (value in values) {
			final object = objectValue(value);
			if (stringField(object, "id") == id)
				return object;
		}
		throw "missing notification fixture: " + id;
	}

	static function valueField(object:Value, name:String):Value {
		return switch object {
			case JObject(keys, values):
				var i = 0;
				while (i < keys.length) {
					if (keys[i] == name)
						return values[i];
					i = i + 1;
				}
				throw "missing field: " + name;
			case _:
				throw "expected object for field: " + name;
		}
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

	static function stringField(object:Value, name:String):String {
		return switch valueField(object, name) {
			case JString(value): value;
			case _: throw "expected string field: " + name;
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

	static function assertOutcome(outcome:RuntimeClientOutcome, ok:Bool, code:String):Void {
		assertEquals(ok ? "true" : "false", outcome.ok ? "true" : "false");
		assertEquals(code, outcome.code);
	}

	static function assertEquals(expected:String, actual:String):Void {
		if (expected != actual)
			throw "expected " + expected + " but got " + actual;
	}

	static function assertTrue(value:Bool, message:String):Void {
		if (!value)
			throw message;
	}

	static function assertFalse(value:Bool, message:String):Void {
		if (value)
			throw message;
	}

	static function assertContains(haystack:String, needle:String):Void {
		if (haystack.indexOf(needle) < 0)
			throw "expected to find " + needle + " in " + haystack;
	}
}
