package codexhx.tools.process;

class ProcessExecPolicy {
    public final approvals:Array<ProcessExecApproval>;
    public final maxStdoutChars:Int;
    public final maxStderrChars:Int;

    public function new(approvals:Array<ProcessExecApproval>, maxStdoutChars:Int, maxStderrChars:Int) {
        this.approvals = approvals;
        this.maxStdoutChars = maxStdoutChars;
        this.maxStderrChars = maxStderrChars;
    }

    public static function denyAll(maxStdoutChars:Int, maxStderrChars:Int):ProcessExecPolicy {
        return new ProcessExecPolicy([], maxStdoutChars, maxStderrChars);
    }

    public static function allowExact(command:String, args:Array<String>, maxStdoutChars:Int, maxStderrChars:Int):ProcessExecPolicy {
        return new ProcessExecPolicy([new ProcessExecApproval(command, args)], maxStdoutChars, maxStderrChars);
    }

    public function isApproved(command:String, args:Array<String>):Bool {
        for (approval in approvals) {
            if (approval.matches(command, args)) return true;
        }
        return false;
    }

    public function safeStdoutLimit():Int {
        return safeLimit(maxStdoutChars);
    }

    public function safeStderrLimit():Int {
        return safeLimit(maxStderrChars);
    }

    static function safeLimit(value:Int):Int {
        if (value < 0) return 0;
        return value;
    }
}
