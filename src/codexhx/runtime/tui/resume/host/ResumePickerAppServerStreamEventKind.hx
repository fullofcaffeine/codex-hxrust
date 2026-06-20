package codexhx.runtime.tui.resume.host;

enum abstract ResumePickerAppServerStreamEventKind(String) to String {
	final PageResult = "page_result";
	final ReadResult = "read_result";
	final ReadError = "read_error";
	final FrameRequested = "frame_requested";
	final Disconnected = "disconnected";
	final Lagged = "lagged";
	final Unknown = "unknown";
}
