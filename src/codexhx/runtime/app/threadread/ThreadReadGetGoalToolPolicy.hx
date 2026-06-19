package codexhx.runtime.app.threadread;

import codexhx.protocol.json.CodexJson;

class ThreadReadGetGoalToolPolicy {
	public static function buildCases(requests:Array<ThreadReadGetGoalToolRequest>):ThreadReadGetGoalToolReport {
		final outcomes:Array<ThreadReadGetGoalToolOutcome> = [];
		for (request in requests)
			outcomes.push(build(request));
		return new ThreadReadGetGoalToolReport(outcomes);
	}

	public static function build(request:ThreadReadGetGoalToolRequest):ThreadReadGetGoalToolOutcome {
		final arguments = parseArguments(request.argumentsJson);
		if (!arguments.ok)
			return ThreadReadGetGoalToolOutcome.invalidArguments(request, arguments.errorMessage);
		if (request.dbOutcomeKind == ThreadReadGetGoalToolDbOutcomeKind.Error)
			return ThreadReadGetGoalToolOutcome.readError(request);
		final goal = request.dbOutcomeKind == ThreadReadGetGoalToolDbOutcomeKind.Found ? request.goal : null;
		return ThreadReadGetGoalToolOutcome.success(request, ThreadReadGetGoalToolResponse.fromGoal(goal));
	}

	static function parseArguments(argumentsJson:String):ThreadReadGetGoalToolArgsRead {
		final text = StringTools.trim(argumentsJson);
		final source = text.length == 0 ? "{}" : text;
		final parsed = try {
			CodexJson.parse(source);
		} catch (e:Dynamic) {
			return ThreadReadGetGoalToolArgsRead.failure("goal tool arguments are not valid JSON");
		}
		if (!parsed.ok)
			return ThreadReadGetGoalToolArgsRead.failure("goal tool arguments are not valid JSON");
		return switch parsed.value {
			case JObject(_, _): ThreadReadGetGoalToolArgsRead.success();
			case _: ThreadReadGetGoalToolArgsRead.failure("goal tool arguments must be a JSON object");
		}
	}
}

class ThreadReadGetGoalToolArgsRead {
	public final ok:Bool;
	public final errorMessage:String;

	function new(ok:Bool, errorMessage:String) {
		this.ok = ok;
		this.errorMessage = errorMessage;
	}

	public static function success():ThreadReadGetGoalToolArgsRead {
		return new ThreadReadGetGoalToolArgsRead(true, "");
	}

	public static function failure(errorMessage:String):ThreadReadGetGoalToolArgsRead {
		return new ThreadReadGetGoalToolArgsRead(false, errorMessage);
	}
}
