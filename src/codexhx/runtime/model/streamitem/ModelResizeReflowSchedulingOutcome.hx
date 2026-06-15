package codexhx.runtime.model.streamitem;

typedef ModelResizeReflowSchedulingOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final resizeReflowRequestId:String;
	final decisionKind:ModelResizeReflowSchedulingDecisionKind;
	final currentWidth:Int;
	final currentHeight:Int;
	final lastKnownWidth:Int;
	final lastKnownHeight:Int;
	final widthInitialized:Bool;
	final widthChanged:Bool;
	final reflowNeededForWidth:Bool;
	final heightChanged:Bool;
	final shouldRebuildTranscript:Bool;
	final pendingReflowSet:Bool;
	final pendingTargetWidth:Int;
	final debounceMs:Int;
	final immediateFrameRequested:Bool;
	final delayedFrameRequested:Bool;
	final statusLineRefreshNeeded:Bool;
	final streamResizeMarked:Bool;
	final reflowStateCleared:Bool;
	final eventOrderingPreserved:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelResizeReflowSchedulingOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final resizeReflowRequestId:String;
	public final decisionKind:ModelResizeReflowSchedulingDecisionKind;
	public final currentWidth:Int;
	public final currentHeight:Int;
	public final lastKnownWidth:Int;
	public final lastKnownHeight:Int;
	public final widthInitialized:Bool;
	public final widthChanged:Bool;
	public final reflowNeededForWidth:Bool;
	public final heightChanged:Bool;
	public final shouldRebuildTranscript:Bool;
	public final pendingReflowSet:Bool;
	public final pendingTargetWidth:Int;
	public final debounceMs:Int;
	public final immediateFrameRequested:Bool;
	public final delayedFrameRequested:Bool;
	public final statusLineRefreshNeeded:Bool;
	public final streamResizeMarked:Bool;
	public final reflowStateCleared:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelResizeReflowSchedulingOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.resizeReflowRequestId = fields.resizeReflowRequestId == null ? "" : fields.resizeReflowRequestId;
		this.decisionKind = fields.decisionKind == null ? ModelResizeReflowSchedulingDecisionKind.UnchangedSizeNoOp : fields.decisionKind;
		this.currentWidth = fields.currentWidth < 1 ? 1 : fields.currentWidth;
		this.currentHeight = fields.currentHeight < 1 ? 1 : fields.currentHeight;
		this.lastKnownWidth = fields.lastKnownWidth < 1 ? 1 : fields.lastKnownWidth;
		this.lastKnownHeight = fields.lastKnownHeight < 1 ? 1 : fields.lastKnownHeight;
		this.widthInitialized = fields.widthInitialized;
		this.widthChanged = fields.widthChanged;
		this.reflowNeededForWidth = fields.reflowNeededForWidth;
		this.heightChanged = fields.heightChanged;
		this.shouldRebuildTranscript = fields.shouldRebuildTranscript;
		this.pendingReflowSet = fields.pendingReflowSet;
		this.pendingTargetWidth = fields.pendingTargetWidth;
		this.debounceMs = fields.debounceMs < 0 ? 0 : fields.debounceMs;
		this.immediateFrameRequested = fields.immediateFrameRequested;
		this.delayedFrameRequested = fields.delayedFrameRequested;
		this.statusLineRefreshNeeded = fields.statusLineRefreshNeeded;
		this.streamResizeMarked = fields.streamResizeMarked;
		this.reflowStateCleared = fields.reflowStateCleared;
		this.eventOrderingPreserved = fields.eventOrderingPreserved;
		this.liveNetworkAttempted = fields.liveNetworkAttempted;
		this.realFilesystemMutated = fields.realFilesystemMutated;
		this.toolExecutedOutsideFixture = fields.toolExecutedOutsideFixture;
		this.errorMessage = fields.errorMessage == null ? "" : fields.errorMessage;
	}

	public function summary():String {
		return "code=" + code
			+ ";ok=" + boolText(ok)
			+ ";request=" + requestId
			+ ";resizeReflowRequest=" + noneIfEmpty(resizeReflowRequestId)
			+ ";decisionKind=" + decisionKind
			+ ";currentWidth=" + currentWidth
			+ ";currentHeight=" + currentHeight
			+ ";lastKnownWidth=" + lastKnownWidth
			+ ";lastKnownHeight=" + lastKnownHeight
			+ ";widthInitialized=" + boolText(widthInitialized)
			+ ";widthChanged=" + boolText(widthChanged)
			+ ";reflowNeededForWidth=" + boolText(reflowNeededForWidth)
			+ ";heightChanged=" + boolText(heightChanged)
			+ ";shouldRebuildTranscript=" + boolText(shouldRebuildTranscript)
			+ ";pendingReflowSet=" + boolText(pendingReflowSet)
			+ ";pendingTargetWidth=" + pendingTargetWidth
			+ ";debounceMs=" + debounceMs
			+ ";immediateFrameRequested=" + boolText(immediateFrameRequested)
			+ ";delayedFrameRequested=" + boolText(delayedFrameRequested)
			+ ";statusLineRefreshNeeded=" + boolText(statusLineRefreshNeeded)
			+ ";streamResizeMarked=" + boolText(streamResizeMarked)
			+ ";reflowStateCleared=" + boolText(reflowStateCleared)
			+ ";eventOrderingPreserved=" + boolText(eventOrderingPreserved)
			+ ";liveNetworkAttempted=" + boolText(liveNetworkAttempted)
			+ ";realFilesystemMutated=" + boolText(realFilesystemMutated)
			+ ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture)
			+ ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
