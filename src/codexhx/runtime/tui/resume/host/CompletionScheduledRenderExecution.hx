package codexhx.runtime.tui.resume.host;

typedef CompletionScheduledRenderExecutionFields = {
	final kind:CompletionScheduledRenderExecutionKind;
	final sourceScheduleKind:CompletionRenderRequestScheduleKind;
	final executionRequested:Bool;
	final rendered:Bool;
	final executionSequence:Int;
	final sourceSchedulerRequestCount:Int;
	final consumedScheduledRequestCount:Int;
	final renderCount:Int;
	final renderOutcomeKind:ResumePickerHostOutcomeKind;
	final renderOutcomePendingCount:Int;
	final renderedSnapshotMatchesSchedule:Bool;
	final finalThreadId:String;
	final finalFooter:String;
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
	final renderedSnapshot:String;
	final reason:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class CompletionScheduledRenderExecution {
	@:recordDefault(CompletionScheduledRenderExecutionKind.Unknown)
	public final kind:CompletionScheduledRenderExecutionKind;
	@:recordDefault(CompletionRenderRequestScheduleKind.Unknown)
	public final sourceScheduleKind:CompletionRenderRequestScheduleKind;
	public final executionRequested:Bool;
	public final rendered:Bool;
	public final executionSequence:Int;
	public final sourceSchedulerRequestCount:Int;
	public final consumedScheduledRequestCount:Int;
	public final renderCount:Int;
	@:recordDefault(ResumePickerHostOutcomeKind.Unknown)
	public final renderOutcomeKind:ResumePickerHostOutcomeKind;
	public final renderOutcomePendingCount:Int;
	public final renderedSnapshotMatchesSchedule:Bool;
	public final finalThreadId:String;
	public final finalFooter:String;
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
	public final renderedSnapshot:String;
	public final reason:String;

	public function summary():String {
		return "kind=" + kind + ";sourceScheduleKind=" + sourceScheduleKind + ";executionRequested=" + boolLabel(executionRequested) + ";rendered="
			+ boolLabel(rendered) + ";executionSequence=" + executionSequence + ";sourceSchedulerRequestCount=" + sourceSchedulerRequestCount
			+ ";consumedScheduledRequestCount=" + consumedScheduledRequestCount + ";renderCount=" + renderCount + ";renderOutcomeKind=" + renderOutcomeKind
			+ ";renderOutcomePendingCount=" + renderOutcomePendingCount + ";renderedSnapshotMatchesSchedule=" + boolLabel(renderedSnapshotMatchesSchedule)
			+ ";finalThread=" + finalThreadId + ";finalFooter=" + finalFooter + ";finalSelectionPreserved=" + boolLabel(finalSelectionPreserved)
			+ ";finalFooterPreserved=" + boolLabel(finalFooterPreserved) + ";inputAdmitted=" + boolLabel(inputAdmitted) + ";localOnlyRenderIntent="
			+ boolLabel(localOnlyRenderIntent) + ";stalePromptActionInactive=" + boolLabel(stalePromptActionInactive) + ";staleSideParentActionInactive="
			+ boolLabel(staleSideParentActionInactive) + ";staleActiveThreadActionInactive=" + boolLabel(staleActiveThreadActionInactive)
			+ ";ignoredNoSurfaceAbsent=" + boolLabel(ignoredNoSurfaceRecordsAbsent) + ";noPressureDropRejection=" + boolLabel(noPressureDropRejection)
			+ ";liveTransportSuppressed=" + boolLabel(liveTransportSuppressed) + ";liveTerminalSuppressed=" + boolLabel(liveTerminalSuppressed)
			+ ";stateDbUntouched=" + boolLabel(stateDbUntouched) + ";noModelCall=" + boolLabel(noModelCall) + ";noFilesystemMutation="
			+ boolLabel(noFilesystemMutation) + ";renderedSnapshot=" + renderedSnapshot.split("\n").join("\\n") + ";reason=" + reason;
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
