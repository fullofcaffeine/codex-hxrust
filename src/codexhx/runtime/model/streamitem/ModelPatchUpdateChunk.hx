package codexhx.runtime.model.streamitem;

class ModelPatchUpdateChunk {
	public final changeContext:String;
	public final oldLines:Array<String>;
	public final newLines:Array<String>;
	public var isEndOfFile:Bool;

	public function new(changeContext:String) {
		this.changeContext = changeContext == null ? "" : changeContext;
		this.oldLines = [];
		this.newLines = [];
		this.isEndOfFile = false;
	}

	public function isEmpty():Bool {
		return oldLines.length == 0 && newLines.length == 0;
	}

	public function appendContext(line:String):Void {
		oldLines.push(line);
		newLines.push(line);
	}

	public function appendAdded(line:String):Void {
		newLines.push(line);
	}

	public function appendRemoved(line:String):Void {
		oldLines.push(line);
	}

	public function unifiedDiff():String {
		var out = changeContext.length > 0 ? "@@ " + changeContext + "\n" : "@@\n";
		for (line in oldLines)
			out = out + "-" + line + "\n";
		for (line in newLines)
			out = out + "+" + line + "\n";
		if (isEndOfFile)
			out = out + "*** End of File\n";
		return out;
	}

	public function summary():String {
		return "context="
			+ noneIfEmpty(changeContext)
			+ ";old="
			+ oldLines.join("\\n")
			+ ";new="
			+ newLines.join("\\n")
			+ ";eof="
			+ boolText(isEndOfFile);
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
