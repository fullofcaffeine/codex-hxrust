package codexhx.runtime.tui.resume.host;

typedef CompletionRenderRequestScheduleFields = {
	final kind:CompletionRenderRequestScheduleKind;
	final sourceRenderIntentKind:CompletionInputRenderIntentKind;
	final scheduleRequested:Bool;
	final scheduled:Bool;
	final scheduleSequence:Int;
	final schedulerPendingCount:Int;
	final schedulerSkippedCount:Int;
	final schedulerReason:String;
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
	final reason:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class CompletionRenderRequestSchedule {
	@:recordDefault(CompletionRenderRequestScheduleKind.Unknown)
	public final kind:CompletionRenderRequestScheduleKind;
	@:recordDefault(CompletionInputRenderIntentKind.Unknown)
	public final sourceRenderIntentKind:CompletionInputRenderIntentKind;
	public final scheduleRequested:Bool;
	public final scheduled:Bool;
	public final scheduleSequence:Int;
	public final schedulerPendingCount:Int;
	public final schedulerSkippedCount:Int;
	public final schedulerReason:String;
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
	public final reason:String;

	public function summary():String {
		return "kind=" + kind + ";sourceRenderIntentKind=" + sourceRenderIntentKind + ";scheduleRequested=" + boolLabel(scheduleRequested) + ";scheduled="
			+ boolLabel(scheduled) + ";scheduleSequence=" + scheduleSequence + ";schedulerPendingCount=" + schedulerPendingCount + ";schedulerSkippedCount="
			+ schedulerSkippedCount + ";schedulerReason=" + schedulerReason + ";finalThread=" + finalThreadId + ";finalFooter=" + finalFooter
			+ ";finalSelectionPreserved=" + boolLabel(finalSelectionPreserved) + ";finalFooterPreserved=" + boolLabel(finalFooterPreserved)
			+ ";inputAdmitted=" + boolLabel(inputAdmitted) + ";localOnlyRenderIntent=" + boolLabel(localOnlyRenderIntent) + ";stalePromptActionInactive="
			+ boolLabel(stalePromptActionInactive) + ";staleSideParentActionInactive=" + boolLabel(staleSideParentActionInactive)
			+ ";staleActiveThreadActionInactive=" + boolLabel(staleActiveThreadActionInactive) + ";ignoredNoSurfaceAbsent="
			+ boolLabel(ignoredNoSurfaceRecordsAbsent) + ";noPressureDropRejection=" + boolLabel(noPressureDropRejection) + ";liveTransportSuppressed="
			+ boolLabel(liveTransportSuppressed) + ";liveTerminalSuppressed=" + boolLabel(liveTerminalSuppressed) + ";stateDbUntouched="
			+ boolLabel(stateDbUntouched) + ";noModelCall=" + boolLabel(noModelCall) + ";noFilesystemMutation=" + boolLabel(noFilesystemMutation)
			+ ";reason=" + reason;
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
