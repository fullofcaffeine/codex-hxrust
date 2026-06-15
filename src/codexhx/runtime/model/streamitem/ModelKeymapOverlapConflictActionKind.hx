package codexhx.runtime.model.streamitem;

enum abstract ModelKeymapOverlapConflictActionKind(String) to String {
	final ListMoveUp = "list_move_up";
	final ListPageUp = "list_page_up";
	final ListJumpTop = "list_jump_top";
	final GlobalCopy = "global_copy";
	final ApprovalApprove = "approval_approve";
	final VimNormalMoveLeft = "vim_normal_move_left";
	final VimNormalStartChangeOperator = "vim_normal_start_change_operator";
	final VimNormalSubstituteChar = "vim_normal_substitute_char";
	final Unknown = "unknown";

	public static function fromString(value:String):ModelKeymapOverlapConflictActionKind {
		return switch value {
			case "list_move_up": ListMoveUp;
			case "list_page_up": ListPageUp;
			case "list_jump_top": ListJumpTop;
			case "global_copy": GlobalCopy;
			case "approval_approve": ApprovalApprove;
			case "vim_normal_move_left": VimNormalMoveLeft;
			case "vim_normal_start_change_operator": VimNormalStartChangeOperator;
			case "vim_normal_substitute_char": VimNormalSubstituteChar;
			case _: Unknown;
		}
	}
}
