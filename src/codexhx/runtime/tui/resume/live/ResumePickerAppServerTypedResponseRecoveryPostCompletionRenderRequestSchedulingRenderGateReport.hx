package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderRequestScheduleKind;

typedef ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderRequestSchedulingRenderGateReportFields = {
	final scheduleKind:ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderRequestScheduleKind;
	final scheduleSummary:String;
	final scheduleRequested:Bool;
	final scheduled:Bool;
	final scheduleSequence:Int;
	final schedulerRequestCount:Int;
	final schedulerSummary:String;
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
	final renderIntentSummary:String;
	final schedulerLogSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderRequestSchedulingRenderGateReport {
	@:recordDefault(ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderRequestScheduleKind.Unknown)
	public final scheduleKind:ResumePickerAppServerTypedResponseRecoveryPostCompletionRenderRequestScheduleKind;
	public final scheduleSummary:String;
	public final scheduleRequested:Bool;
	public final scheduled:Bool;
	public final scheduleSequence:Int;
	public final schedulerRequestCount:Int;
	public final schedulerSummary:String;
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
	public final renderIntentSummary:String;
	public final schedulerLogSummaries:Array<String>;

	public function summary():String {
		return "scheduleKind=" + scheduleKind + ";scheduleRequested=" + boolLabel(scheduleRequested) + ";scheduled=" + boolLabel(scheduled)
			+ ";scheduleSequence=" + scheduleSequence + ";schedulerRequestCount=" + schedulerRequestCount + ";schedulerSummary=" + schedulerSummary
			+ ";localOnlyRenderIntent=" + boolLabel(localOnlyRenderIntent) + ";finalThread=" + finalThreadId + ";finalSelectionPreserved="
			+ boolLabel(finalSelectionPreserved) + ";finalFooterPreserved=" + boolLabel(finalFooterPreserved) + ";inputAdmitted=" + boolLabel(inputAdmitted)
			+ ";stalePromptActionInactive=" + boolLabel(stalePromptActionInactive) + ";staleSideParentActionInactive="
			+ boolLabel(staleSideParentActionInactive) + ";staleActiveThreadActionInactive=" + boolLabel(staleActiveThreadActionInactive)
			+ ";ignoredNoSurfaceAbsent=" + boolLabel(ignoredNoSurfaceRecordsAbsent) + ";noPressureDropRejection=" + boolLabel(noPressureDropRejection)
			+ ";liveTransportSuppressed=" + boolLabel(liveTransportSuppressed) + ";liveTerminalSuppressed=" + boolLabel(liveTerminalSuppressed)
			+ ";stateDbUntouched=" + boolLabel(stateDbUntouched) + ";noModelCall=" + boolLabel(noModelCall) + ";noFilesystemMutation="
			+ boolLabel(noFilesystemMutation) + ";schedule=[" + scheduleSummary + "]" + ";finalSnapshot=" + finalSnapshot.split("\n").join("\\n")
			+ ";schedulerLog=[" + schedulerLogSummaries.join("##") + "]" + ";renderIntent=[" + renderIntentSummary + "]";
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
