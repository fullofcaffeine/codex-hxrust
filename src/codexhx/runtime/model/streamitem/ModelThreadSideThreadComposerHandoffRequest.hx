package codexhx.runtime.model.streamitem;

class ModelThreadSideThreadComposerHandoffRequest {
	public final requestId:String;
	public final startOutcome:ModelThreadSideThreadStartOutcome;
	public final startupRoutingOutcome:ModelThreadSideThreadStartupRoutingOutcome;
	public final userMessageProvided:Bool;
	public final inlineUserMessageText:String;
	public final composerInitiallyEmpty:Bool;
	public final sideContextLabelBefore:String;
	public final eventOrderIndex:Int;
	public final previousEventCount:Int;
	public final secretProbe:String;

	public function new(
		requestId:String,
		startOutcome:ModelThreadSideThreadStartOutcome,
		startupRoutingOutcome:ModelThreadSideThreadStartupRoutingOutcome,
		userMessageProvided:Bool,
		inlineUserMessageText:String,
		composerInitiallyEmpty:Bool,
		sideContextLabelBefore:String,
		eventOrderIndex:Int,
		previousEventCount:Int,
		secretProbe:String
	) {
		this.requestId = requestId == null ? "" : requestId;
		this.startOutcome = startOutcome;
		this.startupRoutingOutcome = startupRoutingOutcome;
		this.userMessageProvided = userMessageProvided;
		this.inlineUserMessageText = inlineUserMessageText == null ? "" : inlineUserMessageText;
		this.composerInitiallyEmpty = composerInitiallyEmpty;
		this.sideContextLabelBefore = sideContextLabelBefore == null ? "" : sideContextLabelBefore;
		this.eventOrderIndex = eventOrderIndex;
		this.previousEventCount = previousEventCount;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
