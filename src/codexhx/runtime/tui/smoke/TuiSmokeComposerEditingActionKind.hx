package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeComposerEditingActionKind(String) to String {
	final RouteKey = "route_key";
	final RemoteSelection = "remote_selection";
	final ClearRemoteSelection = "clear_remote_selection";
	final BashEscape = "bash_escape";
	final VimTransition = "vim_transition";
	final VimNormalShortcut = "vim_normal_shortcut";
	final QueueKey = "queue_key";
	final SubmitKey = "submit_key";
	final HistoryNavigate = "history_navigate";
	final BasicInput = "basic_input";
	final TextareaRoute = "textarea_route";
	final CurrentImport = "current_import";
	final ExternalEdit = "external_edit";
	final ImageSubmit = "image_submit";
	final ImagePlaceholderEdit = "image_placeholder_edit";
	final ImagePathPaste = "image_path_paste";
	final FilePopupSelect = "file_popup_select";
	final PasteBurstFlush = "paste_burst_flush";
	final ReconcileElements = "reconcile_elements";
	final ShortcutOverlay = "shortcut_overlay";
	final CtrlD = "ctrl_d";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeComposerEditingActionKind {
		return switch value {
			case "route_key": RouteKey;
			case "remote_selection": RemoteSelection;
			case "clear_remote_selection": ClearRemoteSelection;
			case "bash_escape": BashEscape;
			case "vim_transition": VimTransition;
			case "vim_normal_shortcut": VimNormalShortcut;
			case "queue_key": QueueKey;
			case "submit_key": SubmitKey;
			case "history_navigate": HistoryNavigate;
			case "basic_input": BasicInput;
			case "textarea_route": TextareaRoute;
			case "current_import": CurrentImport;
			case "external_edit": ExternalEdit;
			case "image_submit": ImageSubmit;
			case "image_placeholder_edit": ImagePlaceholderEdit;
			case "image_path_paste": ImagePathPaste;
			case "file_popup_select": FilePopupSelect;
			case "paste_burst_flush": PasteBurstFlush;
			case "reconcile_elements": ReconcileElements;
			case "shortcut_overlay": ShortcutOverlay;
			case "ctrl_d": CtrlD;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
