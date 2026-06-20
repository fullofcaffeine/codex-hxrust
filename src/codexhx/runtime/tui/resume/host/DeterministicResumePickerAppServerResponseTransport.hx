package codexhx.runtime.tui.resume.host;

import codexhx.protocol.json.CodexJson;

class DeterministicResumePickerAppServerResponseTransport {
	final envelopes:Array<ResumePickerAppServerResponseTransportEnvelope>;
	final log:Array<String>;

	public function new() {
		this.envelopes = [];
		this.log = [];
	}

	public function enqueue(command:ResumePickerAppServerRequestDispatchCommand):ResumePickerAppServerResponseTransportEnvelope {
		final envelope = envelopeFor(command);
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

	public function count():Int {
		return envelopes.length;
	}

	function envelopeFor(command:ResumePickerAppServerRequestDispatchCommand):ResumePickerAppServerResponseTransportEnvelope {
		if (command == null)
			return envelope(ResumePickerAppServerResponseTransportEnvelopeKind.LocalSerializationRefusal,
				ResumePickerAppServerRequestDispatchCommandKind.Unknown, "", "serverRequest/localRefusal", "",
				errorJson("missing_command", "missing dispatch command"), "", true, false, false, true);

		return switch command.kind {
			case ResumePickerAppServerRequestDispatchCommandKind.ResolveServerRequest:
				envelope(ResumePickerAppServerResponseTransportEnvelopeKind.ResolveResult, command.kind, command.requestId, "resolve_server_request",
					resultPayload(command), "", correlationKey(command), false, command.transportSendIntentRecorded, command.liveTransportAttempted,
					command.liveTransportSuppressed);
			case ResumePickerAppServerRequestDispatchCommandKind.RejectServerRequest:
				envelope(ResumePickerAppServerResponseTransportEnvelopeKind.RejectError, command.kind, command.requestId, "reject_server_request", "",
					errorPayload(command), correlationKey(command), false, command.transportSendIntentRecorded, command.liveTransportAttempted,
					command.liveTransportSuppressed);
			case ResumePickerAppServerRequestDispatchCommandKind.SendFailed:
				envelope(ResumePickerAppServerResponseTransportEnvelopeKind.SendFailure, command.kind, command.requestId, methodForIntent(command), "",
					errorPayload(command), correlationKey(command), false, command.transportSendIntentRecorded, command.liveTransportAttempted,
					command.liveTransportSuppressed);
			case ResumePickerAppServerRequestDispatchCommandKind.MissingSessionNoop:
				envelope(ResumePickerAppServerResponseTransportEnvelopeKind.LocalNoop, command.kind, command.requestId, "serverRequest/noop", "", "",
					correlationKey(command), true, command.transportSendIntentRecorded, command.liveTransportAttempted, command.liveTransportSuppressed);
			case ResumePickerAppServerRequestDispatchCommandKind.SerializationRefused:
				envelope(ResumePickerAppServerResponseTransportEnvelopeKind.LocalSerializationRefusal, command.kind, command.requestId,
					"serverRequest/localRefusal", "", errorPayload(command), correlationKey(command), true, command.transportSendIntentRecorded,
					command.liveTransportAttempted, command.liveTransportSuppressed);
			case _:
				envelope(ResumePickerAppServerResponseTransportEnvelopeKind.LocalSerializationRefusal, command.kind, command.requestId,
					"serverRequest/localRefusal", "", errorPayload(command), correlationKey(command), true, command.transportSendIntentRecorded,
					command.liveTransportAttempted, command.liveTransportSuppressed);
		}
	}

	function envelope(kind:ResumePickerAppServerResponseTransportEnvelopeKind, commandKind:ResumePickerAppServerRequestDispatchCommandKind, requestId:String,
			method:String, payloadJson:String, errorJson:String, correlationKey:String, localOnly:Bool, sendIntentRecorded:Bool, liveTransportAttempted:Bool,
			liveTransportSuppressed:Bool):ResumePickerAppServerResponseTransportEnvelope {
		return new ResumePickerAppServerResponseTransportEnvelope({
			kind: kind,
			commandKind: commandKind,
			requestId: requestId,
			method: method,
			payloadJson: payloadJson,
			errorJson: errorJson,
			correlationKey: correlationKey,
			localOnly: localOnly,
			sendIntentRecorded: sendIntentRecorded,
			liveTransportAttempted: liveTransportAttempted,
			liveTransportSuppressed: liveTransportSuppressed
		});
	}

	static function resultPayload(command:ResumePickerAppServerRequestDispatchCommand):String {
		return "{\"jsonrpc\":\"2.0\",\"id\":" + CodexJson.quote(command.requestId) + ",\"result\":" + command.responseJson + "}";
	}

	static function errorPayload(command:ResumePickerAppServerRequestDispatchCommand):String {
		final code = command.errorCode.length == 0 ? "app_server_request_rejected" : command.errorCode;
		final message = command.errorMessage.length == 0 ? "app-server request rejected" : command.errorMessage;
		return "{\"jsonrpc\":\"2.0\",\"id\":" + CodexJson.quote(command.requestId) + ",\"error\":" + errorJson(code, message) + "}";
	}

	static function errorJson(code:String, message:String):String {
		return "{\"code\":" + CodexJson.quote(code) + ",\"message\":" + CodexJson.quote(message) + "}";
	}

	static function methodForIntent(command:ResumePickerAppServerRequestDispatchCommand):String {
		return command.intentKind == ResumePickerAppServerRequestResponseIntentKind.Resolved ? "resolve_server_request" : "reject_server_request";
	}

	static function correlationKey(command:ResumePickerAppServerRequestDispatchCommand):String {
		return command.requestId.length == 0 ? "local:" + command.errorCode : "server:" + command.requestId;
	}
}
