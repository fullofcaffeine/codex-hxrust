package codexhx.runtime.model.streamitem;

typedef ModelInterruptBacktrackKeymapRequestFields = {
	final requestId:String;
	final defaultInterruptBinding:String;
	final fixedBacktrackBinding:String;
	final remappedInterruptBinding:String;
	final unboundInterruptCount:Int;
	final fixedPasteImageBinding:String;
	final conflictingInterruptBinding:String;
	final conflictOuterAction:ModelInterruptBacktrackFixedShortcutActionKind;
	final conflictInnerAction:ModelInterruptBacktrackFixedShortcutActionKind;
	final expectedOuterActionName:String;
	final expectedInnerActionName:String;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelInterruptBacktrackKeymapRequest {
	public final requestId:String;
	public final defaultInterruptBinding:String;
	public final fixedBacktrackBinding:String;
	public final remappedInterruptBinding:String;
	public final unboundInterruptCount:Int;
	public final fixedPasteImageBinding:String;
	public final conflictingInterruptBinding:String;
	public final conflictOuterAction:ModelInterruptBacktrackFixedShortcutActionKind;
	public final conflictInnerAction:ModelInterruptBacktrackFixedShortcutActionKind;
	public final expectedOuterActionName:String;
	public final expectedInnerActionName:String;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelInterruptBacktrackKeymapRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.defaultInterruptBinding = normalizeBinding(fields.defaultInterruptBinding);
		this.fixedBacktrackBinding = normalizeBinding(fields.fixedBacktrackBinding);
		this.remappedInterruptBinding = normalizeBinding(fields.remappedInterruptBinding);
		this.unboundInterruptCount = fields.unboundInterruptCount;
		this.fixedPasteImageBinding = normalizeBinding(fields.fixedPasteImageBinding);
		this.conflictingInterruptBinding = normalizeBinding(fields.conflictingInterruptBinding);
		this.conflictOuterAction = fields.conflictOuterAction == null ? ModelInterruptBacktrackFixedShortcutActionKind.Unknown : fields.conflictOuterAction;
		this.conflictInnerAction = fields.conflictInnerAction == null ? ModelInterruptBacktrackFixedShortcutActionKind.Unknown : fields.conflictInnerAction;
		this.expectedOuterActionName = fields.expectedOuterActionName == null ? "" : fields.expectedOuterActionName;
		this.expectedInnerActionName = fields.expectedInnerActionName == null ? "" : fields.expectedInnerActionName;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}

	static function normalizeBinding(value:String):String {
		return value == null ? "" : value.toLowerCase();
	}
}
