package codexhx.runtime.tui.smoke;

typedef TuiSmokeThreadSettingsActionFields = {
	final kind:TuiSmokeThreadSettingsActionKind;
	final threadId:String;
	final incomingThreadId:String;
	final previousModel:String;
	final incomingModel:String;
	final finalModel:String;
	final previousReasoningEffort:String;
	final incomingReasoningEffort:String;
	final finalReasoningEffort:String;
	final serviceTier:String;
	final approvalPolicy:String;
	final approvalsReviewer:String;
	final permissionProfile:String;
	final personality:String;
	final activeCollaborationMode:String;
	final defaultCollaborationMode:String;
	final maskCollaborationMode:String;
	final restoredModel:String;
	final restoredReasoningEffort:String;
	final transcriptHistoryInserted:Bool;
	final ignored:Bool;
	final defaultPreserved:Bool;
	final defaultMaskRestored:Bool;
	final failureCode:String;
	final noAppServerDelivery:Bool;
	final noRatatuiRender:Bool;
	final noModelCall:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
/** Typed headless evidence for one upstream ChatWidget thread-settings notification behavior. */
class TuiSmokeThreadSettingsAction {
	public final kind:TuiSmokeThreadSettingsActionKind;
	public final threadId:String;
	public final incomingThreadId:String;
	public final previousModel:String;
	public final incomingModel:String;
	public final finalModel:String;
	public final previousReasoningEffort:String;
	public final incomingReasoningEffort:String;
	public final finalReasoningEffort:String;
	public final serviceTier:String;
	public final approvalPolicy:String;
	public final approvalsReviewer:String;
	public final permissionProfile:String;
	public final personality:String;
	public final activeCollaborationMode:String;
	public final defaultCollaborationMode:String;
	public final maskCollaborationMode:String;
	public final restoredModel:String;
	public final restoredReasoningEffort:String;
	public final transcriptHistoryInserted:Bool;
	public final ignored:Bool;
	public final defaultPreserved:Bool;
	public final defaultMaskRestored:Bool;
	public final failureCode:String;
	public final noAppServerDelivery:Bool;
	public final noRatatuiRender:Bool;
	public final noModelCall:Bool;
	public final unsupportedRejected:Bool;
}
