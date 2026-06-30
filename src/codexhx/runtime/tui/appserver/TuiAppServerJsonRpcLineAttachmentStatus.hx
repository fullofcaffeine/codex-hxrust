package codexhx.runtime.tui.appserver;

/**
	Result status for attaching an opened app-server line connection to a transport.
**/
enum abstract TuiAppServerJsonRpcLineAttachmentStatus(String) to String {
	final Ready = "ready";
	final Refused = "refused";

	public function text():String {
		return this;
	}
}
