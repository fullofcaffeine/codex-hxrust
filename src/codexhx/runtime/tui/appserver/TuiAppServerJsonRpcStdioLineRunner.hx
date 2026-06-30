package codexhx.runtime.tui.appserver;

import sys.io.Process;

/**
	Owns one stdio process exchange for app-server JSON-RPC line traffic.

	Why
	- The live TUI needs to prove generated Rust can cross the app-server process boundary before
	  the full long-lived transport/parser/session stack is ready.
	- This runner exercises the real `sys.io.Process` stdio path without credentials, sockets,
	  model calls, or persistence.

	What
	- Validates a typed process launch plan.
	- Spawns a child process, writes one outbound JSONL line, closes stdin, reads stdout/stderr,
	  waits for exit, and returns a structured report.

	How
	- Refuses cwd/env plans for now because this slice uses Haxe's current `sys.io.Process`
	  constructor, which does not expose those process attributes.
	- Keeps stdout as line-preserving strings at this boundary; downstream JSON-RPC parsing remains
	  owned by the typed transport/session layers.
**/
class TuiAppServerJsonRpcStdioLineRunner {
	public function new() {}

	public function run(plan:TuiAppServerJsonRpcProcessLaunchPlan, outboundLine:String):TuiAppServerJsonRpcStdioLineRunReport {
		final refusal = refusalCode(plan, outboundLine);
		if (refusal.length > 0)
			return TuiAppServerJsonRpcStdioLineRunReport.rejected(refusal);

		try {
			final process = new Process(plan.command, plan.args());
			process.stdin.writeString(outboundLine);
			process.stdin.close();
			final stdoutText = normalizeNewlines(process.stdout.readAll().toString());
			final stderrText = normalizeNewlines(process.stderr.readAll().toString());
			final exit = process.exitCode(true);
			process.close();
			final concreteExit:Int = switch (exit) {
				case null: -1;
				case value: value;
			}
			final inboundLines = linesFromStdout(stdoutText);
			if (concreteExit == 0)
				return TuiAppServerJsonRpcStdioLineRunReport.succeeded(concreteExit, stderrText, outboundLine, inboundLines);
			return TuiAppServerJsonRpcStdioLineRunReport.failed("exit_nonzero", concreteExit, stderrText, outboundLine, inboundLines);
		} catch (e:haxe.Exception) {
			return TuiAppServerJsonRpcStdioLineRunReport.failed("spawn_failed", -1, normalizeNewlines(e.message), outboundLine, []);
		}
	}

	static function refusalCode(plan:TuiAppServerJsonRpcProcessLaunchPlan, outboundLine:String):String {
		if (plan == null)
			return "missing_launch_plan";
		final validationCode = plan.validationCode();
		if (validationCode != "ready")
			return validationCode;
		if (plan.cwd.length > 0)
			return "stdio_cwd_unsupported";
		if (plan.envCount() > 0)
			return "stdio_env_unsupported";
		if (outboundLine == null || outboundLine.length == 0)
			return "missing_outbound_line";
		return "";
	}

	static function linesFromStdout(stdoutText:String):Array<String> {
		final out:Array<String> = [];
		final text = normalizeNewlines(stdoutText);
		if (text.length == 0)
			return out;
		var start = 0;
		var index = 0;
		while (index < text.length) {
			if (text.charAt(index) == "\n") {
				out.push(text.substr(start, index - start + 1));
				start = index + 1;
			}
			index = index + 1;
		}
		if (start < text.length)
			out.push(text.substr(start));
		return out;
	}

	static function normalizeNewlines(text:String):String {
		if (text == null)
			return "";
		return StringTools.replace(StringTools.replace(text, "\r\n", "\n"), "\r", "\n");
	}
}
