package codexhx.runtime.model.streamitem;

enum abstract ModelKeymapMainSurfaceActionKind(String) to String {
	final ClearTerminal = "clear_terminal";
	final ToggleFastMode = "toggle_fast_mode";
	final InterruptTurn = "interrupt_turn";
	final DecreaseReasoningEffort = "decrease_reasoning_effort";
	final IncreaseReasoningEffort = "increase_reasoning_effort";
	final Unknown = "unknown";

	public static function fromString(value:String):ModelKeymapMainSurfaceActionKind {
		return switch value {
			case "clear_terminal": ClearTerminal;
			case "toggle_fast_mode": ToggleFastMode;
			case "interrupt_turn": InterruptTurn;
			case "decrease_reasoning_effort": DecreaseReasoningEffort;
			case "increase_reasoning_effort": IncreaseReasoningEffort;
			case _: Unknown;
		}
	}
}
