package codexhx.runtime.tui.resume.host;

import codexhx.runtime.tui.resume.ResumePickerState;
import codexhx.runtime.tui.resume.ResumePickerVisibleRow;

class DeterministicResumePickerTerminalRenderer implements ResumePickerTerminalRenderer {
	final snapshots:Array<String>;

	public function new() {
		this.snapshots = [];
	}

	public function render(state:ResumePickerState):ResumePickerHostOutcome {
		final snapshot = renderScreen(state);
		snapshots.push(snapshot);
		return ResumePickerHostOutcome.rendered(snapshot, snapshots.length, 0);
	}

	public function renderCount():Int {
		return snapshots.length;
	}

	public function lastSnapshot():String {
		if (snapshots.length == 0) return "";
		return snapshots[snapshots.length - 1];
	}

	public function allSnapshots():Array<String> {
		return snapshots.copy();
	}

	static function renderScreen(state:ResumePickerState):String {
		final lines:Array<String> = [];
		lines.push("resume-picker action=" + state.action + " density=" + state.density);
		lines.push("toolbar sort=" + state.sortKey + " filter=" + state.filterMode + " query=" + emptyLabel(state.query));
		lines.push("rows loaded=" + state.loadedRows + " filtered=" + state.filteredRows + " scanned=" + state.scannedRows + " accepted=" + state.acceptedRows);
		if (state.visibleRows.length == 0) {
			lines.push("  no rows loaded");
		} else {
			for (row in state.visibleRows) {
				lines.push(renderRow(row));
				for (previewLine in row.previewLines) {
					lines.push("    preview: " + previewLine);
				}
			}
		}
		if (state.moreBelow || state.loadingOlderShown) {
			lines.push("page next=" + emptyLabel(state.nextCursor) + " moreBelow=" + boolLabel(state.moreBelow) + " loadingOlder=" + boolLabel(state.loadingOlderShown));
		}
		if (state.loadingOverlayMessage.length > 0) {
			lines.push("overlay loading thread=" + emptyLabel(state.pendingThreadId) + " message=" + state.loadingOverlayMessage);
		} else if (state.overlayOpen) {
			lines.push("overlay transcript thread=" + emptyLabel(state.pendingThreadId) + " cells=" + state.transcriptCellCount);
		} else {
			lines.push("overlay closed");
		}
		lines.push("footer " + emptyLabel(state.footerProgressLabel) + " selected=" + state.selectedIndex + " selectedThread=" + emptyLabel(state.selectedThreadId));
		return lines.join("\n");
	}

	static function renderRow(row:ResumePickerVisibleRow):String {
		final marker = row.selected ? ">" : " ";
		return marker
			+ " "
			+ row.title
			+ " | "
			+ row.threadId
			+ " | turns="
			+ row.turnCount
			+ " | "
			+ row.updatedAt;
	}

	static function emptyLabel(value:String):String {
		return value.length == 0 ? "<empty>" : value;
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
