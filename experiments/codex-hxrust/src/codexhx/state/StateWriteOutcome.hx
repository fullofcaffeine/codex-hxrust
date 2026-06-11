package codexhx.state;

class StateWriteOutcome {
    public final ok:Bool;
    public final transcriptPath:String;
    public final statePath:String;
    public final errorCode:String;
    public final errorMessage:String;

    function new(ok:Bool, transcriptPath:String, statePath:String, errorCode:String, errorMessage:String) {
        this.ok = ok;
        this.transcriptPath = transcriptPath;
        this.statePath = statePath;
        this.errorCode = errorCode;
        this.errorMessage = errorMessage;
    }

    public static function success(transcriptPath:String, statePath:String):StateWriteOutcome {
        return new StateWriteOutcome(true, transcriptPath, statePath, "", "");
    }

    public static function failure(code:String, message:String):StateWriteOutcome {
        return new StateWriteOutcome(false, "", "", code, message);
    }
}
