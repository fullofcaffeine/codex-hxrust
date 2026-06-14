package codexhx.runtime.model.streamitem;

class ModelTurnTerminalProjectionOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final threadId:String;
	public final turnId:String;
	public final lifecycleRequestId:String;
	public final eventKind:ModelTurnTerminalProjectionEventKind;
	public final coreAgentStatusKind:ModelTurnTerminalProjectedStatusKind;
	public final appTurnStatusKind:ModelTurnTerminalProjectedStatusKind;
	public final appServerNotificationIntentKind:ModelTurnTerminalNotificationIntentKind;
	public final tuiNotificationIntentKind:ModelTurnTerminalNotificationIntentKind;
	public final pendingServerRequestsAborted:Bool;
	public final pendingInterruptsResolved:Bool;
	public final threadStatusCleared:Bool;
	public final threadHistoryTurnClosed:Bool;
	public final threadHistoryFailedStatusPreserved:Bool;
	public final turnCompletedNotificationEmitted:Bool;
	public final appServerTurnFailedRecorded:Bool;
	public final lastAgentMessagePropagatedToCoreStatus:Bool;
	public final collabAgentStateHasMessage:Bool;
	public final tuiReceivesLastAgentMessageFromTurnNotification:Bool;
	public final tuiNotificationResponseUsesCopySource:Bool;
	public final tuiTaskCompletionHandled:Bool;
	public final tuiInterruptedHandled:Bool;
	public final tuiErrorHandled:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(
		ok:Bool,
		code:String,
		requestId:String,
		threadId:String,
		turnId:String,
		lifecycleRequestId:String,
		eventKind:ModelTurnTerminalProjectionEventKind,
		coreAgentStatusKind:ModelTurnTerminalProjectedStatusKind,
		appTurnStatusKind:ModelTurnTerminalProjectedStatusKind,
		appServerNotificationIntentKind:ModelTurnTerminalNotificationIntentKind,
		tuiNotificationIntentKind:ModelTurnTerminalNotificationIntentKind,
		pendingServerRequestsAborted:Bool,
		pendingInterruptsResolved:Bool,
		threadStatusCleared:Bool,
		threadHistoryTurnClosed:Bool,
		threadHistoryFailedStatusPreserved:Bool,
		turnCompletedNotificationEmitted:Bool,
		appServerTurnFailedRecorded:Bool,
		lastAgentMessagePropagatedToCoreStatus:Bool,
		collabAgentStateHasMessage:Bool,
		tuiReceivesLastAgentMessageFromTurnNotification:Bool,
		tuiNotificationResponseUsesCopySource:Bool,
		tuiTaskCompletionHandled:Bool,
		tuiInterruptedHandled:Bool,
		tuiErrorHandled:Bool,
		liveNetworkAttempted:Bool,
		realFilesystemMutated:Bool,
		toolExecutedOutsideFixture:Bool,
		errorMessage:String
	) {
		this.ok = ok;
		this.code = code;
		this.requestId = requestId == null ? "" : requestId;
		this.threadId = threadId == null ? "" : threadId;
		this.turnId = turnId == null ? "" : turnId;
		this.lifecycleRequestId = lifecycleRequestId == null ? "" : lifecycleRequestId;
		this.eventKind = eventKind == null ? ModelTurnTerminalProjectionEventKind.TurnComplete : eventKind;
		this.coreAgentStatusKind = coreAgentStatusKind == null ? ModelTurnTerminalProjectedStatusKind.Completed : coreAgentStatusKind;
		this.appTurnStatusKind = appTurnStatusKind == null ? ModelTurnTerminalProjectedStatusKind.Completed : appTurnStatusKind;
		this.appServerNotificationIntentKind = appServerNotificationIntentKind == null ? ModelTurnTerminalNotificationIntentKind.None : appServerNotificationIntentKind;
		this.tuiNotificationIntentKind = tuiNotificationIntentKind == null ? ModelTurnTerminalNotificationIntentKind.None : tuiNotificationIntentKind;
		this.pendingServerRequestsAborted = pendingServerRequestsAborted;
		this.pendingInterruptsResolved = pendingInterruptsResolved;
		this.threadStatusCleared = threadStatusCleared;
		this.threadHistoryTurnClosed = threadHistoryTurnClosed;
		this.threadHistoryFailedStatusPreserved = threadHistoryFailedStatusPreserved;
		this.turnCompletedNotificationEmitted = turnCompletedNotificationEmitted;
		this.appServerTurnFailedRecorded = appServerTurnFailedRecorded;
		this.lastAgentMessagePropagatedToCoreStatus = lastAgentMessagePropagatedToCoreStatus;
		this.collabAgentStateHasMessage = collabAgentStateHasMessage;
		this.tuiReceivesLastAgentMessageFromTurnNotification = tuiReceivesLastAgentMessageFromTurnNotification;
		this.tuiNotificationResponseUsesCopySource = tuiNotificationResponseUsesCopySource;
		this.tuiTaskCompletionHandled = tuiTaskCompletionHandled;
		this.tuiInterruptedHandled = tuiInterruptedHandled;
		this.tuiErrorHandled = tuiErrorHandled;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code
			+ ";ok=" + boolText(ok)
			+ ";request=" + requestId
			+ ";thread=" + threadId
			+ ";turn=" + turnId
			+ ";lifecycleRequest=" + noneIfEmpty(lifecycleRequestId)
			+ ";eventKind=" + eventKind
			+ ";coreAgentStatusKind=" + coreAgentStatusKind
			+ ";appTurnStatusKind=" + appTurnStatusKind
			+ ";appServerNotificationIntentKind=" + appServerNotificationIntentKind
			+ ";tuiNotificationIntentKind=" + tuiNotificationIntentKind
			+ ";pendingServerRequestsAborted=" + boolText(pendingServerRequestsAborted)
			+ ";pendingInterruptsResolved=" + boolText(pendingInterruptsResolved)
			+ ";threadStatusCleared=" + boolText(threadStatusCleared)
			+ ";threadHistoryTurnClosed=" + boolText(threadHistoryTurnClosed)
			+ ";threadHistoryFailedStatusPreserved=" + boolText(threadHistoryFailedStatusPreserved)
			+ ";turnCompletedNotificationEmitted=" + boolText(turnCompletedNotificationEmitted)
			+ ";appServerTurnFailedRecorded=" + boolText(appServerTurnFailedRecorded)
			+ ";lastAgentMessagePropagatedToCoreStatus=" + boolText(lastAgentMessagePropagatedToCoreStatus)
			+ ";collabAgentStateHasMessage=" + boolText(collabAgentStateHasMessage)
			+ ";tuiReceivesLastAgentMessageFromTurnNotification=" + boolText(tuiReceivesLastAgentMessageFromTurnNotification)
			+ ";tuiNotificationResponseUsesCopySource=" + boolText(tuiNotificationResponseUsesCopySource)
			+ ";tuiTaskCompletionHandled=" + boolText(tuiTaskCompletionHandled)
			+ ";tuiInterruptedHandled=" + boolText(tuiInterruptedHandled)
			+ ";tuiErrorHandled=" + boolText(tuiErrorHandled)
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
