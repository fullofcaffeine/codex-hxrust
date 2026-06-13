package codexhx.runtime.tui;

import codexhx.protocol.json.CodexJson;
import codexhx.protocol.json.JsonValueCodec;
import haxe.json.Value;

class TuiStoryReplayParser {
    public static function replaySummary(jsonl:String):TuiStoryReplaySummary {
        final summary = new TuiStoryReplaySummary();
        final normalized = StringTools.replace(jsonl, "\r\n", "\n");
        final lines = normalized.split("\n");
        var lineNumber = 0;
        for (line in lines) {
            lineNumber = lineNumber + 1;
            final trimmed = StringTools.trim(line);
            if (trimmed.length == 0) continue;
            final parsed = parseLine(trimmed, lineNumber);
            if (!parsed.ok) {
                throw parsed.errorCode + " at " + parsed.errorPath + ": " + parsed.errorMessage;
            }
            if (parsed.record != null) summary.add(parsed.record);
        }
        return summary;
    }

    public static function parseLine(line:String, lineNumber:Int):TuiStoryParseOutcome {
        final parsed = CodexJson.parse(line);
        if (!parsed.ok) return TuiStoryParseOutcome.failure(parsed.errorCode, parsed.errorPath, parsed.errorMessage);

        if (hasField(parsed.value, "schema")) return TuiStoryParseOutcome.success(null);

        final dir = requiredString(parsed.value, "dir");
        if (dir == null) return failedRequired(lineNumber, "dir", "expected direction string");
        if (!TuiStoryDirection.isValid(dir)) return TuiStoryParseOutcome.failure("invalid_direction", path(lineNumber, "dir"), "unsupported story direction");

        final kind = requiredString(parsed.value, "kind");
        if (kind == null) return failedRequired(lineNumber, "kind", "expected kind string");
        if (!TuiStoryKind.isValid(kind)) return TuiStoryParseOutcome.failure("invalid_kind", path(lineNumber, "kind"), "unsupported story kind");

        final ts = requiredString(parsed.value, "ts");
        if (ts == null) return failedRequired(lineNumber, "ts", "expected timestamp string");

        return switch kind {
            case TuiStoryKind.SessionStart:
                parseSessionStart(parsed.value, lineNumber, dir, ts);
            case TuiStoryKind.SessionEnd:
                record(lineNumber, dir, kind, ts, "", null, CodexStoryMessageType.Unsupported, "", 0, "", "");
            case TuiStoryKind.AppEvent:
                final variant = requiredString(parsed.value, "variant");
                if (variant == null) failedRequired(lineNumber, "variant", "expected app event variant");
                else record(lineNumber, dir, kind, ts, variant, null, CodexStoryMessageType.Unsupported, "", 0, "", "");
            case TuiStoryKind.KeyEvent:
                final event = requiredString(parsed.value, "event");
                if (event == null) failedRequired(lineNumber, "event", "expected key event string");
                else record(lineNumber, dir, kind, ts, "", TuiStoryKeyEvent.parse(event), CodexStoryMessageType.Unsupported, "", 0, "", "");
            case TuiStoryKind.CodexEvent:
                parseCodexEvent(parsed.value, lineNumber, dir, ts);
            case TuiStoryKind.InsertHistory:
                final lines = requiredInt(parsed.value, "lines");
                if (lines < 0) failedRequired(lineNumber, "lines", "expected non-negative insert_history line count");
                else record(lineNumber, dir, kind, ts, "", null, CodexStoryMessageType.Unsupported, "", lines, "", "");
            case TuiStoryKind.Operation:
                parseOperation(parsed.value, lineNumber, dir, ts);
            case _:
                TuiStoryParseOutcome.failure("unsupported_kind", path(lineNumber, "kind"), "unsupported story kind");
        }
    }

    static function parseSessionStart(value:Value, lineNumber:Int, dir:String, ts:String):TuiStoryParseOutcome {
        final cwd = requiredString(value, "cwd");
        if (cwd == null) return failedRequired(lineNumber, "cwd", "expected cwd string");
        final model = requiredString(value, "model");
        if (model == null) return failedRequired(lineNumber, "model", "expected model string");
        return record(lineNumber, dir, TuiStoryKind.SessionStart, ts, "", null, CodexStoryMessageType.Unsupported, "", 0, "", "cwd:<normalized>|model:<normalized>");
    }

