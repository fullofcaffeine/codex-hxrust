package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeComposerTextareaRenderActionKind(String) to String {
	final Layout = "layout";
	final DesiredHeight = "desired_height";
	final RemoteImages = "remote_images";
	final Prompt = "prompt";
	final Plain = "plain";
	final Masked = "masked";
	final Highlighted = "highlighted";
	final Placeholder = "placeholder";
	final Cursor = "cursor";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeComposerTextareaRenderActionKind {
		return switch value {
			case "layout": Layout;
			case "desired_height": DesiredHeight;
			case "remote_images": RemoteImages;
			case "prompt": Prompt;
			case "plain": Plain;
			case "masked": Masked;
			case "highlighted": Highlighted;
			case "placeholder": Placeholder;
			case "cursor": Cursor;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
