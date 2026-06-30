package codexhx.runtime.tui.live;

import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineEndpoint;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcProcessEnvVar;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcProcessLaunchPlan;

/**
	Typed configuration for the generated live shell demo entrypoint.

	Command-line strings are kept at this boundary and converted into a transport
	mode before the runner request is built.
**/
class TuiLiveShellDemoConfig {
	public final ok:Bool;
	public final code:String;
	public final transportMode:TuiLiveShellDemoTransportMode;
	public final rejectionCode:String;
	public final scriptedPrompt:String;

	final scriptedPromptsValue:Array<String>;

	public function new(ok:Bool, code:String, transportMode:TuiLiveShellDemoTransportMode, rejectionCode:String, scriptedPrompts:Array<String>) {
		this.ok = ok;
		this.code = normalize(code);
		this.transportMode = transportMode;
		this.rejectionCode = normalize(rejectionCode);
		this.scriptedPromptsValue = copyPrompts(scriptedPrompts);
		this.scriptedPrompt = scriptedPromptsValue.length == 0 ? "" : scriptedPromptsValue[0];
	}

	public static function fake():TuiLiveShellDemoConfig {
		return fakeWithPrompt("");
	}

	public static function fakeWithPrompt(scriptedPrompt:String):TuiLiveShellDemoConfig {
		return new TuiLiveShellDemoConfig(true, "fake", TuiLiveShellDemoTransportMode.Fake, "", promptArray(scriptedPrompt));
	}

	public static function parse(args:Array<String>):TuiLiveShellDemoConfig {
		final parser = new TuiLiveShellDemoConfigParser(args);
		return parser.parse();
	}

	public function apply(request:TuiLiveShellRunRequest):TuiLiveShellRunRequest {
		if (request == null)
			return request;
		if (!ok)
			return request;
		switch transportMode {
			case Fake:
				return request;
			case LineStdio(plan):
				return request.withLineConnectedPromptTransport(TuiAppServerJsonRpcLineEndpoint.Stdio(plan), rejectionCode);
			case ProcessStdio(plan):
				return request.withProcessBackedLineConnectedPromptTransport(TuiAppServerJsonRpcLineEndpoint.Stdio(plan), rejectionCode);
			case PersistentStdio(plan):
				return request.withPersistentStdioLineConnectedPromptTransport(TuiAppServerJsonRpcLineEndpoint.Stdio(plan), 10);
		}
	}

	public function transportCode():String {
		return switch transportMode {
			case Fake: "fake";
			case LineStdio(_): "line_stdio";
			case ProcessStdio(_): "process_stdio";
			case PersistentStdio(_): "persistent_stdio";
		}
	}

	public function hasScriptedPrompt():Bool {
		return scriptedPrompt.length > 0;
	}

	public function scriptedPromptCount():Int {
		return scriptedPromptsValue.length;
	}

	public function scriptedPromptAt(index:Int):String {
		if (index < 0 || index >= scriptedPromptsValue.length)
			return "";
		return scriptedPromptsValue[index];
	}

	public function scriptedPrompts():Array<String> {
		return scriptedPromptsValue.copy();
	}

	static function normalize(value:String):String {
		return value == null ? "" : value;
	}

	static function copyPrompts(values:Array<String>):Array<String> {
		final out:Array<String> = [];
		if (values == null)
			return out;
		for (value in values) {
			final prompt = normalize(value);
			if (prompt.length > 0)
				out.push(prompt);
		}
		return out;
	}

	static function promptArray(prompt:String):Array<String> {
		final normalized = normalize(prompt);
		return normalized.length == 0 ? [] : [normalized];
	}
}

/**
	Small CLI parser for demo-only transport options.
**/
class TuiLiveShellDemoConfigParser {
	final args:Array<String>;
	var transport:String;
	var command:String;
	var cwd:String;
	var stdioArgs:Array<String>;
	var env:Array<TuiAppServerJsonRpcProcessEnvVar>;
	var rejectionCode:String;
	var scriptedPrompts:Array<String>;

