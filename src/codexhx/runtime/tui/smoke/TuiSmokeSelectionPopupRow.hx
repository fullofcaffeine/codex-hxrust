package codexhx.runtime.tui.smoke;

typedef TuiSmokeSelectionPopupRowFields = {
	final name:String;
	final prefix:String;
	final shortcut:String;
	final matchIndices:Array<Int>;
	final description:String;
	final categoryTag:String;
	final disabledReason:String;
	final isDisabled:Bool;
	final wrapIndent:Int;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeSelectionPopupRow {
	public final name:String;
	public final prefix:String;
	public final shortcut:String;
	public final matchIndices:Array<Int>;
	public final description:String;
	public final categoryTag:String;
	public final disabledReason:String;
	public final isDisabled:Bool;
	public final wrapIndent:Int;
}
