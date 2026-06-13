package codexhx.runtime.app.threadread;

class ThreadReadGoalToolContributorVisibilityOutcome {
	public final ok:Bool;
	public final code:String;
	public final runtimeAvailable:Bool;
	public final runtimeEnabled:Bool;
	public final toolsAvailableForThread:Bool;
	public final toolsVisible:Bool;
	public final threadId:String;
	public final returnedToolCount:Int;
	public final tools:Array<ThreadReadGoalToolExecutorDescriptor>;
	public final stableOrder:String;
	public final sequence:String;
	public final message:String;

	function new(
		ok:Bool,
		code:String,
		runtimeAvailable:Bool,
		runtimeEnabled:Bool,
		toolsAvailableForThread:Bool,
		toolsVisible:Bool,
		threadId:String,
		returnedToolCount:Int,
		tools:Array<ThreadReadGoalToolExecutorDescriptor>,
		stableOrder:String,
		sequence:String,
		message:String
	) {
		this.ok = ok;
		this.code = code;
		this.runtimeAvailable = runtimeAvailable;
		this.runtimeEnabled = runtimeEnabled;
		this.toolsAvailableForThread = toolsAvailableForThread;
		this.toolsVisible = toolsVisible;
		this.threadId = threadId;
		this.returnedToolCount = returnedToolCount;
		this.tools = tools;
		this.stableOrder = stableOrder;
		this.sequence = sequence;
		this.message = message;
	}

	public static function runtimeMissing(request:ThreadReadGoalToolContributorVisibilityRequest):ThreadReadGoalToolContributorVisibilityOutcome {
		return skipped(
			"runtime_missing_no_tools",
			request,
			false,
			"tools->goal_runtime_handle/none->return_empty_vec",
			"goal tools are hidden because no goal runtime handle is attached to the thread"
		);
	}

	public static function toolsHidden(request:ThreadReadGoalToolContributorVisibilityRequest, code:String):ThreadReadGoalToolContributorVisibilityOutcome {
		final reason = request.runtimeEnabled ? "tools_unavailable_for_thread" : "runtime_disabled";
		return skipped(
			code,
			request,
			false,
			"tools->runtime.tools_visible:" + reason + "->return_empty_vec",
			request.runtimeEnabled
				? "goal tools are hidden because they are not available for this thread"
				: "goal tools are hidden because the goal runtime is disabled"
		);
	}

	public static function visible(
		request:ThreadReadGoalToolContributorVisibilityRequest,
		tools:Array<ThreadReadGoalToolExecutorDescriptor>
	):ThreadReadGoalToolContributorVisibilityOutcome {
		final order:Array<String> = [];
		for (tool in tools) order.push(tool.toolName);
		return new ThreadReadGoalToolContributorVisibilityOutcome(
			true,
			"goal_tools_visible",
			true,
			true,
			true,
			true,
			request.threadId,
			tools.length,
			tools,
			order.join(","),
			"tools->runtime.tools_visible:true->GoalToolExecutor::get->create->update",
			"goal tools are visible in upstream get/create/update order"
		);
	}

	static function skipped(
		code:String,
		request:ThreadReadGoalToolContributorVisibilityRequest,
		toolsVisible:Bool,
		sequence:String,
		message:String
	):ThreadReadGoalToolContributorVisibilityOutcome {
		return new ThreadReadGoalToolContributorVisibilityOutcome(
			true,
			code,
			request.runtimeAvailable,
			request.runtimeAvailable && request.runtimeEnabled,
			request.runtimeAvailable && request.toolsAvailableForThread,
			toolsVisible,
			request.threadId,
			0,
			[],
			"",
			sequence,
			message
		);
	}

	public function summary():String {
		final parts:Array<String> = [];
		for (tool in tools) parts.push(tool.summary());
		return "code=" + code
			+ ";runtimeAvailable=" + boolText(runtimeAvailable)
			+ ";runtimeEnabled=" + boolText(runtimeEnabled)
			+ ";toolsAvailableForThread=" + boolText(toolsAvailableForThread)
			+ ";toolsVisible=" + boolText(toolsVisible)
			+ ";thread=" + threadId
			+ ";returnedToolCount=" + Std.string(returnedToolCount)
			+ ";stableOrder=" + stableOrder
			+ ";sequence=" + sequence
			+ ";tools=[" + parts.join("|") + "]";
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
