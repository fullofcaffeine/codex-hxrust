package codexhx.tools.registry;

import codexhx.protocol.JsonScalar;

class ToolCallOutcome {
    public static inline final schema = "codex-hxrust.tool-call-outcome.v1";

    public final ok:Bool;
    public final method:String;
    public final toolName:String;
    public final outputJson:String;
    public final errorCode:String;
    public final errorMessage:String;

    public function new(ok:Bool, method:String, toolName:String, outputJson:String, errorCode:String, errorMessage:String) {
        this.ok = ok;
        this.method = method;
        this.toolName = toolName;
        this.outputJson = outputJson;
        this.errorCode = errorCode;
        this.errorMessage = errorMessage;
    }

    public static function unsupported(method:String, toolName:String, errorCode:String, errorMessage:String):ToolCallOutcome {
        return new ToolCallOutcome(false, method, toolName, "", errorCode, errorMessage);
    }

    public function json():String {
        var out = "{";
        out += "\"schema\":" + quote(schema);
        out += ",\"ok\":" + bool(ok);
        out += ",\"method\":" + quote(method);
        out += ",\"toolName\":" + quote(toolName);
        out += ",\"output\":";
        out += ok ? outputJson : "null";
        out += ",\"errorCode\":" + quote(errorCode);
        out += ",\"errorMessage\":" + quote(errorMessage);
        out += "}";
        return out;
    }

    static function quote(value:String):String {
        return JsonScalar.quote(value);
    }

    static function bool(value:Bool):String {
        if (value) return "true";
        return "false";
    }
}
