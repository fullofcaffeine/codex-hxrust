package codexhx.runtime.model.streamitem;

class ModelResizeReflowSchedulingRequest {
	public final requestId:String;
	public final resizeReflowOutcome:ModelTerminalResizeReflowOutcome;
	public final terminalResizeReflowEnabled:Bool;
	public final currentWidth:Int;
	public final currentHeight:Int;
	public final lastKnownWidth:Int;
	public final lastKnownHeight:Int;
	public final previousObservedWidth:Int;
	public final previousReflowWidth:Int;
	public final previousPendingWidth:Int;
	public final streamTimeSensitive:Bool;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(
		requestId:String,
		resizeReflowOutcome:ModelTerminalResizeReflowOutcome,
		terminalResizeReflowEnabled:Bool,
		currentWidth:Int,
		currentHeight:Int,
		lastKnownWidth:Int,
		lastKnownHeight:Int,
		previousObservedWidth:Int,
		previousReflowWidth:Int,
		previousPendingWidth:Int,
		streamTimeSensitive:Bool,
		previousEventCount:Int,
		eventOrderIndex:Int,
		secretProbe:String
	) {
		this.requestId = requestId == null ? "" : requestId;
		this.resizeReflowOutcome = resizeReflowOutcome;
		this.terminalResizeReflowEnabled = terminalResizeReflowEnabled;
		this.currentWidth = currentWidth < 1 ? 1 : currentWidth;
		this.currentHeight = currentHeight < 1 ? 1 : currentHeight;
		this.lastKnownWidth = lastKnownWidth < 1 ? 1 : lastKnownWidth;
		this.lastKnownHeight = lastKnownHeight < 1 ? 1 : lastKnownHeight;
		this.previousObservedWidth = previousObservedWidth;
		this.previousReflowWidth = previousReflowWidth;
		this.previousPendingWidth = previousPendingWidth;
		this.streamTimeSensitive = streamTimeSensitive;
		this.previousEventCount = previousEventCount;
		this.eventOrderIndex = eventOrderIndex;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
