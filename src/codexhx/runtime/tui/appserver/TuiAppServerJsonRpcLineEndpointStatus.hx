package codexhx.runtime.tui.appserver;

/**
	Validation status for an app-server line endpoint plan.
**/
enum abstract TuiAppServerJsonRpcLineEndpointStatus(String) to String {
	final StdioReady = "stdio_ready";
	final SocketReady = "socket_ready";
	final Invalid = "invalid";
	final Unsupported = "unsupported";

	public function text():String {
		return this;
	}
}
