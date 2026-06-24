package codexhx.validation.tui.resume.live;

import codexhx.runtime.diagnostics.DiagnosticSummary;
import codexhx.runtime.tui.resume.host.CompletionRenderedStateHandoffKind;

typedef CompletionStateHandoffReportFields = {
	final handoffKind:CompletionRenderedStateHandoffKind;
	final handoffSummary:String;
	final postRenderIdleListReady:Bool;
	final keyboardInputReady:Bool;
	final listNavigationReady:Bool;
	final noLeftoverScheduledRenderRequest:Bool;
	final sourceSchedulerRequestCount:Int;
	final consumedScheduledRequestCount:Int;
	final renderCount:Int;
	final renderedSnapshotPreserved:Bool;
	final finalThreadId:String;
	final finalSelectionPreserved:Bool;
	final finalFooterPreserved:Bool;
	final inputAdmitted:Bool;
	final localOnlyRenderIntent:Bool;
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
	final executionSummary:String;
	final handoffLogSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class CompletionStateHandoffReport {
	@:recordDefault(CompletionRenderedStateHandoffKind.Unknown)
	public final handoffKind:CompletionRenderedStateHandoffKind;
	public final handoffSummary:String;
	public final postRenderIdleListReady:Bool;
	public final keyboardInputReady:Bool;
	public final listNavigationReady:Bool;
	public final noLeftoverScheduledRenderRequest:Bool;
	public final sourceSchedulerRequestCount:Int;
	public final consumedScheduledRequestCount:Int;
	public final renderCount:Int;
	public final renderedSnapshotPreserved:Bool;
	public final finalThreadId:String;
	public final finalSelectionPreserved:Bool;
	public final finalFooterPreserved:Bool;
	public final inputAdmitted:Bool;
	public final localOnlyRenderIntent:Bool;
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
	public final executionSummary:String;
	public final handoffLogSummaries:Array<String>;

	public function summary():String {
		return DiagnosticSummary.render([
			DiagnosticSummary.enumValue("handoffKind", Std.string(handoffKind)),
			DiagnosticSummary.boolValue("postRenderIdleListReady", postRenderIdleListReady),
			DiagnosticSummary.boolValue("keyboardInputReady", keyboardInputReady),
			DiagnosticSummary.boolValue("listNavigationReady", listNavigationReady),
			DiagnosticSummary.boolValue("noLeftoverScheduledRenderRequest", noLeftoverScheduledRenderRequest),
			DiagnosticSummary.intValue("sourceSchedulerRequestCount", sourceSchedulerRequestCount),
			DiagnosticSummary.intValue("consumedScheduledRequestCount", consumedScheduledRequestCount),
			DiagnosticSummary.intValue("renderCount", renderCount),
			DiagnosticSummary.boolValue("renderedSnapshotPreserved", renderedSnapshotPreserved),
			DiagnosticSummary.text("finalThread", finalThreadId),
			DiagnosticSummary.boolValue("finalSelectionPreserved", finalSelectionPreserved),
			DiagnosticSummary.boolValue("finalFooterPreserved", finalFooterPreserved),
			DiagnosticSummary.boolValue("inputAdmitted", inputAdmitted),
			DiagnosticSummary.boolValue("localOnlyRenderIntent", localOnlyRenderIntent),
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
			DiagnosticSummary.snapshot("finalSnapshot", finalSnapshot),
			DiagnosticSummary.nested("handoff", handoffSummary),
			DiagnosticSummary.logList("handoffLog", handoffLogSummaries),
			DiagnosticSummary.nested("execution", executionSummary)
		]);
	}
}
