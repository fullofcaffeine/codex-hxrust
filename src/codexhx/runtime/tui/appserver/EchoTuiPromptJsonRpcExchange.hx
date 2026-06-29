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
		final started = TuiPromptJsonRpcNotification.turnStarted(envelope, turn);
		final userCompleted = TuiPromptUserMessageCompletedNotification.fromEnvelope(envelope, turn);
		final delta = TuiPromptAgentMessageDeltaNotification.fromEnvelope(envelope, turn);
		final itemStarted = TuiPromptAgentMessageStartedNotification.fromDelta(delta);
		final itemCompleted = TuiPromptAgentMessageCompletedNotification.fromDelta(delta);
		final completed = TuiPromptJsonRpcNotification.turnCompleted(envelope, turn);
		return TuiPromptJsonRpcExchangeOutcome.accepted(response, [started, completed], [
			TuiPromptJsonRpcStreamNotification.Turn(started),
			TuiPromptJsonRpcStreamNotification.UserMessageCompleted(userCompleted),
			TuiPromptJsonRpcStreamNotification.AgentMessageStarted(itemStarted),
			TuiPromptJsonRpcStreamNotification.AgentMessageDelta(delta),
			TuiPromptJsonRpcStreamNotification.AgentMessageCompleted(itemCompleted),
			TuiPromptJsonRpcStreamNotification.Turn(completed)
		], []);
	}
}
