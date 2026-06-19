package codexhx.runtime.app;

import codexhx.protocol.app.AppProtocol;
import codexhx.protocol.app.AppProtocolParseOutcome;
import codexhx.protocol.json.CodexJson;
import haxe.ds.StringMap;

class InMemoryAppServerClient {
	final queue:CodexRuntimeEventQueue;
	final pending:StringMap<CodexRuntimeCommand>;
	var pendingTotal:Int;

	public function new(queueCapacity:Int) {
		this.queue = new CodexRuntimeEventQueue(queueCapacity);
		this.pending = new StringMap();
		this.pendingTotal = 0;
	}

	public function send(command:CodexRuntimeCommand):RuntimeClientOutcome {
		if (command.kind != CodexRuntimeCommandKind.AppRequest) {
			return RuntimeClientOutcome.failure("unsupported_command_kind", "send accepts only app request commands", command.requestId, command.method,
				pendingTotal);
		}
		if (pending.exists(command.requestId)) {
			return RuntimeClientOutcome.failure("duplicate_request_id", "request id already has a pending response", command.requestId, command.method,
				pendingTotal);
		}

		final parsed = parseFixture(wrapRequest(command));
		if (!parsed.ok) {
			return RuntimeClientOutcome.failure("invalid_request:" + parsed.errorCode, parsed.errorMessage, command.requestId, command.method, pendingTotal);
		}

		pending.set(command.requestId, command);
		pendingTotal = pendingTotal + 1;
		return RuntimeClientOutcome.accepted(command, parsed.message.canonicalJson, pendingTotal);
	}

	public function complete(command:CodexRuntimeCommand):RuntimeClientOutcome {
		if (command.kind != CodexRuntimeCommandKind.CompleteResponse) {
			return RuntimeClientOutcome.failure("unsupported_command_kind", "complete accepts only response completion commands", command.requestId,
				command.method, pendingTotal);
		}

		final original = pending.get(command.requestId);
		if (original == null) {
			return RuntimeClientOutcome.failure("unknown_request_id", "no pending request for response", command.requestId, command.method, pendingTotal);
		}
		if (original.method != command.method) {
			return RuntimeClientOutcome.failure("response_method_mismatch", "response method differs from pending request method", command.requestId,
				command.method, pendingTotal);
		}

		final parsed = parseFixture(wrapResponse(command));
		if (!parsed.ok) {
			return RuntimeClientOutcome.failure("invalid_response:" + parsed.errorCode, parsed.errorMessage, command.requestId, command.method, pendingTotal);
		}

		pending.remove(command.requestId);
		pendingTotal = pendingTotal - 1;
		final queued = queue.pushResponse(command.requestId, command.method, parsed.message.canonicalJson);
		return RuntimeClientOutcome.evented("completed", command.requestId, command.method, parsed.message.canonicalJson, queued, pendingTotal);
	}

	public function fail(command:CodexRuntimeCommand):RuntimeClientOutcome {
		if (command.kind != CodexRuntimeCommandKind.FailResponse) {
			return RuntimeClientOutcome.failure("unsupported_command_kind", "fail accepts only response failure commands", command.requestId, command.method,
				pendingTotal);
		}

		final original = pending.get(command.requestId);
		if (original == null) {
			return RuntimeClientOutcome.failure("unknown_request_id", "no pending request for failure", command.requestId, command.method, pendingTotal);
		}
		if (original.method != command.method) {
			return RuntimeClientOutcome.failure("response_method_mismatch", "failure method differs from pending request method", command.requestId,
				command.method, pendingTotal);
		}

		final parsed = CodexJson.parse(command.payloadJson);
		if (!parsed.ok) {
			return RuntimeClientOutcome.failure("invalid_error_json", parsed.errorMessage, command.requestId, command.method, pendingTotal);
		}

		pending.remove(command.requestId);
		pendingTotal = pendingTotal - 1;
		final queued = queue.pushError(command.requestId, command.method, command.payloadJson, "error:" + command.method);
		return RuntimeClientOutcome.evented("failed", command.requestId, command.method, command.payloadJson, queued, pendingTotal);
	}

