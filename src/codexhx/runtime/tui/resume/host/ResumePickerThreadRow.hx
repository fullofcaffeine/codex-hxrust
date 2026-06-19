package codexhx.runtime.tui.resume.host;

typedef ResumePickerThreadRowFields = {
	final threadId:String;
	final title:String;
	final cwd:String;
	final updatedAt:String;
	final archived:Bool;
	final turnCount:Int;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerThreadRow {
	public final threadId:String;
	public final title:String;
	public final cwd:String;
	public final updatedAt:String;
	public final archived:Bool;
	public final turnCount:Int;

	public function summary():String {
		return threadId + ":" + title + ":" + cwd + ":" + Std.string(turnCount);
	}
}
