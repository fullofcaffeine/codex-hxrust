package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeComposerPopupKeyActionKind(String) to String {
	final Dispatch = "dispatch";
	final ShortcutOverlay = "shortcut_overlay";
	final FooterEscHint = "footer_esc_hint";
	final MoveSelection = "move_selection";
	final Dismiss = "dismiss";
	final CompleteCommand = "complete_command";
	final DispatchCommand = "dispatch_command";
	final AcceptFile = "accept_file";
	final AcceptImage = "accept_image";
	final AcceptMention = "accept_mention";
	final SwitchMentionMode = "switch_mention_mode";
	final AcceptMentionsV2File = "accept_mentions_v2_file";
	final AcceptMentionsV2Tool = "accept_mentions_v2_tool";
	final FallbackEnter = "fallback_enter";
	final BasicInput = "basic_input";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeComposerPopupKeyActionKind {
		return switch value {
			case "dispatch": Dispatch;
			case "shortcut_overlay": ShortcutOverlay;
			case "footer_esc_hint": FooterEscHint;
			case "move_selection": MoveSelection;
			case "dismiss": Dismiss;
			case "complete_command": CompleteCommand;
			case "dispatch_command": DispatchCommand;
			case "accept_file": AcceptFile;
			case "accept_image": AcceptImage;
			case "accept_mention": AcceptMention;
			case "switch_mention_mode": SwitchMentionMode;
			case "accept_mentions_v2_file": AcceptMentionsV2File;
			case "accept_mentions_v2_tool": AcceptMentionsV2Tool;
			case "fallback_enter": FallbackEnter;
			case "basic_input": BasicInput;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
