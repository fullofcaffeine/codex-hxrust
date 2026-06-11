package codexhx.adapters.cafex;

import codexhx.protocol.JsonScalar;
import sys.FileSystem;
import sys.io.File;

class CafReceiptWriter {
    static inline final clientId = "codex";
    static inline final sessionSchema = "caf-client-session.v1";
    static inline final turnSchema = "caf-client-turn.v1";

    public static function maybeWriteSessionReceipt(env:CafReceiptEnv, conversationId:String, source:String, writtenAt:String):CafReceiptWriteOutcome {
        if (env.sessionReceiptPath.length == 0) return CafReceiptWriteOutcome.skipped("missing_session_receipt_path");
        if (env.successorRunId.length == 0) return CafReceiptWriteOutcome.skipped("missing_successor_run_id");

        final continuity = continuityForSource(source);
        if (!continuity.ok) return CafReceiptWriteOutcome.failure("unsupported_session_source", "unsupported session start source");

        return writeReceipt(env.sessionReceiptPath, sessionJson(env, conversationId, source, writtenAt, continuity));
    }

    public static function maybeWriteTurnReceipt(env:CafReceiptEnv, conversationId:String, turnId:String, source:String, writtenAt:String):CafReceiptWriteOutcome {
        if (env.turnReceiptPath.length == 0) return CafReceiptWriteOutcome.skipped("missing_turn_receipt_path");
        if (env.successorRunId.length == 0) return CafReceiptWriteOutcome.skipped("missing_successor_run_id");

        final continuity = continuityForSource(source);
        if (!continuity.ok) return CafReceiptWriteOutcome.failure("unsupported_session_source", "unsupported session start source");

        return writeReceipt(env.turnReceiptPath, turnJson(env, conversationId, turnId, source, writtenAt, continuity));
    }

    static function sessionJson(env:CafReceiptEnv, conversationId:String, source:String, writtenAt:String, continuity:CafContinuity):String {
        var json = "{\n"
            + "  \"schema\": " + quote(sessionSchema) + ",\n"
            + "  \"clientId\": " + quote(clientId) + ",\n"
            + "  \"runId\": " + quote(env.successorRunId) + ",\n"
            + "  \"conversationId\": " + quote(conversationId) + ",\n"
            + "  \"actualContinuityMode\": " + quote(continuity.actualContinuityMode) + ",\n"
            + "  \"continuityLoaded\": " + bool(continuity.continuityLoaded) + ",\n"
            + "  \"state\": \"session_ready\",\n"
            + "  \"source\": " + quote(source) + ",\n"
            + "  \"writtenAt\": " + quote(writtenAt);
        if (env.predecessorSessionId.length > 0) {
            json = json + ",\n  \"predecessorSessionId\": " + quote(env.predecessorSessionId);
        }
        return json + "\n}\n";
    }

    static function turnJson(env:CafReceiptEnv, conversationId:String, turnId:String, source:String, writtenAt:String, continuity:CafContinuity):String {
        var json = "{\n"
            + "  \"schema\": " + quote(turnSchema) + ",\n"
            + "  \"clientId\": " + quote(clientId) + ",\n"
            + "  \"runId\": " + quote(env.successorRunId) + ",\n"
            + "  \"conversationId\": " + quote(conversationId) + ",\n"
            + "  \"turnId\": " + quote(turnId) + ",\n"
            + "  \"actualContinuityMode\": " + quote(continuity.actualContinuityMode) + ",\n"
            + "  \"continuityLoaded\": " + bool(continuity.continuityLoaded) + ",\n"
            + "  \"state\": \"turn_started\",\n"
            + "  \"source\": " + quote(source) + ",\n"
            + "  \"writtenAt\": " + quote(writtenAt);
        if (env.predecessorSessionId.length > 0) {
            json = json + ",\n  \"predecessorSessionId\": " + quote(env.predecessorSessionId);
        }
        return json + "\n}\n";
    }

    static function continuityForSource(source:String):CafContinuity {
        return switch source {
            case "resume":
                CafContinuity.success("resume_same_conversation", true);
            case "startup" | "clear" | "compact":
                CafContinuity.success("fresh_unlinked", false);
            case _:
                CafContinuity.failure();
        }
    }

    static function writeReceipt(path:String, json:String):CafReceiptWriteOutcome {
        try {
            ensureDirectory(directoryOf(path));
            File.saveContent(path, json);
        } catch (e:Dynamic) {
            return CafReceiptWriteOutcome.failure("receipt_write_failed", "failed to write Caf receipt");
        }
        return CafReceiptWriteOutcome.written(path);
    }

    static function directoryOf(path:String):String {
        final normalized = StringTools.replace(path, "\\", "/");
        final parts = normalized.split("/");
        if (parts.length <= 1) return "";
        final limit = parts.length - 1;
        var directory = StringTools.startsWith(normalized, "/") ? "/" : "";
        var i = 0;
        while (i < limit) {
            final part = parts[i];
            if (part.length > 0) {
                if (directory == "/") {
                    directory = "/" + part;
                } else if (directory.length == 0) {
                    directory = part;
                } else {
                    directory = directory + "/" + part;
                }
            }
            i = i + 1;
        }
        return directory;
    }

    static function ensureDirectory(path:String):Void {
        if (path.length == 0 || FileSystem.exists(path)) return;
        final normalized = StringTools.replace(path, "\\", "/");
        final parts = normalized.split("/");
        var current = StringTools.startsWith(normalized, "/") ? "/" : "";
        for (part in parts) {
            if (part.length == 0) continue;
            if (current == "/") {
                current = "/" + part;
            } else if (current.length == 0) {
                current = part;
            } else {
                current = current + "/" + part;
            }
            if (!FileSystem.exists(current)) {
                FileSystem.createDirectory(current);
            }
        }
    }

    static function quote(value:String):String {
        return JsonScalar.quote(value);
    }

    static function bool(value:Bool):String {
        if (value) return "true";
        return "false";
    }
}

class CafContinuity {
    public final ok:Bool;
    public final actualContinuityMode:String;
    public final continuityLoaded:Bool;

    function new(ok:Bool, actualContinuityMode:String, continuityLoaded:Bool) {
        this.ok = ok;
        this.actualContinuityMode = actualContinuityMode;
        this.continuityLoaded = continuityLoaded;
    }

    public static function success(actualContinuityMode:String, continuityLoaded:Bool):CafContinuity {
        return new CafContinuity(true, actualContinuityMode, continuityLoaded);
    }

    public static function failure():CafContinuity {
        return new CafContinuity(false, "", false);
    }
}
