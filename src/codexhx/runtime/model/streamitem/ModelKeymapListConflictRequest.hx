package codexhx.runtime.model.streamitem;

typedef ModelKeymapListConflictRequestFields = {
	final requestId:String;
	final configuredOuterBinding:Null<ModelKeymapBinding>;
	final configuredInnerBinding:Null<ModelKeymapBinding>;
	final conflictOuterAction:ModelKeymapListConflictActionKind;
	final conflictInnerAction:ModelKeymapListConflictActionKind;
	final expectedOuterActionName:String;
	final expectedInnerActionName:String;
	final conflictRejected:Bool;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelKeymapListConflictRequest {
	public final requestId:String;
	public final configuredOuterBinding:Null<ModelKeymapBinding>;
	public final configuredInnerBinding:Null<ModelKeymapBinding>;
	public final conflictOuterAction:ModelKeymapListConflictActionKind;
	public final conflictInnerAction:ModelKeymapListConflictActionKind;
	public final expectedOuterActionName:String;
	public final expectedInnerActionName:String;
	public final conflictRejected:Bool;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelKeymapListConflictRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.configuredOuterBinding = fields.configuredOuterBinding;
		this.configuredInnerBinding = fields.configuredInnerBinding;
		this.conflictOuterAction = fields.conflictOuterAction == null ? ModelKeymapListConflictActionKind.Unknown : fields.conflictOuterAction;
		this.conflictInnerAction = fields.conflictInnerAction == null ? ModelKeymapListConflictActionKind.Unknown : fields.conflictInnerAction;
		this.expectedOuterActionName = fields.expectedOuterActionName == null ? "" : fields.expectedOuterActionName;
		this.expectedInnerActionName = fields.expectedInnerActionName == null ? "" : fields.expectedInnerActionName;
		this.conflictRejected = fields.conflictRejected;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
