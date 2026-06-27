package codexhx.runtime.tui.smoke;

typedef TuiSmokeMarkdownTextEventFields = {
	final kind:TuiSmokeMarkdownTextEventKind;
	final text:String;
	final start:Int;
	final end:Int;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeMarkdownTextEvent {
	public final kind:TuiSmokeMarkdownTextEventKind;
	public final text:String;
	public final start:Int;
	public final end:Int;
}
