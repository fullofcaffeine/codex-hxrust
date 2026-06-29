package codexhx.runtime.tui.chatwidget;

/**
	Single rendered transcript row in the minimal ChatWidget shell.
**/
class ChatWidgetTranscriptRow {
	public final role:ChatWidgetTranscriptRole;
	public final text:String;

	public function new(role:ChatWidgetTranscriptRole, text:String) {
		this.role = role;
		this.text = text == null ? "" : text;
	}

	public function renderText():String {
		return rolePrefix(role) + text;
	}

	public static function rolePrefix(role:ChatWidgetTranscriptRole):String {
		return switch role {
			case User:
				"user> ";
			case Assistant:
				"assistant> ";
			case System:
				"system> ";
		}
	}
}
