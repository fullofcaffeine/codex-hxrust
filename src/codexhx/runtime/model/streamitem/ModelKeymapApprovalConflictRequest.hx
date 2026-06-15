package codexhx.runtime.model.streamitem;

typedef ModelKeymapApprovalConflictRequestFields = {
	final requestId:String;
	final configuredApprove:Null<ModelKeymapBinding>;
	final configuredDecline:Null<ModelKeymapBinding>;
	final configuredDeny:Null<ModelKeymapBinding>;
	final conflictOuterAction:ModelKeymapApprovalConflictActionKind;
	final conflictInnerAction:ModelKeymapApprovalConflictActionKind;
	final expectedOuterActionName:String;
	final expectedInnerActionName:String;
	final conflictRejected:Bool;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelKeymapApprovalConflictRequest {
	public final requestId:String;
	public final configuredApprove:Null<ModelKeymapBinding>;
	public final configuredDecline:Null<ModelKeymapBinding>;
	public final configuredDeny:Null<ModelKeymapBinding>;
	public final conflictOuterAction:ModelKeymapApprovalConflictActionKind;
	public final conflictInnerAction:ModelKeymapApprovalConflictActionKind;
	public final expectedOuterActionName:String;
	public final expectedInnerActionName:String;
	public final conflictRejected:Bool;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelKeymapApprovalConflictRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.configuredApprove = fields.configuredApprove;
		this.configuredDecline = fields.configuredDecline;
		this.configuredDeny = fields.configuredDeny;
		this.conflictOuterAction = fields.conflictOuterAction == null ? ModelKeymapApprovalConflictActionKind.Unknown : fields.conflictOuterAction;
		this.conflictInnerAction = fields.conflictInnerAction == null ? ModelKeymapApprovalConflictActionKind.Unknown : fields.conflictInnerAction;
		this.expectedOuterActionName = fields.expectedOuterActionName == null ? "" : fields.expectedOuterActionName;
		this.expectedInnerActionName = fields.expectedInnerActionName == null ? "" : fields.expectedInnerActionName;
		this.conflictRejected = fields.conflictRejected;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
