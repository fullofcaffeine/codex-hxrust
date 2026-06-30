package codexhx.runtime.tui.appserver;

/**
	Result status for opening an app-server JSON-RPC line connection.
**/
enum abstract TuiAppServerJsonRpcLineOpenOutcomeStatus(String) to String {
	final Opened = "opened";
	final Refused = "refused";

	public function text():String {
		return this;
	}
}
