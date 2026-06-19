package codexhx.runtime.tui.resume.host;

enum abstract ResumePickerHostEventKind(String) to String {
	final PageLoaded = "page_loaded";
	final PreviewLoaded = "preview_loaded";
	final TranscriptLoaded = "transcript_loaded";
	final FrameRequested = "frame_requested";
	final DensityPersisted = "density_persisted";
	final Rendered = "rendered";
	final Failed = "failed";
	final Unknown = "unknown";
}
