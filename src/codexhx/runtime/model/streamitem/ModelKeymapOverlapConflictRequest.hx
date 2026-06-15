package codexhx.runtime.model.streamitem;

typedef ModelKeymapOverlapConflictRequestFields = {
	final requestId:String;
	final explicitListLegacyOuterAction:ModelKeymapOverlapConflictActionKind;
	final explicitListLegacyInnerAction:ModelKeymapOverlapConflictActionKind;
	final explicitListLegacyBinding:Null<ModelKeymapBinding>;
	final configuredAppCopy:Null<ModelKeymapBinding>;
	final prunedListPageDownAfterApp:Array<ModelKeymapBinding>;
	final configuredApprovalApprove:Null<ModelKeymapBinding>;
	final prunedListJumpTopAfterApproval:Array<ModelKeymapBinding>;
	final explicitListApprovalOuterAction:ModelKeymapOverlapConflictActionKind;
	final explicitListApprovalInnerAction:ModelKeymapOverlapConflictActionKind;
	final explicitListApprovalBinding:Null<ModelKeymapBinding>;
	final configuredLegacyVimMoveLeftForChange:Null<ModelKeymapBinding>;
	final prunedVimStartChangeOperator:Array<ModelKeymapBinding>;
	final explicitVimChangeOuterAction:ModelKeymapOverlapConflictActionKind;
	final explicitVimChangeInnerAction:ModelKeymapOverlapConflictActionKind;
	final explicitVimChangeBinding:Null<ModelKeymapBinding>;
	final configuredLegacyVimMoveLeftForSubstitute:Null<ModelKeymapBinding>;
	final prunedVimSubstituteChar:Array<ModelKeymapBinding>;
	final explicitVimSubstituteOuterAction:ModelKeymapOverlapConflictActionKind;
	final explicitVimSubstituteInnerAction:ModelKeymapOverlapConflictActionKind;
	final explicitVimSubstituteBinding:Null<ModelKeymapBinding>;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelKeymapOverlapConflictRequest {
	public final requestId:String;
	public final explicitListLegacyOuterAction:ModelKeymapOverlapConflictActionKind;
	public final explicitListLegacyInnerAction:ModelKeymapOverlapConflictActionKind;
	public final explicitListLegacyBinding:Null<ModelKeymapBinding>;
	public final configuredAppCopy:Null<ModelKeymapBinding>;
	public final prunedListPageDownAfterApp:Array<ModelKeymapBinding>;
	public final configuredApprovalApprove:Null<ModelKeymapBinding>;
	public final prunedListJumpTopAfterApproval:Array<ModelKeymapBinding>;
	public final explicitListApprovalOuterAction:ModelKeymapOverlapConflictActionKind;
	public final explicitListApprovalInnerAction:ModelKeymapOverlapConflictActionKind;
	public final explicitListApprovalBinding:Null<ModelKeymapBinding>;
	public final configuredLegacyVimMoveLeftForChange:Null<ModelKeymapBinding>;
	public final prunedVimStartChangeOperator:Array<ModelKeymapBinding>;
	public final explicitVimChangeOuterAction:ModelKeymapOverlapConflictActionKind;
	public final explicitVimChangeInnerAction:ModelKeymapOverlapConflictActionKind;
	public final explicitVimChangeBinding:Null<ModelKeymapBinding>;
	public final configuredLegacyVimMoveLeftForSubstitute:Null<ModelKeymapBinding>;
	public final prunedVimSubstituteChar:Array<ModelKeymapBinding>;
	public final explicitVimSubstituteOuterAction:ModelKeymapOverlapConflictActionKind;
	public final explicitVimSubstituteInnerAction:ModelKeymapOverlapConflictActionKind;
	public final explicitVimSubstituteBinding:Null<ModelKeymapBinding>;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelKeymapOverlapConflictRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.explicitListLegacyOuterAction = actionOrUnknown(fields.explicitListLegacyOuterAction);
		this.explicitListLegacyInnerAction = actionOrUnknown(fields.explicitListLegacyInnerAction);
		this.explicitListLegacyBinding = fields.explicitListLegacyBinding;
		this.configuredAppCopy = fields.configuredAppCopy;
		this.prunedListPageDownAfterApp = fields.prunedListPageDownAfterApp == null ? [] : fields.prunedListPageDownAfterApp;
		this.configuredApprovalApprove = fields.configuredApprovalApprove;
		this.prunedListJumpTopAfterApproval = fields.prunedListJumpTopAfterApproval == null ? [] : fields.prunedListJumpTopAfterApproval;
		this.explicitListApprovalOuterAction = actionOrUnknown(fields.explicitListApprovalOuterAction);
		this.explicitListApprovalInnerAction = actionOrUnknown(fields.explicitListApprovalInnerAction);
		this.explicitListApprovalBinding = fields.explicitListApprovalBinding;
		this.configuredLegacyVimMoveLeftForChange = fields.configuredLegacyVimMoveLeftForChange;
		this.prunedVimStartChangeOperator = fields.prunedVimStartChangeOperator == null ? [] : fields.prunedVimStartChangeOperator;
		this.explicitVimChangeOuterAction = actionOrUnknown(fields.explicitVimChangeOuterAction);
		this.explicitVimChangeInnerAction = actionOrUnknown(fields.explicitVimChangeInnerAction);
		this.explicitVimChangeBinding = fields.explicitVimChangeBinding;
		this.configuredLegacyVimMoveLeftForSubstitute = fields.configuredLegacyVimMoveLeftForSubstitute;
		this.prunedVimSubstituteChar = fields.prunedVimSubstituteChar == null ? [] : fields.prunedVimSubstituteChar;
		this.explicitVimSubstituteOuterAction = actionOrUnknown(fields.explicitVimSubstituteOuterAction);
		this.explicitVimSubstituteInnerAction = actionOrUnknown(fields.explicitVimSubstituteInnerAction);
		this.explicitVimSubstituteBinding = fields.explicitVimSubstituteBinding;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}

	static function actionOrUnknown(action:ModelKeymapOverlapConflictActionKind):ModelKeymapOverlapConflictActionKind {
		return action == null ? ModelKeymapOverlapConflictActionKind.Unknown : action;
	}
}
