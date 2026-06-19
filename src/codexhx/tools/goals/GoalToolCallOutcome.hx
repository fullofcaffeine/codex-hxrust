package codexhx.tools.goals;

class GoalToolCallOutcome {
	public final ok:Bool;
	public final outputJson:String;
	public final errorCode:String;
	public final errorMessage:String;

	function new(ok:Bool, outputJson:String, errorCode:String, errorMessage:String) {
		this.ok = ok;
		this.outputJson = outputJson;
		this.errorCode = errorCode;
		this.errorMessage = errorMessage;
	}

	public static function success(outputJson:String):GoalToolCallOutcome {
		return new GoalToolCallOutcome(true, outputJson, "", "");
	}

	public static function failure(code:String, message:String):GoalToolCallOutcome {
		return new GoalToolCallOutcome(false, "", code, message);
	}
}
