package codexhx.config;

class ConfigProfileParseOutcome {
    public final ok:Bool;
    public final profile:ConfigProfile;
    public final errorCode:String;
    public final errorPath:String;
    public final errorMessage:String;

    function new(ok:Bool, profile:ConfigProfile, errorCode:String, errorPath:String, errorMessage:String) {
        this.ok = ok;
        this.profile = profile;
        this.errorCode = errorCode;
        this.errorPath = errorPath;
        this.errorMessage = errorMessage;
    }

    public static function success(profile:ConfigProfile):ConfigProfileParseOutcome {
        return new ConfigProfileParseOutcome(true, profile, "", "", "");
    }

    public static function failure(code:String, path:String, message:String):ConfigProfileParseOutcome {
        return new ConfigProfileParseOutcome(false, ConfigProfile.empty(), code, path, message);
    }
}
