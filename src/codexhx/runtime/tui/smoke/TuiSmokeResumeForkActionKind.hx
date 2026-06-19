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
	final PickerTranscriptOpen = "picker_transcript_open";
	final PickerTranscriptRequest = "picker_transcript_request";
	final PickerTranscriptLoadingFrame = "picker_transcript_loading_frame";
	final PickerTranscriptComplete = "picker_transcript_complete";
	final PickerTranscriptOverlayOpen = "picker_transcript_overlay_open";
	final PickerKeyboardMove = "picker_keyboard_move";
	final PickerQueryClear = "picker_query_clear";
	final PickerLoadMoreTrigger = "picker_load_more_trigger";
	final PickerTranscriptLoadingKey = "picker_transcript_loading_key";
	final PickerOverlayClose = "picker_overlay_close";
	final PickerMetadataFailure = "picker_metadata_failure";
	final PickerDensityToggle = "picker_density_toggle";
	final PickerToolbarFocus = "picker_toolbar_focus";
	final PickerToolbarActivate = "picker_toolbar_activate";
	final PickerToolbarRender = "picker_toolbar_render";
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
			case "picker_transcript_open": PickerTranscriptOpen;
			case "picker_transcript_request": PickerTranscriptRequest;
			case "picker_transcript_loading_frame": PickerTranscriptLoadingFrame;
			case "picker_transcript_complete": PickerTranscriptComplete;
			case "picker_transcript_overlay_open": PickerTranscriptOverlayOpen;
			case "picker_keyboard_move": PickerKeyboardMove;
			case "picker_query_clear": PickerQueryClear;
			case "picker_load_more_trigger": PickerLoadMoreTrigger;
			case "picker_transcript_loading_key": PickerTranscriptLoadingKey;
			case "picker_overlay_close": PickerOverlayClose;
			case "picker_metadata_failure": PickerMetadataFailure;
			case "picker_density_toggle": PickerDensityToggle;
			case "picker_toolbar_focus": PickerToolbarFocus;
			case "picker_toolbar_activate": PickerToolbarActivate;
			case "picker_toolbar_render": PickerToolbarRender;
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
