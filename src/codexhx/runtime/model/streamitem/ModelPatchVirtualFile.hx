package codexhx.runtime.model.streamitem;

class ModelPatchVirtualFile {
	public final path:String;
	public final content:String;

	public function new(path:String, content:String) {
		this.path = path == null ? "" : path;
		this.content = content == null ? "" : content;
	}

	public function summary():String {
		return "path=" + path + ";bytes=" + Std.string(content.length);
	}
}
