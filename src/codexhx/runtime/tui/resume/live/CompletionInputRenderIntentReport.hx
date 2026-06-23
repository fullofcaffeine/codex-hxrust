package codexhx.runtime.tui.resume.live;

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
		return "renderIntentKind=" + renderIntentKind + ";renderRequested=" + boolLabel(renderRequested) + ";localOnlyRenderIntent="
			+ boolLabel(localOnlyRenderIntent) + ";finalThread=" + finalThreadId + ";finalSelectionPreserved=" + boolLabel(finalSelectionPreserved)
			+ ";finalFooterPreserved=" + boolLabel(finalFooterPreserved) + ";inputAdmitted=" + boolLabel(inputAdmitted) + ";stalePromptActionInactive="
			+ boolLabel(stalePromptActionInactive) + ";staleSideParentActionInactive=" + boolLabel(staleSideParentActionInactive)
			+ ";staleActiveThreadActionInactive=" + boolLabel(staleActiveThreadActionInactive) + ";ignoredNoSurfaceAbsent="
			+ boolLabel(ignoredNoSurfaceRecordsAbsent) + ";noPressureDropRejection=" + boolLabel(noPressureDropRejection) + ";liveTransportSuppressed="
			+ boolLabel(liveTransportSuppressed) + ";liveTerminalSuppressed=" + boolLabel(liveTerminalSuppressed) + ";stateDbUntouched="
			+ boolLabel(stateDbUntouched) + ";noModelCall=" + boolLabel(noModelCall) + ";noFilesystemMutation=" + boolLabel(noFilesystemMutation)
			+ ";renderIntent=[" + renderIntentSummary + "]" + ";finalSnapshot=" + finalSnapshot.split("\n").join("\\n") + ";renderIntentLog=["
			+ renderIntentLogSummaries.join("##") + "]" + ";admission=[" + admissionSummary + "]";
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
