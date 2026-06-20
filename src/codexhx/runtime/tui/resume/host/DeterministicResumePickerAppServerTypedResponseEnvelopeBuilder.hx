package codexhx.runtime.tui.resume.host;

import codexhx.protocol.json.CodexJson;

class DeterministicResumePickerAppServerTypedResponseEnvelopeBuilder {
	final envelopes:Array<ResumePickerAppServerTypedResponseEnvelope>;
	final log:Array<String>;

	public function new() {
		this.envelopes = [];
		this.log = [];
	}

	public function resolve(event:ResumePickerAppServerTypedPendingRequestEvent):ResumePickerAppServerTypedResponseEnvelope {
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

	function envelopeFor(event:ResumePickerAppServerTypedPendingRequestEvent):ResumePickerAppServerTypedResponseEnvelope {
		if (event == null)
			return envelope(ResumePickerAppServerTypedResponseEnvelopeKind.SerializationRefused, ResumePickerAppServerPendingRequestClassKind.Unknown,
				ResumePickerAppServerTypedResponsePayloadKind.JsonRpcError, "", "serverRequest/localRefusal", "",
				errorJson("missing_pending_event", "missing typed pending request event"), "", true, false);
		if (event.kind == ResumePickerAppServerTypedPendingRequestEventKind.UnsupportedRefused)
			return envelope(ResumePickerAppServerTypedResponseEnvelopeKind.RejectError, event.requestClass,
				ResumePickerAppServerTypedResponsePayloadKind.JsonRpcError, event.requestId, "reject_server_request", "",
				jsonRpcError(event.requestId, "unsupported_request_class", "unsupported app-server request class"), correlationKey(event.requestId), false,
				true);
		if (event.kind == ResumePickerAppServerTypedPendingRequestEventKind.MissingPendingRefused
			|| event.kind == ResumePickerAppServerTypedPendingRequestEventKind.StaleReplaySkipped)
			return envelope(ResumePickerAppServerTypedResponseEnvelopeKind.MissingPendingNoop, event.requestClass,
				ResumePickerAppServerTypedResponsePayloadKind.MissingPendingNoop, event.requestId, "serverRequest/noop", "", "",
				correlationKey(event.requestId), true, false);
		if (event.requestId.length == 0)
			return envelope(ResumePickerAppServerTypedResponseEnvelopeKind.SerializationRefused, event.requestClass,
				ResumePickerAppServerTypedResponsePayloadKind.JsonRpcError, "", "serverRequest/localRefusal", "",
				errorJson("missing_request_id", "typed response event has no request id"), "", true, false);

		final payloadKind = payloadKindFor(event.requestClass);
		if (payloadKind == ResumePickerAppServerTypedResponsePayloadKind.Unknown)
			return envelope(ResumePickerAppServerTypedResponseEnvelopeKind.RejectError, event.requestClass,
				ResumePickerAppServerTypedResponsePayloadKind.JsonRpcError, event.requestId, "reject_server_request", "",
				jsonRpcError(event.requestId, "unsupported_request_class", "unsupported app-server request class"), correlationKey(event.requestId), false,
				true);

		return envelope(ResumePickerAppServerTypedResponseEnvelopeKind.ResolvePayload, event.requestClass, payloadKind, event.requestId,
			"resolve_server_request", jsonRpcResult(event.requestId, responsePayload(event)), "", correlationKey(event.requestId), false, true);
	}

	function envelope(kind:ResumePickerAppServerTypedResponseEnvelopeKind, requestClass:ResumePickerAppServerPendingRequestClassKind,
			payloadKind:ResumePickerAppServerTypedResponsePayloadKind, requestId:String, method:String, payloadJson:String, errorJson:String,
			correlationKey:String, localOnly:Bool, sendIntentRecorded:Bool):ResumePickerAppServerTypedResponseEnvelope {
		return new ResumePickerAppServerTypedResponseEnvelope({
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

	static function payloadKindFor(requestClass:ResumePickerAppServerPendingRequestClassKind):ResumePickerAppServerTypedResponsePayloadKind {
		return switch requestClass {
			case ResumePickerAppServerPendingRequestClassKind.ExecApproval:
				ResumePickerAppServerTypedResponsePayloadKind.CommandExecutionApprovalResponse;
			case ResumePickerAppServerPendingRequestClassKind.FileChangeApproval:
				ResumePickerAppServerTypedResponsePayloadKind.FileChangeApprovalResponse;
			case ResumePickerAppServerPendingRequestClassKind.PermissionsApproval:
				ResumePickerAppServerTypedResponsePayloadKind.PermissionsApprovalResponse;
			case ResumePickerAppServerPendingRequestClassKind.UserInput:
				ResumePickerAppServerTypedResponsePayloadKind.ToolRequestUserInputResponse;
			case ResumePickerAppServerPendingRequestClassKind.McpElicitation:
				ResumePickerAppServerTypedResponsePayloadKind.McpElicitationResponse;
			case _:
				ResumePickerAppServerTypedResponsePayloadKind.Unknown;
		}
	}

	static function responsePayload(event:ResumePickerAppServerTypedPendingRequestEvent):String {
		return switch event.requestClass {
			case ResumePickerAppServerPendingRequestClassKind.ExecApproval:
				"{\"decision\":\"accept\"}";
			case ResumePickerAppServerPendingRequestClassKind.FileChangeApproval:
				"{\"decision\":\"apply\"}";
			case ResumePickerAppServerPendingRequestClassKind.PermissionsApproval:
				"{\"permissions\":{\"network\":{\"enabled\":true},\"fileSystem\":{\"read\":[\"/workspace/codex-hxrust\"],\"write\":[]}},\"scope\":\"session\"}";
			case ResumePickerAppServerPendingRequestClassKind.UserInput:
				"{\"answers\":{\"question\":{\"answers\":[\"yes\"]}},\"itemId\":" + CodexJson.quote(event.itemId) + "}";
			case ResumePickerAppServerPendingRequestClassKind.McpElicitation:
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
