package codexhx.runtime.model.streamitem;

class ModelReplayedServerRequestSurfaceOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final dispatchRequestId:String;
	public final requestKind:ModelReplayedServerRequestKind;
	public final surfaceKind:ModelReplayedServerRequestSurfaceKind;
	public final replayKind:ModelTurnReplayKind;
	public final replayKindAttached:Bool;
	public final snapshotRequestAllowed:Bool;
	public final chatWidgetRequestHandled:Bool;
	public final execApprovalRendered:Bool;
	public final fileChangeApprovalRendered:Bool;
	public final elicitationRendered:Bool;
	public final elicitationUrlDeclined:Bool;
	public final permissionsRendered:Bool;
	public final userInputRendered:Bool;
	public final unsupportedStubErrorEmitted:Bool;
	public final unsupportedReplayStubSuppressed:Bool;
	public final liveOnlyEffectsSuppressed:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(ok:Bool, code:String, requestId:String, dispatchRequestId:String, requestKind:ModelReplayedServerRequestKind,
			surfaceKind:ModelReplayedServerRequestSurfaceKind, replayKind:ModelTurnReplayKind, replayKindAttached:Bool, snapshotRequestAllowed:Bool,
			chatWidgetRequestHandled:Bool, execApprovalRendered:Bool, fileChangeApprovalRendered:Bool, elicitationRendered:Bool, elicitationUrlDeclined:Bool,
			permissionsRendered:Bool, userInputRendered:Bool, unsupportedStubErrorEmitted:Bool, unsupportedReplayStubSuppressed:Bool,
			liveOnlyEffectsSuppressed:Bool, liveNetworkAttempted:Bool, realFilesystemMutated:Bool, toolExecutedOutsideFixture:Bool, errorMessage:String) {
		this.ok = ok;
		this.code = code == null ? "" : code;
		this.requestId = requestId == null ? "" : requestId;
		this.dispatchRequestId = dispatchRequestId == null ? "" : dispatchRequestId;
		this.requestKind = requestKind == null ? ModelReplayedServerRequestKind.UserInput : requestKind;
		this.surfaceKind = surfaceKind == null ? ModelReplayedServerRequestSurfaceKind.RequestFiltered : surfaceKind;
		this.replayKind = replayKind == null ? ModelTurnReplayKind.ThreadSnapshot : replayKind;
		this.replayKindAttached = replayKindAttached;
		this.snapshotRequestAllowed = snapshotRequestAllowed;
		this.chatWidgetRequestHandled = chatWidgetRequestHandled;
		this.execApprovalRendered = execApprovalRendered;
		this.fileChangeApprovalRendered = fileChangeApprovalRendered;
		this.elicitationRendered = elicitationRendered;
		this.elicitationUrlDeclined = elicitationUrlDeclined;
		this.permissionsRendered = permissionsRendered;
		this.userInputRendered = userInputRendered;
		this.unsupportedStubErrorEmitted = unsupportedStubErrorEmitted;
		this.unsupportedReplayStubSuppressed = unsupportedReplayStubSuppressed;
		this.liveOnlyEffectsSuppressed = liveOnlyEffectsSuppressed;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";dispatchRequest=" + noneIfEmpty(dispatchRequestId) + ";requestKind="
			+ requestKind + ";surfaceKind=" + surfaceKind + ";replayKind=" + replayKind + ";replayKindAttached=" + boolText(replayKindAttached)
			+ ";snapshotRequestAllowed=" + boolText(snapshotRequestAllowed) + ";chatWidgetRequestHandled=" + boolText(chatWidgetRequestHandled)
			+ ";execApprovalRendered=" + boolText(execApprovalRendered) + ";fileChangeApprovalRendered=" + boolText(fileChangeApprovalRendered)
			+ ";elicitationRendered=" + boolText(elicitationRendered) + ";elicitationUrlDeclined=" + boolText(elicitationUrlDeclined)
			+ ";permissionsRendered=" + boolText(permissionsRendered) + ";userInputRendered=" + boolText(userInputRendered) + ";unsupportedStubErrorEmitted="
			+ boolText(unsupportedStubErrorEmitted) + ";unsupportedReplayStubSuppressed=" + boolText(unsupportedReplayStubSuppressed)
			+ ";liveOnlyEffectsSuppressed=" + boolText(liveOnlyEffectsSuppressed) + ";liveNetworkAttempted=" + boolText(liveNetworkAttempted)
			+ ";realFilesystemMutated=" + boolText(realFilesystemMutated) + ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture) + ";error="
			+ errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
