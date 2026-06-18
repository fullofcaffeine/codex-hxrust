package codexhx.runtime.model.streamitem;

typedef ModelKeymapDefaultPruningRequestFields = {
	final requestId:String;
	final tailMainSurfaceDefaults:Array<ModelKeymapDefaultPruningCase>;
	final listPageAndJumpDefaults:Array<ModelKeymapDefaultPruningCase>;
	final configuredEditorMoveUp:Null<ModelKeymapBinding>;
	final configuredVimTextObjectWord:Null<ModelKeymapBinding>;
	final prunedDecreaseReasoningBindings:Array<ModelKeymapBinding>;
	final prunedIncreaseReasoningBindings:Array<ModelKeymapBinding>;
	final explicitConflictOuterAction:ModelKeymapDefaultPruningActionKind;
	final explicitConflictInnerAction:ModelKeymapDefaultPruningActionKind;
	final explicitConflictBinding:Null<ModelKeymapBinding>;
	final legacyListMoveUpConfigured:Null<ModelKeymapBinding>;
	final legacyListMoveDownConfigured:Null<ModelKeymapBinding>;
	final legacyListPageUpPruned:Array<ModelKeymapBinding>;
	final legacyListPageDownPruned:Array<ModelKeymapBinding>;
	final legacyListPruneAllMoveUpConfigured:Array<ModelKeymapBinding>;
	final legacyListPruneAllRuntimeMoveUp:Array<ModelKeymapBinding>;
	final legacyListPruneAllPageUpPruned:Array<ModelKeymapBinding>;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelKeymapDefaultPruningRequest {
	public final requestId:String;
	public final tailMainSurfaceDefaults:Array<ModelKeymapDefaultPruningCase>;
	public final listPageAndJumpDefaults:Array<ModelKeymapDefaultPruningCase>;
	public final configuredEditorMoveUp:Null<ModelKeymapBinding>;
	public final configuredVimTextObjectWord:Null<ModelKeymapBinding>;
	public final prunedDecreaseReasoningBindings:Array<ModelKeymapBinding>;
	public final prunedIncreaseReasoningBindings:Array<ModelKeymapBinding>;
	public final explicitConflictOuterAction:ModelKeymapDefaultPruningActionKind;
	public final explicitConflictInnerAction:ModelKeymapDefaultPruningActionKind;
	public final explicitConflictBinding:Null<ModelKeymapBinding>;
	public final legacyListMoveUpConfigured:Null<ModelKeymapBinding>;
	public final legacyListMoveDownConfigured:Null<ModelKeymapBinding>;
	public final legacyListPageUpPruned:Array<ModelKeymapBinding>;
	public final legacyListPageDownPruned:Array<ModelKeymapBinding>;
	public final legacyListPruneAllMoveUpConfigured:Array<ModelKeymapBinding>;
	public final legacyListPruneAllRuntimeMoveUp:Array<ModelKeymapBinding>;
	public final legacyListPruneAllPageUpPruned:Array<ModelKeymapBinding>;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelKeymapDefaultPruningRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.tailMainSurfaceDefaults = fields.tailMainSurfaceDefaults == null ? [] : fields.tailMainSurfaceDefaults;
		this.listPageAndJumpDefaults = fields.listPageAndJumpDefaults == null ? [] : fields.listPageAndJumpDefaults;
		this.configuredEditorMoveUp = fields.configuredEditorMoveUp;
		this.configuredVimTextObjectWord = fields.configuredVimTextObjectWord;
		this.prunedDecreaseReasoningBindings = fields.prunedDecreaseReasoningBindings == null ? [] : fields.prunedDecreaseReasoningBindings;
		this.prunedIncreaseReasoningBindings = fields.prunedIncreaseReasoningBindings == null ? [] : fields.prunedIncreaseReasoningBindings;
		this.explicitConflictOuterAction = fields.explicitConflictOuterAction == null ? ModelKeymapDefaultPruningActionKind.Unknown : fields.explicitConflictOuterAction;
		this.explicitConflictInnerAction = fields.explicitConflictInnerAction == null ? ModelKeymapDefaultPruningActionKind.Unknown : fields.explicitConflictInnerAction;
		this.explicitConflictBinding = fields.explicitConflictBinding;
		this.legacyListMoveUpConfigured = fields.legacyListMoveUpConfigured;
		this.legacyListMoveDownConfigured = fields.legacyListMoveDownConfigured;
		this.legacyListPageUpPruned = fields.legacyListPageUpPruned == null ? [] : fields.legacyListPageUpPruned;
		this.legacyListPageDownPruned = fields.legacyListPageDownPruned == null ? [] : fields.legacyListPageDownPruned;
		this.legacyListPruneAllMoveUpConfigured = fields.legacyListPruneAllMoveUpConfigured == null ? [] : fields.legacyListPruneAllMoveUpConfigured;
		this.legacyListPruneAllRuntimeMoveUp = fields.legacyListPruneAllRuntimeMoveUp == null ? [] : fields.legacyListPruneAllRuntimeMoveUp;
		this.legacyListPruneAllPageUpPruned = fields.legacyListPruneAllPageUpPruned == null ? [] : fields.legacyListPruneAllPageUpPruned;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
