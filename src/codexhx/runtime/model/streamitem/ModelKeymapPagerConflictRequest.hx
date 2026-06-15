package codexhx.runtime.model.streamitem;

typedef ModelKeymapPagerConflictRequestFields = {
	final requestId:String;
	final configuredScrollUp:Null<ModelKeymapBinding>;
	final configuredScrollDown:Null<ModelKeymapBinding>;
	final conflictOuterAction:ModelKeymapPagerConflictActionKind;
	final conflictInnerAction:ModelKeymapPagerConflictActionKind;
	final expectedOuterActionName:String;
	final expectedInnerActionName:String;
	final conflictRejected:Bool;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelKeymapPagerConflictRequest {
	public final requestId:String;
	public final configuredScrollUp:Null<ModelKeymapBinding>;
	public final configuredScrollDown:Null<ModelKeymapBinding>;
	public final conflictOuterAction:ModelKeymapPagerConflictActionKind;
	public final conflictInnerAction:ModelKeymapPagerConflictActionKind;
	public final expectedOuterActionName:String;
	public final expectedInnerActionName:String;
	public final conflictRejected:Bool;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelKeymapPagerConflictRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.configuredScrollUp = fields.configuredScrollUp;
		this.configuredScrollDown = fields.configuredScrollDown;
		this.conflictOuterAction = fields.conflictOuterAction == null ? ModelKeymapPagerConflictActionKind.Unknown : fields.conflictOuterAction;
		this.conflictInnerAction = fields.conflictInnerAction == null ? ModelKeymapPagerConflictActionKind.Unknown : fields.conflictInnerAction;
		this.expectedOuterActionName = fields.expectedOuterActionName == null ? "" : fields.expectedOuterActionName;
		this.expectedInnerActionName = fields.expectedInnerActionName == null ? "" : fields.expectedInnerActionName;
		this.conflictRejected = fields.conflictRejected;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
