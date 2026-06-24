package codexhx.validation.tui.resume.live;

enum abstract NoCredentialKeyKind(String) to String {
	final Down = "down";
	final OpenTranscript = "open_transcript";
	final ToggleDensity = "toggle_density";
	final Unknown = "unknown";
}
