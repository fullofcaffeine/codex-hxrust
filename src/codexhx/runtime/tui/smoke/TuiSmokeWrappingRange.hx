package codexhx.runtime.tui.smoke;

typedef TuiSmokeWrappingRangeFields = {
	final start:Int;
	final end:Int;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeWrappingRange {
	public final start:Int;
	public final end:Int;
}
