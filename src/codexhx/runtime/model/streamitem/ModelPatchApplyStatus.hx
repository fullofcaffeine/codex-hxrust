package codexhx.runtime.model.streamitem;

enum abstract ModelPatchApplyStatus(String) to String {
	public var Completed = "completed";
	public var Failed = "failed";
	public var Declined = "declined";
}