    static function parseCodexEvent(value:Value, lineNumber:Int, dir:String, ts:String):TuiStoryParseOutcome {
        final payload = requiredObject(value, "payload");
        if (payload == null) return failedRequired(lineNumber, "payload", "expected codex event payload");
        final msg = requiredObject(payload, "msg");
        if (msg == null) return failedRequired(lineNumber, "payload.msg", "expected codex event msg");
        final rawType = requiredString(msg, "type");
        if (rawType == null) return failedRequired(lineNumber, "payload.msg.type", "expected codex event type");

        final typed = codexType(rawType);
        final delta = optionalString(msg, "delta");
        final lastMessage = optionalString(msg, "last_agent_message");
        final sourceId = switch typed {
            case CodexStoryMessageType.SessionConfigured:
                "session:<normalized>|model:<normalized>";
            case CodexStoryMessageType.TaskComplete:
                "last_agent_message:" + preview(lastMessage, 48);
            case _:
                "";
        }
        return record(lineNumber, dir, TuiStoryKind.CodexEvent, ts, "", null, typed, delta, 0, "", sourceId);
    }

    static function parseOperation(value:Value, lineNumber:Int, dir:String, ts:String):TuiStoryParseOutcome {
        final payload = requiredObject(value, "payload");
        if (payload == null) return failedRequired(lineNumber, "payload", "expected op payload");
        final opType = requiredString(payload, "type");
        if (opType == null) return failedRequired(lineNumber, "payload.type", "expected op type");
        return record(lineNumber, dir, TuiStoryKind.Operation, ts, "", null, CodexStoryMessageType.Unsupported, "", 0, opType, "");
    }

    static function record(
        lineNumber:Int,
        dir:String,
        kind:String,
        ts:String,
        appVariant:String,
        keyEvent:TuiStoryKeyEvent,
        codexEventType:CodexStoryMessageType,
        textDelta:String,
        historyLines:Int,
        operationType:String,
        sourceId:String
    ):TuiStoryParseOutcome {
        return TuiStoryParseOutcome.success(new TuiStoryRecord(
            lineNumber,
            cast dir,
            cast kind,
            normalizeTimestamp(ts),
            appVariant,
            keyEvent,
            codexEventType,
            textDelta,
            historyLines,
            operationType,
            sourceId
        ));
    }

    static function codexType(value:String):CodexStoryMessageType {
        return switch value {
            case "session_configured": CodexStoryMessageType.SessionConfigured;
            case "task_started": CodexStoryMessageType.TaskStarted;
            case "agent_reasoning_raw_content_delta": CodexStoryMessageType.AgentReasoningRawContentDelta;
            case "agent_message_delta": CodexStoryMessageType.AgentMessageDelta;
            case "task_complete": CodexStoryMessageType.TaskComplete;
            case "shutdown_complete": CodexStoryMessageType.ShutdownComplete;
            case _: CodexStoryMessageType.Unsupported;
        }
    }

    static function normalizeTimestamp(value:String):String {
        if (value.length >= 10) return "<ts:" + value.substr(0, 10) + ">";
        return "<ts>";
    }

    static function preview(value:String, limit:Int):String {
        if (value.length <= limit) return value;
        return value.substr(0, limit) + "...";
    }

    static function requiredObject(object:Value, name:String):Null<Value> {
        final value = field(object, name);
        return switch value {
            case JObject(_, _): value;
            case _: null;
        }
    }

    static function requiredString(object:Value, name:String):Null<String> {
        return switch field(object, name) {
            case JString(value): value;
            case _: null;
        }
    }

    static function optionalString(object:Value, name:String):String {
        return switch field(object, name) {
            case JString(value): value;
            case _: "";
        }
    }

    static function requiredInt(object:Value, name:String):Int {
        return switch field(object, name) {
            case JNumber(value):
                final intValue = Std.int(value);
                if (intValue < 0 || intValue != value) -1 else intValue;
            case _:
                -1;
        }
    }

    static function field(object:Value, name:String):Value {
        return switch object {
            case JObject(keys, values):
                var i = 0;
                while (i < keys.length && i < values.length) {
                    if (keys[i] == name) return values[i];
                    i = i + 1;
                }
                JNull;
            case _:
                JNull;
        }
    }

    static function hasField(object:Value, name:String):Bool {
        return switch object {
            case JObject(keys, _):
                for (key in keys) {
                    if (key == name) return true;
                }
                false;
            case _:
                false;
        }
    }

    static function failedRequired(lineNumber:Int, fieldPath:String, message:String):TuiStoryParseOutcome {
        return TuiStoryParseOutcome.failure("invalid_story_record", path(lineNumber, fieldPath), message);
    }

    static function path(lineNumber:Int, fieldPath:String):String {
        return "$.line[" + Std.string(lineNumber) + "]." + fieldPath;
    }
}
