package codexhx.runtime.model.streamitem;

enum abstract ModelKeymapPagerConflictActionKind(String) to String {
	final PagerScrollUp = "pager_scroll_up";
	final PagerScrollDown = "pager_scroll_down";
	final Unknown = "unknown";

	public static function fromString(value:String):ModelKeymapPagerConflictActionKind {
		return switch value {
			case "pager_scroll_up": PagerScrollUp;
			case "pager_scroll_down": PagerScrollDown;
			case _: Unknown;
		}
	}
}
