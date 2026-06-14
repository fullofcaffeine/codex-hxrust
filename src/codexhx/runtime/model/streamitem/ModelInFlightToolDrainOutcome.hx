package codexhx.runtime.model.streamitem;

class ModelInFlightToolDrainOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final drainKind:ModelInFlightToolDrainOutcomeKind;
	public final itemCount:Int;
	public final drainedItemCount:Int;
	public final convertedFailureCount:Int;
	public final fatalFailureCount:Int;
	public final responseOrderPreserved:Bool;
	public final conversationItemsRecorded:Bool;
	public final memoryModePolluted:Bool;
	public final toolBlockingTimingStarted:Bool;
	public final drainCompletedBeforeTokenCount:Bool;
	public final drainCompletedBeforeTurnDiff:Bool;
	public final tokenCountEmittedAfterDrain:Bool;
	public final turnDiffEmittedAfterDrain:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final orderedItemSummary:String;
	public final errorMessage:String;

	public function new(
		ok:Bool,
		code:String,
		requestId:String,
		drainKind:ModelInFlightToolDrainOutcomeKind,
		itemCount:Int,
		drainedItemCount:Int,
		convertedFailureCount:Int,
		fatalFailureCount:Int,
		responseOrderPreserved:Bool,
		conversationItemsRecorded:Bool,
		memoryModePolluted:Bool,
		toolBlockingTimingStarted:Bool,
		drainCompletedBeforeTokenCount:Bool,
		drainCompletedBeforeTurnDiff:Bool,
		tokenCountEmittedAfterDrain:Bool,
		turnDiffEmittedAfterDrain:Bool,
		liveNetworkAttempted:Bool,
		realFilesystemMutated:Bool,
		toolExecutedOutsideFixture:Bool,
		orderedItemSummary:String,
		errorMessage:String
	) {
		this.ok = ok;
		this.code = code;
		this.requestId = requestId == null ? "" : requestId;
		this.drainKind = drainKind;
		this.itemCount = itemCount;
		this.drainedItemCount = drainedItemCount;
		this.convertedFailureCount = convertedFailureCount;
		this.fatalFailureCount = fatalFailureCount;
		this.responseOrderPreserved = responseOrderPreserved;
		this.conversationItemsRecorded = conversationItemsRecorded;
		this.memoryModePolluted = memoryModePolluted;
		this.toolBlockingTimingStarted = toolBlockingTimingStarted;
		this.drainCompletedBeforeTokenCount = drainCompletedBeforeTokenCount;
		this.drainCompletedBeforeTurnDiff = drainCompletedBeforeTurnDiff;
		this.tokenCountEmittedAfterDrain = tokenCountEmittedAfterDrain;
		this.turnDiffEmittedAfterDrain = turnDiffEmittedAfterDrain;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.orderedItemSummary = orderedItemSummary == null ? "" : orderedItemSummary;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code
			+ ";ok=" + boolText(ok)
			+ ";request=" + requestId
			+ ";drainKind=" + drainKind
			+ ";itemCount=" + Std.string(itemCount)
			+ ";drainedItemCount=" + Std.string(drainedItemCount)
			+ ";convertedFailureCount=" + Std.string(convertedFailureCount)
			+ ";fatalFailureCount=" + Std.string(fatalFailureCount)
			+ ";responseOrderPreserved=" + boolText(responseOrderPreserved)
			+ ";conversationItemsRecorded=" + boolText(conversationItemsRecorded)
			+ ";memoryModePolluted=" + boolText(memoryModePolluted)
			+ ";toolBlockingTimingStarted=" + boolText(toolBlockingTimingStarted)
			+ ";drainCompletedBeforeTokenCount=" + boolText(drainCompletedBeforeTokenCount)
			+ ";drainCompletedBeforeTurnDiff=" + boolText(drainCompletedBeforeTurnDiff)
			+ ";tokenCountEmittedAfterDrain=" + boolText(tokenCountEmittedAfterDrain)
			+ ";turnDiffEmittedAfterDrain=" + boolText(turnDiffEmittedAfterDrain)
			+ ";liveNetworkAttempted=" + boolText(liveNetworkAttempted)
			+ ";realFilesystemMutated=" + boolText(realFilesystemMutated)
			+ ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture)
			+ ";orderedItems=[" + orderedItemSummary + "]"
			+ ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
