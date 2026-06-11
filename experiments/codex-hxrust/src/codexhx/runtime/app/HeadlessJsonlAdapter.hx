package codexhx.runtime.app;

import codexhx.protocol.JsonScalar;
import codexhx.protocol.json.CodexJson;
import codexhx.runtime.model.MockModelProvider;
import codexhx.runtime.model.ModelStreamRequest;
import codexhx.runtime.session.OneTurnSessionOutcome;
import codexhx.runtime.session.OneTurnSessionRunner;
import haxe.json.Value;

class HeadlessJsonlAdapter {
    static inline final sessionId = "session-1";
    static inline final threadId = "thread-1";

    final provider:MockModelProvider;
    var started:Bool;
    var nextTurnNumber:Int;
    var currentTurnId:String;
    var currentStatus:String;
    var lastOutcome:OneTurnSessionOutcome;

    public function new(fixturePath:String) {
        this.provider = new MockModelProvider(fixturePath);
        this.started = false;
        this.nextTurnNumber = 1;
        this.currentTurnId = "";
        this.currentStatus = "notStarted";
        this.lastOutcome = null;
    }

    public function dispatchJsonl(script:String):String {
        final outputs:Array<String> = [];
        final normalized = StringTools.replace(script, "\r\n", "\n");
        final lines = normalized.split("\n");
        for (line in lines) {
            final trimmed = StringTools.trim(line);
            if (trimmed.length == 0) continue;
            final commandOutputs = dispatchLine(trimmed);
            for (output in commandOutputs) {
                outputs.push(output);
            }
        }
        return outputs.join("\n") + "\n";
    }

    public function dispatchLine(line:String):Array<String> {
        final parsed = try {
            CodexJson.parse(line);
        } catch (e:Dynamic) {
            return [errorLine("", "parse", "invalid_json", "adapter command is not valid JSON")];
        }
        if (!parsed.ok) {
            return [errorLine("", "parse", "invalid_json", "adapter command is not valid JSON")];
        }

        final commandId = optionalString(parsed.value, "id", "");
        final command = requiredString(parsed.value, "command");
        if (!command.ok) {
            return [errorLine(commandId, "", "missing_command", "adapter command is required")];
        }

        return switch command.value {
            case "start":
                start(commandId);
            case "submit":
                submit(commandId, parsed.value);
            case "status":
                status(commandId);
            case "transcript":
                transcript(commandId);
            case _:
                [errorLine(commandId, command.value, "unsupported_command", "unsupported adapter command")];
        }
    }

    function start(commandId:String):Array<String> {
        started = true;
        currentStatus = "idle";
        return ["{\"command\":\"start\",\"id\":" + quote(commandId) + ",\"kind\":\"response\",\"ok\":true,\"sessionId\":\"" + sessionId
            + "\",\"status\":\"idle\",\"threadId\":\"" + threadId + "\"}"];
    }

    function submit(commandId:String, commandValue:Value):Array<String> {
        if (!started) {
            return [errorLine(commandId, "submit", "thread_not_started", "start must be called before submit")];
        }

        final prompt = requiredString(commandValue, "prompt");
        if (!prompt.ok) {
            return [errorLine(commandId, "submit", "missing_prompt", "submit prompt is required")];
        }

        currentStatus = "active";
        currentTurnId = "turn-" + Std.string(nextTurnNumber);
        nextTurnNumber = nextTurnNumber + 1;

        final outcome = OneTurnSessionRunner.run(provider, new ModelStreamRequest(commandId, "mock-model", prompt.value));
        lastOutcome = outcome;
        currentStatus = outcome.terminalState;
        return ["{\"command\":\"submit\",\"id\":" + quote(commandId) + ",\"kind\":\"response\",\"ok\":" + bool(outcome.ok) + ",\"terminalState\":"
            + quote(outcome.terminalState) + ",\"threadId\":\"" + threadId + "\",\"turnId\":" + quote(currentTurnId) + "}"];
    }

    function status(commandId:String):Array<String> {
        return ["{\"command\":\"status\",\"id\":" + quote(commandId) + ",\"kind\":\"response\",\"ok\":true,\"status\":" + quote(currentStatus)
            + ",\"threadId\":\"" + threadId + "\",\"turnId\":" + quote(currentTurnId) + "}"];
    }

    function transcript(commandId:String):Array<String> {
        if (lastOutcome == null) {
            return [errorLine(commandId, "transcript", "missing_transcript", "no transcript is available")];
        }

        final lines:Array<String> = [];
        var i = 0;
        for (event in lastOutcome.events) {
            lines.push("{\"command\":\"transcript\",\"event\":" + event.canonicalJson() + ",\"id\":" + quote(commandId)
                + ",\"index\":" + Std.string(i) + ",\"kind\":\"transcript_event\",\"ok\":true,\"threadId\":\"" + threadId + "\",\"turnId\":"
                + quote(currentTurnId) + "}");
            i = i + 1;
        }
        lines.push("{\"command\":\"transcript\",\"eventCount\":" + Std.string(lastOutcome.events.length) + ",\"id\":" + quote(commandId)
            + ",\"kind\":\"response\",\"ok\":true,\"threadId\":\"" + threadId + "\",\"turnId\":" + quote(currentTurnId) + "}");
        return lines;
    }

    function errorLine(commandId:String, command:String, code:String, message:String):String {
        return "{\"command\":" + quote(command) + ",\"errorCode\":" + quote(code) + ",\"errorMessage\":" + quote(message) + ",\"id\":"
            + quote(commandId) + ",\"kind\":\"error\",\"ok\":false}";
    }

    static function optionalString(value:Value, name:String, fallback:String):String {
        return switch value {
            case JObject(keys, values):
                final i = fieldIndex(keys, name);
                if (i < 0) fallback else switch values[i] {
                    case JString(text): text;
                    case _: fallback;
                }
            case _:
                fallback;
        }
    }

    static function requiredString(value:Value, name:String):StringField {
        return switch value {
            case JObject(keys, values):
                final i = fieldIndex(keys, name);
                if (i < 0) StringField.failure() else switch values[i] {
                    case JString(text): StringField.success(text);
                    case _: StringField.failure();
                }
            case _:
                StringField.failure();
        }
    }

    static function fieldIndex(keys:Array<String>, name:String):Int {
        var i = 0;
        while (i < keys.length) {
            if (keys[i] == name) return i;
            i = i + 1;
        }
        return -1;
    }

    static function quote(value:String):String {
        return JsonScalar.quote(value);
    }

    static function bool(value:Bool):String {
        if (value) return "true";
        return "false";
    }
}

class StringField {
    public final ok:Bool;
    public final value:String;

    function new(ok:Bool, value:String) {
        this.ok = ok;
        this.value = value;
    }

    public static function success(value:String):StringField {
        return new StringField(true, value);
    }

    public static function failure():StringField {
        return new StringField(false, "");
    }
}
