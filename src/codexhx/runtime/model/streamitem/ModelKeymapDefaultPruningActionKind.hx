package codexhx.runtime.model.streamitem;

enum abstract ModelKeymapDefaultPruningActionKind(String) to String {
	final EditQueuedMessage = "edit_queued_message";
	final HistorySearchPrevious = "history_search_previous";
	final HistorySearchNext = "history_search_next";
	final KillWholeLine = "kill_whole_line";
	final ListMoveUp = "list_move_up";
	final ListMoveDown = "list_move_down";
	final ListMoveLeft = "list_move_left";
	final ListMoveRight = "list_move_right";
	final ListPageUp = "list_page_up";
	final ListPageDown = "list_page_down";
	final ListJumpTop = "list_jump_top";
	final ListJumpBottom = "list_jump_bottom";
	final EditorMoveUp = "editor_move_up";
	final VimTextObjectWord = "vim_text_object_word";
	final ChatDecreaseReasoningEffort = "chat_decrease_reasoning_effort";
	final ChatIncreaseReasoningEffort = "chat_increase_reasoning_effort";
	final Unknown = "unknown";

	public static function fromString(value:String):ModelKeymapDefaultPruningActionKind {
		return switch value {
			case "edit_queued_message": EditQueuedMessage;
			case "history_search_previous": HistorySearchPrevious;
			case "history_search_next": HistorySearchNext;
			case "kill_whole_line": KillWholeLine;
			case "list_move_up": ListMoveUp;
			case "list_move_down": ListMoveDown;
			case "list_move_left": ListMoveLeft;
			case "list_move_right": ListMoveRight;
			case "list_page_up": ListPageUp;
			case "list_page_down": ListPageDown;
			case "list_jump_top": ListJumpTop;
			case "list_jump_bottom": ListJumpBottom;
			case "editor_move_up": EditorMoveUp;
			case "vim_text_object_word": VimTextObjectWord;
			case "chat_decrease_reasoning_effort": ChatDecreaseReasoningEffort;
			case "chat_increase_reasoning_effort": ChatIncreaseReasoningEffort;
			case _: Unknown;
		}
	}
}
