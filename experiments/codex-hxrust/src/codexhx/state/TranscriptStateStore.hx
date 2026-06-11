package codexhx.state;

import codexhx.protocol.JsonScalar;
import codexhx.protocol.json.CodexJson;
import codexhx.runtime.session.OneTurnSessionOutcome;
import sys.FileSystem;
import sys.io.File;

class TranscriptStateStore {
    static inline final stateSchema = "codex-hxrust.state.one-turn.v1";

    public static function writeOneTurn(baseDir:String, outcome:OneTurnSessionOutcome):StateWriteOutcome {
        final transcriptPath = baseDir + "/transcript.jsonl";
        final statePath = baseDir + "/state.json";

        try {
            ensureDirectory(baseDir);
            writeAtomically(transcriptPath, transcriptJsonl(outcome));
            writeAtomically(statePath, stateJson(outcome));
        } catch (e:Dynamic) {
            return StateWriteOutcome.failure("state_write_failed", "failed to write transcript/state artifacts");
        }

        return StateWriteOutcome.success(transcriptPath, statePath);
    }

    public static function loadState(path:String):StateLoadOutcome {
        final content = try {
            File.getContent(path);
        } catch (e:Dynamic) {
            return StateLoadOutcome.failure("state_read_failed", "$.path", "state file could not be read");
        }

        final parsed = try {
            CodexJson.parse(content);
        } catch (e:Dynamic) {
            return StateLoadOutcome.failure("invalid_state_json", "$", "state file is not valid JSON");
        }

        if (!parsed.ok) {
            return StateLoadOutcome.failure("invalid_state_json", "$", "state file is not valid JSON");
        }

        return StateLoadOutcome.success(content);
    }

    public static function transcriptJsonl(outcome:OneTurnSessionOutcome):String {
        final lines:Array<String> = [];
        for (event in outcome.events) {
            lines.push(event.canonicalJson());
        }
        return lines.join("\n") + "\n";
    }

    public static function stateJson(outcome:OneTurnSessionOutcome):String {
        return "{"
            + "\"assistantText\":" + JsonScalar.quote(outcome.assistantText)
            + ",\"eventCount\":" + Std.string(outcome.events.length)
            + ",\"schema\":" + JsonScalar.quote(stateSchema)
            + ",\"streamId\":" + JsonScalar.quote(outcome.streamId)
            + ",\"terminalState\":" + JsonScalar.quote(outcome.terminalState)
            + "}\n";
    }

    static function writeAtomically(path:String, content:String):Void {
        final tmpPath = path + ".tmp";
        File.saveContent(tmpPath, content);
        if (FileSystem.exists(path)) {
            FileSystem.deleteFile(path);
        }
        FileSystem.rename(tmpPath, path);
    }

    static function ensureDirectory(path:String):Void {
        if (!FileSystem.exists(path)) {
            FileSystem.createDirectory(path);
        }
    }
}
