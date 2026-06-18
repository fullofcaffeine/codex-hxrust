package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeChatWidgetComposerRenderActionKind(String) to String {
	final Composition = "composition";
	final BottomPaneDelegate = "bottom_pane_delegate";
	final TranscriptArea = "transcript_area";
	final Cursor = "cursor";
	final InputResult = "input_result";
	final QueuePreview = "queue_preview";
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
			case "frame": Frame;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
