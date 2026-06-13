package codexhx.runtime.app.threadread;

class ThreadReadGoalToolDispatchOutcome {
	public static inline final sharedResponseShape = "goal,remainingTokens,completionBudgetReport";

	public final kind:ThreadReadGoalToolKind;
	public final toolName:String;
	public final spec:ThreadReadGoalToolSpec;
	public final specMatchesDispatch:Bool;
	public final responseShape:String;
	public final ok:Bool;
	public final code:String;
	public final threadId:String;
	public final turnId:String;
	public final callId:String;
	public final functionCallErrorKind:String;
	public final errorMessage:String;
	public final goalPresent:Bool;
	public final hasRemainingTokens:Bool;
	public final remainingTokens:Int;
	public final hasCompletionBudgetReport:Bool;
	public final eventEmitted:Bool;
	public final getOutcome:ThreadReadGetGoalToolOutcome;
	public final createOutcome:ThreadReadCreateGoalToolOutcome;
	public final updateOutcome:ThreadReadUpdateGoalToolOutcome;
	public final sequence:String;

	function new(
		kind:ThreadReadGoalToolKind,
		spec:ThreadReadGoalToolSpec,
		ok:Bool,
		code:String,
		threadId:String,
		turnId:String,
		callId:String,
		functionCallErrorKind:String,
		errorMessage:String,
		goalPresent:Bool,
		hasRemainingTokens:Bool,
		remainingTokens:Int,
		hasCompletionBudgetReport:Bool,
		eventEmitted:Bool,
		getOutcome:ThreadReadGetGoalToolOutcome,
		createOutcome:ThreadReadCreateGoalToolOutcome,
		updateOutcome:ThreadReadUpdateGoalToolOutcome,
		sequence:String
	) {
		this.kind = kind;
		this.toolName = kind;
		this.spec = spec;
		this.specMatchesDispatch = spec.toolName == this.toolName;
		this.responseShape = sharedResponseShape;
		this.ok = ok;
		this.code = code;
		this.threadId = threadId;
		this.turnId = turnId;
		this.callId = callId;
		this.functionCallErrorKind = functionCallErrorKind;
		this.errorMessage = errorMessage;
		this.goalPresent = goalPresent;
		this.hasRemainingTokens = hasRemainingTokens;
		this.remainingTokens = remainingTokens;
		this.hasCompletionBudgetReport = hasCompletionBudgetReport;
		this.eventEmitted = eventEmitted;
		this.getOutcome = getOutcome;
		this.createOutcome = createOutcome;
		this.updateOutcome = updateOutcome;
		this.sequence = sequence;
	}

	public static function fromGet(outcome:ThreadReadGetGoalToolOutcome):ThreadReadGoalToolDispatchOutcome {
		return new ThreadReadGoalToolDispatchOutcome(
			ThreadReadGoalToolKind.Get,
			ThreadReadGoalToolSpec.fromKind(ThreadReadGoalToolKind.Get),
			outcome.ok,
			outcome.code,
			outcome.threadId,
			"",
			"",
			outcome.functionCallErrorKind,
			outcome.errorMessage,
			outcome.goalPresent,
			outcome.hasRemainingTokens,
			outcome.remainingTokens,
			outcome.hasCompletionBudgetReport,
			outcome.eventsEmitted,
			outcome,
			null,
			null,
			"GoalToolExecutor::handle->GoalToolKind::Get->" + outcome.sequence
		);
	}

	public static function fromCreate(outcome:ThreadReadCreateGoalToolOutcome):ThreadReadGoalToolDispatchOutcome {
		return new ThreadReadGoalToolDispatchOutcome(
			ThreadReadGoalToolKind.Create,
			ThreadReadGoalToolSpec.fromKind(ThreadReadGoalToolKind.Create),
			outcome.ok,
			outcome.code,
			outcome.threadId,
			outcome.turnId,
			"",
			outcome.functionCallErrorKind,
			outcome.errorMessage,
			outcome.goalPresent,
			outcome.hasRemainingTokens,
			outcome.remainingTokens,
			outcome.hasCompletionBudgetReport,
			outcome.eventEmitted,
			null,
			outcome,
			null,
			"GoalToolExecutor::handle->GoalToolKind::Create->" + outcome.sequence
		);
	}

	public static function fromUpdate(outcome:ThreadReadUpdateGoalToolOutcome):ThreadReadGoalToolDispatchOutcome {
		return new ThreadReadGoalToolDispatchOutcome(
			ThreadReadGoalToolKind.Update,
			ThreadReadGoalToolSpec.fromKind(ThreadReadGoalToolKind.Update),
			outcome.ok,
			outcome.code,
			outcome.threadId,
			outcome.turnId,
			outcome.callId,
			outcome.functionCallErrorKind,
			outcome.errorMessage,
			outcome.goalPresent,
			outcome.hasRemainingTokens,
			outcome.remainingTokens,
			outcome.hasCompletionBudgetReport,
			outcome.eventEmitted,
			null,
			null,
			outcome,
			"GoalToolExecutor::handle->GoalToolKind::Update->" + outcome.sequence
		);
	}

	public static function malformedRequest(kind:ThreadReadGoalToolKind):ThreadReadGoalToolDispatchOutcome {
		final spec = ThreadReadGoalToolSpec.fromKind(kind);
		return new ThreadReadGoalToolDispatchOutcome(
			kind,
			spec,
			false,
			"goal_tool_dispatch_request_error",
			"",
			"",
			"",
			"respond_to_model",
			"dispatch request did not carry the payload for " + kind,
			false,
			false,
			0,
			false,
			false,
			null,
			null,
			null,
			"GoalToolExecutor::handle->" + kind + "->missing_typed_request"
		);
	}

	public function delegateSummary():String {
		if (getOutcome != null) return getOutcome.summary();
		if (createOutcome != null) return createOutcome.summary();
		if (updateOutcome != null) return updateOutcome.summary();
		return "";
	}

	public function summary():String {
		return "toolName=" + toolName
			+ ";specMatchesDispatch=" + boolText(specMatchesDispatch)
			+ ";spec={" + spec.summary() + "}"
			+ ";responseShape=" + responseShape
			+ ";code=" + code
			+ ";ok=" + boolText(ok)
			+ ";thread=" + threadId
			+ ";turn=" + turnId
			+ ";call=" + callId
			+ ";goalPresent=" + boolText(goalPresent)
			+ ";remainingTokens=" + (hasRemainingTokens ? Std.string(remainingTokens) : "null")
			+ ";completionBudgetReport=" + boolText(hasCompletionBudgetReport)
			+ ";eventEmitted=" + boolText(eventEmitted)
			+ ";functionCallErrorKind=" + functionCallErrorKind
			+ ";sequence=" + sequence
			+ ";delegate={" + delegateSummary() + "}";
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
