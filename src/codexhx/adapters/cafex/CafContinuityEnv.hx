package codexhx.adapters.cafex;

import codexhx.protocol.JsonScalar;

class CafContinuityEnv {
    public final sessionReceiptPath:String;
    public final turnReceiptPath:String;
    public final successorRunId:String;
    public final predecessorSessionId:String;
    public final actualContinuityMode:String;
    public final continuityLoaded:Bool;
    public final receiptSource:String;

    function new(
        sessionReceiptPath:String,
        turnReceiptPath:String,
        successorRunId:String,
        predecessorSessionId:String,
        actualContinuityMode:String,
        continuityLoaded:Bool,
        receiptSource:String
    ) {
        this.sessionReceiptPath = sessionReceiptPath;
        this.turnReceiptPath = turnReceiptPath;
        this.successorRunId = successorRunId;
        this.predecessorSessionId = predecessorSessionId;
        this.actualContinuityMode = actualContinuityMode;
        this.continuityLoaded = continuityLoaded;
        this.receiptSource = receiptSource;
    }

    public static function parse(sessionReceiptPath:String, turnReceiptPath:String, successorRunId:String, predecessorSessionId:String):CafContinuityEnvParseOutcome {
        final successor = StringTools.trim(successorRunId);
        final predecessor = StringTools.trim(predecessorSessionId);

        if (successor.length == 0) return CafContinuityEnvParseOutcome.failure("missing_successor_run_id", "CAF_CODEX_SUCCESSOR_RUN_ID is required");
        if (!validMetadataAtom(successor)) return CafContinuityEnvParseOutcome.failure("invalid_successor_run_id", "CAF_CODEX_SUCCESSOR_RUN_ID contains unsupported characters");
        if (predecessor.length > 0 && !validMetadataAtom(predecessor)) {
            return CafContinuityEnvParseOutcome.failure("invalid_predecessor_session_id", "CAF_CODEX_PREDECESSOR_SESSION contains unsupported characters");
        }

        final loaded = predecessor.length > 0;
        return CafContinuityEnvParseOutcome.success(new CafContinuityEnv(
            sessionReceiptPath,
            turnReceiptPath,
            successor,
            predecessor,
            loaded ? "resume_same_conversation" : "fresh_unlinked",
            loaded,
            loaded ? "resume" : "startup"
        ));
    }

    public static function fromProcess():CafContinuityEnvParseOutcome {
        return parse(env("CAF_CODEX_SESSION_RECEIPT_PATH"), env("CAF_CODEX_TURN_RECEIPT_PATH"), env("CAF_CODEX_SUCCESSOR_RUN_ID"), env("CAF_CODEX_PREDECESSOR_SESSION"));
    }

    public function toReceiptEnv():CafReceiptEnv {
        return new CafReceiptEnv(sessionReceiptPath, turnReceiptPath, successorRunId, predecessorSessionId);
    }

    public function metadataJson():String {
        return "{"
            + "\"schema\":\"codex-hxrust.caf-continuity-metadata.v1\""
            + ",\"successorRunId\":" + quote(successorRunId)
            + ",\"predecessorSessionId\":" + quote(predecessorSessionId)
            + ",\"actualContinuityMode\":" + quote(actualContinuityMode)
            + ",\"continuityLoaded\":" + bool(continuityLoaded)
            + ",\"receiptSource\":" + quote(receiptSource)
            + "}";
    }

    static function validMetadataAtom(value:String):Bool {
        var i = 0;
        while (i < value.length) {
            final char = value.charAt(i);
            if (char == " " || char == "\n" || char == "\r" || char == "\t") return false;
            if (char == "/" || char == "\\" || char == "\"" || char == "'") return false;
            i = i + 1;
        }
        return true;
    }

    static function env(name:String):String {
        final value = Sys.getEnv(name);
        if (value == null) return "";
        return value;
    }

    static function quote(value:String):String {
        return JsonScalar.quote(value);
    }

    static function bool(value:Bool):String {
        if (value) return "true";
        return "false";
    }
}
