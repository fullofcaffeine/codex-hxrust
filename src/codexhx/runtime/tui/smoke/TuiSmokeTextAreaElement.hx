package codexhx.runtime.tui.smoke;

typedef TuiSmokeTextAreaElementFields = {
	final start:Int;
	final end:Int;
	final name:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeTextAreaElement {
	public final start:Int;
	public final end:Int;
	public final name:String;
}
