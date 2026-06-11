package codexhx.tools.registry;

import codexhx.protocol.JsonScalar;
import codexhx.protocol.json.JsonValueCodec;
import haxe.json.Value;

class ToolRegistryEntry {
    public static inline final schema = "codex-hxrust.tool-registry-entry.v1";

    public final kind:String;
    public final name:String;
    public final namespace:String;
    public final tool:String;
    public final rawServerName:String;
    public final rawToolName:String;
    public final description:String;
    public final inputSchema:Value;
    public final deferLoading:Bool;
    public final supportsParallelToolCalls:Bool;
    public final executable:Bool;
    public final connectorId:String;
    public final connectorName:String;
    public final pluginId:String;

    public function new(kind:String, name:String, namespace:String, tool:String, rawServerName:String, rawToolName:String, description:String, inputSchema:Value, deferLoading:Bool, supportsParallelToolCalls:Bool, executable:Bool, connectorId:String, connectorName:String, pluginId:String) {
        this.kind = kind;
        this.name = name;
        this.namespace = namespace;
        this.tool = tool;
        this.rawServerName = rawServerName;
        this.rawToolName = rawToolName;
        this.description = description;
        this.inputSchema = inputSchema;
        this.deferLoading = deferLoading;
        this.supportsParallelToolCalls = supportsParallelToolCalls;
        this.executable = executable;
        this.connectorId = connectorId;
        this.connectorName = connectorName;
        this.pluginId = pluginId;
    }

    public static function localFunction(name:String, description:String, inputSchema:Value):ToolRegistryEntry {
        final callable = sanitizeToolPart(name);
        return new ToolRegistryEntry(
            ToolKind.LocalFunction,
            callable,
            "",
            callable,
            "",
            name,
            description,
            inputSchema,
            false,
            false,
            true,
            "",
            "",
            ""
        );
    }

    public static function mcp(serverName:String, rawToolName:String, description:String, inputSchema:Value, connectorId:String, connectorName:String, supportsParallelToolCalls:Bool):ToolRegistryEntry {
        final namespace = "mcp__" + sanitizeToolPart(serverName);
        final tool = sanitizeToolPart(rawToolName);
        return new ToolRegistryEntry(
            ToolKind.Mcp,
            namespace + "__" + tool,
            namespace,
            tool,
            serverName,
            rawToolName,
            description,
            inputSchema,
            false,
            supportsParallelToolCalls,
            false,
            connectorId,
            connectorName,
            ""
        );
    }

    public static function dynamicTool(namespace:String, name:String, description:String, inputSchema:Value, deferLoading:Bool):ToolRegistryEntry {
        final cleanNamespace = sanitizeToolPart(namespace);
        final cleanTool = sanitizeToolPart(name);
        final modelName = cleanNamespace == "" ? "" + cleanTool : cleanNamespace + "__" + cleanTool;
        return new ToolRegistryEntry(
            ToolKind.Dynamic,
            modelName,
            cleanNamespace,
            cleanTool,
            "",
            name,
            description,
            inputSchema,
            deferLoading,
            false,
            false,
            "",
            "",
            ""
        );
    }

    public function json():String {
        var out = "{";
        out += "\"schema\":" + quote(schema);
        out += ",\"kind\":" + quote(kind);
        out += ",\"name\":" + quote(name);
        out += ",\"namespace\":" + quote(namespace);
        out += ",\"tool\":" + quote(tool);
        out += ",\"rawServerName\":" + nullableString(rawServerName);
        out += ",\"rawToolName\":" + quote(rawToolName);
        out += ",\"description\":" + quote(description);
        out += ",\"inputSchema\":" + JsonValueCodec.encode(inputSchema);
        out += ",\"deferLoading\":" + bool(deferLoading);
        out += ",\"supportsParallelToolCalls\":" + bool(supportsParallelToolCalls);
        out += ",\"executable\":" + bool(executable);
        out += ",\"connectorId\":" + nullableString(connectorId);
        out += ",\"connectorName\":" + nullableString(connectorName);
        out += ",\"pluginId\":" + nullableString(pluginId);
        out += "}";
        return out;
    }

    public static function sanitizeToolPart(value:String):String {
        final trimmed = StringTools.trim(value);
        var out = "";
        var previousUnderscore = false;
        var i = 0;
        while (i < trimmed.length) {
            final ch = trimmed.substr(i, 1);
            final ok = isAsciiAlphaNumeric(ch) || ch == "_";
            if (ok) {
                out += ch;
                previousUnderscore = false;
            } else if (!previousUnderscore) {
                out += "_";
                previousUnderscore = true;
            }
            i = i + 1;
        }
        out = trimUnderscores(out);
        if (out == "") out = "tool";
        if (isAsciiDigit(out.substr(0, 1))) out = "_" + out;
        if (out.length > 64) out = out.substr(0, 64);
        return out;
    }

    static function trimUnderscores(value:String):String {
        var start = 0;
        var end = value.length;
        while (start < end && value.substr(start, 1) == "_") start = start + 1;
        while (end > start && value.substr(end - 1, 1) == "_") end = end - 1;
        return value.substr(start, end - start);
    }

    static function isAsciiAlphaNumeric(ch:String):Bool {
        return isAsciiDigit(ch)
            || (ch >= "A" && ch <= "Z")
            || (ch >= "a" && ch <= "z");
    }

    static function isAsciiDigit(ch:String):Bool {
        return ch >= "0" && ch <= "9";
    }

    static function nullableString(value:String):String {
        if (value == "") return "null";
        return quote(value);
    }

    static function quote(value:String):String {
        return JsonScalar.quote(value);
    }

    static function bool(value:Bool):String {
        if (value) return "true";
        return "false";
    }
}
