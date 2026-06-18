package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeComposerFooterRenderActionKind(String) to String {
	final Props = "props";
	final Height = "height";
	final PassiveStatus = "passive_status";
	final ShortcutOverlay = "shortcut_overlay";
	final QuitShortcut = "quit_shortcut";
	final EscHint = "esc_hint";
	final FooterFallback = "footer_fallback";
	final StatusLine = "status_line";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeComposerFooterRenderActionKind {
		return switch value {
			case "props": Props;
			case "height": Height;
			case "passive_status": PassiveStatus;
			case "shortcut_overlay": ShortcutOverlay;
			case "quit_shortcut": QuitShortcut;
			case "esc_hint": EscHint;
			case "footer_fallback": FooterFallback;
			case "status_line": StatusLine;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
