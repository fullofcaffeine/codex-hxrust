package codexhx.runtime.app.bootstrap;

class BootstrapValidationOutcome {
    public final ok:Bool;
    public final code:String;
    public final message:String;
    public final report:BootstrapReport;

    function new(ok:Bool, code:String, message:String, report:BootstrapReport) {
        this.ok = ok;
        this.code = code;
        this.message = message;
        this.report = report;
    }

    public static function success(code:String):BootstrapValidationOutcome {
        return new BootstrapValidationOutcome(true, code, "", emptyReport());
    }

    public static function completed(report:BootstrapReport):BootstrapValidationOutcome {
        return new BootstrapValidationOutcome(true, "bootstrapped", "", report);
    }

    public static function failure(code:String, message:String):BootstrapValidationOutcome {
        return new BootstrapValidationOutcome(false, code, message, emptyReport());
    }

    static function emptyReport():BootstrapReport {
        return new BootstrapReport(BootstrapMode.InProcess, "", "", "", "", "", "");
    }
}
