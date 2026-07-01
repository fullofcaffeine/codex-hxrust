package codexhx.runtime.tui.appserver;

import codexhx.protocol.ItemId;
import codexhx.protocol.RequestId;
import codexhx.protocol.ThreadId;
import codexhx.protocol.TurnId;
import codexhx.protocol.json.CodexJson;
import haxe.json.Value;

/**
	Strict decoder for the prompt JSON-RPC subset currently modeled by the live TUI.

	Why
	- A real stdio child returns raw JSONL, while downstream prompt transport code
	  already expects typed response and stream-notification values.

	What
	- Decodes one `turn/start` response and the selected fake prompt stream
	  notification subset: thread status, turn lifecycle, user/agent item
	  lifecycle, agent message deltas, and raw response item completion.

	How
	- Treats JSON as a boundary value only. App-facing code receives concrete
	  prompt DTOs or a stable rejection code.
	- Fails unknown or incomplete records instead of using an `Unknown` fallback.
**/
class TuiPromptJsonRpcInboundLineDecoder {
	var failureCode:String;

	public function new() {
		this.failureCode = "";
	}

	public function decode(request:TuiPromptJsonRpcRequest, lines:Array<String>):TuiPromptJsonRpcInboundLineDecodeOutcome {
		failureCode = "";
		if (request == null)
			return TuiPromptJsonRpcInboundLineDecodeOutcome.rejected("missing_request");
		if (lines == null || lines.length == 0)
			return TuiPromptJsonRpcInboundLineDecodeOutcome.rejected("missing_inbound_lines");
		var response:Null<TuiPromptJsonRpcResponse> = null;
		final notifications:Array<TuiPromptJsonRpcNotification> = [];
		final streamNotifications:Array<TuiPromptJsonRpcStreamNotification> = [];
		for (index in 0...lines.length) {
			final value = parseLine(lines[index]);
			if (failed())
				return rejected();
			if (isResponse(value)) {
				if (response != null)
					return TuiPromptJsonRpcInboundLineDecodeOutcome.rejected("duplicate_response");
				response = decodeResponse(request, value);
				if (failed())
					return rejected();
			} else {
				if (!decodeStreamNotificationInto(value, notifications, streamNotifications))
					return rejected();
			}
		}
		if (response == null)
			return TuiPromptJsonRpcInboundLineDecodeOutcome.rejected("missing_response");
		return TuiPromptJsonRpcInboundLineDecodeOutcome.accepted(response, notifications, streamNotifications, []);
	}

	public function decodeStreamNotifications(lines:Array<String>):TuiPromptJsonRpcInboundLineDecodeOutcome {
		failureCode = "";
		if (lines == null || lines.length == 0)
			return TuiPromptJsonRpcInboundLineDecodeOutcome.rejected("missing_inbound_lines");
		final notifications:Array<TuiPromptJsonRpcNotification> = [];
		final streamNotifications:Array<TuiPromptJsonRpcStreamNotification> = [];
		for (index in 0...lines.length) {
			final value = parseLine(lines[index]);
			if (failed())
				return rejected();
			if (isResponse(value))
				return TuiPromptJsonRpcInboundLineDecodeOutcome.rejected("unexpected_response_line");
			if (!decodeStreamNotificationInto(value, notifications, streamNotifications))
				return rejected();
		}
		return TuiPromptJsonRpcInboundLineDecodeOutcome.accepted(null, notifications, streamNotifications, []);
	}

	function parseLine(line:String):Value {
		try {
			final parsed = CodexJson.parse(line == null ? "" : line);
			return parsed.value;
		} catch (e:haxe.Exception) {
			fail("invalid_json_line");
			return JNull;
		}
	}

	function decodeResponse(request:TuiPromptJsonRpcRequest, value:Value):TuiPromptJsonRpcResponse {
		final id = requestIdField(value, "id");
		if (failed())
			return null;
		if (id.toString() != request.requestId.toString()) {
			fail("response_id_mismatch");
			return null;
		}
		final result = field(value, "result");
		final turn = turnFromValue(field(result, "turn"), "line.result.turn");
		if (failed())
			return null;
		return TuiPromptJsonRpcResponse.turnStart(request, turn);
	}

