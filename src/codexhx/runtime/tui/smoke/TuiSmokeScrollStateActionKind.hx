package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeScrollStateActionKind(String) to String {
	final Reset = "reset";
	final SetState = "set_state";
	final ClampSelection = "clamp_selection";
	final MoveUpWrap = "move_up_wrap";
	final MoveDownWrap = "move_down_wrap";
	final PageUpClamped = "page_up_clamped";
	final PageDownClamped = "page_down_clamped";
	final JumpTop = "jump_top";
	final JumpBottom = "jump_bottom";
	final EnsureVisible = "ensure_visible";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeScrollStateActionKind {
		return switch value {
			case "reset": Reset;
			case "set_state": SetState;
			case "clamp_selection": ClampSelection;
			case "move_up_wrap": MoveUpWrap;
			case "move_down_wrap": MoveDownWrap;
			case "page_up_clamped": PageUpClamped;
			case "page_down_clamped": PageDownClamped;
			case "jump_top": JumpTop;
			case "jump_bottom": JumpBottom;
			case "ensure_visible": EnsureVisible;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
