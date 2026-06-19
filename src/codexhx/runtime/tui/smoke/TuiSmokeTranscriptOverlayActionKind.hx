package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeTranscriptOverlayActionKind(String) to String {
	final Open = "open";
	final LiveTailKey = "live_tail_key";
	final LiveTailSync = "live_tail_sync";
	final LiveTailDrop = "live_tail_drop";
	final InsertCell = "insert_cell";
	final ReplaceCells = "replace_cells";
	final Consolidate = "consolidate";
	final Highlight = "highlight";
	final Paging = "paging";
	final RawMode = "raw_mode";
	final Close = "close";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeTranscriptOverlayActionKind {
		return switch value {
			case "open": Open;
			case "live_tail_key": LiveTailKey;
			case "live_tail_sync": LiveTailSync;
			case "live_tail_drop": LiveTailDrop;
			case "insert_cell": InsertCell;
			case "replace_cells": ReplaceCells;
			case "consolidate": Consolidate;
			case "highlight": Highlight;
			case "paging": Paging;
			case "raw_mode": RawMode;
			case "close": Close;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
