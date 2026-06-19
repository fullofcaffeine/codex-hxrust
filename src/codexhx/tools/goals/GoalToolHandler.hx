package codexhx.tools.goals;

import codexhx.protocol.JsonScalar;
import codexhx.protocol.goals.ThreadGoal;
import codexhx.protocol.goals.ThreadGoalStatus;
import codexhx.protocol.json.CodexJson;
import codexhx.state.goals.GoalOperationOutcome;
import codexhx.state.goals.ThreadGoalStore;
import haxe.json.Value;

class GoalToolHandler {
	public static inline final getGoalToolName = "get_goal";
	public static inline final createGoalToolName = "create_goal";
	public static inline final updateGoalToolName = "update_goal";

	final store:ThreadGoalStore;
	var now:Int;

	public function new(store:ThreadGoalStore, now:Int) {
		this.store = store;
		this.now = now;
	}

	public function setNow(now:Int):Void {
		this.now = now;
	}

	public function handle(toolName:String, argumentsJson:String):GoalToolCallOutcome {
		final parsed = parseArguments(argumentsJson);
		if (!parsed.ok)
			return GoalToolCallOutcome.failure(parsed.errorCode, parsed.errorMessage);

		return switch toolName {
			case getGoalToolName:
				GoalToolCallOutcome.success(responseJson(store.get(), false));
			case createGoalToolName:
				handleCreate(parsed.value);
			case updateGoalToolName:
				handleUpdate(parsed.value);
			case _:
				GoalToolCallOutcome.failure("unsupported_goal_tool", "unsupported goal tool");
		}
	}

	function handleCreate(value:Value):GoalToolCallOutcome {
		final objective = readString(value, "objective");
		if (!objective.ok)
			return GoalToolCallOutcome.failure("missing_objective", "goal objective is required");
		final budget = readOptionalInt(value, "token_budget");
		if (!budget.ok)
			return GoalToolCallOutcome.failure("invalid_goal_budget", "goal budgets must be positive when provided");

		final outcome = store.createGoal(objective.value, budget.present, budget.value, now);
		if (!outcome.ok)
			return failureFromOutcome(outcome);
		return GoalToolCallOutcome.success(responseJson(outcome.goal, false));
	}

	function handleUpdate(value:Value):GoalToolCallOutcome {
		final status = readString(value, "status");
		if (!status.ok)
			return GoalToolCallOutcome.failure("missing_status", "goal status is required");
		if (status.value != ThreadGoalStatus.Complete && status.value != ThreadGoalStatus.Blocked) {
			return GoalToolCallOutcome.failure("unsupported_goal_status_update",
				"update_goal can only mark the existing goal complete or blocked; pause, resume, budget-limited, and usage-limited status changes are controlled by the user or system");
		}

		final outcome = store.setStatus(status.value, now);
		if (!outcome.ok)
			return failureFromOutcome(outcome);
		return GoalToolCallOutcome.success(responseJson(outcome.goal, status.value == ThreadGoalStatus.Complete));
	}

	static function responseJson(goal:ThreadGoal, includeCompletionBudgetReport:Bool):String {
		final goalJson = goal == null ? "null" : goal.toolJson();
		final remaining = goal == null ? "null" : remainingJson(goal);
		final report = completionBudgetReport(goal, includeCompletionBudgetReport);
		return "{" + "\"completionBudgetReport\":" + report + ",\"goal\":" + goalJson + ",\"remainingTokens\":" + remaining + "}";
	}

	static function remainingJson(goal:ThreadGoal):String {
		final remaining = goal.remainingTokens();
		if (!remaining.present)
			return "null";
		return Std.string(remaining.value);
	}

	static function completionBudgetReport(goal:ThreadGoal, include:Bool):String {
		if (!include || goal == null || goal.status != ThreadGoalStatus.Complete)
			return "null";
		if (!goal.hasTokenBudget && goal.timeUsedSeconds <= 0)
			return "null";
		return
			quote("Goal achieved. Report final usage from this tool result's structured goal fields. If `goal.tokenBudget` is present, include token usage from `goal.tokensUsed` and `goal.tokenBudget`. If `goal.timeUsedSeconds` is greater than 0, summarize elapsed time in a concise, human-friendly form appropriate to the response language.");
	}

