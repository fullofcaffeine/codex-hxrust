package codexhx.validation.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;

typedef ResumePickerNoCredentialReportFields = {
	final pageLoads:Int;
	final transcriptLoads:Int;
	final keyEvents:Int;
	final frameRequests:Int;
	final renderCount:Int;
	final overlayOpened:Bool;
	final densityPersisted:Bool;
	final configPath:String;
	final configText:String;
	final finalSummary:String;
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
	final eventSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerNoCredentialReport {
	public final pageLoads:Int;
	public final transcriptLoads:Int;
	public final keyEvents:Int;
	public final frameRequests:Int;
	public final renderCount:Int;
	public final overlayOpened:Bool;
	public final densityPersisted:Bool;
	public final configPath:String;
	public final configText:String;
	public final finalSummary:String;
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;
	public final eventSummaries:Array<String>;

	public function summary():String {
		return DiagnosticSummary.render([
			DiagnosticSummary.intValue("pageLoads", pageLoads),
			DiagnosticSummary.intValue("transcriptLoads", transcriptLoads),
			DiagnosticSummary.intValue("keys", keyEvents),
			DiagnosticSummary.intValue("frames", frameRequests),
			DiagnosticSummary.intValue("renders", renderCount),
			DiagnosticSummary.boolValue("overlay", overlayOpened),
			DiagnosticSummary.boolValue("densityPersisted", densityPersisted),
			DiagnosticSummary.text("configPath", configPath),
			DiagnosticSummary.text("final", finalSummary),
			DiagnosticSummary.snapshot("finalSnapshot", finalSnapshot),
			DiagnosticSummary.logList("events", eventSummaries)
		]);
	}
}
