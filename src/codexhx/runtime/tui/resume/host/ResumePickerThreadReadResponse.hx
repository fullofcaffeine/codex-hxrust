package codexhx.runtime.tui.resume.host;

typedef ResumePickerThreadReadResponseFields = {
	final requestId:String;
	final threadId:String;
	final previewLines:Array<String>;
	final transcriptCells:Array<String>;
	final truncated:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerThreadReadResponse {
	public final requestId:String;
	public final threadId:String;
	public final previewLines:Array<String>;
	public final transcriptCells:Array<String>;
	public final truncated:Bool;

	public function summary():String {
		return "id=" + requestId + ";thread=" + threadId + ";preview=" + previewLines.length + ";cells=" + transcriptCells.length + ";truncated="
			+ (truncated ? "true" : "false");
	}
}
