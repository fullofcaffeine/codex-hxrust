package codexhx.runtime.tui.resume.host;

class DeterministicResumePickerFrameScheduler implements ResumePickerFrameSchedulerHandle {
	final reasons:Array<String>;

	public function new() {
		this.reasons = [];
	}

	public function requestFrame(reason:String):ResumePickerHostOutcome {
		reasons.push(reason);
		return ResumePickerHostOutcome.scheduled(reason, reasons.length, 0);
	}

	public function requestCount():Int {
		return reasons.length;
	}

	public function summary():String {
		return reasons.join(",");
	}
}
