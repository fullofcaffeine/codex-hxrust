package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeTextAreaActionKind(String) to String {
	final ReplaceClear = "replace_clear";
	final ReplaceElements = "replace_elements";
	final InsertReplace = "insert_replace";
	final CursorBoundary = "cursor_boundary";
	final KillPreserve = "kill_preserve";
	final PasteBurstMode = "paste_burst_mode";
	final WrapCursor = "wrap_cursor";
	final DeleteEdges = "delete_edges";
	final ElementDelete = "element_delete";
	final WordDelete = "word_delete";
	final KillLine = "kill_line";
	final YankRestore = "yank_restore";
	final CursorMove = "cursor_move";
	final VimEditing = "vim_editing";
	final VimTextObjects = "vim_text_objects";
	final VimTextObjectGuards = "vim_text_object_guards";
	final VimWordEnd = "vim_word_end";
	final ElementMutation = "element_mutation";
	final ElementRange = "element_range";
	final ElementBoundary = "element_boundary";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeTextAreaActionKind {
		return switch value {
			case "replace_clear": ReplaceClear;
			case "replace_elements": ReplaceElements;
			case "insert_replace": InsertReplace;
			case "cursor_boundary": CursorBoundary;
			case "kill_preserve": KillPreserve;
			case "paste_burst_mode": PasteBurstMode;
			case "wrap_cursor": WrapCursor;
			case "delete_edges": DeleteEdges;
			case "element_delete": ElementDelete;
			case "word_delete": WordDelete;
			case "kill_line": KillLine;
			case "yank_restore": YankRestore;
			case "cursor_move": CursorMove;
			case "vim_editing": VimEditing;
			case "vim_text_objects": VimTextObjects;
			case "vim_text_object_guards": VimTextObjectGuards;
			case "vim_word_end": VimWordEnd;
			case "element_mutation": ElementMutation;
			case "element_range": ElementRange;
			case "element_boundary": ElementBoundary;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
