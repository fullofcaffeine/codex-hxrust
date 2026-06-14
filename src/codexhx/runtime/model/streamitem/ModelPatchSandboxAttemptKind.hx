package codexhx.runtime.model.streamitem;

enum abstract ModelPatchSandboxAttemptKind(String) to String {
	public var None = "none";
	public var Sandboxed = "sandboxed";
	public var Escalated = "escalated";
}
