package codexhx.runtime.tui.smoke;

typedef TuiSmokeThreadTranscriptCellFields = {
	final kind:TuiSmokeThreadTranscriptCellKind;
	final text:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeThreadTranscriptCell {
	public final kind:TuiSmokeThreadTranscriptCellKind;
	public final text:String;
}
