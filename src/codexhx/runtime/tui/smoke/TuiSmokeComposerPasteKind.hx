package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeComposerPasteKind(String) to String {
	final SmallText = "small_text";
	final LargeText = "large_text";
	final ImagePath = "image_path";
	final PasteBurst = "paste_burst";
	final SelectedFile = "selected_file";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeComposerPasteKind {
		return switch value {
			case "small_text": SmallText;
			case "large_text": LargeText;
			case "image_path": ImagePath;
			case "paste_burst": PasteBurst;
			case "selected_file": SelectedFile;
			case _: Unknown;
		}
	}
}
