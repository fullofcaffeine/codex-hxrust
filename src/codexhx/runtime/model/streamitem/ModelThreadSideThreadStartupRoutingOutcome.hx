package codexhx.runtime.model.streamitem;

class ModelThreadSideThreadStartupRoutingOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final startRequestId:String;
	public final decisionKind:ModelThreadSideThreadStartupRoutingDecisionKind;
	public final startupEventKind:ModelThreadSideThreadStartupEventKind;
	public final expectedServersRefreshed:Bool;
	public final appScopedIgnored:Bool;
	public final misroutedVisibleThreadIgnored:Bool;
	public final childThreadChannelEnsured:Bool;
	public final notificationBuffered:Bool;
	public final notificationSentToActiveReceiver:Bool;
	public final sideThreadSessionHandled:Bool;
	public final sideConversationDisplayMode:Bool;
	public final contextLabelPreserved:Bool;
	public final startupStatusRendered:Bool;
	public final startupFailureWarningRendered:Bool;
	public final loginErrorRendered:Bool;
	public final activeTranscriptMutated:Bool;
	public final appEventRendered:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(ok:Bool, code:String, requestId:String, startRequestId:String, decisionKind:ModelThreadSideThreadStartupRoutingDecisionKind,
			startupEventKind:ModelThreadSideThreadStartupEventKind, expectedServersRefreshed:Bool, appScopedIgnored:Bool, misroutedVisibleThreadIgnored:Bool,
			childThreadChannelEnsured:Bool, notificationBuffered:Bool, notificationSentToActiveReceiver:Bool, sideThreadSessionHandled:Bool,
			sideConversationDisplayMode:Bool, contextLabelPreserved:Bool, startupStatusRendered:Bool, startupFailureWarningRendered:Bool,
			loginErrorRendered:Bool, activeTranscriptMutated:Bool, appEventRendered:Bool, eventOrderingPreserved:Bool, liveNetworkAttempted:Bool,
			realFilesystemMutated:Bool, toolExecutedOutsideFixture:Bool, errorMessage:String) {
		this.ok = ok;
		this.code = code == null ? "" : code;
		this.requestId = requestId == null ? "" : requestId;
		this.startRequestId = startRequestId == null ? "" : startRequestId;
		this.decisionKind = decisionKind == null ? ModelThreadSideThreadStartupRoutingDecisionKind.BufferedForChildThread : decisionKind;
		this.startupEventKind = startupEventKind == null ? ModelThreadSideThreadStartupEventKind.Starting : startupEventKind;
		this.expectedServersRefreshed = expectedServersRefreshed;
		this.appScopedIgnored = appScopedIgnored;
		this.misroutedVisibleThreadIgnored = misroutedVisibleThreadIgnored;
		this.childThreadChannelEnsured = childThreadChannelEnsured;
		this.notificationBuffered = notificationBuffered;
		this.notificationSentToActiveReceiver = notificationSentToActiveReceiver;
		this.sideThreadSessionHandled = sideThreadSessionHandled;
		this.sideConversationDisplayMode = sideConversationDisplayMode;
		this.contextLabelPreserved = contextLabelPreserved;
		this.startupStatusRendered = startupStatusRendered;
		this.startupFailureWarningRendered = startupFailureWarningRendered;
		this.loginErrorRendered = loginErrorRendered;
		this.activeTranscriptMutated = activeTranscriptMutated;
		this.appEventRendered = appEventRendered;
		this.eventOrderingPreserved = eventOrderingPreserved;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";startRequest=" + noneIfEmpty(startRequestId) + ";decisionKind="
			+ decisionKind + ";startupEventKind=" + startupEventKind + ";expectedServersRefreshed=" + boolText(expectedServersRefreshed)
			+ ";appScopedIgnored=" + boolText(appScopedIgnored) + ";misroutedVisibleThreadIgnored=" + boolText(misroutedVisibleThreadIgnored)
			+ ";childThreadChannelEnsured=" + boolText(childThreadChannelEnsured) + ";notificationBuffered=" + boolText(notificationBuffered)
			+ ";notificationSentToActiveReceiver=" + boolText(notificationSentToActiveReceiver) + ";sideThreadSessionHandled="
			+ boolText(sideThreadSessionHandled) + ";sideConversationDisplayMode=" + boolText(sideConversationDisplayMode) + ";contextLabelPreserved="
			+ boolText(contextLabelPreserved) + ";startupStatusRendered=" + boolText(startupStatusRendered) + ";startupFailureWarningRendered="
			+ boolText(startupFailureWarningRendered) + ";loginErrorRendered=" + boolText(loginErrorRendered) + ";activeTranscriptMutated="
			+ boolText(activeTranscriptMutated) + ";appEventRendered=" + boolText(appEventRendered) + ";eventOrderingPreserved="
			+ boolText(eventOrderingPreserved) + ";liveNetworkAttempted=" + boolText(liveNetworkAttempted) + ";realFilesystemMutated="
			+ boolText(realFilesystemMutated) + ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
