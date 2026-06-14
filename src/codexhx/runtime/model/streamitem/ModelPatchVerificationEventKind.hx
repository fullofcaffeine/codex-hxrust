package codexhx.runtime.model.streamitem;

enum abstract ModelPatchVerificationEventKind(String) to String {
	public var Begin = "patch_apply_begin";
	public var End = "patch_apply_end";
}
