package codexhx.protocol.json;

import haxe.json.Value;

class JsonFieldOutcome {
    public final ok:Bool;
    public final value:Null<Value>;
    public final error:Null<JsonError>;

    function new(ok:Bool, value:Null<Value>, error:Null<JsonError>) {
        this.ok = ok;
        this.value = value;
        this.error = error;
    }

    public static function found(value:Value):JsonFieldOutcome {
        return new JsonFieldOutcome(true, value, null);
    }

    public static function failure(code:String, path:String, message:String):JsonFieldOutcome {
        return new JsonFieldOutcome(false, null, new JsonError(code, path, message));
    }
}
