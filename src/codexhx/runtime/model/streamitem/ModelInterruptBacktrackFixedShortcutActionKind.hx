package codexhx.runtime.model.streamitem;

enum abstract ModelInterruptBacktrackFixedShortcutActionKind(String) to String {
	final ChatInterruptTurn = "chat_interrupt_turn";
	final FixedPasteImage = "fixed_paste_image";
	final Unknown = "unknown";

	public static function fromString(value:String):ModelInterruptBacktrackFixedShortcutActionKind {
		return switch value {
			case "chat_interrupt_turn": ChatInterruptTurn;
			case "fixed_paste_image": FixedPasteImage;
			case _: Unknown;
		}
	}
}
