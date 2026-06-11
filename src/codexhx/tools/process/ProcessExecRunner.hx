package codexhx.tools.process;

import sys.io.Process;

class ProcessExecRunner {
    public static function run(command:String, args:Array<String>, policy:ProcessExecPolicy):ProcessExecOutcome {
        if (StringTools.trim(command) == "") {
            return ProcessExecOutcome.invalid(command, args, "invalid_command", "process command must not be empty");
        }
        if (policy == null || !policy.isApproved(command, args)) {
            return ProcessExecOutcome.denied(command, args);
        }

        try {
            final process = new Process(command, args);
            process.stdin.close();
            final stdoutText = process.stdout.readAll().toString();
            final stderrText = process.stderr.readAll().toString();
            final exit = process.exitCode(true);
            process.close();

            var code = -1;
            if (exit != null) code = exit;
            return ProcessExecOutcome.spawned(
                command,
                args,
                code,
                ProcessOutputSlice.fromText(normalizeNewlines(stdoutText), policy.safeStdoutLimit()),
                ProcessOutputSlice.fromText(normalizeNewlines(stderrText), policy.safeStderrLimit())
            );
        } catch (e:Dynamic) {
            return ProcessExecOutcome.spawnFailed(command, args, normalizeNewlines(Std.string(e)));
        }
    }

    static function normalizeNewlines(text:String):String {
        return StringTools.replace(StringTools.replace(text, "\r\n", "\n"), "\r", "\n");
    }
}
