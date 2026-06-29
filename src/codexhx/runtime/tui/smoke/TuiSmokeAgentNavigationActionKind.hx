package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeAgentNavigationActionKind(String) to String {
	final Upsert = "upsert";
	final RecordActivity = "record_activity";
	final SetRunning = "set_running";
	final SetAgentPath = "set_agent_path";
	final MarkClosed = "mark_closed";
	final Remove = "remove";
	final Clear = "clear";
	final Ordered = "ordered";
	final Adjacent = "adjacent";
	final AdjacentWithBackfill = "adjacent_with_backfill";
	final ActiveLabel = "active_label";
	final PickerItemName = "picker_item_name";
	final HasNonPrimary = "has_non_primary";
	final Subtitle = "subtitle";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeAgentNavigationActionKind {
		return switch value {
			case "upsert": Upsert;
			case "record_activity": RecordActivity;
			case "set_running": SetRunning;
			case "set_agent_path": SetAgentPath;
			case "mark_closed": MarkClosed;
			case "remove": Remove;
			case "clear": Clear;
			case "ordered": Ordered;
			case "adjacent": Adjacent;
			case "adjacent_with_backfill": AdjacentWithBackfill;
			case "active_label": ActiveLabel;
			case "picker_item_name": PickerItemName;
			case "has_non_primary": HasNonPrimary;
			case "subtitle": Subtitle;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
