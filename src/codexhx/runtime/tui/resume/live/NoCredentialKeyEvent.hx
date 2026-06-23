package codexhx.runtime.tui.resume.live;

typedef NoCredentialKeyEventFields = {
	final kind:NoCredentialKeyKind;
	final keyName:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class NoCredentialKeyEvent {
	@:recordDefault(NoCredentialKeyKind.Unknown)
	public final kind:NoCredentialKeyKind;
	public final keyName:String;
}
