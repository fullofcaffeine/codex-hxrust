package codexhx.runtime.model.streamitem;

enum abstract ModelThreadSideParentStatusKind(String) to String {
	var None = "none";
	var NeedsInput = "needs_input";
	var NeedsApproval = "needs_approval";
	var Finished = "finished";
	var Interrupted = "interrupted";
	var Failed = "failed";
	var Closed = "closed";
}
