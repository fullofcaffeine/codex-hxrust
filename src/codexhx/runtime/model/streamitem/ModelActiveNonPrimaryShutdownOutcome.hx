package codexhx.runtime.model.streamitem;

class ModelActiveNonPrimaryShutdownOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final navigationCleanupRequestId:String;
	public final decisionKind:ModelActiveNonPrimaryShutdownDecisionKind;
	public final eventKind:ModelActiveNonPrimaryShutdownEventKind;
	public final activeThreadId:String;
	public final primaryThreadId:String;
	public final pendingShutdownExitThreadId:String;
	public final closedThreadId:String;
	public final selectedPrimaryThreadId:String;
	public final failoverTargetSelected:Bool;
	public final nonShutdownIgnored:Bool;
	public final primaryShutdownIgnored:Bool;
	public final missingThreadIdsIgnored:Bool;
	public final pendingShutdownExitIgnored:Bool;
	public final otherPendingExitStillSwitches:Bool;
	public final markAgentPickerClosed:Bool;
	public final sideClosedLocalCleanupAttempted:Bool;
	public final discardVisibleSideAttempted:Bool;
	public final selectPrimaryThreadAttempted:Bool;
	public final primarySelectSucceeded:Bool;
	public final infoMessageIntended:Bool;
	public final errorMessageDisplayed:Bool;
	public final activeThreadClearedAfterFailedSwitch:Bool;
	public final pendingShutdownExitMarkerCleared:Bool;
	public final activeEventForwarded:Bool;
	public final failoverBeforePendingExitClear:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(ok:Bool, code:String, requestId:String, navigationCleanupRequestId:String, decisionKind:ModelActiveNonPrimaryShutdownDecisionKind,
			eventKind:ModelActiveNonPrimaryShutdownEventKind, activeThreadId:String, primaryThreadId:String, pendingShutdownExitThreadId:String,
			closedThreadId:String, selectedPrimaryThreadId:String, failoverTargetSelected:Bool, nonShutdownIgnored:Bool, primaryShutdownIgnored:Bool,
			missingThreadIdsIgnored:Bool, pendingShutdownExitIgnored:Bool, otherPendingExitStillSwitches:Bool, markAgentPickerClosed:Bool,
			sideClosedLocalCleanupAttempted:Bool, discardVisibleSideAttempted:Bool, selectPrimaryThreadAttempted:Bool, primarySelectSucceeded:Bool,
			infoMessageIntended:Bool, errorMessageDisplayed:Bool, activeThreadClearedAfterFailedSwitch:Bool, pendingShutdownExitMarkerCleared:Bool,
			activeEventForwarded:Bool, failoverBeforePendingExitClear:Bool, eventOrderingPreserved:Bool, liveNetworkAttempted:Bool,
			realFilesystemMutated:Bool, toolExecutedOutsideFixture:Bool, errorMessage:String) {
		this.ok = ok;
		this.code = code == null ? "" : code;
		this.requestId = requestId == null ? "" : requestId;
		this.navigationCleanupRequestId = navigationCleanupRequestId == null ? "" : navigationCleanupRequestId;
		this.decisionKind = decisionKind == null ? ModelActiveNonPrimaryShutdownDecisionKind.IgnoredNonShutdownEvent : decisionKind;
		this.eventKind = eventKind == null ? ModelActiveNonPrimaryShutdownEventKind.Other : eventKind;
		this.activeThreadId = activeThreadId == null ? "" : activeThreadId;
		this.primaryThreadId = primaryThreadId == null ? "" : primaryThreadId;
		this.pendingShutdownExitThreadId = pendingShutdownExitThreadId == null ? "" : pendingShutdownExitThreadId;
		this.closedThreadId = closedThreadId == null ? "" : closedThreadId;
		this.selectedPrimaryThreadId = selectedPrimaryThreadId == null ? "" : selectedPrimaryThreadId;
		this.failoverTargetSelected = failoverTargetSelected;
		this.nonShutdownIgnored = nonShutdownIgnored;
		this.primaryShutdownIgnored = primaryShutdownIgnored;
		this.missingThreadIdsIgnored = missingThreadIdsIgnored;
		this.pendingShutdownExitIgnored = pendingShutdownExitIgnored;
		this.otherPendingExitStillSwitches = otherPendingExitStillSwitches;
		this.markAgentPickerClosed = markAgentPickerClosed;
		this.sideClosedLocalCleanupAttempted = sideClosedLocalCleanupAttempted;
		this.discardVisibleSideAttempted = discardVisibleSideAttempted;
		this.selectPrimaryThreadAttempted = selectPrimaryThreadAttempted;
		this.primarySelectSucceeded = primarySelectSucceeded;
		this.infoMessageIntended = infoMessageIntended;
		this.errorMessageDisplayed = errorMessageDisplayed;
		this.activeThreadClearedAfterFailedSwitch = activeThreadClearedAfterFailedSwitch;
		this.pendingShutdownExitMarkerCleared = pendingShutdownExitMarkerCleared;
		this.activeEventForwarded = activeEventForwarded;
		this.failoverBeforePendingExitClear = failoverBeforePendingExitClear;
		this.eventOrderingPreserved = eventOrderingPreserved;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";navigationCleanupRequest=" + noneIfEmpty(navigationCleanupRequestId)
			+ ";decisionKind=" + decisionKind + ";eventKind=" + eventKind + ";activeThreadId=" + noneIfEmpty(activeThreadId) + ";primaryThreadId="
			+ noneIfEmpty(primaryThreadId) + ";pendingShutdownExitThreadId=" + noneIfEmpty(pendingShutdownExitThreadId) + ";closedThreadId="
			+ noneIfEmpty(closedThreadId) + ";selectedPrimaryThreadId=" + noneIfEmpty(selectedPrimaryThreadId) + ";failoverTargetSelected="
			+ boolText(failoverTargetSelected) + ";nonShutdownIgnored=" + boolText(nonShutdownIgnored) + ";primaryShutdownIgnored="
			+ boolText(primaryShutdownIgnored) + ";missingThreadIdsIgnored=" + boolText(missingThreadIdsIgnored) + ";pendingShutdownExitIgnored="
			+ boolText(pendingShutdownExitIgnored) + ";otherPendingExitStillSwitches=" + boolText(otherPendingExitStillSwitches) + ";markAgentPickerClosed="
			+ boolText(markAgentPickerClosed) + ";sideClosedLocalCleanupAttempted=" + boolText(sideClosedLocalCleanupAttempted)
			+ ";discardVisibleSideAttempted=" + boolText(discardVisibleSideAttempted) + ";selectPrimaryThreadAttempted="
			+ boolText(selectPrimaryThreadAttempted) + ";primarySelectSucceeded=" + boolText(primarySelectSucceeded) + ";infoMessageIntended="
			+ boolText(infoMessageIntended) + ";errorMessageDisplayed=" + boolText(errorMessageDisplayed) + ";activeThreadClearedAfterFailedSwitch="
			+ boolText(activeThreadClearedAfterFailedSwitch) + ";pendingShutdownExitMarkerCleared=" + boolText(pendingShutdownExitMarkerCleared)
			+ ";activeEventForwarded=" + boolText(activeEventForwarded) + ";failoverBeforePendingExitClear=" + boolText(failoverBeforePendingExitClear)
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
