package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeComposerPopupRenderActionKind(String) to String {
	final Layout = "layout";
	final RenderDispatch = "render_dispatch";
	final RenderRows = "render_rows";
	final EmptyState = "empty_state";
	final FooterHint = "footer_hint";
	final ScrollWindow = "scroll_window";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeComposerPopupRenderActionKind {
		return switch value {
			case "layout": Layout;
			case "render_dispatch": RenderDispatch;
			case "render_rows": RenderRows;
			case "empty_state": EmptyState;
			case "footer_hint": FooterHint;
			case "scroll_window": ScrollWindow;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
