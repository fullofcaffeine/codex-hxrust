package codexhx.runtime.model;

class ModelStreamStartOutcome {
    public final ok:Bool;
    public final handle:ModelStreamHandle;
    public final stream:String;
    public final errorCode:String;
    public final errorMessage:String;

    function new(ok:Bool, handle:ModelStreamHandle, stream:String, errorCode:String, errorMessage:String) {
        this.ok = ok;
        this.handle = handle;
        this.stream = stream;
        this.errorCode = errorCode;
        this.errorMessage = errorMessage;
    }

    public static function success(handle:ModelStreamHandle, stream:String):ModelStreamStartOutcome {
        return new ModelStreamStartOutcome(true, handle, stream, "", "");
    }

    public static function failure(code:String, message:String):ModelStreamStartOutcome {
        return new ModelStreamStartOutcome(false, null, "", code, message);
    }
}
