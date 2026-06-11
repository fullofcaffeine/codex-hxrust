package codexhx.runtime.model;

import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonParseOutcome;
import haxe.json.Value;

class MockModelStreamParser {
    public static function parseSse(stream:String):ModelStreamParseOutcome {
        return parseSseInternal(stream, -1);
    }

    public static function parseSsePrefix(stream:String, maxEvents:Int):ModelStreamParseOutcome {
        return parseSseInternal(stream, maxEvents);
    }

    static function parseSseInternal(stream:String, maxEvents:Int):ModelStreamParseOutcome {
        final events:Array<ModelStreamEvent> = [];
        var assistantText = "";
        var blockEvent = "";
        final dataLines:Array<String> = [];
        var blockIndex = 0;
        var blockLine = 0;
        var sawBlockContent = false;
        var failure:ModelStreamParseOutcome = null;
        var stoppedAtEventLimit = false;

        function flushBlock():Void {
            if (failure != null || !sawBlockContent) {
                return;
            }

            final path = "$.blocks[" + blockIndex + "]";
            if (blockEvent.length == 0) {
                failure = fail("missing_event", path, "SSE block is missing event line");
                return;
            }
            if (dataLines.length == 0) {
                failure = fail("missing_data", path, "SSE block is missing data line");
                return;
            }

            final parsed = parseJson(dataLines.join("\n"), path + ".data");
            if (!parsed.ok) {
                failure = fail(parsed.errorCode, parsed.errorPath, parsed.errorMessage);
                return;
            }

            final typeOutcome = CodexJson.stringField(parsed.value, "type", path + ".data");
            if (!typeOutcome.ok) {
                failure = fail(typeOutcome.errorCode, typeOutcome.errorPath, typeOutcome.errorMessage);
                return;
            }
            if (typeOutcome.value != blockEvent) {
                failure = fail("event_type_mismatch", path + ".event", "event line does not match data.type");
                return;
            }

            final mapped = mapEvent(blockEvent, parsed.value, path);
            if (!mapped.ok) {
                failure = mapped;
                return;
            }

            for (event in mapped.events) {
                events.push(event);
                if (event.kind == "assistant_delta") {
                    assistantText = assistantText + event.text;
                }
            }
            if (maxEvents >= 0 && events.length >= maxEvents) {
                stoppedAtEventLimit = true;
            }

            blockEvent = "";
            dataLines.resize(0);
            sawBlockContent = false;
            blockLine = 0;
            blockIndex = blockIndex + 1;
        }

        final normalized = StringTools.replace(stream, "\r\n", "\n");
        final lines = normalized.split("\n");
        for (line in lines) {
            if (stoppedAtEventLimit) break;
            final trimmed = StringTools.trim(line);
            if (trimmed.length == 0) {
                flushBlock();
                if (failure != null) return failure;
                continue;
            }

            sawBlockContent = true;
            if (StringTools.startsWith(line, "event:")) {
                blockEvent = StringTools.trim(line.substr("event:".length));
            } else if (StringTools.startsWith(line, "data:")) {
                dataLines.push(StringTools.trim(line.substr("data:".length)));
            } else {
                return fail("malformed_sse_line", "$.blocks[" + blockIndex + "].lines[" + blockLine + "]", "expected event or data line");
            }
            blockLine = blockLine + 1;
        }

        if (!stoppedAtEventLimit) flushBlock();
        if (failure != null) return failure;
        return ModelStreamParseOutcome.success(events, assistantText);
    }

    static function mapEvent(eventType:String, value:Value, path:String):ModelStreamParseOutcome {
        return switch eventType {
            case "response.created":
                final response = objectField(value, "response", path + ".data");
                if (!response.ok) response.toOutcome() else {
                    final id = CodexJson.stringField(response.value, "id", path + ".data.response");
                    if (!id.ok) fail(id.errorCode, id.errorPath, id.errorMessage) else one(new ModelStreamEvent("response_created", id.value, "", "", "", "", 0));
                }
            case "response.output_text.delta":
                final delta = CodexJson.stringField(value, "delta", path + ".data");
                if (!delta.ok) fail(delta.errorCode, delta.errorPath, delta.errorMessage) else one(new ModelStreamEvent("assistant_delta", "", "", delta.value, "", "", 0));
            case "response.output_item.done":
                mapOutputItemDone(value, path);
            case "response.completed":
                mapCompleted(value, path);
            case "response.failed":
                mapFailed(value, path);
            case _:
                fail("unsupported_event", path + ".event", "unsupported model stream event: " + eventType);
        }
    }

    static function mapOutputItemDone(value:Value, path:String):ModelStreamParseOutcome {
        final item = objectField(value, "item", path + ".data");
        if (!item.ok) return item.toOutcome();

        final itemType = CodexJson.stringField(item.value, "type", path + ".data.item");
        if (!itemType.ok) return fail(itemType.errorCode, itemType.errorPath, itemType.errorMessage);
        if (itemType.value != "message") return fail("unsupported_output_item", path + ".data.item.type", "only assistant message output items are supported");

        final role = CodexJson.stringField(item.value, "role", path + ".data.item");
        if (!role.ok) return fail(role.errorCode, role.errorPath, role.errorMessage);
        if (role.value != "assistant") return fail("unsupported_output_role", path + ".data.item.role", "only assistant output items are supported");

        final id = CodexJson.stringField(item.value, "id", path + ".data.item");
        if (!id.ok) return fail(id.errorCode, id.errorPath, id.errorMessage);

        final content = arrayField(item.value, "content", path + ".data.item");
        if (!content.ok) return content.toOutcome();

        var text = "";
        var i = 0;
        for (entry in content.values) {
            final entryPath = path + ".data.item.content[" + i + "]";
            final entryObject = expectObject(entry, entryPath);
            if (!entryObject.ok) return entryObject.toOutcome();
            final contentType = CodexJson.stringField(entry, "type", entryPath);
            if (!contentType.ok) return fail(contentType.errorCode, contentType.errorPath, contentType.errorMessage);
            if (contentType.value == "output_text") {
                final textField = CodexJson.stringField(entry, "text", entryPath);
                if (!textField.ok) return fail(textField.errorCode, textField.errorPath, textField.errorMessage);
                text = text + textField.value;
            }
            i = i + 1;
        }

        return one(new ModelStreamEvent("assistant_message", "", id.value, text, "", "", 0));
    }

