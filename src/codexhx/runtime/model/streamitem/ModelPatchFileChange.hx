package codexhx.runtime.model.streamitem;

class ModelPatchFileChange {
	public final path:String;
	public final kind:ModelPatchFileChangeKind;
	public var content:String;
	public var movePath:String;
	public final chunks:Array<ModelPatchUpdateChunk>;

	public function new(path:String, kind:ModelPatchFileChangeKind, content:String, movePath:String, chunks:Array<ModelPatchUpdateChunk>) {
		this.path = path;
		this.kind = kind;
		this.content = content;
		this.movePath = movePath;
		this.chunks = chunks == null ? [] : chunks;
	}

	public static function add(path:String):ModelPatchFileChange {
		return new ModelPatchFileChange(path, ModelPatchFileChangeKind.Add, "", "", []);
	}

	public static function deleteFile(path:String):ModelPatchFileChange {
		return new ModelPatchFileChange(path, ModelPatchFileChangeKind.Delete, "", "", []);
	}

	public static function update(path:String):ModelPatchFileChange {
		return new ModelPatchFileChange(path, ModelPatchFileChangeKind.Update, "", "", []);
	}

	public function appendContent(value:String):Void {
		content = content + value;
	}

	public function setMovePath(path:String):Void {
		movePath = path == null ? "" : path;
	}

	public function addChunk(chunk:ModelPatchUpdateChunk):Void {
		chunks.push(chunk);
	}

	public function copy():ModelPatchFileChange {
		final copiedChunks:Array<ModelPatchUpdateChunk> = [];
		for (chunk in chunks) {
			final copyChunk = new ModelPatchUpdateChunk(chunk.changeContext);
			for (line in chunk.oldLines) copyChunk.oldLines.push(line);
			for (line in chunk.newLines) copyChunk.newLines.push(line);
			copyChunk.isEndOfFile = chunk.isEndOfFile;
			copiedChunks.push(copyChunk);
		}
		return new ModelPatchFileChange(path, kind, content, movePath, copiedChunks);
	}

	public function withoutAddContent():ModelPatchFileChange {
		if (kind != ModelPatchFileChangeKind.Add) return copy();
		return new ModelPatchFileChange(path, kind, "", movePath, []);
	}

	public function unifiedDiff():String {
		var out = "";
		for (chunk in chunks) out = out + chunk.unifiedDiff();
		return out;
	}

	public function summary():String {
		final chunkParts:Array<String> = [];
		for (chunk in chunks) chunkParts.push(chunk.summary());
		return "path=" + path
			+ ";kind=" + kind
			+ ";content=" + content
			+ ";unifiedDiff=" + unifiedDiff()
			+ ";movePath=" + noneIfEmpty(movePath)
			+ ";chunks=[" + chunkParts.join("||") + "]";
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
