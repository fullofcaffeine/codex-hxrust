package codexhx.runtime.tui.resume.host;

import codexhx.protocol.json.CodexJson;

class EnvelopeBuilder {
	final envelopes:Array<Envelope>;
	final log:Array<String>;

	public function new() {
		this.envelopes = [];
		this.log = [];
	}

	public function resolve(event:TypedPendingRequestEvent):Envelope {
		final envelope = envelopeFor(event);
		envelopes.push(envelope);
		log.push("envelope:" + envelope.summary());
		return envelope;
	}

	public function summaries():Array<String> {
		return log.copy();
	}

	public function envelopeSummaries():Array<String> {
		final out:Array<String> = [];
		for (envelope in envelopes)
			out.push(envelope.summary());
		return out;
	}

	function envelopeFor(event:TypedPendingRequestEvent):Envelope {
		if (event == null)
			return envelope(EnvelopeKind.SerializationRefused, PendingRequestClassKind.Unknown, PayloadKind.JsonRpcError, "", "serverRequest/localRefusal",
				"", errorJson("missing_pending_event", "missing typed pending request event"), "", true, false);
		if (event.kind == TypedPendingRequestEventKind.UnsupportedRefused)
			return envelope(EnvelopeKind.RejectError, event.requestClass, PayloadKind.JsonRpcError, event.requestId, "reject_server_request", "",
				jsonRpcError(event.requestId, "unsupported_request_class", "unsupported app-server request class"), correlationKey(event.requestId), false,
				true);
		if (event.kind == TypedPendingRequestEventKind.MissingPendingRefused
			|| event.kind == TypedPendingRequestEventKind.StaleReplaySkipped)
			return envelope(EnvelopeKind.MissingPendingNoop, event.requestClass, PayloadKind.MissingPendingNoop, event.requestId, "serverRequest/noop", "",
				"", correlationKey(event.requestId), true, false);
		if (event.requestId.length == 0)
			return envelope(EnvelopeKind.SerializationRefused, event.requestClass, PayloadKind.JsonRpcError, "", "serverRequest/localRefusal", "",
				errorJson("missing_request_id", "typed response event has no request id"), "", true, false);

		final payloadKind = payloadKindFor(event.requestClass);
		if (payloadKind == PayloadKind.Unknown)
			return envelope(EnvelopeKind.RejectError, event.requestClass, PayloadKind.JsonRpcError, event.requestId, "reject_server_request", "",
				jsonRpcError(event.requestId, "unsupported_request_class", "unsupported app-server request class"), correlationKey(event.requestId), false,
				true);

		return envelope(EnvelopeKind.ResolvePayload, event.requestClass, payloadKind, event.requestId, "resolve_server_request",
			jsonRpcResult(event.requestId, responsePayload(event)), "", correlationKey(event.requestId), false, true);
	}

	function envelope(kind:EnvelopeKind, requestClass:PendingRequestClassKind, payloadKind:PayloadKind, requestId:String, method:String, payloadJson:String,
			errorJson:String, correlationKey:String, localOnly:Bool, sendIntentRecorded:Bool):Envelope {
		return new Envelope({
			kind: kind,
			requestClass: requestClass,
			payloadKind: payloadKind,
			requestId: requestId,
			method: method,
			payloadJson: payloadJson,
			errorJson: errorJson,
			correlationKey: correlationKey,
			localOnly: localOnly,
			sendIntentRecorded: sendIntentRecorded,
			liveTransportAttempted: false,
			liveTransportSuppressed: true
		});
	}

	static function payloadKindFor(requestClass:PendingRequestClassKind):PayloadKind {
		return switch requestClass {
			case PendingRequestClassKind.ExecApproval:
				PayloadKind.CommandExecutionApprovalResponse;
			case PendingRequestClassKind.FileChangeApproval:
				PayloadKind.FileChangeApprovalResponse;
			case PendingRequestClassKind.PermissionsApproval:
				PayloadKind.PermissionsApprovalResponse;
			case PendingRequestClassKind.UserInput:
				PayloadKind.ToolRequestUserInputResponse;
			case PendingRequestClassKind.McpElicitation:
				PayloadKind.McpElicitationResponse;
			case _:
				PayloadKind.Unknown;
		}
	}

	static function responsePayload(event:TypedPendingRequestEvent):String {
		return switch event.requestClass {
			case PendingRequestClassKind.ExecApproval:
				"{\"decision\":\"accept\"}";
			case PendingRequestClassKind.FileChangeApproval:
				"{\"decision\":\"apply\"}";
			case PendingRequestClassKind.PermissionsApproval:
				"{\"permissions\":{\"network\":{\"enabled\":true},\"fileSystem\":{\"read\":[\"/workspace/codex-hxrust\"],\"write\":[]}},\"scope\":\"session\"}";
			case PendingRequestClassKind.UserInput:
				"{\"answers\":{\"question\":{\"answers\":[\"yes\"]}},\"itemId\":" + CodexJson.quote(event.itemId) + "}";
			case PendingRequestClassKind.McpElicitation:
				"{\"action\":\"accept\",\"content\":{\"answer\":\"yes\"},\"_meta\":{\"source\":\"resume_picker\",\"server\":" +
				CodexJson.quote(event.serverName) + "}}";
			case _:
				"{}";
		}
	}

	static function jsonRpcResult(requestId:String, payloadJson:String):String {
		return "{\"jsonrpc\":\"2.0\",\"id\":" + CodexJson.quote(requestId) + ",\"result\":" + payloadJson + "}";
	}

	static function jsonRpcError(requestId:String, code:String, message:String):String {
		return "{\"jsonrpc\":\"2.0\",\"id\":" + CodexJson.quote(requestId) + ",\"error\":" + errorJson(code, message) + "}";
	}

	static function errorJson(code:String, message:String):String {
		return "{\"code\":" + CodexJson.quote(code) + ",\"message\":" + CodexJson.quote(message) + "}";
	}

	static function correlationKey(requestId:String):String {
		return requestId.length == 0 ? "local:missing-request" : "server:" + requestId;
	}
}
