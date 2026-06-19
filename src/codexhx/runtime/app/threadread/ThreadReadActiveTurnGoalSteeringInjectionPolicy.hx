package codexhx.runtime.app.threadread;

class ThreadReadActiveTurnGoalSteeringInjectionPolicy {
	public static function buildCases(requests:Array<ThreadReadActiveTurnGoalSteeringInjectionRequest>):ThreadReadActiveTurnGoalSteeringInjectionReport {
		final outcomes:Array<ThreadReadActiveTurnGoalSteeringInjectionOutcome> = [];
		for (request in requests) {
			outcomes.push(build(request));
		}
		return new ThreadReadActiveTurnGoalSteeringInjectionReport(outcomes);
	}

	public static function build(request:ThreadReadActiveTurnGoalSteeringInjectionRequest):ThreadReadActiveTurnGoalSteeringInjectionOutcome {
		final itemSummary = request.steeringOutcome == null ? "item=none" : request.steeringOutcome.itemSummary();
		final itemStep = request.steeringOutcome == null ? "goal/steering/item" : "goal/" + request.steeringOutcome.kind + "/item";
		if (request.steeringOutcome == null || !request.steeringOutcome.ok || !request.steeringOutcome.emitted || request.steeringOutcome.item == null) {
			return ThreadReadActiveTurnGoalSteeringInjectionOutcome.failure("steering_item_not_available", itemSummary,
				"active-turn injection requires an emitted goal steering item");
		}

		if (!request.threadManagerAvailable) {
			return ThreadReadActiveTurnGoalSteeringInjectionOutcome.makeSkipped("thread_manager_unavailable_skip", false, false, false, false, itemSummary,
				itemStep + "->thread_manager/missing->skip", "skipping goal steering because thread manager is unavailable");
		}

		if (!request.liveThreadAvailable) {
			return ThreadReadActiveTurnGoalSteeringInjectionOutcome.makeSkipped("live_thread_unavailable_skip", true, false, false, false, itemSummary,
				itemStep + "->thread_manager/live_thread/missing->skip", "skipping goal steering because live thread is unavailable");
		}

		if (!request.activeTurnRunning) {
			return ThreadReadActiveTurnGoalSteeringInjectionOutcome.makeSkipped("no_active_turn_skip", true, true, false, true, itemSummary,
				itemStep + "->thread_manager/live_thread->inject_if_running->returned/input", "skipping goal steering because no turn is active");
		}

		return ThreadReadActiveTurnGoalSteeringInjectionOutcome.makeInjected(itemSummary);
	}
}
