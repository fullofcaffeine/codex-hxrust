package codexhx.runtime.model.streamitem;

enum abstract ModelPatchParserMode(String) to String {
	public var NotStarted = "not_started";
	public var StartedPatch = "started_patch";
	public var AddFile = "add_file";
	public var DeleteFile = "delete_file";
	public var UpdateFile = "update_file";
	public var EndedPatch = "ended_patch";
}
