package codexhx.runtime.tui.appserver;

/**
	Lifecycle status for a prompt submit request in the facade pending map.
**/
enum abstract TuiPromptPendingRequestStatus(String) to String {
	final None = "none";
	final Registered = "registered";
	final Resolved = "resolved";
	final Rejected = "rejected";

	public function text():String {
		return this;
	}
}
