package codexhx.runtime.app.threadread;

class ThreadReadGoalSteeringItem {
	public final source:String;
	public final fragmentKind:String;
	public final kind:ThreadReadGoalSteeringItemKind;
	public final prompt:String;

	public function new(source:String, fragmentKind:String, kind:ThreadReadGoalSteeringItemKind, prompt:String) {
		this.source = source;
		this.fragmentKind = fragmentKind;
		this.kind = kind;
		this.prompt = prompt;
	}

	public function summary():String {
		return "source=" + source + ";fragmentKind=" + fragmentKind + ";kind=" + kind + ";promptChars=" + Std.string(prompt.length) + ";promptHead="
			+ promptHead();
	}

	function promptHead():String {
		final max = prompt.length < 80 ? prompt.length : 80;
		return StringTools.replace(prompt.substr(0, max), "\n", "\\n");
	}
}