	function decodeStreamNotificationInto(value:Value, notifications:Array<TuiPromptJsonRpcNotification>,
			streamNotifications:Array<TuiPromptJsonRpcStreamNotification>):Bool {
		final path = "line";
		final method = stringField(value, "method", path);
		if (failed())
			return false;
		final params = field(value, "params");
		if (failed())
			return false;
		if (method == TuiPromptJsonRpcNotificationMethod.ThreadStatusChanged.text()) {
			final decoded = threadStatusChanged(params, path + ".params");
			if (failed() || decoded == null)
				return false;
			streamNotifications.push(TuiPromptJsonRpcStreamNotification.ThreadStatusChanged(decoded));
			return true;
		}
		if (method == TuiPromptJsonRpcNotificationMethod.TurnStarted.text()) {
			final decoded = turnNotification(TuiPromptJsonRpcNotificationMethod.TurnStarted, params, path + ".params");
			if (failed() || decoded == null)
				return false;
			notifications.push(decoded);
			streamNotifications.push(TuiPromptJsonRpcStreamNotification.Turn(decoded));
			return true;
		}
		if (method == TuiPromptJsonRpcNotificationMethod.TurnCompleted.text()) {
			final decoded = turnNotification(TuiPromptJsonRpcNotificationMethod.TurnCompleted, params, path + ".params");
			if (failed() || decoded == null)
				return false;
			notifications.push(decoded);
			streamNotifications.push(TuiPromptJsonRpcStreamNotification.Turn(decoded));
			return true;
		}
		if (method == TuiPromptJsonRpcNotificationMethod.ItemStarted.text()) {
			final decoded = agentMessageStarted(params, path + ".params");
			if (failed() || decoded == null)
				return false;
			streamNotifications.push(TuiPromptJsonRpcStreamNotification.AgentMessageStarted(decoded));
			return true;
		}
		if (method == TuiPromptJsonRpcNotificationMethod.AgentMessageDelta.text()) {
			final decoded = agentMessageDelta(params, path + ".params");
			if (failed() || decoded == null)
				return false;
			streamNotifications.push(TuiPromptJsonRpcStreamNotification.AgentMessageDelta(decoded));
			return true;
		}
		if (method == TuiPromptJsonRpcNotificationMethod.RawResponseItemCompleted.text()) {
			final decoded = rawResponseItemCompleted(params, path + ".params");
			if (failed() || decoded == null)
				return false;
			streamNotifications.push(TuiPromptJsonRpcStreamNotification.RawResponseItemCompleted(decoded));
			return true;
		}
		if (method == TuiPromptJsonRpcNotificationMethod.ItemCompleted.text())
			return itemCompletedInto(params, path + ".params", streamNotifications);
		fail("unknown_inbound_method");
		return false;
	}

	function threadStatusChanged(params:Value, path:String):TuiPromptThreadStatusChangedNotification {
		final threadId = threadIdField(params, "threadId", path);
		final status = field(params, "status");
		final statusType = stringField(status, "type", path + ".status");
		if (failed())
			return null;
		if (statusType == "active")
			return new TuiPromptThreadStatusChangedNotification(threadId, TuiAppServerThreadStatus.Working("submitted"));
		if (statusType == "idle")
			return new TuiPromptThreadStatusChangedNotification(threadId, TuiAppServerThreadStatus.Ready("ready"));
		if (statusType == "systemError")
			return new TuiPromptThreadStatusChangedNotification(threadId, TuiAppServerThreadStatus.Failed("systemError"));
		fail("unknown_thread_status");
		return null;
	}

	function turnNotification(method:TuiPromptJsonRpcNotificationMethod, params:Value, path:String):TuiPromptJsonRpcNotification {
		final threadId = threadIdField(params, "threadId", path);
		final turn = turnFromValue(field(params, "turn"), path + ".turn");
		if (failed())
			return null;
		return new TuiPromptJsonRpcNotification(method, threadId, turn);
	}

	function itemCompletedInto(params:Value, path:String, streamNotifications:Array<TuiPromptJsonRpcStreamNotification>):Bool {
		final item = field(params, "item");
		final itemType = stringField(item, "type", path + ".item");
		if (failed())
			return false;
		if (itemType == "userMessage") {
			final decoded = userMessageCompleted(params, item, path);
			if (failed() || decoded == null)
				return false;
			streamNotifications.push(TuiPromptJsonRpcStreamNotification.UserMessageCompleted(decoded));
			return true;
		}
		if (itemType == "agentMessage") {
			final decoded = agentMessageCompleted(params, item, path);
			if (failed() || decoded == null)
				return false;
			streamNotifications.push(TuiPromptJsonRpcStreamNotification.AgentMessageCompleted(decoded));
			return true;
		}
		fail("unknown_completed_item_type");
		return false;
	}

	function userMessageCompleted(params:Value, item:Value, path:String):Null<TuiPromptUserMessageCompletedNotification> {
		final content = arrayField(item, "content");
		final first = arrayAt(content, 0);
		final text = stringField(first, "text", path + ".item.content[0]");
		if (failed())
			return null;
		return new TuiPromptUserMessageCompletedNotification(threadIdField(params, "threadId", path), turnIdField(params, "turnId", path),
			itemIdField(item, "id", path + ".item"), text, numberField(params, "completedAtMs", path));
	}

	function agentMessageStarted(params:Value, path:String):Null<TuiPromptAgentMessageStartedNotification> {
		final item = field(params, "item");
		final text = stringField(item, "text", path + ".item");
		if (failed())
			return null;
		return new TuiPromptAgentMessageStartedNotification(threadIdField(params, "threadId", path), turnIdField(params, "turnId", path),
			itemIdField(item, "id", path + ".item"), text, numberField(params, "startedAtMs", path));
	}

