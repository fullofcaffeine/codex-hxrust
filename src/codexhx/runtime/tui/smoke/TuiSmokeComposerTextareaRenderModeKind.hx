package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeComposerTextareaRenderModeKind(String) to String {
	final Plain = "plain";
	final Masked = "masked";
	final Highlighted = "highlighted";
	final Placeholder = "placeholder";
	final DisabledPlaceholder = "disabled_placeholder";
	final RemoteImages = "remote_images";
	final Cursor = "cursor";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeComposerTextareaRenderModeKind {
		return switch value {
			case "plain": Plain;
			case "masked": Masked;
			case "highlighted": Highlighted;
			case "placeholder": Placeholder;
			case "disabled_placeholder": DisabledPlaceholder;
			case "remote_images": RemoteImages;
			case "cursor": Cursor;
			case _: Unknown;
		}
	}
}
