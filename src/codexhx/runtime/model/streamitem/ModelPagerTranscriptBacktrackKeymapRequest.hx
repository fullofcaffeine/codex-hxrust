package codexhx.runtime.model.streamitem;

typedef ModelPagerTranscriptBacktrackKeymapRequestFields = {
	final requestId:String;
	final pagerActionName:String;
	final pagerBinding:String;
	final transcriptBacktrackActionName:String;
	final transcriptBacktrackBinding:String;
	final interruptActionName:String;
	final fixedBacktrackActionName:String;
	final allowedBacktrackOverlapBinding:String;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelPagerTranscriptBacktrackKeymapRequest {
	public final requestId:String;
	public final pagerActionName:String;
	public final pagerBinding:String;
	public final transcriptBacktrackActionName:String;
	public final transcriptBacktrackBinding:String;
	public final interruptActionName:String;
	public final fixedBacktrackActionName:String;
	public final allowedBacktrackOverlapBinding:String;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelPagerTranscriptBacktrackKeymapRequestFields) {
		this.requestId = normalizeText(fields.requestId);
		this.pagerActionName = normalizeText(fields.pagerActionName);
		this.pagerBinding = normalizeBinding(fields.pagerBinding);
		this.transcriptBacktrackActionName = normalizeText(fields.transcriptBacktrackActionName);
		this.transcriptBacktrackBinding = normalizeBinding(fields.transcriptBacktrackBinding);
		this.interruptActionName = normalizeText(fields.interruptActionName);
		this.fixedBacktrackActionName = normalizeText(fields.fixedBacktrackActionName);
		this.allowedBacktrackOverlapBinding = normalizeBinding(fields.allowedBacktrackOverlapBinding);
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
