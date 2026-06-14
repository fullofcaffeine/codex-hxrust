package codexhx.runtime.model.streamitem;

enum abstract ModelPatchApprovalRequirement(String) to String {
	public var Skip = "skip";
	public var NeedsApproval = "needs_approval";
}
