package codexhx.runtime.tui.appserver;

/**
	Transport-level status for the app-server JSON-RPC prompt boundary.
**/
enum abstract TuiAppServerJsonRpcTransportStatus(String) to String {
	final Accepted = "accepted";
	final Rejected = "rejected";
	final Disconnected = "disconnected";

	public function text():String {
		return this;
	}
}
