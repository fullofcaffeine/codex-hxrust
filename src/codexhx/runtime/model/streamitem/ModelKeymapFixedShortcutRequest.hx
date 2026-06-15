package codexhx.runtime.model.streamitem;

typedef ModelKeymapFixedShortcutRequestFields = {
	final requestId:String;
	final configuredCopyBinding:Null<ModelKeymapBinding>;
	final defaultIncreaseReasoningBinding:Null<ModelKeymapBinding>;
	final conflictOuterAction:ModelKeymapFixedShortcutActionKind;
	final conflictInnerAction:ModelKeymapFixedShortcutActionKind;
	final expectedOuterActionName:String;
	final expectedInnerActionName:String;
	final conflictRejected:Bool;
	final increaseReasoningUnbound:Bool;
	final runtimeAcceptedAfterUnbind:Bool;
	final runtimeCopyBinding:Null<ModelKeymapBinding>;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelKeymapFixedShortcutRequest {
	public final requestId:String;
	public final configuredCopyBinding:Null<ModelKeymapBinding>;
	public final defaultIncreaseReasoningBinding:Null<ModelKeymapBinding>;
	public final conflictOuterAction:ModelKeymapFixedShortcutActionKind;
	public final conflictInnerAction:ModelKeymapFixedShortcutActionKind;
	public final expectedOuterActionName:String;
	public final expectedInnerActionName:String;
	public final conflictRejected:Bool;
	public final increaseReasoningUnbound:Bool;
	public final runtimeAcceptedAfterUnbind:Bool;
	public final runtimeCopyBinding:Null<ModelKeymapBinding>;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelKeymapFixedShortcutRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.configuredCopyBinding = fields.configuredCopyBinding;
		this.defaultIncreaseReasoningBinding = fields.defaultIncreaseReasoningBinding;
		this.conflictOuterAction = fields.conflictOuterAction == null ? ModelKeymapFixedShortcutActionKind.Unknown : fields.conflictOuterAction;
		this.conflictInnerAction = fields.conflictInnerAction == null ? ModelKeymapFixedShortcutActionKind.Unknown : fields.conflictInnerAction;
		this.expectedOuterActionName = fields.expectedOuterActionName == null ? "" : fields.expectedOuterActionName;
		this.expectedInnerActionName = fields.expectedInnerActionName == null ? "" : fields.expectedInnerActionName;
		this.conflictRejected = fields.conflictRejected;
		this.increaseReasoningUnbound = fields.increaseReasoningUnbound;
		this.runtimeAcceptedAfterUnbind = fields.runtimeAcceptedAfterUnbind;
		this.runtimeCopyBinding = fields.runtimeCopyBinding;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
