package codexhx.runtime.tui.smoke;

typedef TuiSmokeLiveWrapRowFields = {
	final text:String;
	final explicitBreak:Bool;
	final width:Int;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeLiveWrapRow {
	public final text:String;
	public final explicitBreak:Bool;
	public final width:Int;
}
