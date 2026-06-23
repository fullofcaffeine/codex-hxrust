package codexhx.runtime.tui.resume.host;

class RefreshApplicator {
	final applications:Array<RefreshApplication>;
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

	public function apply(outcome:DispatchOutcome):RefreshApplication {
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

	function applicationFor(outcome:DispatchOutcome):RefreshApplication {
		if (outcome == null)
			return application(RefreshApplicationKind.IgnoredNoRefresh, PendingRequestClassKind.Unknown, PayloadKind.Unknown, "", 0, 0, false, false, false,
				false, "missing_dispatch_outcome");
		if (outcome.kind == DispatchOutcomeKind.ResolveSent
			&& outcome.refreshScheduled
			&& outcome.pendingReplayRefresh
			&& outcome.sideParentStatusUpdated)
			return application(RefreshApplicationKind.Applied, outcome.requestClass, outcome.payloadKind, outcome.requestId, outcome.sequence,
				nextAppliedIndex, true, true, true, true, "refresh_applied");
		return application(RefreshApplicationKind.IgnoredNoRefresh, outcome.requestClass, outcome.payloadKind, outcome.requestId, outcome.sequence, 0, false,
			false, false, false, "no_refresh_mutation");
	}

	function application(kind:RefreshApplicationKind, requestClass:PendingRequestClassKind, payloadKind:PayloadKind, requestId:String, dispatchSequence:Int,
			appliedIndex:Int, pendingReplayRefreshed:Bool, sideParentStatusRefreshed:Bool, activeThreadStatusUpdated:Bool, mutationApplied:Bool,
			reason:String):RefreshApplication {
		return new RefreshApplication({
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
