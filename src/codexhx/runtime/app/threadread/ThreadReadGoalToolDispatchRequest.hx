package codexhx.runtime.app.threadread;

class ThreadReadGoalToolDispatchRequest {
	public final kind:ThreadReadGoalToolKind;
	public final getRequest:ThreadReadGetGoalToolRequest;
	public final createRequest:ThreadReadCreateGoalToolRequest;
	public final updateRequest:ThreadReadUpdateGoalToolRequest;

	function new(kind:ThreadReadGoalToolKind, getRequest:ThreadReadGetGoalToolRequest, createRequest:ThreadReadCreateGoalToolRequest,
			updateRequest:ThreadReadUpdateGoalToolRequest) {
		this.kind = kind;
		this.getRequest = getRequest;
		this.createRequest = createRequest;
		this.updateRequest = updateRequest;
	}

	public static function get(request:ThreadReadGetGoalToolRequest):ThreadReadGoalToolDispatchRequest {
		return new ThreadReadGoalToolDispatchRequest(ThreadReadGoalToolKind.Get, request, null, null);
	}

	public static function create(request:ThreadReadCreateGoalToolRequest):ThreadReadGoalToolDispatchRequest {
		return new ThreadReadGoalToolDispatchRequest(ThreadReadGoalToolKind.Create, null, request, null);
	}

	public static function update(request:ThreadReadUpdateGoalToolRequest):ThreadReadGoalToolDispatchRequest {
		return new ThreadReadGoalToolDispatchRequest(ThreadReadGoalToolKind.Update, null, null, request);
	}
}
