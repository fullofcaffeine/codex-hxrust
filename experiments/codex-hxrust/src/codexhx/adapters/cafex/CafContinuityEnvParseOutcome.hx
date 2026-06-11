package codexhx.adapters.cafex;

class CafContinuityEnvParseOutcome {
    public final ok:Bool;
    public final metadata:CafContinuityEnv;
    public final errorCode:String;
    public final errorMessage:String;

    function new(ok:Bool, metadata:CafContinuityEnv, errorCode:String, errorMessage:String) {
        this.ok = ok;
        this.metadata = metadata;
        this.errorCode = errorCode;
        this.errorMessage = errorMessage;
    }

    public static function success(metadata:CafContinuityEnv):CafContinuityEnvParseOutcome {
        return new CafContinuityEnvParseOutcome(true, metadata, "", "");
    }

    public static function failure(code:String, message:String):CafContinuityEnvParseOutcome {
        return new CafContinuityEnvParseOutcome(false, null, code, message);
    }
}
