package codexhx.runtime.model.streamitem;

class ModelStreamItemFixtureEvent {
	public final kind:ModelStreamItemEventKind;
	public final item:ModelStreamOutputItem;
	public final itemId:String;
	public final callId:String;
	public final delta:String;
	public final summaryIndex:Int;
	public final contentIndex:Int;
	public final responseId:String;
	public final totalTokens:Int;
	public final endTurn:Bool;

	public function new(
		kind:ModelStreamItemEventKind,
		item:ModelStreamOutputItem,
		itemId:String,
		callId:String,
		delta:String,
		summaryIndex:Int,
		contentIndex:Int,
		responseId:String,
		totalTokens:Int,
		endTurn:Bool
	) {
		this.kind = kind;
		this.item = item;
		this.itemId = itemId;
		this.callId = callId;
		this.delta = delta;
		this.summaryIndex = summaryIndex;
		this.contentIndex = contentIndex;
		this.responseId = responseId;
		this.totalTokens = totalTokens;
		this.endTurn = endTurn;
	}
}
