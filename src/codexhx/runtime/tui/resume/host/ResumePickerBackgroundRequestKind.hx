package codexhx.runtime.tui.resume.host;

enum abstract ResumePickerBackgroundRequestKind(String) to String {
	final Page = "page";
	final Preview = "preview";
	final Transcript = "transcript";
	final Frame = "frame";
	final Unknown = "unknown";
}
