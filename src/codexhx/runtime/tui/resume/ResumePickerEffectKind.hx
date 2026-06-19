package codexhx.runtime.tui.resume;

enum abstract ResumePickerEffectKind(String) to String {
	final RequestPage = "request_page";
	final RequestPreview = "request_preview";
	final RequestTranscript = "request_transcript";
	final RequestFrame = "request_frame";
	final PersistDensity = "persist_density";
	final ResetPage = "reset_page";
	final LoadMore = "load_more";
	final StartFresh = "start_fresh";
	final OpenTranscriptOverlay = "open_transcript_overlay";
	final SurfaceError = "surface_error";
	final Unknown = "unknown";
}
