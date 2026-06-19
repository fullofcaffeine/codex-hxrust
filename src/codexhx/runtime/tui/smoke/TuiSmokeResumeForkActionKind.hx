package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeResumeForkActionKind(String) to String {
	final PickerOpen = "picker_open";
	final PickerPageRequest = "picker_page_request";
	final PickerPageIngest = "picker_page_ingest";
	final PickerSearchContinue = "picker_search_continue";
	final PickerSortToggle = "picker_sort_toggle";
	final PickerFilterToggle = "picker_filter_toggle";
	final PickerPreviewToggle = "picker_preview_toggle";
	final PickerPreviewRequest = "picker_preview_request";
	final PickerPreviewComplete = "picker_preview_complete";
	final PickerPreviewRender = "picker_preview_render";
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
			case "picker_page_request": PickerPageRequest;
			case "picker_page_ingest": PickerPageIngest;
			case "picker_search_continue": PickerSearchContinue;
			case "picker_sort_toggle": PickerSortToggle;
			case "picker_filter_toggle": PickerFilterToggle;
			case "picker_preview_toggle": PickerPreviewToggle;
			case "picker_preview_request": PickerPreviewRequest;
			case "picker_preview_complete": PickerPreviewComplete;
			case "picker_preview_render": PickerPreviewRender;
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
