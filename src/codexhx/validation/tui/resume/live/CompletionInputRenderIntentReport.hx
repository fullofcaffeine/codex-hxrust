package codexhx.validation.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;
import codexhx.runtime.tui.resume.host.CompletionInputRenderIntentKind;

typedef CompletionInputRenderIntentReportFields = {
	final renderIntentKind:CompletionInputRenderIntentKind;
	final renderIntentSummary:String;
	final renderRequested:Bool;
	final localOnlyRenderIntent:Bool;
	final finalThreadId:String;
	final finalSelectionPreserved:Bool;
	final finalFooterPreserved:Bool;
	final inputAdmitted:Bool;
	final stalePromptActionInactive:Bool;
	final staleSideParentActionInactive:Bool;
	final staleActiveThreadActionInactive:Bool;
	final ignoredNoSurfaceRecordsAbsent:Bool;
	final noPressureDropRejection:Bool;
	final liveTransportSuppressed:Bool;
	final liveTerminalSuppressed:Bool;
	final stateDbUntouched:Bool;
	final noModelCall:Bool;
	final noFilesystemMutation:Bool;
	final finalSnapshot:String;
	final admissionSummary:String;
	final renderIntentLogSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class CompletionInputRenderIntentReport {
	@:recordDefault(CompletionInputRenderIntentKind.Unknown)
	public final renderIntentKind:CompletionInputRenderIntentKind;
	public final renderIntentSummary:String;
	public final renderRequested:Bool;
	public final localOnlyRenderIntent:Bool;
	public final finalThreadId:String;
	public final finalSelectionPreserved:Bool;
	public final finalFooterPreserved:Bool;
	public final inputAdmitted:Bool;
	public final stalePromptActionInactive:Bool;
	public final staleSideParentActionInactive:Bool;
	public final staleActiveThreadActionInactive:Bool;
	public final ignoredNoSurfaceRecordsAbsent:Bool;
	public final noPressureDropRejection:Bool;
	public final liveTransportSuppressed:Bool;
	public final liveTerminalSuppressed:Bool;
	public final stateDbUntouched:Bool;
	public final noModelCall:Bool;
	public final noFilesystemMutation:Bool;
	public final finalSnapshot:String;
	public final admissionSummary:String;
	public final renderIntentLogSummaries:Array<String>;

	public function summary():String {
		return DiagnosticSummary.render([
			DiagnosticSummary.enumValue("renderIntentKind", Std.string(renderIntentKind)),
			DiagnosticSummary.boolValue("renderRequested", renderRequested),
			DiagnosticSummary.boolValue("localOnlyRenderIntent", localOnlyRenderIntent),
			DiagnosticSummary.text("finalThread", finalThreadId),
			DiagnosticSummary.boolValue("finalSelectionPreserved", finalSelectionPreserved),
			DiagnosticSummary.boolValue("finalFooterPreserved", finalFooterPreserved),
			DiagnosticSummary.boolValue("inputAdmitted", inputAdmitted),
			DiagnosticSummary.boolValue("stalePromptActionInactive", stalePromptActionInactive),
			DiagnosticSummary.boolValue("staleSideParentActionInactive", staleSideParentActionInactive),
			DiagnosticSummary.boolValue("staleActiveThreadActionInactive", staleActiveThreadActionInactive),
			DiagnosticSummary.boolValue("ignoredNoSurfaceAbsent", ignoredNoSurfaceRecordsAbsent),
			DiagnosticSummary.boolValue("noPressureDropRejection", noPressureDropRejection),
			DiagnosticSummary.boolValue("liveTransportSuppressed", liveTransportSuppressed),
			DiagnosticSummary.boolValue("liveTerminalSuppressed", liveTerminalSuppressed),
			DiagnosticSummary.boolValue("stateDbUntouched", stateDbUntouched),
			DiagnosticSummary.boolValue("noModelCall", noModelCall),
			DiagnosticSummary.boolValue("noFilesystemMutation", noFilesystemMutation),
			DiagnosticSummary.nested("renderIntent", renderIntentSummary),
			DiagnosticSummary.snapshot("finalSnapshot", finalSnapshot),
			DiagnosticSummary.logList("renderIntentLog", renderIntentLogSummaries),
			DiagnosticSummary.nested("admission", admissionSummary)
		]);
	}
}
