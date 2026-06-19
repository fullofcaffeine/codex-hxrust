package codexhx.runtime.tui.resume;

typedef ResumePickerEffectFields = {
	final kind:ResumePickerEffectKind;
	final target:String;
	final detail:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerEffect {
	@:recordDefault(ResumePickerEffectKind.Unknown)
	public final kind:ResumePickerEffectKind;
	public final target:String;
	public final detail:String;
}
