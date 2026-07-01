package codexhx.runtime.tui.appserver;

/**
	Transport seam for prompt submissions from the minimal live TUI shell.

	The default implementation is still in-process and credential-free. Keeping
	it behind this typed interface lets a later JSON-RPC or embedded app-server
	transport preserve the shell-facing contract.
**/
interface TuiPromptTransport {
	function submitPrompt(envelope:TuiPromptSubmitEnvelope):TuiPromptTransportOutcome;
	function interruptTurn(envelope:TuiPromptTurnInterruptEnvelope):TuiPromptTurnInterruptOutcome;
	function drainSubmittedTurnLateJsonl(facade:FakeTuiAppServerFacade, maxLinesPerBatch:Int, maxBatches:Int):TuiPromptSubmittedTurnLateJsonlDrainResult;
	function shutdown(code:String):TuiPromptTransportShutdownReport;
}
