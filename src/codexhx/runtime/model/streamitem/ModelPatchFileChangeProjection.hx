package codexhx.runtime.model.streamitem;

class ModelPatchFileChangeProjection {
	public final path:String;
	public final kind:ModelPatchFileChangeKind;
	public final diff:String;
	public final movePath:String;
	public final addedLines:Int;
	public final removedLines:Int;

	public function new(path:String, kind:ModelPatchFileChangeKind, diff:String, movePath:String, addedLines:Int, removedLines:Int) {
		this.path = path == null ? "" : path;
		this.kind = kind;
		this.diff = diff == null ? "" : diff;
		this.movePath = movePath == null ? "" : movePath;
		this.addedLines = addedLines;
		this.removedLines = removedLines;
	}

	public static function fromChange(change:ModelPatchFileChange):ModelPatchFileChangeProjection {
		if (change == null)
			return new ModelPatchFileChangeProjection("", ModelPatchFileChangeKind.Update, "", "", 0, 0);
		if (change.kind == ModelPatchFileChangeKind.Add) {
			final lines = splitLines(change.content);
			return new ModelPatchFileChangeProjection(change.path, change.kind, change.content, change.movePath, lines.length, 0);
		}
		if (change.kind == ModelPatchFileChangeKind.Delete) {
			final lines = splitLines(change.content);
			return new ModelPatchFileChangeProjection(change.path, change.kind, change.content, change.movePath, 0, lines.length);
		}
		final diff = change.unifiedDiff();
		return new ModelPatchFileChangeProjection(change.path, change.kind, diff, change.movePath, countPrefix(diff, "+"), countPrefix(diff, "-"));
	}

	public function summary():String {
		return "path=" + path + ";kind=" + kind + ";movePath=" + noneIfEmpty(movePath) + ";addedLines=" + Std.string(addedLines) + ";removedLines="
			+ Std.string(removedLines) + ";diff=" + diff;
	}

	static function splitLines(content:String):Array<String> {
		if (content == null || content.length == 0)
			return [];
		final raw = content.split("\n");
		if (raw.length > 0 && raw[raw.length - 1] == "")
			raw.resize(raw.length - 1);
		return raw;
	}

	static function countPrefix(value:String, prefix:String):Int {
		var count = 0;
		for (line in splitLines(value)) {
			if (line.indexOf(prefix) == 0 && line.indexOf(prefix + prefix) != 0)
				count = count + 1;
		}
		return count;
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
