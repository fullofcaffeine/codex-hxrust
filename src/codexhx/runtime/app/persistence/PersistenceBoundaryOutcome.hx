package codexhx.runtime.app.persistence;

class PersistenceBoundaryOutcome {
    public final ok:Bool;
    public final code:String;
    public final message:String;
    public final nativeFeatures:Array<String>;
    public final summary:String;

    function new(ok:Bool, code:String, message:String, nativeFeatures:Array<String>, summary:String) {
        this.ok = ok;
        this.code = code;
        this.message = message;
        this.nativeFeatures = nativeFeatures;
        this.summary = summary;
    }

    public static function success(code:String, message:String, nativeFeatures:Array<String>, summary:String):PersistenceBoundaryOutcome {
        return new PersistenceBoundaryOutcome(true, code, message, nativeFeatures, summary);
    }

    public static function failure(code:String, message:String):PersistenceBoundaryOutcome {
        return new PersistenceBoundaryOutcome(false, code, message, [], "");
    }

    public function nativeFeatureSummary():String {
        return nativeFeatures.join("|");
    }
}
