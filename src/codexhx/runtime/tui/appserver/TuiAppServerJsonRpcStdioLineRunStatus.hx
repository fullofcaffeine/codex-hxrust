package codexhx.runtime.tui.appserver;

/**
	Result status for a stdio app-server JSON-RPC process line run.

	Why
	- Callers need a closed typed status set for process-run control flow.

	What
	- Distinguishes successful execution, executed-but-failed children, and plans rejected before
	  spawn.

	How
	- Lowers to stable text for reports while keeping app code off ad hoc status strings.
**/
enum abstract TuiAppServerJsonRpcStdioLineRunStatus(String) to String {
	final Succeeded = "succeeded";
	final Failed = "failed";
	final Rejected = "rejected";

	public function text():String {
		return this;
	}
}
