package codexhx.runtime.model.streamitem;

typedef ModelKeymapShadowRequestFields = {
	final requestId:String;
	final canonicalBinding:Null<ModelKeymapBinding>;
	final shadowCases:Array<ModelKeymapShadowCase>;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelKeymapShadowRequest {
	public final requestId:String;
	public final canonicalBinding:Null<ModelKeymapBinding>;
	public final shadowCases:Array<ModelKeymapShadowCase>;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelKeymapShadowRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.canonicalBinding = fields.canonicalBinding;
		this.shadowCases = fields.shadowCases == null ? [] : fields.shadowCases;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