	static function parseArguments(argumentsJson:String):ToolArgsRead {
		final text = StringTools.trim(argumentsJson);
		final source = text.length == 0 ? "{}" : text;
		final parsed = try {
			CodexJson.parse(source);
		} catch (e:Dynamic) {
			return ToolArgsRead.failure("invalid_tool_arguments", "goal tool arguments are not valid JSON");
		}
		if (!parsed.ok)
			return ToolArgsRead.failure("invalid_tool_arguments", "goal tool arguments are not valid JSON");
		return switch parsed.value {
			case JObject(_, _): ToolArgsRead.success(parsed.value);
			case _: ToolArgsRead.failure("invalid_tool_arguments", "goal tool arguments must be a JSON object");
		}
	}

	static function readString(value:Value, name:String):ToolStringRead {
		return switch value {
			case JObject(keys, values):
				final i = fieldIndex(keys, name);
				if (i < 0)
					return ToolStringRead.failure();
				switch values[i] {
					case JString(text): ToolStringRead.success(text);
					case _: ToolStringRead.failure();
				}
			case _:
				ToolStringRead.failure();
		}
	}

	static function readOptionalInt(value:Value, name:String):ToolOptionalIntRead {
		return switch value {
			case JObject(keys, values):
				final i = fieldIndex(keys, name);
				if (i < 0)
					return ToolOptionalIntRead.absent();
				switch values[i] {
					case JNull: ToolOptionalIntRead.absent();
					case JNumber(number):
						final asInt = Std.int(number);
						if (asInt <= 0) ToolOptionalIntRead.failure() else ToolOptionalIntRead.some(asInt);
					case _: ToolOptionalIntRead.failure();
				}
			case _:
				ToolOptionalIntRead.failure();
		}
	}

	static function failureFromOutcome(outcome:GoalOperationOutcome):GoalToolCallOutcome {
		return GoalToolCallOutcome.failure(outcome.errorCode, outcome.errorMessage);
	}

	static function fieldIndex(keys:Array<String>, name:String):Int {
		var i = 0;
		while (i < keys.length) {
			if (keys[i] == name)
				return i;
			i = i + 1;
		}
		return -1;
	}

	static function quote(value:String):String {
		return JsonScalar.quote(value);
	}
}

class ToolArgsRead {
	public final ok:Bool;
	public final value:Value;
	public final errorCode:String;
	public final errorMessage:String;

	function new(ok:Bool, value:Value, errorCode:String, errorMessage:String) {
		this.ok = ok;
		this.value = value;
		this.errorCode = errorCode;
		this.errorMessage = errorMessage;
	}

	public static function success(value:Value):ToolArgsRead {
		return new ToolArgsRead(true, value, "", "");
	}

	public static function failure(code:String, message:String):ToolArgsRead {
		return new ToolArgsRead(false, JNull, code, message);
	}
}

class ToolStringRead {
	public final ok:Bool;
	public final value:String;

	function new(ok:Bool, value:String) {
		this.ok = ok;
		this.value = value;
	}

	public static function success(value:String):ToolStringRead {
		return new ToolStringRead(true, value);
	}

	public static function failure():ToolStringRead {
		return new ToolStringRead(false, "");
	}
}

class ToolOptionalIntRead {
	public final ok:Bool;
	public final present:Bool;
	public final value:Int;

	function new(ok:Bool, present:Bool, value:Int) {
		this.ok = ok;
		this.present = present;
		this.value = value;
	}

	public static function some(value:Int):ToolOptionalIntRead {
		return new ToolOptionalIntRead(true, true, value);
	}

	public static function absent():ToolOptionalIntRead {
		return new ToolOptionalIntRead(true, false, 0);
	}

	public static function failure():ToolOptionalIntRead {
		return new ToolOptionalIntRead(false, false, 0);
	}
}
