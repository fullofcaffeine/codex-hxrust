package codexhx.runtime.tui;

enum abstract TuiStoryKind(String) from String to String {
    var Provenance = "provenance";
    var SessionStart = "session_start";
    var SessionEnd = "session_end";
    var AppEvent = "app_event";
    var KeyEvent = "key_event";
    var CodexEvent = "codex_event";
    var InsertHistory = "insert_history";
    var Operation = "op";

    public static function isValid(value:String):Bool {
        return value == SessionStart
            || value == SessionEnd
            || value == AppEvent
            || value == KeyEvent
            || value == CodexEvent
            || value == InsertHistory
            || value == Operation;
    }
}
