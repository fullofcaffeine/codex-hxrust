package codexhx.runtime.tui.appserver;

/**
	Wire-visible JSON-RPC prompt frame shape.
**/
enum abstract TuiPromptJsonRpcFrameKind(String) to String {
	final Request = "request";
	final Response = "response";
	final Notification = "notification";

	public function text():String {
		return this;
	}
}
