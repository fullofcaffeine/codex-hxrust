package codexhx.runtime.tui.resume.live;

typedef ResumePickerNoCredentialKeyEventFields = {
	final kind:ResumePickerNoCredentialKeyKind;
	final keyName:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerNoCredentialKeyEvent {
	@:recordDefault(ResumePickerNoCredentialKeyKind.Unknown)
	public final kind:ResumePickerNoCredentialKeyKind;
	public final keyName:String;
}
