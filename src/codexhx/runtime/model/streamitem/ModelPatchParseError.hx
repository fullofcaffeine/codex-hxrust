package codexhx.runtime.model.streamitem;

class ModelPatchParseError {
	public final kind:ModelPatchParseErrorKind;
	public final message:String;
	public final lineNumber:Int;

	public function new(kind:ModelPatchParseErrorKind, message:String, lineNumber:Int) {
		this.kind = kind;
		this.message = message;
		this.lineNumber = lineNumber;
	}

	public function summary():String {
		return "kind=" + kind + ";line=" + Std.string(lineNumber) + ";message=" + message;
	}
}
