package codexhx.runtime.tui.appserver;

import codexhx.protocol.RequestId;
import codexhx.protocol.ThreadId;
import codexhx.protocol.json.CodexJson;
import haxe.json.Value;

/**
	Strict decoder for the `turn/interrupt` JSON-RPC response subset.

	The line boundary may see raw JSONL, but app-facing code only receives the
	empty-result response and projected thread-status events after typed checks.
**/
class TuiPromptTurnInterruptInboundLineDecoder {
	var failureCode:String;

	public function new() {
		this.failureCode = "";
	}

	public function decode(request:TuiPromptTurnInterruptRequest, lines:Array<String>):TuiPromptTurnInterruptInboundLineDecodeOutcome {
		failureCode = "";
		if (request == null)
			return TuiPromptTurnInterruptInboundLineDecodeOutcome.rejected("missing_request");
		if (lines == null || lines.length == 0)
			return TuiPromptTurnInterruptInboundLineDecodeOutcome.rejected("missing_inbound_lines");
		var response:Null<TuiPromptTurnInterruptResponse> = null;
		final events:Array<TuiAppServerEvent> = [];
		for (index in 0...lines.length) {
			final value = parseLine(lines[index]);
			if (failed())
				return rejected();
			if (hasField(value, "error"))
				return TuiPromptTurnInterruptInboundLineDecodeOutcome.rejected("json_rpc_error");
			if (hasField(value, "result")) {
				if (response != null)
					return TuiPromptTurnInterruptInboundLineDecodeOutcome.rejected("duplicate_response");
				response = decodeResponse(request, value);
				if (failed())
					return rejected();
			} else if (!decodeNotificationInto(value, events)) {
				return rejected();
			}
		}
		if (response == null)
			return TuiPromptTurnInterruptInboundLineDecodeOutcome.rejected("missing_response");
		return TuiPromptTurnInterruptInboundLineDecodeOutcome.accepted(response, events);
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

	function decodeResponse(request:TuiPromptTurnInterruptRequest, value:Value):TuiPromptTurnInterruptResponse {
		final id = requestIdField(value, "id");
		if (failed())
			return null;
		if (id.toString() != request.requestId.toString()) {
			fail("response_id_mismatch");
			return null;
		}
		final result = field(value, "result");
		if (failed())
			return null;
		switch result {
			case JObject(_, _):
				return TuiPromptTurnInterruptResponse.fromRequest(request);
			case _:
				fail("expected_result_object");
				return null;
		}
	}

	function decodeNotificationInto(value:Value, events:Array<TuiAppServerEvent>):Bool {
		final method = stringField(value, "method", "line");
		if (failed())
			return false;
		final params = field(value, "params");
		if (failed())
			return false;
		if (method != TuiPromptJsonRpcNotificationMethod.ThreadStatusChanged.text()) {
			fail("unknown_inbound_method");
			return false;
		}
		final threadId = threadIdField(params, "threadId", "line.params");
		final status = field(params, "status");
		final statusType = stringField(status, "type", "line.params.status");
		if (failed())
			return false;
		if (statusType == "idle") {
			events.push(TuiAppServerEvent.ThreadStatus(threadId, TuiAppServerThreadStatus.Ready("interrupted")));
			return true;
		}
		if (statusType == "active") {
			events.push(TuiAppServerEvent.ThreadStatus(threadId, TuiAppServerThreadStatus.Working("submitted")));
			return true;
		}
		if (statusType == "systemError") {
			events.push(TuiAppServerEvent.ThreadStatus(threadId, TuiAppServerThreadStatus.Failed("systemError")));
			return true;
		}
		fail("unknown_thread_status");
		return false;
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

	function hasField(value:Value, name:String):Bool {
		return switch value {
			case JObject(keys, _):
				contains(keys, name);
			case _:
				false;
		}
	}

	function failed():Bool {
		return failureCode.length > 0;
	}

	function rejected():TuiPromptTurnInterruptInboundLineDecodeOutcome {
		return TuiPromptTurnInterruptInboundLineDecodeOutcome.rejected(failureCode);
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
