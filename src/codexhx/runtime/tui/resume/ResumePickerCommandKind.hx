package codexhx.runtime.tui.resume;

enum abstract ResumePickerCommandKind(String) to String {
	final PickerOpen = "picker_open";
	final PageRequest = "picker_page_request";
	final PageIngest = "picker_page_ingest";
	final SearchContinue = "picker_search_continue";
	final SortToggle = "picker_sort_toggle";
	final FilterToggle = "picker_filter_toggle";
	final PreviewToggle = "picker_preview_toggle";
	final PreviewRequest = "picker_preview_request";
	final PreviewComplete = "picker_preview_complete";
	final PreviewRender = "picker_preview_render";
	final TranscriptOpen = "picker_transcript_open";
	final TranscriptRequest = "picker_transcript_request";
	final TranscriptLoadingFrame = "picker_transcript_loading_frame";
	final TranscriptComplete = "picker_transcript_complete";
	final TranscriptOverlayOpen = "picker_transcript_overlay_open";
	final KeyboardMove = "picker_keyboard_move";
	final QueryClear = "picker_query_clear";
	final LoadMoreTrigger = "picker_load_more_trigger";
	final TranscriptLoadingKey = "picker_transcript_loading_key";
	final OverlayClose = "picker_overlay_close";
	final MetadataFailure = "picker_metadata_failure";
	final DensityToggle = "picker_density_toggle";
	final ToolbarFocus = "picker_toolbar_focus";
	final ToolbarActivate = "picker_toolbar_activate";
	final ToolbarRender = "picker_toolbar_render";
	final FooterProgress = "picker_footer_progress";
	final FooterHints = "picker_footer_hints";
	final ListRenderState = "picker_list_render_state";
	final EmptyState = "picker_empty_state";
	final TranscriptLoadingOverlay = "picker_transcript_loading_overlay";
	final Selection = "picker_selection";
	final Failure = "failure";
	final Other = "other";
	final Unknown = "unknown";

	public static function fromString(value:String):ResumePickerCommandKind {
		return switch value {
			case "picker_open": PickerOpen;
			case "picker_page_request": PageRequest;
			case "picker_page_ingest": PageIngest;
			case "picker_search_continue": SearchContinue;
			case "picker_sort_toggle": SortToggle;
			case "picker_filter_toggle": FilterToggle;
			case "picker_preview_toggle": PreviewToggle;
			case "picker_preview_request": PreviewRequest;
			case "picker_preview_complete": PreviewComplete;
			case "picker_preview_render": PreviewRender;
			case "picker_transcript_open": TranscriptOpen;
			case "picker_transcript_request": TranscriptRequest;
			case "picker_transcript_loading_frame": TranscriptLoadingFrame;
			case "picker_transcript_complete": TranscriptComplete;
			case "picker_transcript_overlay_open": TranscriptOverlayOpen;
			case "picker_keyboard_move": KeyboardMove;
			case "picker_query_clear": QueryClear;
			case "picker_load_more_trigger": LoadMoreTrigger;
			case "picker_transcript_loading_key": TranscriptLoadingKey;
			case "picker_overlay_close": OverlayClose;
			case "picker_metadata_failure": MetadataFailure;
			case "picker_density_toggle": DensityToggle;
			case "picker_toolbar_focus": ToolbarFocus;
			case "picker_toolbar_activate": ToolbarActivate;
			case "picker_toolbar_render": ToolbarRender;
			case "picker_footer_progress": FooterProgress;
			case "picker_footer_hints": FooterHints;
			case "picker_list_render_state": ListRenderState;
			case "picker_empty_state": EmptyState;
			case "picker_transcript_loading_overlay": TranscriptLoadingOverlay;
			case "picker_selection": Selection;
			case "failure": Failure;
			case "lookup" | "startup_gate" | "resume_request" | "resume_attach" | "same_thread_noop" | "fork_request" | "fork_attach": Other;
			case _: Unknown;
		}
	}
}
