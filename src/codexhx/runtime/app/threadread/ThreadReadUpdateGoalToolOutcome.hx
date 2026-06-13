package codexhx.runtime.app.threadread;

class ThreadReadUpdateGoalToolOutcome {
	public final ok:Bool;
	public final code:String;
	public final threadId:String;
	public final turnId:String;
	public final callId:String;
	public final argumentsAccepted:Bool;
	public final requestedStatus:String;
	public final accountingAttempted:Bool;
	public final accountingMode:String;
	public final budgetLimitedDisposition:String;
	public final accountingEventId:String;
	public final accountingOutcomeKind:ThreadReadUpdateGoalToolAccountingOutcomeKind;
	public final metricsReadAttempted:Bool;
	public final metricsReadOutcomeKind:ThreadReadUpdateGoalToolMetricsReadOutcomeKind;
	public final previousStatus:String;
	public final updateAttempted:Bool;
	public final updateOutcomeKind:ThreadReadUpdateGoalToolUpdateOutcomeKind;
	public final terminalMetricRecorded:Bool;
	public final analyticsStatusChanged:Bool;
	public final currentTurnCleared:Bool;
	public final clearedTurnId:String;
	public final eventEmitted:Bool;
	public final functionCallErrorKind:String;
	public final errorMessage:String;
	public final response:ThreadReadUpdateGoalToolResponse;
	public final goalPresent:Bool;
	public final hasRemainingTokens:Bool;
	public final remainingTokens:Int;
	public final hasCompletionBudgetReport:Bool;
	public final sequence:String;
	public final message:String;

	function new(
		ok:Bool,
		code:String,
		threadId:String,
		turnId:String,
		callId:String,
		argumentsAccepted:Bool,
		requestedStatus:String,
		accountingAttempted:Bool,
		accountingMode:String,
		budgetLimitedDisposition:String,
		accountingEventId:String,
		accountingOutcomeKind:ThreadReadUpdateGoalToolAccountingOutcomeKind,
		metricsReadAttempted:Bool,
		metricsReadOutcomeKind:ThreadReadUpdateGoalToolMetricsReadOutcomeKind,
		previousStatus:String,
		updateAttempted:Bool,
		updateOutcomeKind:ThreadReadUpdateGoalToolUpdateOutcomeKind,
		terminalMetricRecorded:Bool,
		analyticsStatusChanged:Bool,
		currentTurnCleared:Bool,
		clearedTurnId:String,
		eventEmitted:Bool,
		functionCallErrorKind:String,
		errorMessage:String,
		response:ThreadReadUpdateGoalToolResponse,
		sequence:String,
		message:String
	) {
		this.ok = ok;
		this.code = code;
		this.threadId = threadId;
		this.turnId = turnId;
		this.callId = callId;
		this.argumentsAccepted = argumentsAccepted;
		this.requestedStatus = requestedStatus;
		this.accountingAttempted = accountingAttempted;
		this.accountingMode = accountingMode;
		this.budgetLimitedDisposition = budgetLimitedDisposition;
		this.accountingEventId = accountingEventId;
		this.accountingOutcomeKind = accountingOutcomeKind;
		this.metricsReadAttempted = metricsReadAttempted;
		this.metricsReadOutcomeKind = metricsReadOutcomeKind;
		this.previousStatus = previousStatus;
		this.updateAttempted = updateAttempted;
		this.updateOutcomeKind = updateOutcomeKind;
		this.terminalMetricRecorded = terminalMetricRecorded;
		this.analyticsStatusChanged = analyticsStatusChanged;
		this.currentTurnCleared = currentTurnCleared;
		this.clearedTurnId = clearedTurnId;
		this.eventEmitted = eventEmitted;
		this.functionCallErrorKind = functionCallErrorKind;
		this.errorMessage = errorMessage;
		this.response = response;
		this.goalPresent = response != null && response.goal != null;
		this.hasRemainingTokens = response != null && response.hasRemainingTokens;
		this.remainingTokens = response == null ? 0 : response.remainingTokens;
		this.hasCompletionBudgetReport = response != null && response.hasCompletionBudgetReport;
		this.sequence = sequence;
		this.message = message;
	}

