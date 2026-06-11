package codexhx.state;

class StateLoadOutcome {
    public final ok:Bool;
    public final content:String;
    public final errorCode:String;
    public final errorPath:String;
    public final errorMessage:String;

    function new(ok:Bool, content:String, errorCode:String, errorPath:String, errorMessage:String) {
        this.ok = ok;
        this.content = content;
        this.errorCode = errorCode;
        this.errorPath = errorPath;
        this.errorMessage = errorMessage;
    }

    public static function success(content:String):StateLoadOutcome {
        return new StateLoadOutcome(true, content, "", "", "");
    }

    public static function failure(code:String, path:String, message:String):StateLoadOutcome {
        return new StateLoadOutcome(false, "", code, path, message);
    }
}
