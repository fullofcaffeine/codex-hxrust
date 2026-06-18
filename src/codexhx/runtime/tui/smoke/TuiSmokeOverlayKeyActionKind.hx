package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeOverlayKeyActionKind(String) to String {
	final ScrollUp = "scroll_up";
	final ScrollDown = "scroll_down";
	final PageUp = "page_up";
	final PageDown = "page_down";
	final HalfPageUp = "half_page_up";
	final HalfPageDown = "half_page_down";
	final JumpTop = "jump_top";
	final JumpBottom = "jump_bottom";
	final Close = "close";
	final CloseTranscript = "close_transcript";
	final BacktrackPreview = "backtrack_preview";
	final BacktrackStep = "backtrack_step";
	final BacktrackForward = "backtrack_forward";
	final BacktrackConfirm = "backtrack_confirm";
	final Ignored = "ignored";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeOverlayKeyActionKind {
		return switch value {
			case "scroll_up": ScrollUp;
			case "scroll_down": ScrollDown;
			case "page_up": PageUp;
			case "page_down": PageDown;
			case "half_page_up": HalfPageUp;
			case "half_page_down": HalfPageDown;
			case "jump_top": JumpTop;
			case "jump_bottom": JumpBottom;
			case "close": Close;
			case "close_transcript": CloseTranscript;
			case "backtrack_preview": BacktrackPreview;
			case "backtrack_step": BacktrackStep;
			case "backtrack_forward": BacktrackForward;
			case "backtrack_confirm": BacktrackConfirm;
			case "ignored": Ignored;
			case _: Unknown;
		}
	}
}
