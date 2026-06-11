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
    static inline final itemStartedAtMs = 1000;
    static inline final itemCompletedAtMs = 2000;

    final provider:MockModelProvider;
    var started:Bool;
    var nextTurnNumber:Int;
    var currentTurnId:String;
    var currentStatus:String;
    var lastPrompt:String;
    var lastOutcome:OneTurnSessionOutcome;

    public function new(fixturePath:String) {
        this.provider = new MockModelProvider(fixturePath);
        this.started = false;
        this.nextTurnNumber = 1;
        this.currentTurnId = "";
        this.currentStatus = "notStarted";
        this.lastPrompt = "";
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

        if (!hasField(parsed.value, "command") && hasField(parsed.value, "method")) {
            return dispatchJsonRpcRequest(parsed.value);
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

    function dispatchJsonRpcRequest(request:Value):Array<String> {
        final requestId = requestIdJson(request);
        if (!requestId.ok) {
            return [jsonRpcError("null", -32600, "missing_id", "request id is required")];
        }

        final method = requiredString(request, "method");
        if (!method.ok) {
            return [jsonRpcError(requestId.value, -32600, "missing_method", "request method is required")];
        }

        return switch method.value {
            case "thread/start":
                appThreadStart(requestId.value);
            case "turn/start":
                appTurnStart(requestId.value, request);
            case "turn/interrupt":
                appTurnInterrupt(requestId.value, request);
            case "thread/read":
                appThreadRead(requestId.value, request);
            case _:
                [jsonRpcError(requestId.value, -32601, "unsupported_method", "unsupported app-server method")];
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

        runTurn(commandId, prompt.value);
        return ["{\"command\":\"submit\",\"id\":" + quote(commandId) + ",\"kind\":\"response\",\"ok\":" + bool(lastOutcome.ok) + ",\"terminalState\":"
            + quote(lastOutcome.terminalState) + ",\"threadId\":\"" + threadId + "\",\"turnId\":" + quote(currentTurnId) + "}"];
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

    function appThreadStart(requestIdJson:String):Array<String> {
        started = true;
        currentStatus = "idle";
        return [
            jsonRpcResponse(requestIdJson, "{\"thread\":" + threadJson(false) + "}"),
            jsonRpcNotification("thread/started", "{\"thread\":" + threadJson(false) + "}")
        ];
    }

    function appTurnStart(requestIdJson:String, request:Value):Array<String> {
        if (!started) {
            return [jsonRpcError(requestIdJson, -32000, "thread_not_started", "thread/start must be called before turn/start")];
        }

        final params = requiredObject(request, "params");
        if (!params.ok) return [jsonRpcError(requestIdJson, -32602, params.value, params.errorMessage)];

        final thread = requiredString(params.objectValue, "threadId");
        if (!thread.ok) return [jsonRpcError(requestIdJson, -32602, "missing_thread_id", "turn/start params.threadId is required")];
        if (thread.value != threadId) return [jsonRpcError(requestIdJson, -32000, "unknown_thread", "thread id is not loaded")];

        final prompt = textInput(params.objectValue);
        if (!prompt.ok) return [jsonRpcError(requestIdJson, -32602, prompt.value, prompt.errorMessage)];

        beginTurn(prompt.value);
        final outputs = [
            threadStatusChangedNotification(activeThreadStatusJson()),
            jsonRpcNotification("turn/started", "{\"threadId\":\"" + threadId + "\",\"turn\":" + turnJsonWithStatus("inProgress", false) + "}")
        ];

        completeTurn(requestIdJson, prompt.value);

        outputs.push(itemStartedNotification(userItemJson()));
        outputs.push(itemCompletedNotification(userItemJson()));
        outputs.push(itemStartedNotification(agentItemJson()));
        outputs.push(itemCompletedNotification(agentItemJson()));
        outputs.push(jsonRpcNotification("turn/completed", "{\"threadId\":\"" + threadId + "\",\"turn\":" + turnJson(true) + "}"));
        outputs.push(threadStatusChangedNotification(threadStatusJson()));
        outputs.push(jsonRpcResponse(requestIdJson, "{\"turn\":" + turnJson(true) + "}"));
        return outputs;
    }

    function appTurnInterrupt(requestIdJson:String, request:Value):Array<String> {
        if (!started) {
            return [jsonRpcError(requestIdJson, -32000, "thread_not_started", "thread/start must be called before turn/interrupt")];
        }

        final params = requiredObject(request, "params");
        if (!params.ok) return [jsonRpcError(requestIdJson, -32602, params.value, params.errorMessage)];

        final thread = requiredString(params.objectValue, "threadId");
        if (!thread.ok) return [jsonRpcError(requestIdJson, -32602, "missing_thread_id", "turn/interrupt params.threadId is required")];
        if (thread.value != threadId) return [jsonRpcError(requestIdJson, -32000, "unknown_thread", "thread id is not loaded")];

        final turn = requiredString(params.objectValue, "turnId");
        if (!turn.ok) return [jsonRpcError(requestIdJson, -32602, "missing_turn_id", "turn/interrupt params.turnId is required")];
        if (turn.value != currentTurnId || currentStatus != "active") {
            return [jsonRpcError(requestIdJson, -32000, "turn_not_active", "no active turn to interrupt")];
        }

        currentStatus = "cancelled";
        return [jsonRpcResponse(requestIdJson, "{}")];
    }

    function appThreadRead(requestIdJson:String, request:Value):Array<String> {
        if (!started) {
            return [jsonRpcError(requestIdJson, -32000, "thread_not_started", "thread/start must be called before thread/read")];
        }

        final params = requiredObject(request, "params");
        if (!params.ok) return [jsonRpcError(requestIdJson, -32602, params.value, params.errorMessage)];

        final thread = requiredString(params.objectValue, "threadId");
        if (!thread.ok) return [jsonRpcError(requestIdJson, -32602, "missing_thread_id", "thread/read params.threadId is required")];
        if (thread.value != threadId) return [jsonRpcError(requestIdJson, -32000, "unknown_thread", "thread id is not loaded")];

        final includeTurns = optionalBool(params.objectValue, "includeTurns", false);
        if (!includeTurns.ok) return [jsonRpcError(requestIdJson, -32602, "expected_include_turns_bool", "thread/read params.includeTurns must be a boolean")];

        return [jsonRpcResponse(requestIdJson, "{\"thread\":" + threadJson(includeTurns.boolValue) + "}")];
    }

    function runTurn(requestId:String, prompt:String):Void {
        beginTurn(prompt);
        completeTurn(requestId, prompt);
    }

    function beginTurn(prompt:String):Void {
        currentStatus = "active";
        currentTurnId = "turn-" + Std.string(nextTurnNumber);
        nextTurnNumber = nextTurnNumber + 1;
        lastPrompt = prompt;
    }

    function completeTurn(requestId:String, prompt:String):Void {
        final outcome = OneTurnSessionRunner.run(provider, new ModelStreamRequest(requestId, "mock-model", prompt));
        lastOutcome = outcome;
        currentStatus = outcome.terminalState;
    }

    function threadJson(includeTurns:Bool):String {
        return "{\"id\":\"" + threadId + "\",\"sessionId\":\"" + sessionId + "\",\"status\":" + threadStatusJson() + ",\"turns\":"
            + (includeTurns && lastOutcome != null ? "[" + turnJson(true) + "]" : "[]") + "}";
    }

    function threadStatusJson():String {
        if (!started) return "{\"type\":\"notLoaded\"}";
        if (currentStatus == "active") return activeThreadStatusJson();
        return "{\"type\":\"idle\"}";
    }

    function activeThreadStatusJson():String {
        return "{\"activeFlags\":[\"turnRunning\"],\"type\":\"active\"}";
    }

    function turnJson(includeItems:Bool):String {
        return turnJsonWithStatus(appTurnStatus(), includeItems);
    }

    function turnJsonWithStatus(status:String, includeItems:Bool):String {
        return "{\"id\":" + quote(currentTurnId) + ",\"items\":" + (includeItems ? turnItemsJson() : "[]") + ",\"status\":" + quote(status) + "}";
    }

    function turnItemsJson():String {
        if (lastOutcome == null) return "[]";
        return "[" + userItemJson() + "," + agentItemJson() + "]";
    }

    function userItemJson():String {
        return "{\"content\":[{\"text\":" + quote(lastPrompt) + ",\"type\":\"text\"}],\"id\":\"user-" + currentTurnId + "\",\"type\":\"userMessage\"}";
    }

    function agentItemJson():String {
        final text = lastOutcome == null ? "" : lastOutcome.assistantText;
        return "{\"id\":\"agent-" + currentTurnId + "\",\"text\":" + quote(text) + ",\"type\":\"agentMessage\"}";
    }

    function appTurnStatus():String {
        return switch currentStatus {
            case "completed":
                "completed";
            case "cancelled":
                "interrupted";
            case "active":
                "inProgress";
            case _:
                "failed";
        }
    }

    function errorLine(commandId:String, command:String, code:String, message:String):String {
        return "{\"command\":" + quote(command) + ",\"errorCode\":" + quote(code) + ",\"errorMessage\":" + quote(message) + ",\"id\":"
            + quote(commandId) + ",\"kind\":\"error\",\"ok\":false}";
    }

    function jsonRpcResponse(requestIdJson:String, resultJson:String):String {
        return "{\"id\":" + requestIdJson + ",\"jsonrpc\":\"2.0\",\"result\":" + resultJson + "}";
    }

    function jsonRpcNotification(method:String, paramsJson:String):String {
        return "{\"jsonrpc\":\"2.0\",\"method\":" + quote(method) + ",\"params\":" + paramsJson + "}";
    }

    function threadStatusChangedNotification(statusJson:String):String {
        return jsonRpcNotification("thread/status/changed", "{\"status\":" + statusJson + ",\"threadId\":\"" + threadId + "\"}");
    }

    function itemStartedNotification(itemJson:String):String {
        return jsonRpcNotification("item/started", "{\"item\":" + itemJson + ",\"startedAtMs\":" + Std.string(itemStartedAtMs) + ",\"threadId\":\""
            + threadId + "\",\"turnId\":" + quote(currentTurnId) + "}");
    }

    function itemCompletedNotification(itemJson:String):String {
        return jsonRpcNotification("item/completed", "{\"completedAtMs\":" + Std.string(itemCompletedAtMs) + ",\"item\":" + itemJson
            + ",\"threadId\":\"" + threadId + "\",\"turnId\":" + quote(currentTurnId) + "}");
    }

    function jsonRpcError(requestIdJson:String, code:Int, errorCode:String, message:String):String {
        return "{\"error\":{\"code\":" + Std.string(code) + ",\"data\":{\"errorCode\":" + quote(errorCode) + "},\"message\":" + quote(message)
            + "},\"id\":" + requestIdJson + ",\"jsonrpc\":\"2.0\"}";
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

    static function requiredObject(value:Value, name:String):ObjectField {
        return switch value {
            case JObject(keys, values):
                final i = fieldIndex(keys, name);
                if (i < 0) ObjectField.failure("missing_" + camelToSnake(name), name + " is required") else switch values[i] {
                    case JObject(childKeys, childValues): ObjectField.success(childKeys, childValues);
                    case _: ObjectField.failure("expected_" + camelToSnake(name) + "_object", name + " must be an object");
                }
            case _:
                ObjectField.failure("expected_object", "request must be an object");
        }
    }

    static function textInput(params:Value):StringField {
        return switch params {
            case JObject(keys, values):
                final i = fieldIndex(keys, "input");
                if (i < 0) return StringField.error("missing_input", "turn/start params.input is required");
                switch values[i] {
                    case JArray(entries):
                        final pieces:Array<String> = [];
                        var j = 0;
                        while (j < entries.length) {
                            switch entries[j] {
                                case JObject(inputKeys, inputValues):
                                    final typeIndex = fieldIndex(inputKeys, "type");
                                    if (typeIndex < 0) return StringField.error("missing_input_type", "turn/start text input type is required");
                                    final inputType = switch inputValues[typeIndex] {
                                        case JString(text): text;
                                        case _: return StringField.error("expected_input_type_string", "turn/start input type must be a string");
                                    }
                                    if (inputType != "text") return StringField.error("unsupported_user_input", "only text user input is supported");
                                    final textIndex = fieldIndex(inputKeys, "text");
                                    if (textIndex < 0) return StringField.error("missing_input_text", "turn/start text input is required");
                                    switch inputValues[textIndex] {
                                        case JString(text): pieces.push(text);
                                        case _: return StringField.error("expected_input_text_string", "turn/start input text must be a string");
                                    }
                                case _:
                                    return StringField.error("expected_input_object", "turn/start input entries must be objects");
                            }
                            j = j + 1;
                        }
                        StringField.success(pieces.join("\n"));
                    case _:
                        StringField.error("expected_input_array", "turn/start params.input must be an array");
                }
            case _:
                StringField.error("expected_params_object", "turn/start params must be an object");
        }
    }

    static function optionalBool(value:Value, name:String, fallback:Bool):BoolField {
        return switch value {
            case JObject(keys, values):
                final i = fieldIndex(keys, name);
                if (i < 0) BoolField.success(fallback) else switch values[i] {
                    case JBool(value): BoolField.success(value);
                    case _: BoolField.failure();
                }
            case _:
                BoolField.failure();
        }
    }

    static function requestIdJson(value:Value):StringField {
        return switch value {
            case JObject(keys, values):
                final i = fieldIndex(keys, "id");
                if (i < 0) StringField.failure() else switch values[i] {
                    case JString(text): StringField.success(quote(text));
                    case JNumber(number): StringField.success(Std.string(number));
                    case _: StringField.failure();
                }
            case _:
                StringField.failure();
        }
    }

    static function hasField(value:Value, name:String):Bool {
        return switch value {
            case JObject(keys, _):
                fieldIndex(keys, name) >= 0;
            case _:
                false;
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

    static function camelToSnake(value:String):String {
        var out = "";
        var i = 0;
        while (i < value.length) {
            final ch = value.substr(i, 1);
            if (i > 0 && ch >= "A" && ch <= "Z") out += "_";
            out += ch.toLowerCase();
            i = i + 1;
        }
        return out;
    }
}

class StringField {
    public final ok:Bool;
    public final value:String;
    public final errorMessage:String;

    function new(ok:Bool, value:String, errorMessage:String) {
        this.ok = ok;
        this.value = value;
        this.errorMessage = errorMessage;
    }

    public static function success(value:String):StringField {
        return new StringField(true, value, "");
    }

    public static function failure():StringField {
        return new StringField(false, "", "");
    }

    public static function error(code:String, message:String):StringField {
        return new StringField(false, code, message);
    }
}

class BoolField {
    public final ok:Bool;
    public final boolValue:Bool;

    function new(ok:Bool, boolValue:Bool) {
        this.ok = ok;
        this.boolValue = boolValue;
    }

    public static function success(value:Bool):BoolField {
        return new BoolField(true, value);
    }

    public static function failure():BoolField {
        return new BoolField(false, false);
    }
}

class ObjectField {
    public final ok:Bool;
    public final value:String;
    public final errorMessage:String;
    public final objectValue:Value;

    function new(ok:Bool, value:String, errorMessage:String, objectValue:Value) {
        this.ok = ok;
        this.value = value;
        this.errorMessage = errorMessage;
        this.objectValue = objectValue;
    }

    public static function success(keys:Array<String>, values:Array<Value>):ObjectField {
        return new ObjectField(true, "", "", JObject(keys, values));
    }

    public static function failure(code:String, message:String):ObjectField {
        return new ObjectField(false, code, message, JObject([], []));
    }
}
