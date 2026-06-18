package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeHooksBrowserActionKind(String) to String {
	final OpenBrowser = "open_browser";
	final RenderEvents = "render_events";
	final MoveSelection = "move_selection";
	final OpenEvent = "open_event";
	final ReturnToEvents = "return_to_events";
	final RenderHandlers = "render_handlers";
	final ToggleHook = "toggle_hook";
	final TrustHook = "trust_hook";
	final TrustAll = "trust_all";
	final ManagedNoOp = "managed_no_op";
	final ReviewNoOp = "review_no_op";
	final Close = "close";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeHooksBrowserActionKind {
		return switch value {
			case "open_browser": OpenBrowser;
			case "render_events": RenderEvents;
			case "move_selection": MoveSelection;
			case "open_event": OpenEvent;
			case "return_to_events": ReturnToEvents;
			case "render_handlers": RenderHandlers;
			case "toggle_hook": ToggleHook;
			case "trust_hook": TrustHook;
			case "trust_all": TrustAll;
			case "managed_no_op": ManagedNoOp;
			case "review_no_op": ReviewNoOp;
			case "close": Close;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