	public static function rejected(
		request:ThreadReadUpdateGoalToolRequest,
		code:String,
		errorMessage:String,
		requestedStatus:String,
		sequence:String
	):ThreadReadUpdateGoalToolOutcome {
		return new ThreadReadUpdateGoalToolOutcome(
			false,
			code,
			request.threadId,
			request.turnId,
			request.callId,
			code != "invalid_tool_arguments",
			requestedStatus,
			false,
			"",
			"",
			"",
			request.accountingOutcomeKind,
			false,
			request.metricsReadOutcomeKind,
			"",
			false,
			request.updateOutcomeKind,
			false,
			false,
			false,
			"",
			false,
			"respond_to_model",
			errorMessage,
			null,
			sequence,
			"update_goal rejected the invocation before accounting or state update"
		);
	}

	public static function accountingError(
		request:ThreadReadUpdateGoalToolRequest,
		requestedStatus:String,
		accountingMode:String
	):ThreadReadUpdateGoalToolOutcome {
		return failure(
			request,
			"goal_progress_accounting_error",
			requestedStatus,
			true,
			accountingMode,
			request.accountingOutcomeKind,
			false,
			request.metricsReadOutcomeKind,
			"",
			false,
			request.updateOutcomeKind,
			"respond_to_model",
			"failed to account goal progress: " + request.accountingErrorMessage,
			"handle_update->account_active_goal_progress:" + accountingMode + "/error->RespondToModel"
		);
	}

	public static function metricsReadError(
		request:ThreadReadUpdateGoalToolRequest,
		requestedStatus:String,
		accountingMode:String
	):ThreadReadUpdateGoalToolOutcome {
		return failure(
			request,
			"goal_metrics_status_read_error",
			requestedStatus,
			true,
			accountingMode,
			request.accountingOutcomeKind,
			true,
			ThreadReadUpdateGoalToolMetricsReadOutcomeKind.Error,
			"",
			false,
			request.updateOutcomeKind,
			"respond_to_model",
			"failed to read goal metrics status: " + request.metricsReadErrorMessage,
			"handle_update->current_goal_status_for_metrics:error->RespondToModel"
		);
	}

	public static function updateError(
		request:ThreadReadUpdateGoalToolRequest,
		requestedStatus:String,
		accountingMode:String
	):ThreadReadUpdateGoalToolOutcome {
		return failure(
			request,
			"goal_update_state_error",
			requestedStatus,
			true,
			accountingMode,
			request.accountingOutcomeKind,
			true,
			request.metricsReadOutcomeKind,
			request.previousStatus,
			true,
			ThreadReadUpdateGoalToolUpdateOutcomeKind.Error,
			"respond_to_model",
			"failed to update goal: " + request.updateErrorMessage,
			"handle_update->update_thread_goal:error->RespondToModel"
		);
	}

	public static function noGoal(
		request:ThreadReadUpdateGoalToolRequest,
		requestedStatus:String,
		accountingMode:String
	):ThreadReadUpdateGoalToolOutcome {
		return failure(
			request,
			"goal_update_missing_goal",
			requestedStatus,
			true,
			accountingMode,
			request.accountingOutcomeKind,
			true,
			request.metricsReadOutcomeKind,
			request.previousStatus,
			true,
			ThreadReadUpdateGoalToolUpdateOutcomeKind.Missing,
			"respond_to_model",
			"cannot update goal because this thread has no goal",
			"handle_update->update_thread_goal:none->RespondToModel"
		);
	}

