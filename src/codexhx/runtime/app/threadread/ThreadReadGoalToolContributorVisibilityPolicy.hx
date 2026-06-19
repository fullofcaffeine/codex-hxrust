package codexhx.runtime.app.threadread;

class ThreadReadGoalToolContributorVisibilityPolicy {
	public static function buildCases(requests:Array<ThreadReadGoalToolContributorVisibilityRequest>):ThreadReadGoalToolContributorVisibilityReport {
		final outcomes:Array<ThreadReadGoalToolContributorVisibilityOutcome> = [];
		for (request in requests)
			outcomes.push(build(request));
		return new ThreadReadGoalToolContributorVisibilityReport(outcomes);
	}

	public static function build(request:ThreadReadGoalToolContributorVisibilityRequest):ThreadReadGoalToolContributorVisibilityOutcome {
		if (!request.runtimeAvailable)
			return ThreadReadGoalToolContributorVisibilityOutcome.runtimeMissing(request);
		if (!toolsVisible(request)) {
			return ThreadReadGoalToolContributorVisibilityOutcome.toolsHidden(request,
				request.runtimeEnabled ? "tools_unavailable_for_thread" : "runtime_disabled_no_tools");
		}
		return ThreadReadGoalToolContributorVisibilityOutcome.visible(request, visibleTools(request));
	}

	static function toolsVisible(request:ThreadReadGoalToolContributorVisibilityRequest):Bool {
		return request.runtimeEnabled && request.toolsAvailableForThread;
	}

	static function visibleTools(request:ThreadReadGoalToolContributorVisibilityRequest):Array<ThreadReadGoalToolExecutorDescriptor> {
		return [
			tool(request, ThreadReadGoalToolExecutorKind.Get, "get_goal", 0),
			tool(request, ThreadReadGoalToolExecutorKind.Create, "create_goal", 1),
			tool(request, ThreadReadGoalToolExecutorKind.Update, "update_goal", 2)
		];
	}

	static function tool(request:ThreadReadGoalToolContributorVisibilityRequest, kind:ThreadReadGoalToolExecutorKind, toolName:String,
			orderIndex:Int):ThreadReadGoalToolExecutorDescriptor {
		return new ThreadReadGoalToolExecutorDescriptor(kind, "", toolName, request.threadId, request.stateDbAvailable, request.accountingStateAvailable,
			request.analyticsAvailable, request.eventEmitterAvailable, request.metricsAvailable, orderIndex);
	}
}
