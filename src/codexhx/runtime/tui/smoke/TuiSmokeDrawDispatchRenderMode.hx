package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeDrawDispatchRenderMode(String) to String {
	final Legacy = "legacy";
	final ResizeReflow = "resize_reflow";
	final OverlayTranscript = "overlay_transcript";
	final OverlayStatic = "overlay_static";
	final Skipped = "skipped";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeDrawDispatchRenderMode {
		return switch value {
			case "legacy": Legacy;
			case "resize_reflow": ResizeReflow;
			case "overlay_transcript": OverlayTranscript;
			case "overlay_static": OverlayStatic;
			case "skipped": Skipped;
			case _: Unknown;
		}
	}
}
