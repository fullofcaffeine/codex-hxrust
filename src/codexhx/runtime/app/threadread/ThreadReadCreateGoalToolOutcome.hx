package codexhx.runtime.app.threadread;

class ThreadReadCreateGoalToolOutcome {
	public final ok:Bool;
	public final code:String;
	public final threadId:String;
	public final turnId:String;
	public final argumentsAccepted:Bool;
	public final objectiveTrimmed:String;
	public final hasTokenBudget:Bool;
	public final tokenBudget:Int;
	public final insertAttempted:Bool;
	public final insertOutcomeKind:ThreadReadCreateGoalToolInsertOutcomeKind;
	public final previewAttempted:Bool;
	public final previewOutcomeKind:ThreadReadCreateGoalToolPreviewOutcomeKind;
	public final previewWarningLogged:Bool;
	public final accountingMarked:Bool;
	public final metricsRecorded:Bool;
	public final analyticsCreated:Bool;
	public final eventEmitted:Bool;
	public final functionCallErrorKind:String;
	public final errorMessage:String;
	public final response:ThreadReadCreateGoalToolResponse;
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
		argumentsAccepted:Bool,
		objectiveTrimmed:String,
		hasTokenBudget:Bool,
		tokenBudget:Int,
		insertAttempted:Bool,
		insertOutcomeKind:ThreadReadCreateGoalToolInsertOutcomeKind,
		previewAttempted:Bool,
		previewOutcomeKind:ThreadReadCreateGoalToolPreviewOutcomeKind,
		previewWarningLogged:Bool,
		accountingMarked:Bool,
		metricsRecorded:Bool,
		analyticsCreated:Bool,
		eventEmitted:Bool,
		functionCallErrorKind:String,
		errorMessage:String,
		response:ThreadReadCreateGoalToolResponse,
		sequence:String,
		message:String
	) {
		this.ok = ok;
		this.code = code;
		this.threadId = threadId;
		this.turnId = turnId;
		this.argumentsAccepted = argumentsAccepted;
		this.objectiveTrimmed = objectiveTrimmed;
		this.hasTokenBudget = hasTokenBudget;
		this.tokenBudget = tokenBudget;
		this.insertAttempted = insertAttempted;
		this.insertOutcomeKind = insertOutcomeKind;
		this.previewAttempted = previewAttempted;
		this.previewOutcomeKind = previewOutcomeKind;
		this.previewWarningLogged = previewWarningLogged;
		this.accountingMarked = accountingMarked;
		this.metricsRecorded = metricsRecorded;
		this.analyticsCreated = analyticsCreated;
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
		request:ThreadReadCreateGoalToolRequest,
		code:String,
		errorMessage:String,
		objectiveTrimmed:String,
		hasTokenBudget:Bool,
		tokenBudget:Int,
		sequence:String
	):ThreadReadCreateGoalToolOutcome {
		return new ThreadReadCreateGoalToolOutcome(
			false,
			code,
			request.threadId,
			request.turnId,
			code != "invalid_tool_arguments",
			objectiveTrimmed,
			hasTokenBudget,
			tokenBudget,
			false,
			request.insertOutcomeKind,
			false,
			ThreadReadCreateGoalToolPreviewOutcomeKind.NotAttempted,
			false,
			false,
			false,
			false,
			false,
			"respond_to_model",
			errorMessage,
			null,
			sequence,
			"create_goal rejected the invocation before inserting a goal"
		);
	}

	public static function insertError(
		request:ThreadReadCreateGoalToolRequest,
		objectiveTrimmed:String,
		hasTokenBudget:Bool,
		tokenBudget:Int
	):ThreadReadCreateGoalToolOutcome {
		return new ThreadReadCreateGoalToolOutcome(
			false,
			"goal_create_state_error",
			request.threadId,
			request.turnId,
			true,
			objectiveTrimmed,
			hasTokenBudget,
			tokenBudget,
			true,
			ThreadReadCreateGoalToolInsertOutcomeKind.Error,
			false,
			ThreadReadCreateGoalToolPreviewOutcomeKind.NotAttempted,
			false,
			false,
			false,
			false,
			false,
			"respond_to_model",
			"failed to create goal: " + request.insertErrorMessage,
			null,
			"handle_create->insert_thread_goal:error->RespondToModel",
			"create_goal converted the insert failure into a model-visible tool error"
		);
	}

	public static function unfinishedGoal(
		request:ThreadReadCreateGoalToolRequest,
		objectiveTrimmed:String,
		hasTokenBudget:Bool,
		tokenBudget:Int
	):ThreadReadCreateGoalToolOutcome {
		return new ThreadReadCreateGoalToolOutcome(
			false,
			"unfinished_goal_exists",
			request.threadId,
			request.turnId,
			true,
			objectiveTrimmed,
			hasTokenBudget,
			tokenBudget,
			true,
			ThreadReadCreateGoalToolInsertOutcomeKind.UnfinishedGoal,
			false,
			ThreadReadCreateGoalToolPreviewOutcomeKind.NotAttempted,
			false,
			false,
			false,
			false,
			false,
			"respond_to_model",
			"cannot create a new goal because this thread has an unfinished goal; complete the existing goal first",
			null,
			"handle_create->insert_thread_goal:none->RespondToModel",
			"create_goal rejected because the thread already has an unfinished goal"
		);
	}

	public static function success(
		request:ThreadReadCreateGoalToolRequest,
		objectiveTrimmed:String,
		hasTokenBudget:Bool,
		tokenBudget:Int,
		response:ThreadReadCreateGoalToolResponse
	):ThreadReadCreateGoalToolOutcome {
		final previewWarning = request.previewOutcomeKind == ThreadReadCreateGoalToolPreviewOutcomeKind.Error;
		return new ThreadReadCreateGoalToolOutcome(
			true,
			previewWarning ? "goal_created_preview_warning" : "goal_created",
			request.threadId,
			request.turnId,
			true,
			objectiveTrimmed,
			hasTokenBudget,
			tokenBudget,
			true,
			ThreadReadCreateGoalToolInsertOutcomeKind.Inserted,
			true,
			request.previewOutcomeKind,
			previewWarning,
			true,
			true,
			true,
			true,
			"",
			previewWarning ? "failed to set empty thread preview from goal objective for " + request.threadId + ": " + request.previewErrorMessage : "",
			response,
			"handle_create->insert_thread_goal:inserted->fill_empty_thread_preview_if_possible:" + request.previewOutcomeKind + "->mark_current_turn_goal_active->metrics.record_created->analytics.created->emit_goal_updated_from_tool_call->goal_response:omit_completion_budget_report",
			"create_goal inserted an active goal and returned a structured response"
		);
	}

	public function summary():String {
		return "code=" + code
			+ ";thread=" + threadId
			+ ";turn=" + turnId
			+ ";argumentsAccepted=" + boolText(argumentsAccepted)
			+ ";objective=" + objectiveTrimmed
			+ ";tokenBudget=" + (hasTokenBudget ? Std.string(tokenBudget) : "null")
			+ ";insertAttempted=" + boolText(insertAttempted)
			+ ";insertOutcome=" + insertOutcomeKind
			+ ";previewAttempted=" + boolText(previewAttempted)
			+ ";previewOutcome=" + previewOutcomeKind
			+ ";previewWarning=" + boolText(previewWarningLogged)
			+ ";accountingMarked=" + boolText(accountingMarked)
			+ ";metricsRecorded=" + boolText(metricsRecorded)
			+ ";analyticsCreated=" + boolText(analyticsCreated)
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
