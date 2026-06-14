package codexhx.runtime.model.streamitem;

enum abstract ModelPatchTurnDiffTrackerUpdateKind(String) to String {
	public var Track = "track";
	public var Invalidate = "invalidate";
	public var None = "none";
}
