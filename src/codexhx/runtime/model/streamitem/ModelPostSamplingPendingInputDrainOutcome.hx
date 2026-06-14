package codexhx.runtime.model.streamitem;

class ModelPostSamplingPendingInputDrainOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final integrationRequestId:String;
	public final drainKind:ModelPostSamplingPendingInputDrainKind;
	public final canDrainPendingInput:Bool;
	public final acceptsMailboxDelivery:Bool;
	public final activeTurnItemCount:Int;
	public final mailboxItemCount:Int;
	public final drainedItemCount:Int;
	public final userInputRecordedCount:Int;
	public final responseItemRecordedCount:Int;
	public final mailboxAppendedAfterActiveTurn:Bool;
	public final hookRecordingAttempted:Bool;
	public final promptAssemblyAfterHooks:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final orderedItemsSummary:String;
	public final errorMessage:String;

	public function new(
		ok:Bool,
		code:String,
		requestId:String,
		integrationRequestId:String,
		drainKind:ModelPostSamplingPendingInputDrainKind,
		canDrainPendingInput:Bool,
		acceptsMailboxDelivery:Bool,
		activeTurnItemCount:Int,
		mailboxItemCount:Int,
		drainedItemCount:Int,
		userInputRecordedCount:Int,
		responseItemRecordedCount:Int,
		mailboxAppendedAfterActiveTurn:Bool,
		hookRecordingAttempted:Bool,
		promptAssemblyAfterHooks:Bool,
		liveNetworkAttempted:Bool,
		realFilesystemMutated:Bool,
		toolExecutedOutsideFixture:Bool,
		orderedItemsSummary:String,
		errorMessage:String
	) {
		this.ok = ok;
		this.code = code;
		this.requestId = requestId == null ? "" : requestId;
		this.integrationRequestId = integrationRequestId == null ? "" : integrationRequestId;
		this.drainKind = drainKind;
		this.canDrainPendingInput = canDrainPendingInput;
		this.acceptsMailboxDelivery = acceptsMailboxDelivery;
		this.activeTurnItemCount = activeTurnItemCount < 0 ? 0 : activeTurnItemCount;
		this.mailboxItemCount = mailboxItemCount < 0 ? 0 : mailboxItemCount;
		this.drainedItemCount = drainedItemCount < 0 ? 0 : drainedItemCount;
		this.userInputRecordedCount = userInputRecordedCount < 0 ? 0 : userInputRecordedCount;
		this.responseItemRecordedCount = responseItemRecordedCount < 0 ? 0 : responseItemRecordedCount;
		this.mailboxAppendedAfterActiveTurn = mailboxAppendedAfterActiveTurn;
		this.hookRecordingAttempted = hookRecordingAttempted;
		this.promptAssemblyAfterHooks = promptAssemblyAfterHooks;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.orderedItemsSummary = orderedItemsSummary == null ? "" : orderedItemsSummary;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code
			+ ";ok=" + boolText(ok)
			+ ";request=" + requestId
			+ ";integrationRequest=" + integrationRequestId
			+ ";drainKind=" + drainKind
			+ ";canDrainPendingInput=" + boolText(canDrainPendingInput)
			+ ";acceptsMailboxDelivery=" + boolText(acceptsMailboxDelivery)
			+ ";activeTurnItemCount=" + Std.string(activeTurnItemCount)
			+ ";mailboxItemCount=" + Std.string(mailboxItemCount)
			+ ";drainedItemCount=" + Std.string(drainedItemCount)
			+ ";userInputRecordedCount=" + Std.string(userInputRecordedCount)
			+ ";responseItemRecordedCount=" + Std.string(responseItemRecordedCount)
			+ ";mailboxAppendedAfterActiveTurn=" + boolText(mailboxAppendedAfterActiveTurn)
			+ ";hookRecordingAttempted=" + boolText(hookRecordingAttempted)
			+ ";promptAssemblyAfterHooks=" + boolText(promptAssemblyAfterHooks)
			+ ";liveNetworkAttempted=" + boolText(liveNetworkAttempted)
			+ ";realFilesystemMutated=" + boolText(realFilesystemMutated)
			+ ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture)
			+ ";orderedItems=[" + orderedItemsSummary + "]"
			+ ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
