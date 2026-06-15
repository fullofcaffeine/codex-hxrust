package codexhx.runtime.model.streamitem;

typedef ModelKeymapVimOperatorTextObjectRequestFields = {
	final requestId:String;
	final configuredMotionLeft:Null<ModelKeymapBinding>;
	final configuredMotionRight:Null<ModelKeymapBinding>;
	final prunedSelectInnerTextObject:Array<ModelKeymapBinding>;
	final prunedSelectAroundTextObject:Array<ModelKeymapBinding>;
	final explicitConflictOuterAction:ModelKeymapVimOperatorTextObjectActionKind;
	final explicitConflictInnerAction:ModelKeymapVimOperatorTextObjectActionKind;
	final explicitConflictBinding:Null<ModelKeymapBinding>;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelKeymapVimOperatorTextObjectRequest {
	public final requestId:String;
	public final configuredMotionLeft:Null<ModelKeymapBinding>;
	public final configuredMotionRight:Null<ModelKeymapBinding>;
	public final prunedSelectInnerTextObject:Array<ModelKeymapBinding>;
	public final prunedSelectAroundTextObject:Array<ModelKeymapBinding>;
	public final explicitConflictOuterAction:ModelKeymapVimOperatorTextObjectActionKind;
	public final explicitConflictInnerAction:ModelKeymapVimOperatorTextObjectActionKind;
	public final explicitConflictBinding:Null<ModelKeymapBinding>;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelKeymapVimOperatorTextObjectRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.configuredMotionLeft = fields.configuredMotionLeft;
		this.configuredMotionRight = fields.configuredMotionRight;
		this.prunedSelectInnerTextObject = fields.prunedSelectInnerTextObject == null ? [] : fields.prunedSelectInnerTextObject;
		this.prunedSelectAroundTextObject = fields.prunedSelectAroundTextObject == null ? [] : fields.prunedSelectAroundTextObject;
		this.explicitConflictOuterAction = fields.explicitConflictOuterAction == null
			? ModelKeymapVimOperatorTextObjectActionKind.Unknown
			: fields.explicitConflictOuterAction;
		this.explicitConflictInnerAction = fields.explicitConflictInnerAction == null
			? ModelKeymapVimOperatorTextObjectActionKind.Unknown
			: fields.explicitConflictInnerAction;
		this.explicitConflictBinding = fields.explicitConflictBinding;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
