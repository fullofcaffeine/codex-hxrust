package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.CompletionInputAdmissionKind;

typedef CompletionInputAdmissionReportFields = {
	final admissionKind:CompletionInputAdmissionKind;
	final admissionSummary:String;
	final inputAdmitted:Bool;
	final finalThreadId:String;
	final finalSelectionPreserved:Bool;
	final finalFooterPreserved:Bool;
	final completionReady:Bool;
	final nextSliceReady:Bool;
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
	final completionSummary:String;
	final admissionLogSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class CompletionInputAdmissionReport {
	@:recordDefault(CompletionInputAdmissionKind.Unknown)
	public final admissionKind:CompletionInputAdmissionKind;
	public final admissionSummary:String;
	public final inputAdmitted:Bool;
	public final finalThreadId:String;
	public final finalSelectionPreserved:Bool;
	public final finalFooterPreserved:Bool;
	public final completionReady:Bool;
	public final nextSliceReady:Bool;
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
	public final completionSummary:String;
	public final admissionLogSummaries:Array<String>;

	public function summary():String {
		return "admissionKind=" + admissionKind + ";inputAdmitted=" + boolLabel(inputAdmitted) + ";finalThread=" + finalThreadId
			+ ";finalSelectionPreserved=" + boolLabel(finalSelectionPreserved) + ";finalFooterPreserved=" + boolLabel(finalFooterPreserved)
			+ ";completionReady=" + boolLabel(completionReady) + ";nextSliceReady=" + boolLabel(nextSliceReady) + ";stalePromptActionInactive="
			+ boolLabel(stalePromptActionInactive) + ";staleSideParentActionInactive=" + boolLabel(staleSideParentActionInactive)
			+ ";staleActiveThreadActionInactive=" + boolLabel(staleActiveThreadActionInactive) + ";ignoredNoSurfaceAbsent="
			+ boolLabel(ignoredNoSurfaceRecordsAbsent) + ";noPressureDropRejection=" + boolLabel(noPressureDropRejection) + ";liveTransportSuppressed="
			+ boolLabel(liveTransportSuppressed) + ";liveTerminalSuppressed=" + boolLabel(liveTerminalSuppressed) + ";stateDbUntouched="
			+ boolLabel(stateDbUntouched) + ";noModelCall=" + boolLabel(noModelCall) + ";noFilesystemMutation=" + boolLabel(noFilesystemMutation)
			+ ";admission=[" + admissionSummary + "]" + ";finalSnapshot=" + finalSnapshot.split("\n").join("\\n") + ";admissionLog=["
			+ admissionLogSummaries.join("##") + "]" + ";completion=[" + completionSummary + "]";
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
