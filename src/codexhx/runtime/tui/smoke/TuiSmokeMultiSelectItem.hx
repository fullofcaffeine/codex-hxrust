package codexhx.runtime.tui.smoke;

typedef TuiSmokeMultiSelectItemFields = {
	final id:String;
	final name:String;
	final description:String;
	final enabled:Bool;
	final orderable:Bool;
	final sectionBreakAfter:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeMultiSelectItem {
	public final id:String;
	public final name:String;
	public final description:String;
	public final enabled:Bool;
	public final orderable:Bool;
	public final sectionBreakAfter:Bool;
}
