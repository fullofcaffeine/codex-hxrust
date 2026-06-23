package codexhx.runtime.tui.resume.host;

interface FrameSchedulerHandle {
	function requestFrame(reason:String):ResumePickerHostOutcome;
}
