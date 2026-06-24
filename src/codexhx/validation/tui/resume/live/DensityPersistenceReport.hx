package codexhx.validation.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;

typedef DensityPersistenceReportFields = {
	final frameRequests:Int;
	final renderCount:Int;
	final successConfigPath:String;
	final successConfigText:String;
	final successSnapshot:String;
	final failureSnapshot:String;
	final renderSnapshots:Array<String>;
	final failureCode:String;
	final failureMessage:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class DensityPersistenceReport {
	public final frameRequests:Int;
	public final renderCount:Int;
	public final successConfigPath:String;
	public final successConfigText:String;
	public final successSnapshot:String;
	public final failureSnapshot:String;
	public final renderSnapshots:Array<String>;
	public final failureCode:String;
	public final failureMessage:String;

	public function summary():String {
		return DiagnosticSummary.render([
			DiagnosticSummary.intValue("frames", frameRequests),
			DiagnosticSummary.intValue("renders", renderCount),
			DiagnosticSummary.text("configPath", successConfigPath),
			DiagnosticSummary.text("failureCode", failureCode),
			DiagnosticSummary.snapshot("successSnapshot", successSnapshot),
			DiagnosticSummary.snapshot("failureSnapshot", failureSnapshot)
		]);
	}
}
