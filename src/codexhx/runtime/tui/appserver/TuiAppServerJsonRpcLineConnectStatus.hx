package codexhx.runtime.tui.appserver;

/**
	Result status for the app-server JSON-RPC line endpoint connection pipeline.
**/
enum abstract TuiAppServerJsonRpcLineConnectStatus(String) to String {
	final Ready = "ready";
	final Refused = "refused";

	public function text():String {
		return this;
	}
}
