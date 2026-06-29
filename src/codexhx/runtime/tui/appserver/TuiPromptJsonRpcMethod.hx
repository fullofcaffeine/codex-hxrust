package codexhx.runtime.tui.appserver;

/**
	App-server JSON-RPC methods emitted by the minimal live prompt path.
**/
enum abstract TuiPromptJsonRpcMethod(String) to String {
	final TurnStart = "turn/start";

	public function text():String {
		return this;
	}
}
