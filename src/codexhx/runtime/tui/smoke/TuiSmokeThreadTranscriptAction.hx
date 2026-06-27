package codexhx.runtime.tui.smoke;

typedef TuiSmokeThreadTranscriptActionFields = {
	final kind:TuiSmokeThreadTranscriptActionKind;
	final name:String;
	final cwd:String;
	final rawReasoningVisibility:String;
	final items:Array<TuiSmokeThreadTranscriptItem>;
	final expectedCells:Array<TuiSmokeThreadTranscriptCell>;
	final failureCode:String;
	final noAppServerRead:Bool;
	final noRatatuiRender:Bool;
	final noFilesystemMutation:Bool;
	final noModelCall:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeThreadTranscriptAction {
	public final kind:TuiSmokeThreadTranscriptActionKind;
	public final name:String;
	public final cwd:String;
	public final rawReasoningVisibility:String;
	public final items:Array<TuiSmokeThreadTranscriptItem>;
	public final expectedCells:Array<TuiSmokeThreadTranscriptCell>;
	public final failureCode:String;
	public final noAppServerRead:Bool;
	public final noRatatuiRender:Bool;
	public final noFilesystemMutation:Bool;
	public final noModelCall:Bool;
	public final unsupportedRejected:Bool;
}
