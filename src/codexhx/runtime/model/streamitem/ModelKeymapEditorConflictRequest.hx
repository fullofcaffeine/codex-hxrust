package codexhx.runtime.model.streamitem;

typedef ModelKeymapEditorConflictRequestFields = {
	final requestId:String;
	final configuredMoveLeft:Null<ModelKeymapBinding>;
	final configuredMoveRight:Null<ModelKeymapBinding>;
	final conflictOuterAction:ModelKeymapEditorConflictActionKind;
	final conflictInnerAction:ModelKeymapEditorConflictActionKind;
	final expectedOuterActionName:String;
	final expectedInnerActionName:String;
	final conflictRejected:Bool;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelKeymapEditorConflictRequest {
	public final requestId:String;
	public final configuredMoveLeft:Null<ModelKeymapBinding>;
	public final configuredMoveRight:Null<ModelKeymapBinding>;
	public final conflictOuterAction:ModelKeymapEditorConflictActionKind;
	public final conflictInnerAction:ModelKeymapEditorConflictActionKind;
	public final expectedOuterActionName:String;
	public final expectedInnerActionName:String;
	public final conflictRejected:Bool;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelKeymapEditorConflictRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.configuredMoveLeft = fields.configuredMoveLeft;
		this.configuredMoveRight = fields.configuredMoveRight;
		this.conflictOuterAction = fields.conflictOuterAction == null ? ModelKeymapEditorConflictActionKind.Unknown : fields.conflictOuterAction;
		this.conflictInnerAction = fields.conflictInnerAction == null ? ModelKeymapEditorConflictActionKind.Unknown : fields.conflictInnerAction;
		this.expectedOuterActionName = fields.expectedOuterActionName == null ? "" : fields.expectedOuterActionName;
		this.expectedInnerActionName = fields.expectedInnerActionName == null ? "" : fields.expectedInnerActionName;
		this.conflictRejected = fields.conflictRejected;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
