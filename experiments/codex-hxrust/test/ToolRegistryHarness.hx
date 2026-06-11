import codexhx.protocol.JsonScalar;
import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import codexhx.tools.registry.ToolCallOutcome;
import codexhx.tools.registry.ToolLookupOutcome;
import codexhx.tools.registry.ToolRegistry;
import haxe.json.Value;
import sys.io.File;

class ToolRegistryHarness {
    static function main():Void {
        fixtureToolLookupPasses();
        unsupportedMcpFeaturesReturnExplicitErrors();
        futureMcpScopeIsDocumented();
    }

    static function fixtureToolLookupPasses():Void {
        final registry = fixtureRegistry();
        final lines:Array<String> = [];

        lines.push(lookupLine("get_goal", registry.find("get_goal")));
        lines.push(lookupLine("mcp__music_studio__get_strudel_guide", registry.find("mcp__music_studio__get_strudel_guide")));
        lines.push(lookupLine("agent__summarize", registry.find("agent__summarize")));
        lines.push(lookupLine("missing_tool", registry.find("missing_tool")));

        assertEquals(File.getContent("fixtures/hxrust/tool-registry-lookup.v1.jsonl"), lines.join("\n") + "\n");
    }

    static function unsupportedMcpFeaturesReturnExplicitErrors():Void {
        final registry = fixtureRegistry();
        final lines:Array<String> = [];
        lines.push(errorLine(registry.unsupportedMcpFeature("mcpServerStatus/list", "")));
        lines.push(errorLine(registry.unsupportedMcpFeature("mcpServer/resource/read", "mcp__music_studio__get_strudel_guide")));
        lines.push(errorLine(registry.unsupportedMcpFeature("mcpServer/tool/call", "mcp__music_studio__get_strudel_guide")));
        lines.push(errorLine(registry.unsupportedMcpFeature("config/mcpServer/reload", "")));
        lines.push(errorLine(registry.unsupportedMcpFeature("mcpServer/oauth/login", "music-studio")));

        assertEquals(File.getContent("fixtures/hxrust/tool-registry-unsupported-mcp.v1.jsonl"), lines.join("\n") + "\n");
    }

    static function futureMcpScopeIsDocumented():Void {
        final report = StringTools.trim(File.getContent("../../reference/tool-registry-skeleton.v1.json"));
        final parsed = expectJson(CodexJson.parse(report));
        final schema = CodexJson.stringField(parsed, "schema", "$");
        assertTrue(schema.ok, "reference schema should parse");
        assertEquals("codex-hxrust.tool-registry-skeleton.v1", schema.value);
    }

    static function fixtureRegistry():ToolRegistry {
        final registry = new ToolRegistry();
        expectLookup(registry.registerLocalFunction(
            "get_goal",
            "Read the current thread goal.",
            object(["type", "additionalProperties"], [Value.JString("object"), Value.JBool(false)])
        ));
        expectLookup(registry.registerMcpTool(
            "music-studio",
            "get-strudel-guide",
            "Return Strudel music help.",
            object(["type", "properties"], [
                Value.JString("object"),
                object(["query"], [object(["type"], [Value.JString("string")])])
            ]),
            "connector-music",
            "Music Studio",
            true
        ));
        expectLookup(registry.registerDynamicTool(
            "agent",
            "summarize",
            "Summarize selected thread context.",
            object(["type"], [Value.JString("object")]),
            true
        ));
        return registry;
    }

    static function lookupLine(query:String, outcome:ToolLookupOutcome):String {
        if (outcome.ok) {
            return "{\"case\":" + quote(query) + ",\"lookup\":" + outcome.json() + "}";
        }
        return "{\"case\":" + quote(query) + ",\"lookup\":" + outcome.json() + "}";
    }

    static function errorLine(outcome:ToolCallOutcome):String {
        assertFalse(outcome.ok, "MCP skeleton operations must fail closed");
        return outcome.json();
    }

    static function expectLookup(outcome:ToolLookupOutcome):ToolLookupOutcome {
        if (!outcome.ok) throw outcome.errorCode + ": " + outcome.errorMessage;
        return outcome;
    }

    static function expectJson(outcome:JsonParseOutcome):Value {
        if (!outcome.ok) throw outcome.errorCode + " at " + outcome.errorPath + ": " + outcome.errorMessage;
        return outcome.value;
    }

    static function object(keys:Array<String>, values:Array<Value>):Value {
        return Value.JObject(keys, values);
    }

    static function quote(value:String):String {
        return JsonScalar.quote(value);
    }

    static function assertEquals(expected:String, actual:String):Void {
        if (expected != actual) throw "expected `" + expected + "`, got `" + actual + "`";
    }

    static function assertTrue(value:Bool, message:String):Void {
        if (!value) throw message;
    }

    static function assertFalse(value:Bool, message:String):Void {
        if (value) throw message;
    }
}
