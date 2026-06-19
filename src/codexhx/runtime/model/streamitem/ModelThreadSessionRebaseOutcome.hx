package codexhx.runtime.model.streamitem;

class ModelThreadSessionRebaseOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final evictionRequestId:String;
	public final rebaseKind:ModelThreadSessionRebaseKind;
	public final rebaseEventKind:ModelThreadSessionRebaseEventKind;
	public final eventSurvivesRebase:Bool;
	public final eventDroppedByRebase:Bool;
	public final pendingReplayStatePreserved:Bool;
	public final snapshotRequestReplayed:Bool;
	public final resolvedRequestFilteredAfterRebase:Bool;
	public final bufferEventCountAfter:Int;
	public final orderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(ok:Bool, code:String, requestId:String, evictionRequestId:String, rebaseKind:ModelThreadSessionRebaseKind,
			rebaseEventKind:ModelThreadSessionRebaseEventKind, eventSurvivesRebase:Bool, eventDroppedByRebase:Bool, pendingReplayStatePreserved:Bool,
			snapshotRequestReplayed:Bool, resolvedRequestFilteredAfterRebase:Bool, bufferEventCountAfter:Int, orderingPreserved:Bool,
			liveNetworkAttempted:Bool, realFilesystemMutated:Bool, toolExecutedOutsideFixture:Bool, errorMessage:String) {
		this.ok = ok;
		this.code = code == null ? "" : code;
		this.requestId = requestId == null ? "" : requestId;
		this.evictionRequestId = evictionRequestId == null ? "" : evictionRequestId;
		this.rebaseKind = rebaseKind == null ? ModelThreadSessionRebaseKind.DroppedOrdinaryNotification : rebaseKind;
		this.rebaseEventKind = rebaseEventKind == null ? ModelThreadSessionRebaseEventKind.OrdinaryNotification : rebaseEventKind;
		this.eventSurvivesRebase = eventSurvivesRebase;
		this.eventDroppedByRebase = eventDroppedByRebase;
		this.pendingReplayStatePreserved = pendingReplayStatePreserved;
		this.snapshotRequestReplayed = snapshotRequestReplayed;
		this.resolvedRequestFilteredAfterRebase = resolvedRequestFilteredAfterRebase;
		this.bufferEventCountAfter = bufferEventCountAfter < 0 ? 0 : bufferEventCountAfter;
		this.orderingPreserved = orderingPreserved;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";evictionRequest=" + noneIfEmpty(evictionRequestId) + ";rebaseKind="
			+ rebaseKind + ";rebaseEventKind=" + rebaseEventKind + ";eventSurvivesRebase=" + boolText(eventSurvivesRebase) + ";eventDroppedByRebase="
			+ boolText(eventDroppedByRebase) + ";pendingReplayStatePreserved=" + boolText(pendingReplayStatePreserved) + ";snapshotRequestReplayed="
			+ boolText(snapshotRequestReplayed) + ";resolvedRequestFilteredAfterRebase=" + boolText(resolvedRequestFilteredAfterRebase)
			+ ";bufferEventCountAfter=" + bufferEventCountAfter + ";orderingPreserved=" + boolText(orderingPreserved) + ";liveNetworkAttempted="
			+ boolText(liveNetworkAttempted) + ";realFilesystemMutated=" + boolText(realFilesystemMutated) + ";toolExecutedOutsideFixture="
			+ boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
