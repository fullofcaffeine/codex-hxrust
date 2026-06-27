package codexhx.runtime.tui.smoke;

typedef TuiSmokeSelectionTabFields = {
	final id:String;
	final label:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeSelectionTab {
	public final id:String;
	public final label:String;
}
