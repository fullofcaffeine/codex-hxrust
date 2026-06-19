package codexhx.runtime.tui.resume;

typedef ResumePickerVisibleRowFields = {
	final threadId:String;
	final title:String;
	final cwd:String;
	final updatedAt:String;
	final turnCount:Int;
	final selected:Bool;
	final previewLines:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerVisibleRow {
	public final threadId:String;
	public final title:String;
	public final cwd:String;
	public final updatedAt:String;
	public final turnCount:Int;
	public final selected:Bool;
	public final previewLines:Array<String>;
}
