package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeResumeForkActionKind(String) to String {
	final PickerOpen = "picker_open";
	final PickerSelection = "picker_selection";
	final Lookup = "lookup";
	final StartupGate = "startup_gate";
	final ResumeRequest = "resume_request";
	final ResumeAttach = "resume_attach";
	final SameThreadNoOp = "same_thread_noop";
	final ForkRequest = "fork_request";
	final ForkAttach = "fork_attach";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeResumeForkActionKind {
		return switch value {
			case "picker_open": PickerOpen;
			case "picker_selection": PickerSelection;
			case "lookup": Lookup;
			case "startup_gate": StartupGate;
			case "resume_request": ResumeRequest;
			case "resume_attach": ResumeAttach;
			case "same_thread_noop": SameThreadNoOp;
			case "fork_request": ForkRequest;
			case "fork_attach": ForkAttach;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
