package codexhx.runtime.model.streamitem;

typedef ModelInterruptQuestionNavigationKeymapRequestFields = {
	final requestId:String;
	final interruptActionName:String;
	final questionNavigationActionName:String;
	final interruptBinding:String;
	final questionNavigationBinding:String;
	final fixedBacktrackActionName:String;
	final fixedBacktrackBinding:String;
	final allowedOverlapBinding:String;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelInterruptQuestionNavigationKeymapRequest {
	public final requestId:String;
	public final interruptActionName:String;
	public final questionNavigationActionName:String;
	public final interruptBinding:String;
	public final questionNavigationBinding:String;
	public final fixedBacktrackActionName:String;
	public final fixedBacktrackBinding:String;
	public final allowedOverlapBinding:String;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelInterruptQuestionNavigationKeymapRequestFields) {
		this.requestId = normalizeText(fields.requestId);
		this.interruptActionName = normalizeText(fields.interruptActionName);
		this.questionNavigationActionName = normalizeText(fields.questionNavigationActionName);
		this.interruptBinding = normalizeBinding(fields.interruptBinding);
		this.questionNavigationBinding = normalizeBinding(fields.questionNavigationBinding);
		this.fixedBacktrackActionName = normalizeText(fields.fixedBacktrackActionName);
		this.fixedBacktrackBinding = normalizeBinding(fields.fixedBacktrackBinding);
		this.allowedOverlapBinding = normalizeBinding(fields.allowedOverlapBinding);
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = normalizeText(fields.secretProbe);
	}

	static function normalizeText(value:String):String {
		return value == null ? "" : value;
	}

	static function normalizeBinding(value:String):String {
		return value == null ? "" : value.toLowerCase();
	}
}
