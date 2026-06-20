package codexhx.runtime.tui.resume.live;

typedef ResumePickerAppServerTypedResponseRecoveryFollowUpActionRenderGateReportFields = {
	final actionCount:Int;
	final restoredStatusActionCount:Int;
	final frameActionCount:Int;
	final selectionActionCount:Int;
	final followUpFrameRequests:Int;
	final stalePromptActionAbsent:Bool;
	final staleSideParentActionAbsent:Bool;
	final staleActiveThreadActionAbsent:Bool;
	final ignoredNoSurfaceRecordsAbsent:Bool;
	final recoveryConfirmed:Bool;
	final noPressureDropRejection:Bool;
	final liveTransportSuppressed:Bool;
	final stateDbUntouched:Bool;
	final recoveredThreadId:String;
	final finalSnapshot:String;
	final actionSummaries:Array<String>;
	final plannerLogSummaries:Array<String>;
	final confirmationSummary:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerAppServerTypedResponseRecoveryFollowUpActionRenderGateReport {
	public final actionCount:Int;
	public final restoredStatusActionCount:Int;
	public final frameActionCount:Int;
	public final selectionActionCount:Int;
	public final followUpFrameRequests:Int;
	public final stalePromptActionAbsent:Bool;
	public final staleSideParentActionAbsent:Bool;
	public final staleActiveThreadActionAbsent:Bool;
	public final ignoredNoSurfaceRecordsAbsent:Bool;
	public final recoveryConfirmed:Bool;
	public final noPressureDropRejection:Bool;
	public final liveTransportSuppressed:Bool;
	public final stateDbUntouched:Bool;
	public final recoveredThreadId:String;
	public final finalSnapshot:String;
	public final actionSummaries:Array<String>;
	public final plannerLogSummaries:Array<String>;
	public final confirmationSummary:String;

	public function summary():String {
		return "actionCount=" + actionCount + ";restoredStatusActionCount=" + restoredStatusActionCount + ";frameActionCount=" + frameActionCount
			+ ";selectionActionCount=" + selectionActionCount + ";followUpFrameRequests=" + followUpFrameRequests + ";stalePromptActionAbsent="
			+ boolLabel(stalePromptActionAbsent) + ";staleSideParentActionAbsent=" + boolLabel(staleSideParentActionAbsent)
			+ ";staleActiveThreadActionAbsent=" + boolLabel(staleActiveThreadActionAbsent) + ";ignoredNoSurfaceRecordsAbsent="
			+ boolLabel(ignoredNoSurfaceRecordsAbsent) + ";recoveryConfirmed=" + boolLabel(recoveryConfirmed) + ";noPressureDropRejection="
			+ boolLabel(noPressureDropRejection) + ";liveTransportSuppressed=" + boolLabel(liveTransportSuppressed) + ";stateDbUntouched="
			+ boolLabel(stateDbUntouched) + ";thread=" + recoveredThreadId + ";confirmation=[" + confirmationSummary + "]" + ";finalSnapshot="
			+ finalSnapshot.split("\n").join("\\n") + ";actions=[" + actionSummaries.join("##") + "]" + ";plannerLog=[" + plannerLogSummaries.join("##") + "]";
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
