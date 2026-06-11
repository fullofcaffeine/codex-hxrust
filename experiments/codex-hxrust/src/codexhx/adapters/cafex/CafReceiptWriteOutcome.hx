package codexhx.adapters.cafex;

class CafReceiptWriteOutcome {
    public final ok:Bool;
    public final wrote:Bool;
    public final path:String;
    public final skippedReason:String;
    public final errorCode:String;
    public final errorMessage:String;

    function new(ok:Bool, wrote:Bool, path:String, skippedReason:String, errorCode:String, errorMessage:String) {
        this.ok = ok;
        this.wrote = wrote;
        this.path = path;
        this.skippedReason = skippedReason;
        this.errorCode = errorCode;
        this.errorMessage = errorMessage;
    }

    public static function written(path:String):CafReceiptWriteOutcome {
        return new CafReceiptWriteOutcome(true, true, path, "", "", "");
    }

    public static function skipped(reason:String):CafReceiptWriteOutcome {
        return new CafReceiptWriteOutcome(true, false, "", reason, "", "");
    }

    public static function failure(code:String, message:String):CafReceiptWriteOutcome {
        return new CafReceiptWriteOutcome(false, false, "", "", code, message);
    }
}
