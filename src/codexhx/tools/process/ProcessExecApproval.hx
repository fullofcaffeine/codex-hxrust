package codexhx.tools.process;

class ProcessExecApproval {
	public final command:String;
	public final args:Array<String>;

	public function new(command:String, args:Array<String>) {
		this.command = command;
		this.args = args;
	}

	public function matches(command:String, args:Array<String>):Bool {
		if (this.command != command)
			return false;
		if (this.args.length != args.length)
			return false;
		for (i in 0...args.length) {
			if (this.args[i] != args[i])
				return false;
		}
		return true;
	}
}
