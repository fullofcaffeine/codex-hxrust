package codexhx.runtime.model.streamitem;

typedef ModelKeymapBindingInputRequestFields = {
	final requestId:String;
	final invalidMultiBindingPath:String;
	final invalidModifierRejected:Bool;
	final validMultiBindings:Array<ModelKeymapBinding>;
	final dedupeInputBindings:Array<ModelKeymapBinding>;
	final dedupeExpectedBindings:Array<ModelKeymapBinding>;
	final globalQueueBinding:Null<ModelKeymapBinding>;
	final composerQueueResolved:Null<ModelKeymapBinding>;
	final invalidGlobalOpenTranscriptPath:String;
	final invalidGlobalOpenExternalEditorPath:String;
	final defaultCopyBinding:Null<ModelKeymapBinding>;
	final defaultMainSurfaceActions:Array<ModelKeymapDefaultActionCase>;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelKeymapBindingInputRequest {
	public final requestId:String;
	public final invalidMultiBindingPath:String;
	public final invalidModifierRejected:Bool;
	public final validMultiBindings:Array<ModelKeymapBinding>;
	public final dedupeInputBindings:Array<ModelKeymapBinding>;
	public final dedupeExpectedBindings:Array<ModelKeymapBinding>;
	public final globalQueueBinding:Null<ModelKeymapBinding>;
	public final composerQueueResolved:Null<ModelKeymapBinding>;
	public final invalidGlobalOpenTranscriptPath:String;
	public final invalidGlobalOpenExternalEditorPath:String;
	public final defaultCopyBinding:Null<ModelKeymapBinding>;
	public final defaultMainSurfaceActions:Array<ModelKeymapDefaultActionCase>;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelKeymapBindingInputRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.invalidMultiBindingPath = fields.invalidMultiBindingPath == null ? "" : fields.invalidMultiBindingPath;
		this.invalidModifierRejected = fields.invalidModifierRejected;
		this.validMultiBindings = fields.validMultiBindings == null ? [] : fields.validMultiBindings;
		this.dedupeInputBindings = fields.dedupeInputBindings == null ? [] : fields.dedupeInputBindings;
		this.dedupeExpectedBindings = fields.dedupeExpectedBindings == null ? [] : fields.dedupeExpectedBindings;
		this.globalQueueBinding = fields.globalQueueBinding;
		this.composerQueueResolved = fields.composerQueueResolved;
		this.invalidGlobalOpenTranscriptPath = fields.invalidGlobalOpenTranscriptPath == null ? "" : fields.invalidGlobalOpenTranscriptPath;
		this.invalidGlobalOpenExternalEditorPath = fields.invalidGlobalOpenExternalEditorPath == null ? "" : fields.invalidGlobalOpenExternalEditorPath;
		this.defaultCopyBinding = fields.defaultCopyBinding;
		this.defaultMainSurfaceActions = fields.defaultMainSurfaceActions == null ? [] : fields.defaultMainSurfaceActions;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
