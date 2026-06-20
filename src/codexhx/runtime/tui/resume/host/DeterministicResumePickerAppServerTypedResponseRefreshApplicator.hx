package codexhx.runtime.tui.resume.host;

class DeterministicResumePickerAppServerTypedResponseRefreshApplicator {
	final applications:Array<ResumePickerAppServerTypedResponseRefreshApplication>;
	final log:Array<String>;
	var nextAppliedIndex:Int;
	var pendingReplayRefreshCount:Int;
	var sideParentStatusRefreshCount:Int;
	var activeThreadStatusUpdateCount:Int;

	public function new() {
		this.applications = [];
		this.log = [];
		this.nextAppliedIndex = 1;
		this.pendingReplayRefreshCount = 0;
		this.sideParentStatusRefreshCount = 0;
		this.activeThreadStatusUpdateCount = 0;
	}

	public function apply(outcome:ResumePickerAppServerTypedResponseDispatchOutcome):ResumePickerAppServerTypedResponseRefreshApplication {
		final application = applicationFor(outcome);
		applications.push(application);
		log.push("refresh:" + application.summary());
		if (application.mutationApplied) {
			pendingReplayRefreshCount = pendingReplayRefreshCount + 1;
			sideParentStatusRefreshCount = sideParentStatusRefreshCount + 1;
			activeThreadStatusUpdateCount = activeThreadStatusUpdateCount + 1;
			nextAppliedIndex = nextAppliedIndex + 1;
		}
		return application;
	}

	public function summaries():Array<String> {
		return log.copy();
	}

	public function applicationSummaries():Array<String> {
		final out:Array<String> = [];
		for (application in applications)
			out.push(application.summary());
		return out;
	}

	public function pendingReplayCount():Int {
		return pendingReplayRefreshCount;
	}

	public function sideParentStatusCount():Int {
		return sideParentStatusRefreshCount;
	}

	public function activeThreadStatusCount():Int {
		return activeThreadStatusUpdateCount;
	}

	function applicationFor(outcome:ResumePickerAppServerTypedResponseDispatchOutcome):ResumePickerAppServerTypedResponseRefreshApplication {
		if (outcome == null)
			return application(ResumePickerAppServerTypedResponseRefreshApplicationKind.IgnoredNoRefresh,
				ResumePickerAppServerPendingRequestClassKind.Unknown, ResumePickerAppServerTypedResponsePayloadKind.Unknown, "", 0, 0, false, false, false,
				false, "missing_dispatch_outcome");
		if (outcome.kind == ResumePickerAppServerTypedResponseDispatchOutcomeKind.ResolveSent
			&& outcome.refreshScheduled
			&& outcome.pendingReplayRefresh
			&& outcome.sideParentStatusUpdated)
			return application(ResumePickerAppServerTypedResponseRefreshApplicationKind.Applied, outcome.requestClass, outcome.payloadKind, outcome.requestId,
				outcome.sequence, nextAppliedIndex, true, true, true, true, "refresh_applied");
		return application(ResumePickerAppServerTypedResponseRefreshApplicationKind.IgnoredNoRefresh, outcome.requestClass, outcome.payloadKind,
			outcome.requestId, outcome.sequence, 0, false, false, false, false, "no_refresh_mutation");
	}

	function application(kind:ResumePickerAppServerTypedResponseRefreshApplicationKind, requestClass:ResumePickerAppServerPendingRequestClassKind,
			payloadKind:ResumePickerAppServerTypedResponsePayloadKind, requestId:String, dispatchSequence:Int, appliedIndex:Int, pendingReplayRefreshed:Bool,
			sideParentStatusRefreshed:Bool, activeThreadStatusUpdated:Bool, mutationApplied:Bool,
			reason:String):ResumePickerAppServerTypedResponseRefreshApplication {
		return new ResumePickerAppServerTypedResponseRefreshApplication({
			kind: kind,
			requestClass: requestClass,
			payloadKind: payloadKind,
			requestId: requestId,
			dispatchSequence: dispatchSequence,
			appliedIndex: appliedIndex,
			pendingReplayRefreshed: pendingReplayRefreshed,
			sideParentStatusRefreshed: sideParentStatusRefreshed,
			activeThreadStatusUpdated: activeThreadStatusUpdated,
			mutationApplied: mutationApplied,
			reason: reason
		});
	}
}
