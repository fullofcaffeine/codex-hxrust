package codexhx.runtime.model.streamitem;

enum abstract ModelKeymapComposerFixedShortcutConflictActionKind(String) to String {
	final ComposerSubmit = "composer_submit";
	final FixedPasteImage = "fixed_paste_image";
	final Unknown = "unknown";

	public static function fromString(value:String):ModelKeymapComposerFixedShortcutConflictActionKind {
		return switch value {
			case "composer_submit": ComposerSubmit;
			case "fixed_paste_image": FixedPasteImage;
			case _: Unknown;
		}
	}
}
