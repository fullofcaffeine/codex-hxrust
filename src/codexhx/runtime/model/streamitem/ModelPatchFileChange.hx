package codexhx.runtime.model.streamitem;

class ModelPatchFileChange {
	public final path:String;
	public final kind:ModelPatchFileChangeKind;
	public final content:String;
	public final unifiedDiff:String;
	public final movePath:String;

	public function new(path:String, kind:ModelPatchFileChangeKind, content:String, unifiedDiff:String, movePath:String) {
		this.path = path;
		this.kind = kind;
		this.content = content;
		this.unifiedDiff = unifiedDiff;
		this.movePath = movePath;
	}

	public function summary():String {
		return "path=" + path
			+ ";kind=" + kind
			+ ";content=" + content
			+ ";unifiedDiff=" + unifiedDiff
			+ ";movePath=" + noneIfEmpty(movePath);
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
