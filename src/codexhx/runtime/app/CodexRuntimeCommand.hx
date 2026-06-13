package codexhx.runtime.app;

class CodexRuntimeCommand {
    public final kind:CodexRuntimeCommandKind;
    public final requestId:String;
    public final method:String;
    public final payloadJson:String;

    function new(kind:CodexRuntimeCommandKind, requestId:String, method:String, payloadJson:String) {
        this.kind = kind;
        this.requestId = requestId;
        this.method = method;
        this.payloadJson = payloadJson;
    }

    public static function appRequest(requestId:String, method:String, paramsJson:String):CodexRuntimeCommand {
        return new CodexRuntimeCommand(CodexRuntimeCommandKind.AppRequest, requestId, method, paramsJson);
    }

    public static function completeResponse(requestId:String, method:String, resultJson:String):CodexRuntimeCommand {
        return new CodexRuntimeCommand(CodexRuntimeCommandKind.CompleteResponse, requestId, method, resultJson);
    }

    public static function failResponse(requestId:String, method:String, errorJson:String):CodexRuntimeCommand {
        return new CodexRuntimeCommand(CodexRuntimeCommandKind.FailResponse, requestId, method, errorJson);
    }
}