	function agentMessageDelta(params:Value, path:String):Null<TuiPromptAgentMessageDeltaNotification> {
		final delta = stringField(params, "delta", path);
		if (failed())
			return null;
		return new TuiPromptAgentMessageDeltaNotification(threadIdField(params, "threadId", path), turnIdField(params, "turnId", path),
			itemIdField(params, "itemId", path), delta);
	}

	function rawResponseItemCompleted(params:Value, path:String):Null<TuiPromptRawResponseItemCompletedNotification> {
		final item = field(params, "item");
		final content = arrayField(item, "content");
		final first = arrayAt(content, 0);
		final text = stringField(first, "text", path + ".item.content[0]");
		if (failed())
			return null;
		return new TuiPromptRawResponseItemCompletedNotification(threadIdField(params, "threadId", path), turnIdField(params, "turnId", path), text);
	}

	function agentMessageCompleted(params:Value, item:Value, path:String):Null<TuiPromptAgentMessageCompletedNotification> {
		final text = stringField(item, "text", path + ".item");
		if (failed())
			return null;
		return new TuiPromptAgentMessageCompletedNotification(threadIdField(params, "threadId", path), turnIdField(params, "turnId", path),
			itemIdField(item, "id", path + ".item"), text, numberField(params, "completedAtMs", path));
	}

	function turnFromValue(value:Value, path:String):TuiPromptTurnStartResponse {
		final turnId = turnIdField(value, "id", path);
		final statusText = stringField(value, "status", path);
		if (failed())
			return null;
		final status = if (statusText == TuiPromptTurnStatus.InProgress.text()) {
			TuiPromptTurnStatus.InProgress;
		} else if (statusText == TuiPromptTurnStatus.Completed.text()) {
			TuiPromptTurnStatus.Completed;
		} else {
			fail("unknown_turn_status");
			TuiPromptTurnStatus.InProgress;
		}
		if (failed())
			return null;
		return new TuiPromptTurnStartResponse(turnId, status);
	}

	function isResponse(value:Value):Bool {
		return switch value {
			case JObject(keys, _):
				contains(keys, "result");
			case _:
				false;
		}
	}

	function field(object:Value, name:String):Value {
		if (failed())
			return JNull;
		return switch object {
			case JObject(keys, values):
				var index = 0;
				while (index < keys.length && index < values.length) {
					if (keys[index] == name)
						return values[index];
					index = index + 1;
				}
				fail("missing_field");
				JNull;
			case _:
				fail("expected_object");
				JNull;
		}
	}

	function stringField(object:Value, name:String, path:String):String {
		if (failed())
			return "";
		final outcome = CodexJson.stringField(object, name, path);
		if (!outcome.ok) {
			fail(outcome.errorCode);
			return "";
		}
		return outcome.value;
	}

	function numberField(object:Value, name:String, path:String):Float {
		if (failed())
			return 0;
		final outcome = CodexJson.numberField(object, name, path);
		if (!outcome.ok) {
			fail(outcome.errorCode);
			return 0;
		}
		return outcome.value;
	}

	function arrayField(object:Value, name:String):Array<Value> {
		final value = field(object, name);
		if (failed())
			return [];
		return switch value {
			case JArray(values):
				values;
			case _:
				fail("expected_array");
				[];
		}
	}

	function arrayAt(values:Array<Value>, index:Int):Value {
		if (values == null || index < 0 || index >= values.length) {
			fail("missing_array_item");
			return JNull;
		}
		return values[index];
	}

	function requestIdField(object:Value, name:String):RequestId {
		final value = field(object, name);
		if (failed())
			return null;
		final parsed = switch value {
			case JString(text):
				RequestId.fromString(text);
			case JNumber(number):
				RequestId.fromInteger(Std.int(number));
			case _:
				null;
		};
		if (parsed == null)
			fail("invalid_request_id");
		return parsed;
	}

	function threadIdField(object:Value, name:String, path:String):ThreadId {
		final parsed = ThreadId.fromString(stringField(object, name, path));
		if (!failed() && parsed == null)
			fail("invalid_thread_id");
		return parsed;
	}

	function turnIdField(object:Value, name:String, path:String):TurnId {
		final parsed = TurnId.fromString(stringField(object, name, path));
		if (!failed() && parsed == null)
			fail("invalid_turn_id");
		return parsed;
	}

	function itemIdField(object:Value, name:String, path:String):ItemId {
		final parsed = ItemId.fromString(stringField(object, name, path));
		if (!failed() && parsed == null)
			fail("invalid_item_id");
		return parsed;
	}

	function failed():Bool {
		return failureCode.length > 0;
	}

	function rejected():TuiPromptJsonRpcInboundLineDecodeOutcome {
		return TuiPromptJsonRpcInboundLineDecodeOutcome.rejected(failureCode);
	}

	function fail(code:String):Void {
		if (failureCode.length == 0)
			failureCode = code == null || code.length == 0 ? "decode_failed" : code;
	}

	static function contains(values:Array<String>, needle:String):Bool {
		for (value in values) {
			if (value == needle)
				return true;
		}
		return false;
	}
}
