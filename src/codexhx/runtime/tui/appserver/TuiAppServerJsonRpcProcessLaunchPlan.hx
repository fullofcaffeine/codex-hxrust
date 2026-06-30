package codexhx.runtime.tui.appserver;

/**
	Typed command plan for a stdio app-server JSON-RPC line transport.
**/
class TuiAppServerJsonRpcProcessLaunchPlan {
	public final command:String;
	public final cwd:String;

	final argsValue:Array<String>;
	final envValue:Array<TuiAppServerJsonRpcProcessEnvVar>;

	public function new(command:String, args:Array<String>, cwd:String, env:Array<TuiAppServerJsonRpcProcessEnvVar>) {
		this.command = normalize(command);
		this.argsValue = copyStrings(args);
		this.cwd = normalize(cwd);
		this.envValue = copyEnv(env);
	}

	public static function stdio(command:String, args:Array<String>, cwd:String,
			env:Array<TuiAppServerJsonRpcProcessEnvVar>):TuiAppServerJsonRpcProcessLaunchPlan {
		return new TuiAppServerJsonRpcProcessLaunchPlan(command, args, cwd, env);
	}

	public function isValid():Bool {
		return validationCode() == "ready";
	}

	public function validationCode():String {
		if (command.length == 0)
			return "missing_command";
		for (env in envValue) {
			if (env == null || !env.isValid())
				return "invalid_env";
		}
		return "ready";
	}

	public function argCount():Int {
		return argsValue.length;
	}

	public function argAt(index:Int):String {
		if (index < 0 || index >= argsValue.length)
			return "";
		return argsValue[index];
	}

	public function args():Array<String> {
		return argsValue.copy();
	}

	public function envCount():Int {
		return envValue.length;
	}

	public function envAt(index:Int):Null<TuiAppServerJsonRpcProcessEnvVar> {
		if (index < 0 || index >= envValue.length)
			return null;
		return envValue[index];
	}

	public function env():Array<TuiAppServerJsonRpcProcessEnvVar> {
		return envValue.copy();
	}

	static function copyStrings(values:Array<String>):Array<String> {
		final out:Array<String> = [];
		if (values == null)
			return out;
		for (value in values)
			out.push(normalize(value));
		return out;
	}

	static function copyEnv(values:Array<TuiAppServerJsonRpcProcessEnvVar>):Array<TuiAppServerJsonRpcProcessEnvVar> {
		final out:Array<TuiAppServerJsonRpcProcessEnvVar> = [];
		if (values == null)
			return out;
		for (value in values)
			out.push(value);
		return out;
	}

	static function normalize(value:String):String {
		return value == null ? "" : value;
	}
}
