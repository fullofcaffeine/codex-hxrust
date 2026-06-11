package codexhx.tools.registry;

import codexhx.protocol.JsonScalar;

class ToolLookupOutcome {
    public static inline final schema = "codex-hxrust.tool-lookup.v1";

    public final ok:Bool;
    public final query:String;
    public final entry:ToolRegistryEntry;
    public final errorCode:String;
    public final errorMessage:String;

    public function new(ok:Bool, query:String, entry:ToolRegistryEntry, errorCode:String, errorMessage:String) {
        this.ok = ok;
        this.query = query;
        this.entry = entry;
        this.errorCode = errorCode;
        this.errorMessage = errorMessage;
    }

    public static function found(query:String, entry:ToolRegistryEntry):ToolLookupOutcome {
        return new ToolLookupOutcome(true, query, entry, "", "");
    }

    public static function missing(query:String):ToolLookupOutcome {
        return new ToolLookupOutcome(false, query, nullEntry(), "tool_not_found", "tool is not registered");
    }

    public function json():String {
        var out = "{";
        out += "\"schema\":" + quote(schema);
        out += ",\"ok\":" + bool(ok);
        out += ",\"query\":" + quote(query);
        out += ",\"entry\":";
        out += ok ? entry.json() : "null";
        out += ",\"errorCode\":" + quote(errorCode);
        out += ",\"errorMessage\":" + quote(errorMessage);
        out += "}";
        return out;
    }

    static function nullEntry():ToolRegistryEntry {
        return new ToolRegistryEntry("", "", "", "", "", "", "", haxe.json.Value.JNull, false, false, false, "", "", "");
    }

    static function quote(value:String):String {
        return JsonScalar.quote(value);
    }

    static function bool(value:Bool):String {
        if (value) return "true";
        return "false";
    }
}