    static function mapCompleted(value:Value, path:String):ModelStreamParseOutcome {
        final response = objectField(value, "response", path + ".data");
        if (!response.ok) return response.toOutcome();

        final id = CodexJson.stringField(response.value, "id", path + ".data.response");
        if (!id.ok) return fail(id.errorCode, id.errorPath, id.errorMessage);

        final usage = objectField(response.value, "usage", path + ".data.response");
        var totalTokens = 0;
        if (usage.ok) {
            final total = CodexJson.numberField(usage.value, "total_tokens", path + ".data.response.usage");
            if (!total.ok) return fail(total.errorCode, total.errorPath, total.errorMessage);
            totalTokens = Std.int(total.value);
        }

        return one(new ModelStreamEvent("response_completed", id.value, "", "", "", "", totalTokens));
    }

    static function mapFailed(value:Value, path:String):ModelStreamParseOutcome {
        final response = objectField(value, "response", path + ".data");
        if (!response.ok) return response.toOutcome();
        final id = CodexJson.stringField(response.value, "id", path + ".data.response");
        if (!id.ok) return fail(id.errorCode, id.errorPath, id.errorMessage);
        final error = objectField(response.value, "error", path + ".data.response");
        if (!error.ok) return error.toOutcome();
        final code = CodexJson.stringField(error.value, "code", path + ".data.response.error");
        if (!code.ok) return fail(code.errorCode, code.errorPath, code.errorMessage);
        final message = CodexJson.stringField(error.value, "message", path + ".data.response.error");
        if (!message.ok) return fail(message.errorCode, message.errorPath, message.errorMessage);
        return one(new ModelStreamEvent("response_failed", id.value, "", "", code.value, message.value, 0));
    }

    static function parseJson(text:String, path:String):JsonParseOutcome {
        try {
            return CodexJson.parse(text);
        } catch (e:Dynamic) {
            return JsonParseOutcome.failure("invalid_json", path, "invalid JSON data");
        }
    }

    static function one(event:ModelStreamEvent):ModelStreamParseOutcome {
        return ModelStreamParseOutcome.success([event], "");
    }

    static function fail(code:String, path:String, message:String):ModelStreamParseOutcome {
        return ModelStreamParseOutcome.failure(code, path, message);
    }

    static function objectField(object:Value, name:String, path:String):ObjectField {
        return switch object {
            case JObject(keys, values):
                final i = fieldIndex(keys, name);
                if (i < 0) ObjectField.failure("missing_field", path + "." + name, "required field is missing") else expectObject(values[i], path + "." + name);
            case _:
                ObjectField.failure("expected_object", path, "expected JSON object");
        }
    }

    static function arrayField(object:Value, name:String, path:String):ArrayField {
        return switch object {
            case JObject(keys, values):
                final i = fieldIndex(keys, name);
                if (i < 0) ArrayField.failure("missing_field", path + "." + name, "required field is missing") else switch values[i] {
                    case JArray(entries): ArrayField.success(entries);
                    case _: ArrayField.failure("expected_array", path + "." + name, "expected JSON array");
                }
            case _:
                ArrayField.failure("expected_object", path, "expected JSON object");
        }
    }

    static function expectObject(value:Value, path:String):ObjectField {
        return switch value {
            case JObject(_, _): ObjectField.success(value);
            case _: ObjectField.failure("expected_object", path, "expected JSON object");
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
}

class ObjectField {
    public final ok:Bool;
    public final value:Value;
    public final errorCode:String;
    public final errorPath:String;
    public final errorMessage:String;

    function new(ok:Bool, value:Value, errorCode:String, errorPath:String, errorMessage:String) {
        this.ok = ok;
        this.value = value;
        this.errorCode = errorCode;
        this.errorPath = errorPath;
        this.errorMessage = errorMessage;
    }

    public static function success(value:Value):ObjectField {
        return new ObjectField(true, value, "", "", "");
    }

    public static function failure(code:String, path:String, message:String):ObjectField {
        return new ObjectField(false, JNull, code, path, message);
    }

    public function toOutcome():ModelStreamParseOutcome {
        return ModelStreamParseOutcome.failure(errorCode, errorPath, errorMessage);
    }
}

class ArrayField {
    public final ok:Bool;
    public final values:Array<Value>;
    public final errorCode:String;
    public final errorPath:String;
    public final errorMessage:String;

    function new(ok:Bool, values:Array<Value>, errorCode:String, errorPath:String, errorMessage:String) {
        this.ok = ok;
        this.values = values;
        this.errorCode = errorCode;
        this.errorPath = errorPath;
        this.errorMessage = errorMessage;
    }

    public static function success(values:Array<Value>):ArrayField {
        return new ArrayField(true, values, "", "", "");
    }

    public static function failure(code:String, path:String, message:String):ArrayField {
        return new ArrayField(false, [], code, path, message);
    }

    public function toOutcome():ModelStreamParseOutcome {
        return ModelStreamParseOutcome.failure(errorCode, errorPath, errorMessage);
    }
}
