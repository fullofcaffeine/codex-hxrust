package codexhx.runtime.tui.smoke;

typedef TuiSmokeActionRequiredTitleValueFields = {
	final item:String;
	final value:String;
	final present:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeActionRequiredTitleValue {
	public final item:String;
	public final value:String;
	public final present:Bool;
}
