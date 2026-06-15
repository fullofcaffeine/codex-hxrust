package codexhx.runtime.model.streamitem;

typedef ModelKeymapEditorAssignmentRequestFields = {
	final requestId:String;
	final actionKind:ModelKeymapEditorAssignmentActionKind;
	final defaultBindings:Array<ModelKeymapBinding>;
	final configuredBinding:Null<ModelKeymapBinding>;
	final runtimeBinding:Null<ModelKeymapBinding>;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelKeymapEditorAssignmentRequest {
	public final requestId:String;
	public final actionKind:ModelKeymapEditorAssignmentActionKind;
	public final defaultBindings:Array<ModelKeymapBinding>;
	public final configuredBinding:Null<ModelKeymapBinding>;
	public final runtimeBinding:Null<ModelKeymapBinding>;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelKeymapEditorAssignmentRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.actionKind = fields.actionKind == null ? ModelKeymapEditorAssignmentActionKind.Unknown : fields.actionKind;
		this.defaultBindings = fields.defaultBindings == null ? [] : fields.defaultBindings;
		this.configuredBinding = fields.configuredBinding;
		this.runtimeBinding = fields.runtimeBinding;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
