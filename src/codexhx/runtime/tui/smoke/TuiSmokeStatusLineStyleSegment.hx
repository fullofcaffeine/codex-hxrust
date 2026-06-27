package codexhx.runtime.tui.smoke;

typedef TuiSmokeStatusLineStyleSegmentFields = {
	final item:String;
	final text:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeStatusLineStyleSegment {
	public final item:String;
	public final text:String;
}