	public function cancelPending(requestId:String, method:String, reason:String):RuntimeClientOutcome {
		final original = pending.get(requestId);
		if (original == null) {
			return RuntimeClientOutcome.failure("unknown_request_id", "no pending request for cancellation", requestId, method, pendingTotal);
		}
		if (original.method != method) {
			return RuntimeClientOutcome.failure("response_method_mismatch", "cancellation method differs from pending request method", requestId, method,
				pendingTotal);
		}

		pending.remove(requestId);
		pendingTotal = pendingTotal - 1;
		final payloadJson = "{\"code\":-32800,\"message\":" + quote(reason) + "}";
		final queued = queue.pushError(requestId, method, payloadJson, "cancelled:" + method);
		return RuntimeClientOutcome.evented("cancelled", requestId, method, payloadJson, queued, pendingTotal);
	}

	public function receiveNotification(method:String, paramsJson:String):RuntimeClientOutcome {
		final parsed = parseFixture(wrapNotification(method, paramsJson));
		if (!parsed.ok) {
			return RuntimeClientOutcome.failure("invalid_notification:" + parsed.errorCode, parsed.errorMessage, "", method, pendingTotal);
		}

		final queued = queue.pushNotification(method, parsed.message.canonicalJson, parsed.message.summary);
		return RuntimeClientOutcome.evented(queued.code, "", method, parsed.message.canonicalJson, queued, pendingTotal);
	}

	public function disconnect(message:String):RuntimeClientOutcome {
		final queued = queue.pushDisconnected(message);
		return RuntimeClientOutcome.evented("disconnected", "", "", "{\"message\":" + quote(message) + "}", queued, pendingTotal);
	}

	public function readEvent():RuntimeEventReadOutcome {
		return queue.readEvent();
	}

	public function drainEventSummaries():Array<String> {
		return queue.drainSummaries();
	}

	public function queuedCount():Int {
		return queue.pendingCount();
	}

	public function pendingRequestCount():Int {
		return pendingTotal;
	}

	public function skippedCount():Int {
		return queue.skippedCount();
	}

	function parseFixture(json:String):AppProtocolParseOutcome {
		final parsed = CodexJson.parse(json);
		if (!parsed.ok) {
			return AppProtocolParseOutcome.failure(parsed.errorCode, parsed.errorPath, parsed.errorMessage);
		}
		return AppProtocol.parseFixtureItem(parsed.value);
	}

	function wrapRequest(command:CodexRuntimeCommand):String {
		return "{\"id\":" + quote("runtime-request-" + command.requestId) + ",\"kind\":\"request\",\"method\":" + quote(command.method)
			+ ",\"message\":{\"jsonrpc\":\"2.0\",\"id\":" + quote(command.requestId) + ",\"method\":" + quote(command.method) + ",\"params\":"
			+ command.payloadJson + "}}";
	}

	function wrapResponse(command:CodexRuntimeCommand):String {
		return "{\"id\":" + quote("runtime-response-" + command.requestId) + ",\"kind\":\"response\",\"method\":" + quote(command.method)
			+ ",\"message\":{\"jsonrpc\":\"2.0\",\"id\":" + quote(command.requestId) + ",\"result\":" + command.payloadJson + "}}";
	}

	function wrapNotification(method:String, paramsJson:String):String {
		return "{\"id\":" + quote("runtime-notification-" + method) + ",\"kind\":\"notification\",\"method\":" + quote(method)
			+ ",\"message\":{\"jsonrpc\":\"2.0\",\"method\":" + quote(method) + ",\"params\":" + paramsJson + "}}";
	}

	static function quote(value:String):String {
		var out = "\"";
		var i = 0;
		while (i < value.length) {
			final ch = value.charAt(i);
			out += switch ch {
				case "\\": "\\\\";
				case "\"": "\\\"";
				case "\n": "\\n";
				case "\r": "\\r";
				case "\t": "\\t";
				case _: ch;
			}
			i = i + 1;
		}
		return out + "\"";
	}
}
