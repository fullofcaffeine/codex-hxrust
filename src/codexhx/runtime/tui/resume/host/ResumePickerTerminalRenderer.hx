package codexhx.runtime.tui.resume.host;

import codexhx.runtime.tui.resume.ResumePickerState;

interface ResumePickerTerminalRenderer {
	function render(state:ResumePickerState):ResumePickerHostOutcome;
}
