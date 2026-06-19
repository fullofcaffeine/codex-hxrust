package codexhx.runtime.model.streamitem;

class ModelThreadActiveTurnOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final rebaseRequestId:String;
	public final eventKind:ModelThreadActiveTurnEventKind;
	public final decisionKind:ModelThreadActiveTurnDecisionKind;
	public final activeTurnIdBefore:String;
	public final eventTurnId:String;
	public final activeTurnIdAfter:String;
	public final activeTurnChanged:Bool;
	public final restoredFromTurns:Bool;
	public final nonmatchingCompletionIgnored:Bool;
	public final threadClosedCleared:Bool;
	public final explicitClearApplied:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(ok:Bool, code:String, requestId:String, rebaseRequestId:String, eventKind:ModelThreadActiveTurnEventKind,
			decisionKind:ModelThreadActiveTurnDecisionKind, activeTurnIdBefore:String, eventTurnId:String, activeTurnIdAfter:String, activeTurnChanged:Bool,
			restoredFromTurns:Bool, nonmatchingCompletionIgnored:Bool, threadClosedCleared:Bool, explicitClearApplied:Bool, eventOrderingPreserved:Bool,
			liveNetworkAttempted:Bool, realFilesystemMutated:Bool, toolExecutedOutsideFixture:Bool, errorMessage:String) {
		this.ok = ok;
		this.code = code == null ? "" : code;
		this.requestId = requestId == null ? "" : requestId;
		this.rebaseRequestId = rebaseRequestId == null ? "" : rebaseRequestId;
		this.eventKind = eventKind == null ? ModelThreadActiveTurnEventKind.TurnsRestored : eventKind;
		this.decisionKind = decisionKind == null ? ModelThreadActiveTurnDecisionKind.UnchangedNoActiveTurn : decisionKind;
		this.activeTurnIdBefore = activeTurnIdBefore == null ? "" : activeTurnIdBefore;
		this.eventTurnId = eventTurnId == null ? "" : eventTurnId;
		this.activeTurnIdAfter = activeTurnIdAfter == null ? "" : activeTurnIdAfter;
		this.activeTurnChanged = activeTurnChanged;
		this.restoredFromTurns = restoredFromTurns;
		this.nonmatchingCompletionIgnored = nonmatchingCompletionIgnored;
		this.threadClosedCleared = threadClosedCleared;
		this.explicitClearApplied = explicitClearApplied;
		this.eventOrderingPreserved = eventOrderingPreserved;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";rebaseRequest=" + noneIfEmpty(rebaseRequestId) + ";eventKind="
			+ eventKind + ";decisionKind=" + decisionKind + ";activeTurnIdBefore=" + noneIfEmpty(activeTurnIdBefore) + ";eventTurnId="
			+ noneIfEmpty(eventTurnId) + ";activeTurnIdAfter=" + noneIfEmpty(activeTurnIdAfter) + ";activeTurnChanged=" + boolText(activeTurnChanged)
			+ ";restoredFromTurns=" + boolText(restoredFromTurns) + ";nonmatchingCompletionIgnored=" + boolText(nonmatchingCompletionIgnored)
			+ ";threadClosedCleared=" + boolText(threadClosedCleared) + ";explicitClearApplied=" + boolText(explicitClearApplied)
			+ ";eventOrderingPreserved=" + boolText(eventOrderingPreserved) + ";liveNetworkAttempted=" + boolText(liveNetworkAttempted)
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
