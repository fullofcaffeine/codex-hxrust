package codexhx.runtime.tui.appserver;

/**
	Credential-free app-server JSON-RPC transport backed by a fake wire session.
**/
class FakeTuiAppServerJsonRpcTransport implements TuiAppServerJsonRpcTransport {
	final wireSession:TuiAppServerJsonRpcWireSession;

	public function new(?exchange:TuiPromptJsonRpcExchange, ?wireSession:TuiAppServerJsonRpcWireSession) {
		this.wireSession = wireSession == null ? new FakeTuiAppServerJsonRpcWireSession(exchange) : wireSession;
	}

	public function sendPrompt(request:TuiPromptJsonRpcRequest, envelope:TuiPromptSubmitEnvelope):TuiAppServerJsonRpcTransportOutcome {
		if (request == null)
			return TuiAppServerJsonRpcTransportOutcome.rejected("missing_request");
		final outbound = TuiAppServerJsonRpcTransportTranscript.outbound(request);
		if (envelope == null)
			return TuiAppServerJsonRpcTransportOutcome.rejected("missing_envelope", outbound);
		final outboundRecord = TuiPromptJsonRpcFrameCodec.record(0, TuiPromptJsonRpcFrame.Request(request));
		final outcome = wireSession.sendPrompt(request, envelope, outboundRecord);
		if (outcome == null)
			return TuiAppServerJsonRpcTransportOutcome.rejected("missing_wire_outcome", outbound);
		final transcript = new TuiAppServerJsonRpcTransportTranscript(request, outcome.inboundFrames());
		if (!outcome.isAccepted())
			return TuiAppServerJsonRpcTransportOutcome.rejected(outcome.code(), transcript);
		return TuiAppServerJsonRpcTransportOutcome.accepted(outcome.response(), outcome.notifications(), outcome.streamNotifications(), outcome.events(),
			transcript);
	}

	public function shutdown(code:String):TuiPromptTransportShutdownReport {
		return TuiPromptTransportShutdownReport.noLineClose(code);
	}
}
