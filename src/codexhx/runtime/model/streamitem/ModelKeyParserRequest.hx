package codexhx.runtime.model.streamitem;

typedef ModelKeyParserRequestFields = {
	final requestId:String;
	final maxFunctionKey:Int;
	final cases:Array<ModelKeyParserCase>;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelKeyParserRequest {
	public final requestId:String;
	public final maxFunctionKey:Int;
	public final cases:Array<ModelKeyParserCase>;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelKeyParserRequestFields) {
		this.requestId = normalizeText(fields.requestId);
		this.maxFunctionKey = fields.maxFunctionKey;
		this.cases = fields.cases == null ? [] : fields.cases;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = normalizeText(fields.secretProbe);
	}

	static function normalizeText(value:String):String {
		return value == null ? "" : value;
	}
}
