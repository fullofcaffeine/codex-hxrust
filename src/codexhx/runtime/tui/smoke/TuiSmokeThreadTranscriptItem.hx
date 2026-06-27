package codexhx.runtime.tui.smoke;

typedef TuiSmokeThreadTranscriptItemFields = {
	final kind:TuiSmokeThreadTranscriptItemKind;
	final text:String;
	final summary:Array<String>;
	final content:Array<String>;
	final fragments:Array<String>;
	final command:String;
	final status:String;
	final aggregatedOutput:String;
	final exitCode:String;
	final changesCount:Int;
	final server:String;
	final tool:String;
	final namespace:String;
	final query:String;
	final path:String;
	final savedPath:String;
	final review:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeThreadTranscriptItem {
	public final kind:TuiSmokeThreadTranscriptItemKind;
	public final text:String;
	public final summary:Array<String>;
	public final content:Array<String>;
	public final fragments:Array<String>;
	public final command:String;
	public final status:String;
	public final aggregatedOutput:String;
	public final exitCode:String;
	public final changesCount:Int;
	public final server:String;
	public final tool:String;
	public final namespace:String;
	public final query:String;
	public final path:String;
	public final savedPath:String;
	public final review:String;
}
