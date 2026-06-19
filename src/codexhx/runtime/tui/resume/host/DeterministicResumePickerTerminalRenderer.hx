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
		if (state.toolbarRenderMode.length > 0 || state.toolbarFocus != "filter") {
			lines.push("toolbar-detail focus=" + state.toolbarFocus + " mode=" + emptyLabel(state.toolbarRenderMode));
		}
		lines.push("rows loaded=" + state.loadedRows + " filtered=" + state.filteredRows + " scanned=" + state.scannedRows + " accepted=" + state.acceptedRows);
		if (state.scrollTop > 0 || state.moreAbove || state.pendingPageDownCompleted) {
			lines.push("navigation selected="
				+ state.selectedIndex
				+ " scrollTop="
				+ state.scrollTop
				+ " viewRows="
				+ state.viewRows
				+ " moreAbove="
				+ boolLabel(state.moreAbove)
				+ " pageDownCompleted="
				+ boolLabel(state.pendingPageDownCompleted));
		}
		if (state.visibleRows.length == 0) {
			lines.push(state.emptyStateMessage.length == 0 ? "  no rows loaded" : "  empty: " + state.emptyStateMessage);
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
			for (cell in state.transcriptCells) {
				lines.push("  transcript: " + cell);
			}
		} else {
			lines.push("overlay closed");
		}
		if (state.inlineErrorShown || state.lastError.length > 0 || state.lastFailureCode.length > 0) {
			lines.push("error code=" + emptyLabel(state.lastFailureCode) + " message=" + emptyLabel(state.lastError));
		}
		if (state.configPersistenceStatus.length > 0 || state.configPersistencePath.length > 0) {
			lines.push("config persistence=" + emptyLabel(state.configPersistenceStatus) + " path=" + emptyLabel(state.configPersistencePath));
		}
		if (state.footerHintMode.length > 0 || state.footerWidth > 0 || state.compactFallback || state.keyOnlyFallback) {
			lines.push("footer-hints mode="
				+ emptyLabel(state.footerHintMode)
				+ " width="
				+ state.footerWidth
				+ " compact="
				+ boolLabel(state.compactFallback)
				+ " keyOnly="
				+ boolLabel(state.keyOnlyFallback)
				+ " loading="
				+ boolLabel(state.loadingPending));
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
