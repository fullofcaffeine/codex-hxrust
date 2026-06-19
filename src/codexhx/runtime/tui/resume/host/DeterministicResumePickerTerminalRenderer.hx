package codexhx.runtime.tui.resume.host;

import codexhx.runtime.tui.resume.ResumePickerState;

class DeterministicResumePickerTerminalRenderer implements ResumePickerTerminalRenderer {
	final snapshots:Array<String>;

	public function new() {
		this.snapshots = [];
	}

	public function render(state:ResumePickerState):ResumePickerHostOutcome {
		final snapshot = state.summary();
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
}
