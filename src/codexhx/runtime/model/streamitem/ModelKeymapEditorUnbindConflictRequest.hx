package codexhx.runtime.model.streamitem;

typedef ModelKeymapEditorUnbindConflictRequestFields = {
	final requestId:String;
	final configuredKillWholeLine:Null<ModelKeymapBinding>;
	final defaultKillLineStart:Null<ModelKeymapBinding>;
	final conflictOuterAction:ModelKeymapEditorUnbindConflictActionKind;
	final conflictInnerAction:ModelKeymapEditorUnbindConflictActionKind;
	final expectedOuterActionName:String;
	final expectedInnerActionName:String;
	final conflictRejected:Bool;
	final killLineStartUnbound:Bool;
	final runtimeAcceptedAfterUnbind:Bool;
	final runtimeKillWholeLine:Null<ModelKeymapBinding>;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelKeymapEditorUnbindConflictRequest {
	public final requestId:String;
	public final configuredKillWholeLine:Null<ModelKeymapBinding>;
	public final defaultKillLineStart:Null<ModelKeymapBinding>;
	public final conflictOuterAction:ModelKeymapEditorUnbindConflictActionKind;
	public final conflictInnerAction:ModelKeymapEditorUnbindConflictActionKind;
	public final expectedOuterActionName:String;
	public final expectedInnerActionName:String;
	public final conflictRejected:Bool;
	public final killLineStartUnbound:Bool;
	public final runtimeAcceptedAfterUnbind:Bool;
	public final runtimeKillWholeLine:Null<ModelKeymapBinding>;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelKeymapEditorUnbindConflictRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.configuredKillWholeLine = fields.configuredKillWholeLine;
		this.defaultKillLineStart = fields.defaultKillLineStart;
		this.conflictOuterAction = fields.conflictOuterAction == null ? ModelKeymapEditorUnbindConflictActionKind.Unknown : fields.conflictOuterAction;
		this.conflictInnerAction = fields.conflictInnerAction == null ? ModelKeymapEditorUnbindConflictActionKind.Unknown : fields.conflictInnerAction;
		this.expectedOuterActionName = fields.expectedOuterActionName == null ? "" : fields.expectedOuterActionName;
		this.expectedInnerActionName = fields.expectedInnerActionName == null ? "" : fields.expectedInnerActionName;
		this.conflictRejected = fields.conflictRejected;
		this.killLineStartUnbound = fields.killLineStartUnbound;
		this.runtimeAcceptedAfterUnbind = fields.runtimeAcceptedAfterUnbind;
		this.runtimeKillWholeLine = fields.runtimeKillWholeLine;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
