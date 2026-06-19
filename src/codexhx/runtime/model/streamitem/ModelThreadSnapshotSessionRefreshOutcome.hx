package codexhx.runtime.model.streamitem;

typedef ModelThreadSnapshotSessionRefreshOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final threadId:String;
	final decisionKind:ModelThreadSnapshotSessionRefreshDecisionKind;
	final snapshotSessionCwdAfter:String;
	final storeSessionCwdAfter:String;
	final snapshotTurnCountAfter:Int;
	final storeTurnCountAfter:Int;
	final resumedTurnCount:Int;
	final userMessageCount:Int;
	final activeTurnIdAfter:String;
	final snapshotSessionReplaced:Bool;
	final snapshotTurnsReplaced:Bool;
	final storeSessionReplaced:Bool;
	final storeTurnsReplaced:Bool;
	final storeSnapshotMatchesRefreshedSnapshot:Bool;
	final bufferRebasedAfterRefresh:Bool;
	final refreshedCwdPreserved:Bool;
	final resumedTurnsPersisted:Bool;
	final activeTurnRestoredFromResumedTurns:Bool;
	final liveOnlyEffectsSuppressed:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelThreadSnapshotSessionRefreshOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final threadId:String;
	public final decisionKind:ModelThreadSnapshotSessionRefreshDecisionKind;
	public final snapshotSessionCwdAfter:String;
	public final storeSessionCwdAfter:String;
	public final snapshotTurnCountAfter:Int;
	public final storeTurnCountAfter:Int;
	public final resumedTurnCount:Int;
	public final userMessageCount:Int;
	public final activeTurnIdAfter:String;
	public final snapshotSessionReplaced:Bool;
	public final snapshotTurnsReplaced:Bool;
	public final storeSessionReplaced:Bool;
	public final storeTurnsReplaced:Bool;
	public final storeSnapshotMatchesRefreshedSnapshot:Bool;
	public final bufferRebasedAfterRefresh:Bool;
	public final refreshedCwdPreserved:Bool;
	public final resumedTurnsPersisted:Bool;
	public final activeTurnRestoredFromResumedTurns:Bool;
	public final liveOnlyEffectsSuppressed:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelThreadSnapshotSessionRefreshOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.threadId = fields.threadId == null ? "" : fields.threadId;
		this.decisionKind = fields.decisionKind == null ? ModelThreadSnapshotSessionRefreshDecisionKind.RefreshedSnapshotBlocked : fields.decisionKind;
		this.snapshotSessionCwdAfter = fields.snapshotSessionCwdAfter == null ? "" : fields.snapshotSessionCwdAfter;
		this.storeSessionCwdAfter = fields.storeSessionCwdAfter == null ? "" : fields.storeSessionCwdAfter;
		this.snapshotTurnCountAfter = fields.snapshotTurnCountAfter;
		this.storeTurnCountAfter = fields.storeTurnCountAfter;
		this.resumedTurnCount = fields.resumedTurnCount;
		this.userMessageCount = fields.userMessageCount;
		this.activeTurnIdAfter = fields.activeTurnIdAfter == null ? "" : fields.activeTurnIdAfter;
		this.snapshotSessionReplaced = fields.snapshotSessionReplaced;
		this.snapshotTurnsReplaced = fields.snapshotTurnsReplaced;
		this.storeSessionReplaced = fields.storeSessionReplaced;
		this.storeTurnsReplaced = fields.storeTurnsReplaced;
		this.storeSnapshotMatchesRefreshedSnapshot = fields.storeSnapshotMatchesRefreshedSnapshot;
		this.bufferRebasedAfterRefresh = fields.bufferRebasedAfterRefresh;
		this.refreshedCwdPreserved = fields.refreshedCwdPreserved;
		this.resumedTurnsPersisted = fields.resumedTurnsPersisted;
		this.activeTurnRestoredFromResumedTurns = fields.activeTurnRestoredFromResumedTurns;
		this.liveOnlyEffectsSuppressed = fields.liveOnlyEffectsSuppressed;
		this.liveNetworkAttempted = fields.liveNetworkAttempted;
		this.realFilesystemMutated = fields.realFilesystemMutated;
		this.toolExecutedOutsideFixture = fields.toolExecutedOutsideFixture;
		this.errorMessage = fields.errorMessage == null ? "" : fields.errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";decisionKind=" + decisionKind + ";snapshotTurnCountAfter="
			+ snapshotTurnCountAfter + ";storeTurnCountAfter=" + storeTurnCountAfter + ";resumedTurnCount=" + resumedTurnCount + ";userMessageCount="
			+ userMessageCount + ";activeTurnIdAfter=" + noneIfEmpty(activeTurnIdAfter) + ";snapshotSessionReplaced=" + boolText(snapshotSessionReplaced)
			+ ";snapshotTurnsReplaced=" + boolText(snapshotTurnsReplaced) + ";storeSessionReplaced=" + boolText(storeSessionReplaced)
			+ ";storeTurnsReplaced=" + boolText(storeTurnsReplaced) + ";storeSnapshotMatchesRefreshedSnapshot="
			+ boolText(storeSnapshotMatchesRefreshedSnapshot) + ";bufferRebasedAfterRefresh=" + boolText(bufferRebasedAfterRefresh)
			+ ";refreshedCwdPreserved=" + boolText(refreshedCwdPreserved) + ";resumedTurnsPersisted=" + boolText(resumedTurnsPersisted)
			+ ";activeTurnRestoredFromResumedTurns=" + boolText(activeTurnRestoredFromResumedTurns) + ";liveOnlyEffectsSuppressed="
			+ boolText(liveOnlyEffectsSuppressed) + ";liveNetworkAttempted=" + boolText(liveNetworkAttempted) + ";realFilesystemMutated="
			+ boolText(realFilesystemMutated) + ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
