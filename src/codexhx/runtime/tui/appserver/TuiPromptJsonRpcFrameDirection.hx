package codexhx.runtime.tui.appserver;

/**
	Local direction of a JSON-RPC prompt frame relative to the TUI client.
**/
enum abstract TuiPromptJsonRpcFrameDirection(String) to String {
	final Outbound = "outbound";
	final Inbound = "inbound";

	public function text():String {
		return this;
	}
}
