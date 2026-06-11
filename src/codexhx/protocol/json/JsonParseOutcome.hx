package codexhx.protocol.json;

import haxe.json.Value;

class JsonParseOutcome {
    public final ok:Bool;
    public final value:Value;
    public final errorCode:String;
    public final errorPath:String;
    public final errorMessage:String;

    function new(ok:Bool, value:Value, errorCode:String, errorPath:String, errorMessage:String) {
        this.ok = ok;
        this.value = value;
        this.errorCode = errorCode;
        this.errorPath = errorPath;
        this.errorMessage = errorMessage;
    }

    public static function success(value:Value):JsonParseOutcome {
        return new JsonParseOutcome(true, value, "", "", "");
    }

    public static function failure(code:String, path:String, message:String):JsonParseOutcome {
        return new JsonParseOutcome(false, JNull, code, path, message);
    }
}
