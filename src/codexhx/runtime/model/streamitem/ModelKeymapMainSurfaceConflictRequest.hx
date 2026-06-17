package codexhx.runtime.model.streamitem;

typedef ModelKeymapMainSurfaceConflictRequestFields = {
	final requestId:String;
	final configuredToggleFastModeBinding:Null<ModelKeymapBinding>;
	final defaultClearTerminalBinding:Null<ModelKeymapBinding>;
	final conflictOuterAction:ModelKeymapMainSurfaceActionKind;
	final conflictInnerAction:ModelKeymapMainSurfaceActionKind;
	final expectedOuterActionName:String;
	final expectedInnerActionName:String;
	final conflictRejected:Bool;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelKeymapMainSurfaceConflictRequest {
	public final requestId:String;
	public final configuredToggleFastModeBinding:Null<ModelKeymapBinding>;
	public final defaultClearTerminalBinding:Null<ModelKeymapBinding>;
	public final conflictOuterAction:ModelKeymapMainSurfaceActionKind;
	public final conflictInnerAction:ModelKeymapMainSurfaceActionKind;
	public final expectedOuterActionName:String;
	public final expectedInnerActionName:String;
	public final conflictRejected:Bool;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelKeymapMainSurfaceConflictRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.configuredToggleFastModeBinding = fields.configuredToggleFastModeBinding;
		this.defaultClearTerminalBinding = fields.defaultClearTerminalBinding;
		this.conflictOuterAction = fields.conflictOuterAction == null ? ModelKeymapMainSurfaceActionKind.Unknown : fields.conflictOuterAction;
		this.conflictInnerAction = fields.conflictInnerAction == null ? ModelKeymapMainSurfaceActionKind.Unknown : fields.conflictInnerAction;
		this.expectedOuterActionName = fields.expectedOuterActionName == null ? "" : fields.expectedOuterActionName;
		this.expectedInnerActionName = fields.expectedInnerActionName == null ? "" : fields.expectedInnerActionName;
		this.conflictRejected = fields.conflictRejected;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
