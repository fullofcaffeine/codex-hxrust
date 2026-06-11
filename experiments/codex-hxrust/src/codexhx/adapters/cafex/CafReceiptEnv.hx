package codexhx.adapters.cafex;

class CafReceiptEnv {
    public final sessionReceiptPath:String;
    public final turnReceiptPath:String;
    public final successorRunId:String;
    public final predecessorSessionId:String;

    public function new(sessionReceiptPath:String, turnReceiptPath:String, successorRunId:String, predecessorSessionId:String) {
        this.sessionReceiptPath = sessionReceiptPath;
        this.turnReceiptPath = turnReceiptPath;
        this.successorRunId = successorRunId;
        this.predecessorSessionId = predecessorSessionId;
    }

    public static function empty():CafReceiptEnv {
        return new CafReceiptEnv("", "", "", "");
    }

    public static function fromProcess():CafReceiptEnv {
        return new CafReceiptEnv(
            env("CAF_CODEX_SESSION_RECEIPT_PATH"),
            env("CAF_CODEX_TURN_RECEIPT_PATH"),
            env("CAF_CODEX_SUCCESSOR_RUN_ID"),
            env("CAF_CODEX_PREDECESSOR_SESSION")
        );
    }

    static function env(name:String):String {
        final value = Sys.getEnv(name);
        if (value == null) return "";
        return value;
    }
}
