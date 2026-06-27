package codexhx.runtime.tui.smoke;

typedef TuiSmokeCustomPromptStepFields = {
	final kind:TuiSmokeCustomPromptStepKind;
	final text:String;
	final modifiers:String;
	final elapsedMs:Int;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeCustomPromptStep {
	@:recordDefault(TuiSmokeCustomPromptStepKind.Unknown)
	public final kind:TuiSmokeCustomPromptStepKind;
	public final text:String;
	public final modifiers:String;
	public final elapsedMs:Int;
}
