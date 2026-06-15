package codexhx.runtime.model.streamitem;

enum abstract ModelKeymapFixedShortcutActionKind(String) to String {
	final GlobalCopy = "global_copy";
	final ChatIncreaseReasoningEffort = "chat_increase_reasoning_effort";
	final Unknown = "unknown";

	public static function fromString(value:String):ModelKeymapFixedShortcutActionKind {
		return switch value {
			case "global_copy": GlobalCopy;
			case "chat_increase_reasoning_effort": ChatIncreaseReasoningEffort;
			case _: Unknown;
		}
	}
}
