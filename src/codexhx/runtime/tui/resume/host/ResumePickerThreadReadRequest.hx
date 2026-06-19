package codexhx.runtime.tui.resume.host;

typedef ResumePickerThreadReadRequestFields = {
	final requestId:String;
	final threadId:String;
	final includeTurns:Bool;
	final previewOnly:Bool;
	final maxPreviewLines:Int;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerThreadReadRequest {
	public final requestId:String;
	public final threadId:String;
	public final includeTurns:Bool;
	public final previewOnly:Bool;
	public final maxPreviewLines:Int;

	public function summary():String {
		return "id=" + requestId
			+ ";thread=" + threadId
			+ ";includeTurns=" + (includeTurns ? "true" : "false")
			+ ";previewOnly=" + (previewOnly ? "true" : "false")
			+ ";maxPreview=" + maxPreviewLines;
	}
}
