package codexhx.runtime.app.threadread;

class ThreadReadGoalToolDispatchPolicy {
	public static function buildCases(requests:Array<ThreadReadGoalToolDispatchRequest>):ThreadReadGoalToolDispatchReport {
		final outcomes:Array<ThreadReadGoalToolDispatchOutcome> = [];
		for (request in requests) outcomes.push(build(request));
		return new ThreadReadGoalToolDispatchReport(outcomes);
	}

	public static function build(request:ThreadReadGoalToolDispatchRequest):ThreadReadGoalToolDispatchOutcome {
		return switch request.kind {
			case ThreadReadGoalToolKind.Get:
				if (request.getRequest == null) ThreadReadGoalToolDispatchOutcome.malformedRequest(request.kind)
				else ThreadReadGoalToolDispatchOutcome.fromGet(ThreadReadGetGoalToolPolicy.build(request.getRequest));
			case ThreadReadGoalToolKind.Create:
				if (request.createRequest == null) ThreadReadGoalToolDispatchOutcome.malformedRequest(request.kind)
				else ThreadReadGoalToolDispatchOutcome.fromCreate(ThreadReadCreateGoalToolPolicy.build(request.createRequest));
			case ThreadReadGoalToolKind.Update:
				if (request.updateRequest == null) ThreadReadGoalToolDispatchOutcome.malformedRequest(request.kind)
				else ThreadReadGoalToolDispatchOutcome.fromUpdate(ThreadReadUpdateGoalToolPolicy.build(request.updateRequest));
		}
	}
}
