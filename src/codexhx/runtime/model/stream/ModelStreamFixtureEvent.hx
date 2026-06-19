package codexhx.runtime.model.stream;

class ModelStreamFixtureEvent {
	public final kind:ModelStreamFixtureEventKind;
	public final itemId:String;
	public final responseId:String;
	public final upstreamRequestId:String;
	public final errorCode:String;
	public final errorMessage:String;
	public final inputTokens:Int;
	public final outputTokens:Int;
	public final cachedInputTokens:Int;
	public final reasoningOutputTokens:Int;
	public final totalTokens:Int;
	public final endTurn:Bool;

	public function new(kind:ModelStreamFixtureEventKind, itemId:String, responseId:String, upstreamRequestId:String, errorCode:String, errorMessage:String,
			inputTokens:Int, outputTokens:Int, cachedInputTokens:Int, reasoningOutputTokens:Int, totalTokens:Int, endTurn:Bool) {
		this.kind = kind;
		this.itemId = itemId;
		this.responseId = responseId;
		this.upstreamRequestId = upstreamRequestId;
		this.errorCode = errorCode;
		this.errorMessage = errorMessage;
		this.inputTokens = inputTokens;
		this.outputTokens = outputTokens;
		this.cachedInputTokens = cachedInputTokens;
		this.reasoningOutputTokens = reasoningOutputTokens;
		this.totalTokens = totalTokens;
		this.endTurn = endTurn;
	}
}
