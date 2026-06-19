package codexhx.runtime.tui.resume.host;

interface ResumePickerFrameSchedulerHandle {
	function requestFrame(reason:String):ResumePickerHostOutcome;
}
