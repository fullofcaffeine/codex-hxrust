package codexhx.runtime.tui.resume.live;

enum abstract ResumePickerNoCredentialKeyKind(String) to String {
	final Down = "down";
	final OpenTranscript = "open_transcript";
	final ToggleDensity = "toggle_density";
	final Unknown = "unknown";
}
