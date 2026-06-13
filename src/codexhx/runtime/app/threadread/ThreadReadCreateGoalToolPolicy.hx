package codexhx.runtime.app.threadread;

import codexhx.protocol.goals.ThreadGoalStatus;
import codexhx.protocol.json.CodexJson;
import haxe.json.Value;

class ThreadReadCreateGoalToolPolicy {
	static inline final maxObjectiveChars = 4000;

	public static function buildCases(requests:Array<ThreadReadCreateGoalToolRequest>):ThreadReadCreateGoalToolReport {
		final outcomes:Array<ThreadReadCreateGoalToolOutcome> = [];
		for (request in requests) outcomes.push(build(request));
		return new ThreadReadCreateGoalToolReport(outcomes);
	}

	public static function build(request:ThreadReadCreateGoalToolRequest):ThreadReadCreateGoalToolOutcome {
		final args = parseArguments(request.argumentsJson);
		if (!args.ok) {
			return ThreadReadCreateGoalToolOutcome.rejected(
				request,
				"invalid_tool_arguments",
				args.errorMessage,
				"",
				false,
				0,
				"handle_create->parse_arguments:error->RespondToModel"
			);
		}
		final objective = StringTools.trim(args.objective);
		final objectiveError = validateObjective(objective);
		if (objectiveError.length > 0) {
			return ThreadReadCreateGoalToolOutcome.rejected(
				request,
				"invalid_goal_objective",
				objectiveError,
				objective,
				args.hasTokenBudget,
				args.tokenBudget,
				"handle_create->trim_objective->validate_thread_goal_objective:error->RespondToModel"
			);
		}
		if (args.hasTokenBudget && args.tokenBudget <= 0) {
			return ThreadReadCreateGoalToolOutcome.rejected(
				request,
				"invalid_goal_budget",
				"goal budgets must be positive when provided",
				objective,
				args.hasTokenBudget,
				args.tokenBudget,
				"handle_create->validate_goal_budget:error->RespondToModel"
			);
		}
		if (request.insertOutcomeKind == ThreadReadCreateGoalToolInsertOutcomeKind.Error) {
			return ThreadReadCreateGoalToolOutcome.insertError(request, objective, args.hasTokenBudget, args.tokenBudget);
		}
		if (request.insertOutcomeKind == ThreadReadCreateGoalToolInsertOutcomeKind.UnfinishedGoal) {
			return ThreadReadCreateGoalToolOutcome.unfinishedGoal(request, objective, args.hasTokenBudget, args.tokenBudget);
		}
		final goal = request.insertedGoal.withObjective(objective, ThreadGoalStatus.Active, request.insertedGoal.updatedAt);
		final response = ThreadReadCreateGoalToolResponse.fromGoal(goal);
		return ThreadReadCreateGoalToolOutcome.success(request, objective, args.hasTokenBudget, args.tokenBudget, response);
	}

	static function parseArguments(argumentsJson:String):ThreadReadCreateGoalToolArgsRead {
		final parsed = try {
			CodexJson.parse(argumentsJson);
		} catch (e:Dynamic) {
			return ThreadReadCreateGoalToolArgsRead.failure("goal tool arguments are not valid JSON");
		}
		if (!parsed.ok) return ThreadReadCreateGoalToolArgsRead.failure("goal tool arguments are not valid JSON");
		return switch parsed.value {
			case JObject(keys, values):
				final objective = stringField(keys, values, "objective");
				if (!objective.ok) return ThreadReadCreateGoalToolArgsRead.failure("missing objective");
				final budget = optionalIntField(keys, values, "token_budget");
				if (!budget.ok) return ThreadReadCreateGoalToolArgsRead.failure("invalid token_budget");
				ThreadReadCreateGoalToolArgsRead.success(objective.value, budget.present, budget.value);
			case _:
				ThreadReadCreateGoalToolArgsRead.failure("goal tool arguments must be a JSON object");
		}
	}

	static function validateObjective(value:String):String {
		if (value.length == 0) return "goal objective must not be empty";
		if (value.length > maxObjectiveChars) return "goal objective must be at most 4000 characters";
		return "";
	}

	static function stringField(keys:Array<String>, values:Array<Value>, name:String):ThreadReadCreateGoalToolStringRead {
		final index = fieldIndex(keys, name);
		if (index < 0) return ThreadReadCreateGoalToolStringRead.failure();
		return switch values[index] {
			case JString(value): ThreadReadCreateGoalToolStringRead.success(value);
			case _: ThreadReadCreateGoalToolStringRead.failure();
		}
	}

	static function optionalIntField(keys:Array<String>, values:Array<Value>, name:String):ThreadReadCreateGoalToolOptionalIntRead {
		final index = fieldIndex(keys, name);
		if (index < 0) return ThreadReadCreateGoalToolOptionalIntRead.absent();
		return switch values[index] {
			case JNull: ThreadReadCreateGoalToolOptionalIntRead.absent();
			case JNumber(value): ThreadReadCreateGoalToolOptionalIntRead.some(Std.int(value));
			case _: ThreadReadCreateGoalToolOptionalIntRead.failure();
		}
	}

	static function fieldIndex(keys:Array<String>, name:String):Int {
		var i = 0;
		while (i < keys.length) {
			if (keys[i] == name) return i;
			i = i + 1;
		}
		return -1;
	}
}

class ThreadReadCreateGoalToolArgsRead {
	public final ok:Bool;
	public final objective:String;
	public final hasTokenBudget:Bool;
	public final tokenBudget:Int;
	public final errorMessage:String;

	function new(ok:Bool, objective:String, hasTokenBudget:Bool, tokenBudget:Int, errorMessage:String) {
		this.ok = ok;
		this.objective = objective;
		this.hasTokenBudget = hasTokenBudget;
		this.tokenBudget = tokenBudget;
		this.errorMessage = errorMessage;
	}

	public static function success(objective:String, hasTokenBudget:Bool, tokenBudget:Int):ThreadReadCreateGoalToolArgsRead {
		return new ThreadReadCreateGoalToolArgsRead(true, objective, hasTokenBudget, tokenBudget, "");
	}

	public static function failure(errorMessage:String):ThreadReadCreateGoalToolArgsRead {
		return new ThreadReadCreateGoalToolArgsRead(false, "", false, 0, errorMessage);
	}
}

class ThreadReadCreateGoalToolStringRead {
	public final ok:Bool;
	public final value:String;

	function new(ok:Bool, value:String) {
		this.ok = ok;
		this.value = value;
	}

	public static function success(value:String):ThreadReadCreateGoalToolStringRead {
		return new ThreadReadCreateGoalToolStringRead(true, value);
	}

	public static function failure():ThreadReadCreateGoalToolStringRead {
		return new ThreadReadCreateGoalToolStringRead(false, "");
	}
}

class ThreadReadCreateGoalToolOptionalIntRead {
	public final ok:Bool;
	public final present:Bool;
	public final value:Int;

	function new(ok:Bool, present:Bool, value:Int) {
		this.ok = ok;
		this.present = present;
		this.value = value;
	}

	public static function some(value:Int):ThreadReadCreateGoalToolOptionalIntRead {
		return new ThreadReadCreateGoalToolOptionalIntRead(true, true, value);
	}

	public static function absent():ThreadReadCreateGoalToolOptionalIntRead {
		return new ThreadReadCreateGoalToolOptionalIntRead(true, false, 0);
	}

	public static function failure():ThreadReadCreateGoalToolOptionalIntRead {
		return new ThreadReadCreateGoalToolOptionalIntRead(false, false, 0);
	}
}
