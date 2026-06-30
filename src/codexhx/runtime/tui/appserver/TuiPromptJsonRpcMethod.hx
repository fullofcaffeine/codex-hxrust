package codexhx.runtime.tui.appserver;

/**
	App-server JSON-RPC methods emitted by the minimal live prompt path.
**/
enum abstract TuiPromptJsonRpcMethod(String) to String {
	final TurnStart = "turn/start";
	final TurnInterrupt = "turn/interrupt";

	public function text():String {
		return this;
	}
}
