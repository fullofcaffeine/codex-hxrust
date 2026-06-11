package codexhx.protocol.json;

class NumberOutcome {
    public final ok:Bool;
    public final value:Float;
    public final errorCode:String;
    public final errorPath:String;
    public final errorMessage:String;

    function new(ok:Bool, value:Float, errorCode:String, errorPath:String, errorMessage:String) {
        this.ok = ok;
        this.value = value;
        this.errorCode = errorCode;
        this.errorPath = errorPath;
        this.errorMessage = errorMessage;
    }

    public static function success(value:Float):NumberOutcome {
        return new NumberOutcome(true, value, "", "", "");
    }

    public static function failure(code:String, path:String, message:String):NumberOutcome {
        return new NumberOutcome(false, 0, code, path, message);
    }
}
