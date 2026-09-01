package codexhx.runtime.tui.appserver;

/** Result category for one app-server request response send. */
enum abstract TuiAppServerRequestResponseStatus(String) to String {
	final Sent = "sent";
	final Rejected = "rejected";
	final Disconnected = "disconnected";

	public function text():String
		return this;
}
