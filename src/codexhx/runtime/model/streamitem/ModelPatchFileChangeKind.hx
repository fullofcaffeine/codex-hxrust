package codexhx.runtime.model.streamitem;

enum abstract ModelPatchFileChangeKind(String) to String {
	public var Add = "add";
	public var Delete = "delete";
	public var Update = "update";
}
