package codexhx.runtime.app.threadread;

class ThreadReadGoalToolSpec {
	public final toolName:String;
	public final strict:Bool;
	public final closedParameters:Bool;
	public final requiredFields:Array<String>;
	public final statusEnum:Array<String>;

	public function new(toolName:String, strict:Bool, closedParameters:Bool, requiredFields:Array<String>, statusEnum:Array<String>) {
		this.toolName = toolName;
		this.strict = strict;
		this.closedParameters = closedParameters;
		this.requiredFields = requiredFields;
		this.statusEnum = statusEnum;
	}

	public static function fromKind(kind:ThreadReadGoalToolKind):ThreadReadGoalToolSpec {
		return switch kind {
			case ThreadReadGoalToolKind.Get:
				new ThreadReadGoalToolSpec(ThreadReadGoalToolKind.Get, false, true, [], []);
			case ThreadReadGoalToolKind.Create:
				new ThreadReadGoalToolSpec(ThreadReadGoalToolKind.Create, false, true, ["objective"], []);
			case ThreadReadGoalToolKind.Update:
				new ThreadReadGoalToolSpec(ThreadReadGoalToolKind.Update, false, true, ["status"], ["complete", "blocked"]);
		}
	}

	public function requiredCsv():String {
		return requiredFields.join(",");
	}

	public function statusEnumCsv():String {
		return statusEnum.join(",");
	}

	public function summary():String {
		return "toolName=" + toolName + ";strict=" + boolText(strict) + ";closedParameters=" + boolText(closedParameters) + ";required=" + requiredCsv()
			+ ";statusEnum=" + statusEnumCsv();
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
