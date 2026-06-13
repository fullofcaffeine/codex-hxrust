package codexhx.runtime.app.threadread;

class ThreadReadGetGoalToolOutcome {
	public final ok:Bool;
	public final code:String;
	public final threadId:String;
	public final argumentsAccepted:Bool;
	public final readAttempted:Bool;
	public final dbOutcomeKind:ThreadReadGetGoalToolDbOutcomeKind;
	public final functionCallErrorKind:String;
	public final errorMessage:String;
	public final response:ThreadReadGetGoalToolResponse;
	public final goalPresent:Bool;
	public final hasRemainingTokens:Bool;
	public final remainingTokens:Int;
	public final hasCompletionBudgetReport:Bool;
	public final stateMutated:Bool;
	public final eventsEmitted:Bool;
	public final sequence:String;
	public final message:String;

	function new(
		ok:Bool,
		code:String,
		threadId:String,
		argumentsAccepted:Bool,
		readAttempted:Bool,
		dbOutcomeKind:ThreadReadGetGoalToolDbOutcomeKind,
		functionCallErrorKind:String,
		errorMessage:String,
		response:ThreadReadGetGoalToolResponse,
		stateMutated:Bool,
		eventsEmitted:Bool,
		sequence:String,
		message:String
	) {
		this.ok = ok;
		this.code = code;
		this.threadId = threadId;
		this.argumentsAccepted = argumentsAccepted;
		this.readAttempted = readAttempted;
		this.dbOutcomeKind = dbOutcomeKind;
		this.functionCallErrorKind = functionCallErrorKind;
		this.errorMessage = errorMessage;
		this.response = response;
		this.goalPresent = response != null && response.goal != null;
		this.hasRemainingTokens = response != null && response.hasRemainingTokens;
		this.remainingTokens = response == null ? 0 : response.remainingTokens;
		this.hasCompletionBudgetReport = response != null && response.hasCompletionBudgetReport;
		this.stateMutated = stateMutated;
		this.eventsEmitted = eventsEmitted;
		this.sequence = sequence;
		this.message = message;
	}

	public static function invalidArguments(request:ThreadReadGetGoalToolRequest, errorMessage:String):ThreadReadGetGoalToolOutcome {
		return new ThreadReadGetGoalToolOutcome(
			false,
			"invalid_tool_arguments",
			request.threadId,
			false,
			false,
			request.dbOutcomeKind,
			"respond_to_model",
			errorMessage,
			null,
			false,
			false,
			"handle_get->function_arguments/error->return_error",
			"get_goal rejected invalid tool arguments before reading goal state"
		);
	}

	public static function readError(request:ThreadReadGetGoalToolRequest):ThreadReadGetGoalToolOutcome {
		return new ThreadReadGetGoalToolOutcome(
			false,
			"goal_state_read_error",
			request.threadId,
			true,
			true,
			ThreadReadGetGoalToolDbOutcomeKind.Error,
			"respond_to_model",
			"failed to read goal: " + request.dbErrorMessage,
			null,
			false,
			false,
			"handle_get->get_thread_goal:error->RespondToModel",
			"get_goal converted the state read failure into a model-visible tool error"
		);
	}

	public static function success(request:ThreadReadGetGoalToolRequest, response:ThreadReadGetGoalToolResponse):ThreadReadGetGoalToolOutcome {
		return new ThreadReadGetGoalToolOutcome(
			true,
			response.goal == null ? "goal_missing_response" : "goal_read_response",
			request.threadId,
			true,
			true,
			request.dbOutcomeKind,
			"",
			"",
			response,
			false,
			false,
			"handle_get->get_thread_goal:" + request.dbOutcomeKind + "->protocol_goal_from_state->goal_response:omit_completion_budget_report",
			"get_goal returned a structured read-only goal response"
		);
	}

	public function summary():String {
		return "code=" + code
			+ ";thread=" + threadId
			+ ";argumentsAccepted=" + boolText(argumentsAccepted)
			+ ";readAttempted=" + boolText(readAttempted)
			+ ";dbOutcome=" + dbOutcomeKind
			+ ";goalPresent=" + boolText(goalPresent)
			+ ";remainingTokens=" + (hasRemainingTokens ? Std.string(remainingTokens) : "null")
			+ ";completionBudgetReport=" + boolText(hasCompletionBudgetReport)
			+ ";functionCallErrorKind=" + functionCallErrorKind
			+ ";stateMutated=" + boolText(stateMutated)
			+ ";eventsEmitted=" + boolText(eventsEmitted)
			+ ";sequence=" + sequence;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
