package codexhx.runtime.tui.smoke;

typedef TuiSmokeLineTruncationSpanFields = {
	final text:String;
	final style:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeLineTruncationSpan {
	public final text:String;
	public final style:String;
}
