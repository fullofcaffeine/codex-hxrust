package codexhx.runtime.model.streamitem;

typedef ModelKeymapInvalidGlobalCopyRequestFields = {
	final requestId:String;
	final configuredGlobalCopy:Null<ModelKeymapBinding>;
	final expectedErrorPath:String;
	final parseFailed:Bool;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelKeymapInvalidGlobalCopyRequest {
	public final requestId:String;
	public final configuredGlobalCopy:Null<ModelKeymapBinding>;
	public final expectedErrorPath:String;
	public final parseFailed:Bool;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelKeymapInvalidGlobalCopyRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.configuredGlobalCopy = fields.configuredGlobalCopy;
		this.expectedErrorPath = fields.expectedErrorPath == null ? "" : fields.expectedErrorPath;
		this.parseFailed = fields.parseFailed;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
