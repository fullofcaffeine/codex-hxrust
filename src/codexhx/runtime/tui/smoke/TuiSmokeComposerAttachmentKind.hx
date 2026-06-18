package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeComposerAttachmentKind(String) to String {
	final Text = "text";
	final LargePaste = "large_paste";
	final LocalImage = "local_image";
	final RemoteImage = "remote_image";
	final Draft = "draft";
	final HistoryEntry = "history_entry";
	final Submission = "submission";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeComposerAttachmentKind {
		return switch value {
			case "text": Text;
			case "large_paste": LargePaste;
			case "local_image": LocalImage;
			case "remote_image": RemoteImage;
			case "draft": Draft;
			case "history_entry": HistoryEntry;
			case "submission": Submission;
			case _: Unknown;
		}
	}
}
