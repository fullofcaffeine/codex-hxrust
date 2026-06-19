package codexhx.tools.process;

import codexhx.protocol.JsonScalar;

class ProcessExecOutcome {
	public static inline final schema = "codex-hxrust.process-exec.v1";

	public final ok:Bool;
	public final executed:Bool;
	public final command:String;
	public final args:Array<String>;
	public final exitCode:Int;
	public final exitStatus:String;
	public final errorCode:String;
	public final errorMessage:String;
	public final stdout:ProcessOutputSlice;
	public final stderr:ProcessOutputSlice;

	public function new(ok:Bool, executed:Bool, command:String, args:Array<String>, exitCode:Int, exitStatus:String, errorCode:String, errorMessage:String,
			stdout:ProcessOutputSlice, stderr:ProcessOutputSlice) {
		this.ok = ok;
		this.executed = executed;
		this.command = command;
		this.args = args;
		this.exitCode = exitCode;
		this.exitStatus = exitStatus;
		this.errorCode = errorCode;
		this.errorMessage = errorMessage;
		this.stdout = stdout;
		this.stderr = stderr;
	}

	public static function denied(command:String, args:Array<String>):ProcessExecOutcome {
		return new ProcessExecOutcome(false, false, command, args, -1, "not_executed", "command_denied", "process execution requires an exact approval",
			emptyOutput(), emptyOutput());
	}

	public static function invalid(command:String, args:Array<String>, errorCode:String, errorMessage:String):ProcessExecOutcome {
		return new ProcessExecOutcome(false, false, command, args, -1, "not_executed", errorCode, errorMessage, emptyOutput(), emptyOutput());
	}

	public static function spawned(command:String, args:Array<String>, exitCode:Int, stdout:ProcessOutputSlice, stderr:ProcessOutputSlice):ProcessExecOutcome {
		if (exitCode == 0) {
			return new ProcessExecOutcome(true, true, command, args, exitCode, "success", "", "", stdout, stderr);
		}
		return new ProcessExecOutcome(false, true, command, args, exitCode, "nonzero", "process_exit_nonzero", "process exited with non-zero status", stdout,
			stderr);
	}

	public static function spawnFailed(command:String, args:Array<String>, message:String):ProcessExecOutcome {
		return new ProcessExecOutcome(false, false, command, args, -1, "spawn_failed", "process_spawn_failed", message, emptyOutput(), emptyOutput());
	}

	public function json():String {
		var out = "{";
		out += "\"schema\":" + quote(schema);
		out += ",\"ok\":" + bool(ok);
		out += ",\"executed\":" + bool(executed);
		out += ",\"command\":" + quote(command);
		out += ",\"args\":" + stringArray(args);
		out += ",\"exitCode\":" + Std.string(exitCode);
		out += ",\"exitStatus\":" + quote(exitStatus);
		out += ",\"errorCode\":" + quote(errorCode);
		out += ",\"errorMessage\":" + quote(errorMessage);
		out += ",\"stdout\":" + stdout.json();
		out += ",\"stderr\":" + stderr.json();
		out += "}";
		return out;
	}

	static function emptyOutput():ProcessOutputSlice {
		return new ProcessOutputSlice("", 0, false);
	}

	static function stringArray(values:Array<String>):String {
		var out = "[";
		for (i in 0...values.length) {
			if (i > 0)
				out += ",";
			out += quote(values[i]);
		}
		return out + "]";
	}

	static function quote(value:String):String {
		return JsonScalar.quote(value);
	}

	static function bool(value:Bool):String {
		if (value)
			return "true";
		return "false";
	}
}
