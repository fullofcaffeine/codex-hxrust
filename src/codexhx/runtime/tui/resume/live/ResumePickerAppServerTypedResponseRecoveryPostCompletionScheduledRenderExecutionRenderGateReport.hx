package codexhx.runtime.tui.resume.live;

import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRecoveryPostCompletionScheduledRenderExecutionKind;
import codexhx.runtime.tui.resume.host.ResumePickerHostOutcomeKind;

typedef ResumePickerAppServerTypedResponseRecoveryPostCompletionScheduledRenderExecutionRenderGateReportFields = {
	final executionKind:ResumePickerAppServerTypedResponseRecoveryPostCompletionScheduledRenderExecutionKind;
	final executionSummary:String;
	final executionRequested:Bool;
	final rendered:Bool;
	final executionSequence:Int;
	final sourceSchedulerRequestCount:Int;
	final consumedScheduledRequestCount:Int;
	final renderCount:Int;
	final renderOutcomeKind:ResumePickerHostOutcomeKind;
	final renderedSnapshotMatchesSchedule:Bool;
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
	final renderedSnapshot:String;
	final schedulingSummary:String;
	final executionLogSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerAppServerTypedResponseRecoveryPostCompletionScheduledRenderExecutionRenderGateReport {
	@:recordDefault(ResumePickerAppServerTypedResponseRecoveryPostCompletionScheduledRenderExecutionKind.Unknown)
	public final executionKind:ResumePickerAppServerTypedResponseRecoveryPostCompletionScheduledRenderExecutionKind;
	public final executionSummary:String;
	public final executionRequested:Bool;
	public final rendered:Bool;
	public final executionSequence:Int;
	public final sourceSchedulerRequestCount:Int;
	public final consumedScheduledRequestCount:Int;
	public final renderCount:Int;
	@:recordDefault(ResumePickerHostOutcomeKind.Unknown)
	public final renderOutcomeKind:ResumePickerHostOutcomeKind;
	public final renderedSnapshotMatchesSchedule:Bool;
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
	public final renderedSnapshot:String;
	public final schedulingSummary:String;
	public final executionLogSummaries:Array<String>;

	public function summary():String {
		return "executionKind=" + executionKind + ";executionRequested=" + boolLabel(executionRequested) + ";rendered=" + boolLabel(rendered)
			+ ";executionSequence=" + executionSequence + ";sourceSchedulerRequestCount=" + sourceSchedulerRequestCount + ";consumedScheduledRequestCount="
			+ consumedScheduledRequestCount + ";renderCount=" + renderCount + ";renderOutcomeKind=" + renderOutcomeKind + ";renderedSnapshotMatchesSchedule="
			+ boolLabel(renderedSnapshotMatchesSchedule) + ";localOnlyRenderIntent=" + boolLabel(localOnlyRenderIntent) + ";finalThread=" + finalThreadId
			+ ";finalSelectionPreserved=" + boolLabel(finalSelectionPreserved) + ";finalFooterPreserved=" + boolLabel(finalFooterPreserved)
			+ ";inputAdmitted=" + boolLabel(inputAdmitted) + ";stalePromptActionInactive=" + boolLabel(stalePromptActionInactive)
			+ ";staleSideParentActionInactive=" + boolLabel(staleSideParentActionInactive) + ";staleActiveThreadActionInactive="
			+ boolLabel(staleActiveThreadActionInactive) + ";ignoredNoSurfaceAbsent=" + boolLabel(ignoredNoSurfaceRecordsAbsent)
			+ ";noPressureDropRejection=" + boolLabel(noPressureDropRejection) + ";liveTransportSuppressed=" + boolLabel(liveTransportSuppressed)
			+ ";liveTerminalSuppressed=" + boolLabel(liveTerminalSuppressed) + ";stateDbUntouched=" + boolLabel(stateDbUntouched) + ";noModelCall="
			+ boolLabel(noModelCall) + ";noFilesystemMutation=" + boolLabel(noFilesystemMutation) + ";renderedSnapshot="
			+ renderedSnapshot.split("\n").join("\\n") + ";execution=[" + executionSummary + "]" + ";executionLog=[" + executionLogSummaries.join("##") + "]"
			+ ";scheduling=[" + schedulingSummary + "]";
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