	static function failure(
		request:ThreadReadUpdateGoalToolRequest,
		code:String,
		requestedStatus:String,
		accountingAttempted:Bool,
		accountingMode:String,
		accountingOutcomeKind:ThreadReadUpdateGoalToolAccountingOutcomeKind,
		metricsReadAttempted:Bool,
		metricsReadOutcomeKind:ThreadReadUpdateGoalToolMetricsReadOutcomeKind,
		previousStatus:String,
		updateAttempted:Bool,
		updateOutcomeKind:ThreadReadUpdateGoalToolUpdateOutcomeKind,
		functionCallErrorKind:String,
		errorMessage:String,
		sequence:String
	):ThreadReadUpdateGoalToolOutcome {
		return new ThreadReadUpdateGoalToolOutcome(
			false,
			code,
			request.threadId,
			request.turnId,
			request.callId,
			true,
			requestedStatus,
			accountingAttempted,
			accountingMode,
			accountingAttempted ? "clear_active" : "",
			accountingAttempted ? request.callId : "",
			accountingOutcomeKind,
			metricsReadAttempted,
			metricsReadOutcomeKind,
			previousStatus,
			updateAttempted,
			updateOutcomeKind,
			false,
			false,
			false,
			"",
			false,
			functionCallErrorKind,
			errorMessage,
			null,
			sequence,
			"update_goal stopped before producing a structured goal response"
		);
	}

	public static function success(
		request:ThreadReadUpdateGoalToolRequest,
		requestedStatus:String,
		accountingMode:String,
		response:ThreadReadUpdateGoalToolResponse
	):ThreadReadUpdateGoalToolOutcome {
		final previousStatus = request.metricsReadOutcomeKind == ThreadReadUpdateGoalToolMetricsReadOutcomeKind.Found ? request.previousStatus : "";
		return new ThreadReadUpdateGoalToolOutcome(
			true,
			requestedStatus == "complete" ? "goal_updated_complete" : "goal_updated_blocked",
			request.threadId,
			request.turnId,
			request.callId,
			true,
			requestedStatus,
			true,
			accountingMode,
			"clear_active",
			request.callId,
			request.accountingOutcomeKind,
			true,
			request.metricsReadOutcomeKind,
			previousStatus,
			true,
			ThreadReadUpdateGoalToolUpdateOutcomeKind.Updated,
			previousStatus.length > 0 && previousStatus != response.goal.status,
			true,
			true,
			request.clearedTurnId,
			true,
			"",
			"",
			response,
			"handle_update->account_active_goal_progress:" + accountingMode + "/" + request.accountingOutcomeKind
				+ "->current_goal_status_for_metrics:" + request.metricsReadOutcomeKind
				+ "->update_thread_goal:updated"
				+ "->record_terminal_if_status_changed"
				+ "->analytics.status_changed"
				+ "->clear_current_turn_goal"
				+ "->thread_goal_updated:" + request.callId
				+ "->goal_response:" + (response.hasCompletionBudgetReport ? "include_completion_budget_report" : "omit_completion_budget_report"),
			"update_goal updated the goal and returned a structured response"
		);
	}

	public function summary():String {
		return "code=" + code
			+ ";thread=" + threadId
			+ ";turn=" + turnId
			+ ";call=" + callId
			+ ";argumentsAccepted=" + boolText(argumentsAccepted)
			+ ";status=" + requestedStatus
			+ ";accountingAttempted=" + boolText(accountingAttempted)
			+ ";accountingMode=" + accountingMode
			+ ";disposition=" + budgetLimitedDisposition
			+ ";accountingEventId=" + accountingEventId
			+ ";accountingOutcome=" + accountingOutcomeKind
			+ ";metricsRead=" + boolText(metricsReadAttempted)
			+ ";metricsOutcome=" + metricsReadOutcomeKind
			+ ";previousStatus=" + previousStatus
			+ ";updateAttempted=" + boolText(updateAttempted)
			+ ";updateOutcome=" + updateOutcomeKind
			+ ";terminalMetric=" + boolText(terminalMetricRecorded)
			+ ";analytics=" + boolText(analyticsStatusChanged)
			+ ";currentTurnCleared=" + boolText(currentTurnCleared)
			+ ";clearedTurnId=" + clearedTurnId
			+ ";eventEmitted=" + boolText(eventEmitted)
			+ ";goalPresent=" + boolText(goalPresent)
			+ ";remainingTokens=" + (hasRemainingTokens ? Std.string(remainingTokens) : "null")
			+ ";completionBudgetReport=" + boolText(hasCompletionBudgetReport)
			+ ";functionCallErrorKind=" + functionCallErrorKind
			+ ";sequence=" + sequence;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
