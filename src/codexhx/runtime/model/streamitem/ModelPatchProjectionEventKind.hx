package codexhx.runtime.model.streamitem;

enum abstract ModelPatchProjectionEventKind(String) to String {
	public var FileChangeItem = "file_change_item";
	public var PatchApplyBegin = "patch_apply_begin";
	public var PatchApplyEnd = "patch_apply_end";
	public var TurnDiff = "turn_diff";
}
