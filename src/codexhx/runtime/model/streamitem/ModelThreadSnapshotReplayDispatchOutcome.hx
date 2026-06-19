package codexhx.runtime.model.streamitem;

class ModelThreadSnapshotReplayDispatchOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final pendingReplayRequestId:String;
	public final replayKind:ModelTurnReplayKind;
	public final eventKind:ModelThreadSnapshotReplayEventKind;
	public final dispatchKind:ModelThreadSnapshotReplayDispatchKind;
	public final beginReplayBufferEmitted:Bool;
	public final endReplayBufferEmitted:Bool;
	public final initialSubmitSuppressed:Bool;
	public final queueAutosendSuppressed:Bool;
	public final inputStateRestored:Bool;
	public final turnsReplayed:Bool;
	public final pendingPrimaryEventsDrained:Bool;
	public final noticeSuppressed:Bool;
	public final notificationDeliveredWithReplayKind:Bool;
	public final requestDeliveredWithReplayKind:Bool;
	public final historyEntryDelivered:Bool;
	public final feedbackDelivered:Bool;
	public final replayKindAttached:Bool;
	public final liveOnlyEffectsSuppressed:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(ok:Bool, code:String, requestId:String, pendingReplayRequestId:String, replayKind:ModelTurnReplayKind,
			eventKind:ModelThreadSnapshotReplayEventKind, dispatchKind:ModelThreadSnapshotReplayDispatchKind, beginReplayBufferEmitted:Bool,
			endReplayBufferEmitted:Bool, initialSubmitSuppressed:Bool, queueAutosendSuppressed:Bool, inputStateRestored:Bool, turnsReplayed:Bool,
			pendingPrimaryEventsDrained:Bool, noticeSuppressed:Bool, notificationDeliveredWithReplayKind:Bool, requestDeliveredWithReplayKind:Bool,
			historyEntryDelivered:Bool, feedbackDelivered:Bool, replayKindAttached:Bool, liveOnlyEffectsSuppressed:Bool, liveNetworkAttempted:Bool,
			realFilesystemMutated:Bool, toolExecutedOutsideFixture:Bool, errorMessage:String) {
		this.ok = ok;
		this.code = code == null ? "" : code;
		this.requestId = requestId == null ? "" : requestId;
		this.pendingReplayRequestId = pendingReplayRequestId == null ? "" : pendingReplayRequestId;
		this.replayKind = replayKind == null ? ModelTurnReplayKind.ThreadSnapshot : replayKind;
		this.eventKind = eventKind == null ? ModelThreadSnapshotReplayEventKind.ReplayTurns : eventKind;
		this.dispatchKind = dispatchKind == null ? ModelThreadSnapshotReplayDispatchKind.TurnsReplayed : dispatchKind;
		this.beginReplayBufferEmitted = beginReplayBufferEmitted;
		this.endReplayBufferEmitted = endReplayBufferEmitted;
		this.initialSubmitSuppressed = initialSubmitSuppressed;
		this.queueAutosendSuppressed = queueAutosendSuppressed;
		this.inputStateRestored = inputStateRestored;
		this.turnsReplayed = turnsReplayed;
		this.pendingPrimaryEventsDrained = pendingPrimaryEventsDrained;
		this.noticeSuppressed = noticeSuppressed;
		this.notificationDeliveredWithReplayKind = notificationDeliveredWithReplayKind;
		this.requestDeliveredWithReplayKind = requestDeliveredWithReplayKind;
		this.historyEntryDelivered = historyEntryDelivered;
		this.feedbackDelivered = feedbackDelivered;
		this.replayKindAttached = replayKindAttached;
		this.liveOnlyEffectsSuppressed = liveOnlyEffectsSuppressed;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";pendingReplayRequest=" + noneIfEmpty(pendingReplayRequestId)
			+ ";replayKind=" + replayKind + ";eventKind=" + eventKind + ";dispatchKind=" + dispatchKind + ";beginReplayBufferEmitted="
			+ boolText(beginReplayBufferEmitted) + ";endReplayBufferEmitted=" + boolText(endReplayBufferEmitted) + ";initialSubmitSuppressed="
			+ boolText(initialSubmitSuppressed) + ";queueAutosendSuppressed=" + boolText(queueAutosendSuppressed) + ";inputStateRestored="
			+ boolText(inputStateRestored) + ";turnsReplayed=" + boolText(turnsReplayed) + ";pendingPrimaryEventsDrained="
			+ boolText(pendingPrimaryEventsDrained) + ";noticeSuppressed=" + boolText(noticeSuppressed) + ";notificationDeliveredWithReplayKind="
			+ boolText(notificationDeliveredWithReplayKind) + ";requestDeliveredWithReplayKind=" + boolText(requestDeliveredWithReplayKind)
			+ ";historyEntryDelivered=" + boolText(historyEntryDelivered) + ";feedbackDelivered=" + boolText(feedbackDelivered) + ";replayKindAttached="
			+ boolText(replayKindAttached) + ";liveOnlyEffectsSuppressed=" + boolText(liveOnlyEffectsSuppressed) + ";liveNetworkAttempted="
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