	public function new(args:Array<String>) {
		this.args = args == null ? [] : args.copy();
		this.transport = "fake";
		this.command = "codex";
		this.cwd = "";
		this.stdioArgs = [];
		this.env = [];
		this.rejectionCode = "";
		this.scriptedPrompts = [];
	}

	public function parse():TuiLiveShellDemoConfig {
		var index = 0;
		while (index < args.length) {
			final arg = args[index];
			if (arg == "--line-stdio") {
				transport = "line_stdio";
			} else if (arg == "--process-stdio") {
				transport = "process_stdio";
			} else if (arg == "--persistent-stdio") {
				transport = "persistent_stdio";
			} else if (arg == "--fake") {
				transport = "fake";
			} else if (startsWith(arg, "--transport=")) {
				final value = afterPrefix(arg, "--transport=");
				if (value == "fake") {
					transport = "fake";
				} else if (value == "line-stdio" || value == "line_stdio") {
					transport = "line_stdio";
				} else if (value == "process-stdio" || value == "process_stdio") {
					transport = "process_stdio";
				} else if (value == "persistent-stdio" || value == "persistent_stdio") {
					transport = "persistent_stdio";
				} else {
					return invalid("invalid_transport");
				}
			} else if (startsWith(arg, "--line-command=")) {
				command = afterPrefix(arg, "--line-command=");
			} else if (startsWith(arg, "--line-cwd=")) {
				cwd = afterPrefix(arg, "--line-cwd=");
			} else if (startsWith(arg, "--line-arg=")) {
				stdioArgs.push(afterPrefix(arg, "--line-arg="));
			} else if (startsWith(arg, "--line-env=")) {
				final parsedEnv = parseEnv(afterPrefix(arg, "--line-env="));
				if (parsedEnv == null)
					return invalid("invalid_line_env");
				env.push(parsedEnv);
			} else if (startsWith(arg, "--line-rejection-code=")) {
				rejectionCode = afterPrefix(arg, "--line-rejection-code=");
			} else if (startsWith(arg, "--scripted-prompt=")) {
				scriptedPrompts.push(afterPrefix(arg, "--scripted-prompt="));
			} else {
				return invalid("unknown_argument");
			}
			index++;
		}
		if (transport == "fake")
			return new TuiLiveShellDemoConfig(true, "fake", TuiLiveShellDemoTransportMode.Fake, "", scriptedPrompts);
		if (stdioArgs.length == 0) {
			stdioArgs.push("app-server");
			stdioArgs.push("--json-rpc");
		}
		final plan = TuiAppServerJsonRpcProcessLaunchPlan.stdio(command, stdioArgs, cwd, env);
		if (!plan.isValid())
			return invalid(plan.validationCode());
		if (transport == "process_stdio")
			return new TuiLiveShellDemoConfig(true, "process_stdio", TuiLiveShellDemoTransportMode.ProcessStdio(plan), rejectionCode, scriptedPrompts);
		if (transport == "persistent_stdio")
			return new TuiLiveShellDemoConfig(true, "persistent_stdio", TuiLiveShellDemoTransportMode.PersistentStdio(plan), rejectionCode, scriptedPrompts);
		return new TuiLiveShellDemoConfig(true, "line_stdio", TuiLiveShellDemoTransportMode.LineStdio(plan), rejectionCode, scriptedPrompts);
	}

	function invalid(code:String):TuiLiveShellDemoConfig {
		return new TuiLiveShellDemoConfig(false, code, TuiLiveShellDemoTransportMode.Fake, "", []);
	}

	static function parseEnv(value:String):Null<TuiAppServerJsonRpcProcessEnvVar> {
		final normalized = value == null ? "" : value;
		final splitAt = normalized.indexOf("=");
		if (splitAt <= 0)
			return null;
		return new TuiAppServerJsonRpcProcessEnvVar(normalized.substr(0, splitAt), normalized.substr(splitAt + 1));
	}

	static function startsWith(value:String, prefix:String):Bool {
		if (value == null || prefix == null)
			return false;
		return value.substr(0, prefix.length) == prefix;
	}

	static function afterPrefix(value:String, prefix:String):String {
		return value.substr(prefix.length);
	}
}
