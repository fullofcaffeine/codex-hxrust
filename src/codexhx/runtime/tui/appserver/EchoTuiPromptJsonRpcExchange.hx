package codexhx.runtime.tui.appserver;

/**
	In-process JSON-RPC exchange that produces the fake live prompt response.
**/
class EchoTuiPromptJsonRpcExchange implements TuiPromptJsonRpcExchange {
	public function new() {}

	public function send(request:TuiPromptJsonRpcRequest, envelope:TuiPromptSubmitEnvelope):TuiPromptJsonRpcExchangeOutcome {
		if (request == null)
			return TuiPromptJsonRpcExchangeOutcome.rejected("missing_request");
		if (envelope == null)
			return TuiPromptJsonRpcExchangeOutcome.rejected("missing_envelope");
		final turn = TuiPromptTurnStartResponse.fromEnvelope(envelope);
		final response = TuiPromptJsonRpcResponse.turnStart(request, turn);
		final notification = TuiPromptJsonRpcNotification.turnStarted(envelope, turn);
		return TuiPromptJsonRpcExchangeOutcome.accepted(response, [notification], [
			TuiAppServerEvent.ThreadStatus(envelope.threadId, TuiAppServerThreadStatus.Working("submitted")),
			TuiAppServerEvent.AssistantDelta(envelope.threadId, "echo: " + envelope.promptText),
			TuiAppServerEvent.ThreadStatus(envelope.threadId, TuiAppServerThreadStatus.Ready("ready"))
		]);
	}
}
