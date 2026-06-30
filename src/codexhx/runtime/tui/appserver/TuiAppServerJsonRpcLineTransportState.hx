package codexhx.runtime.tui.appserver;

/**
	Connection state for an app-server JSON-RPC line transport.
**/
enum abstract TuiAppServerJsonRpcLineTransportState(String) to String {
	final Open = "open";
	final Closed = "closed";

	public function text():String {
		return this;
	}
}
