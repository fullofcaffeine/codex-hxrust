package codexhx.runtime.app.threadread;

import codexhx.protocol.goals.ThreadGoalStatus;
import codexhx.protocol.json.CodexJson;
import haxe.json.Value;

class ThreadReadUpdateGoalToolPolicy {
	public static function buildCases(requests:Array<ThreadReadUpdateGoalToolRequest>):ThreadReadUpdateGoalToolReport {
		final outcomes:Array<ThreadReadUpdateGoalToolOutcome> = [];
		for (request in requests)
			outcomes.push(build(request));
		return new ThreadReadUpdateGoalToolReport(outcomes);
	}

	public static function build(request:ThreadReadUpdateGoalToolRequest):ThreadReadUpdateGoalToolOutcome {
		final args = parseArguments(request.argumentsJson);
		if (!args.ok) {
			return ThreadReadUpdateGoalToolOutcome.rejected(request, "invalid_tool_arguments", args.errorMessage, "",
				"handle_update->parse_arguments:error->RespondToModel");
		}
		if (args.status != ThreadGoalStatus.Complete && args.status != ThreadGoalStatus.Blocked) {
			return ThreadReadUpdateGoalToolOutcome.rejected(request, "unsupported_goal_status_update",
				"update_goal can only mark the existing goal complete or blocked; pause, resume, budget-limited, and usage-limited status changes are controlled by the user or system",
				args.status, "handle_update->status_validation:error->RespondToModel");
		}
		final accountingMode = args.status == ThreadGoalStatus.Complete ? "active_or_complete" : "active_or_stopped";
		if (request.accountingOutcomeKind == ThreadReadUpdateGoalToolAccountingOutcomeKind.Error) {
			return ThreadReadUpdateGoalToolOutcome.accountingError(request, args.status, accountingMode);
		}
		if (request.metricsReadOutcomeKind == ThreadReadUpdateGoalToolMetricsReadOutcomeKind.Error) {
			return ThreadReadUpdateGoalToolOutcome.metricsReadError(request, args.status, accountingMode);
		}
		if (request.updateOutcomeKind == ThreadReadUpdateGoalToolUpdateOutcomeKind.Error) {
			return ThreadReadUpdateGoalToolOutcome.updateError(request, args.status, accountingMode);
		}
		if (request.updateOutcomeKind == ThreadReadUpdateGoalToolUpdateOutcomeKind.Missing) {
			return ThreadReadUpdateGoalToolOutcome.noGoal(request, args.status, accountingMode);
		}
		final goal = request.updatedGoal.withStatus(args.status, request.updatedGoal.updatedAt);
		final response = ThreadReadUpdateGoalToolResponse.fromGoal(goal, args.status == ThreadGoalStatus.Complete);
		return ThreadReadUpdateGoalToolOutcome.success(request, args.status, accountingMode, response);
	}

	static function parseArguments(argumentsJson:String):ThreadReadUpdateGoalToolArgsRead {
		final parsed = try {
			CodexJson.parse(argumentsJson);
		} catch (e:Dynamic) {
			return ThreadReadUpdateGoalToolArgsRead.failure("goal tool arguments are not valid JSON");
		}
		if (!parsed.ok)
			return ThreadReadUpdateGoalToolArgsRead.failure("goal tool arguments are not valid JSON");
		return switch parsed.value {
			case JObject(keys, values):
				final status = stringField(keys, values, "status");
				if (!status.ok) ThreadReadUpdateGoalToolArgsRead.failure("missing status") else ThreadReadUpdateGoalToolArgsRead.success(status.value);
			case _:
				ThreadReadUpdateGoalToolArgsRead.failure("goal tool arguments must be a JSON object");
		}
	}

	static function stringField(keys:Array<String>, values:Array<Value>, name:String):ThreadReadUpdateGoalToolStringRead {
		final index = fieldIndex(keys, name);
		if (index < 0)
			return ThreadReadUpdateGoalToolStringRead.failure();
		return switch values[index] {
			case JString(value): ThreadReadUpdateGoalToolStringRead.success(value);
			case _: ThreadReadUpdateGoalToolStringRead.failure();
		}
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
}

class ThreadReadUpdateGoalToolArgsRead {
	public final ok:Bool;
	public final status:String;
	public final errorMessage:String;

	function new(ok:Bool, status:String, errorMessage:String) {
		this.ok = ok;
		this.status = status;
		this.errorMessage = errorMessage;
	}

	public static function success(status:String):ThreadReadUpdateGoalToolArgsRead {
		return new ThreadReadUpdateGoalToolArgsRead(true, status, "");
	}

	public static function failure(errorMessage:String):ThreadReadUpdateGoalToolArgsRead {
		return new ThreadReadUpdateGoalToolArgsRead(false, "", errorMessage);
	}
}

class ThreadReadUpdateGoalToolStringRead {
	public final ok:Bool;
	public final value:String;

	function new(ok:Bool, value:String) {
		this.ok = ok;
		this.value = value;
	}

	public static function success(value:String):ThreadReadUpdateGoalToolStringRead {
		return new ThreadReadUpdateGoalToolStringRead(true, value);
	}

	public static function failure():ThreadReadUpdateGoalToolStringRead {
		return new ThreadReadUpdateGoalToolStringRead(false, "");
	}
}
