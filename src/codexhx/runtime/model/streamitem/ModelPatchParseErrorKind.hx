package codexhx.runtime.model.streamitem;

enum abstract ModelPatchParseErrorKind(String) to String {
	public var InvalidPatch = "invalid_patch";
	public var InvalidHunk = "invalid_hunk";
}
