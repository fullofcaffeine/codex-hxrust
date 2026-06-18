package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeTerminalModeActionKind(String) to String {
	final Init = "init";
	final SetModes = "set_modes";
	final Restore = "restore";
	final RestoreAfterExit = "restore_after_exit";
	final RestoreKeepRaw = "restore_keep_raw";
	final KeyboardDecision = "keyboard_decision";
	final KeyboardPush = "keyboard_push";
	final KeyboardPop = "keyboard_pop";
	final KeyboardReset = "keyboard_reset";
	final ModifyOtherKeys = "modify_other_keys";
	final FlushInput = "flush_input";
	final PanicHook = "panic_hook";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeTerminalModeActionKind {
		return switch value {
			case "init": Init;
			case "set_modes": SetModes;
			case "restore": Restore;
			case "restore_after_exit": RestoreAfterExit;
			case "restore_keep_raw": RestoreKeepRaw;
			case "keyboard_decision": KeyboardDecision;
			case "keyboard_push": KeyboardPush;
			case "keyboard_pop": KeyboardPop;
			case "keyboard_reset": KeyboardReset;
			case "modify_other_keys": ModifyOtherKeys;
			case "flush_input": FlushInput;
			case "panic_hook": PanicHook;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
