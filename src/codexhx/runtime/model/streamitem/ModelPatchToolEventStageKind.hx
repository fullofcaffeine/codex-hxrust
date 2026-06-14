package codexhx.runtime.model.streamitem;

enum abstract ModelPatchToolEventStageKind(String) to String {
	public var Success = "success";
	public var FailureOutput = "failure_output";
	public var FailureMessage = "failure_message";
	public var Rejected = "rejected";
}
