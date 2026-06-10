package codexhx.protocol.json;

class StringOutcome {
    public final ok:Bool;
    public final value:String;
    public final errorCode:String;
    public final errorPath:String;
    public final errorMessage:String;

    function new(ok:Bool, value:String, errorCode:String, errorPath:String, errorMessage:String) {
        this.ok = ok;
        this.value = value;
        this.errorCode = errorCode;
        this.errorPath = errorPath;
        this.errorMessage = errorMessage;
    }

    public static function success(value:String):StringOutcome {
        return new StringOutcome(true, value, "", "", "");
    }

    public static function failure(code:String, path:String, message:String):StringOutcome {
        return new StringOutcome(false, "", code, path, message);
    }
}
