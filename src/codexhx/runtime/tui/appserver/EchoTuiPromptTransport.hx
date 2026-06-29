package codexhx.runtime.tui.appserver;

/**
	Credential-free prompt transport used by the minimal live shell.

	It preserves the existing fake app-server behavior while making the transport
	boundary explicit: submitted prompts produce working, assistant delta, and
	ready events for the target thread.
**/
class EchoTuiPromptTransport implements TuiPromptTransport {
	public function new() {}

	public function submitPrompt(envelope:TuiPromptSubmitEnvelope):TuiPromptTransportOutcome {
		if (envelope == null)
			return TuiPromptTransportOutcome.rejected("missing_envelope");
		return TuiPromptTransportOutcome.accepted([
			TuiAppServerEvent.ThreadStatus(envelope.threadId, TuiAppServerThreadStatus.Working("submitted")),
			TuiAppServerEvent.AssistantDelta(envelope.threadId, "echo: " + envelope.promptText),
			TuiAppServerEvent.ThreadStatus(envelope.threadId, TuiAppServerThreadStatus.Ready("ready"))
		]);
	}
}
