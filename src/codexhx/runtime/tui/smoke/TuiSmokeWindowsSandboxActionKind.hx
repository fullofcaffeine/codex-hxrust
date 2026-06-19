package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeWindowsSandboxActionKind(String) to String {
	final ModeAllowed = "mode_allowed";
	final SetupRequired = "setup_required";
	final EnablePrompt = "enable_prompt";
	final FallbackPrompt = "fallback_prompt";
	final StartupPrompt = "startup_prompt";
	final InitialPromptGate = "initial_prompt_gate";
	final WorldWritableWarning = "world_writable_warning";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeWindowsSandboxActionKind {
		return switch value {
			case "mode_allowed": ModeAllowed;
			case "setup_required": SetupRequired;
			case "enable_prompt": EnablePrompt;
			case "fallback_prompt": FallbackPrompt;
			case "startup_prompt": StartupPrompt;
			case "initial_prompt_gate": InitialPromptGate;
			case "world_writable_warning": WorldWritableWarning;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
