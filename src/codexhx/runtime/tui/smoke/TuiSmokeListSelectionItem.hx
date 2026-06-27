package codexhx.runtime.tui.smoke;

typedef TuiSmokeListSelectionItemFields = {
	final name:String;
	final description:String;
	final selectedDescription:String;
	final searchValue:String;
	final isCurrent:Bool;
	final isDefault:Bool;
	final isDisabled:Bool;
	final disabledReason:String;
	final dismissOnSelect:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeListSelectionItem {
	public final name:String;
	public final description:String;
	public final selectedDescription:String;
	public final searchValue:String;
	public final isCurrent:Bool;
	public final isDefault:Bool;
	public final isDisabled:Bool;
	public final disabledReason:String;
	public final dismissOnSelect:Bool;
}
