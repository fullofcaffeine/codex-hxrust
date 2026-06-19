package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeChatWidgetComposerRenderActionKind(String) to String {
	final Composition = "composition";
	final BottomPaneDelegate = "bottom_pane_delegate";
	final TranscriptArea = "transcript_area";
	final Cursor = "cursor";
	final InputResult = "input_result";
	final QueuePreview = "queue_preview";
	final InputQueueState = "input_queue_state";
	final InputQueueClear = "input_queue_clear";
	final QueueDrainGate = "queue_drain_gate";
	final Frame = "frame";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeChatWidgetComposerRenderActionKind {
		return switch value {
			case "composition": Composition;
			case "bottom_pane_delegate": BottomPaneDelegate;
			case "transcript_area": TranscriptArea;
			case "cursor": Cursor;
			case "input_result": InputResult;
			case "queue_preview": QueuePreview;
			case "input_queue_state": InputQueueState;
			case "input_queue_clear": InputQueueClear;
			case "queue_drain_gate": QueueDrainGate;
			case "frame": Frame;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
