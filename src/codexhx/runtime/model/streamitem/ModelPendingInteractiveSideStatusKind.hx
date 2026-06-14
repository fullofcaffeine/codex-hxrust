package codexhx.runtime.model.streamitem;

enum abstract ModelPendingInteractiveSideStatusKind(String) to String {
	final None = "none";
	final NeedsApproval = "needs_approval";
	final NeedsInput = "needs_input";
}
