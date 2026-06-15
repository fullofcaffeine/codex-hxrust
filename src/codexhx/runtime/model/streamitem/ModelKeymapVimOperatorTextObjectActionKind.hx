package codexhx.runtime.model.streamitem;

enum abstract ModelKeymapVimOperatorTextObjectActionKind(String) to String {
	final VimOperatorMotionLeft = "vim_operator_motion_left";
	final VimOperatorMotionRight = "vim_operator_motion_right";
	final VimOperatorSelectInnerTextObject = "vim_operator_select_inner_text_object";
	final VimOperatorSelectAroundTextObject = "vim_operator_select_around_text_object";
	final Unknown = "unknown";

	public static function fromString(value:String):ModelKeymapVimOperatorTextObjectActionKind {
		return switch value {
			case "vim_operator_motion_left": VimOperatorMotionLeft;
			case "vim_operator_motion_right": VimOperatorMotionRight;
			case "vim_operator_select_inner_text_object": VimOperatorSelectInnerTextObject;
			case "vim_operator_select_around_text_object": VimOperatorSelectAroundTextObject;
			case _: Unknown;
		}
	}
}
