package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeOverlayRoutingActionKind(String) to String {
	final OpenTranscript = "open_transcript";
	final OpenStatic = "open_static";
	final InsertCommittedCell = "insert_committed_cell";
	final ConsolidateCells = "consolidate_cells";
	final SyncLiveTail = "sync_live_tail";
	final Draw = "draw";
	final Resize = "resize";
	final Key = "key";
	final DoneCleanup = "done_cleanup";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeOverlayRoutingActionKind {
		return switch value {
			case "open_transcript": OpenTranscript;
			case "open_static": OpenStatic;
			case "insert_committed_cell": InsertCommittedCell;
			case "consolidate_cells": ConsolidateCells;
			case "sync_live_tail": SyncLiveTail;
			case "draw": Draw;
			case "resize": Resize;
			case "key": Key;
			case "done_cleanup": DoneCleanup;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
