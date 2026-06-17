package codexhx.runtime.model.streamitem;

typedef ModelKeymapComposerFixedShortcutConflictRequestFields = {
	final requestId:String;
	final configuredComposerSubmitBinding:Null<ModelKeymapBinding>;
	final fixedPasteImageBinding:Null<ModelKeymapBinding>;
	final conflictOuterAction:ModelKeymapComposerFixedShortcutConflictActionKind;
	final conflictInnerAction:ModelKeymapComposerFixedShortcutConflictActionKind;
	final expectedOuterActionName:String;
	final expectedInnerActionName:String;
	final conflictRejected:Bool;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelKeymapComposerFixedShortcutConflictRequest {
	public final requestId:String;
	public final configuredComposerSubmitBinding:Null<ModelKeymapBinding>;
	public final fixedPasteImageBinding:Null<ModelKeymapBinding>;
	public final conflictOuterAction:ModelKeymapComposerFixedShortcutConflictActionKind;
	public final conflictInnerAction:ModelKeymapComposerFixedShortcutConflictActionKind;
	public final expectedOuterActionName:String;
	public final expectedInnerActionName:String;
	public final conflictRejected:Bool;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelKeymapComposerFixedShortcutConflictRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.configuredComposerSubmitBinding = fields.configuredComposerSubmitBinding;
		this.fixedPasteImageBinding = fields.fixedPasteImageBinding;
		this.conflictOuterAction = fields.conflictOuterAction == null ? ModelKeymapComposerFixedShortcutConflictActionKind.Unknown : fields.conflictOuterAction;
		this.conflictInnerAction = fields.conflictInnerAction == null ? ModelKeymapComposerFixedShortcutConflictActionKind.Unknown : fields.conflictInnerAction;
		this.expectedOuterActionName = fields.expectedOuterActionName == null ? "" : fields.expectedOuterActionName;
		this.expectedInnerActionName = fields.expectedInnerActionName == null ? "" : fields.expectedInnerActionName;
		this.conflictRejected = fields.conflictRejected;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
