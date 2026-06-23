package codexhx.runtime.tui.resume.host;

import codexhx.runtime.app.RuntimeClientOutcome;

class StreamFanout {
	final source:JsonRpcThreadSource;
	final log:Array<String>;

	public function new(source:JsonRpcThreadSource) {
		this.source = source;
		this.log = [];
	}

	public function enqueuePage(request:ResumePickerThreadListRequest):RuntimeClientOutcome {
		final outcome = source.enqueuePageRequest(request);
		log.push("enqueue:page:" + outcomeSummary(outcome));
		return outcome;
	}

	public function enqueuePreview(request:ResumePickerThreadReadRequest):RuntimeClientOutcome {
		final outcome = source.enqueueReadRequest(request);
		log.push("enqueue:preview:" + outcomeSummary(outcome));
		return outcome;
	}

	public function enqueueTranscript(request:ResumePickerThreadReadRequest):RuntimeClientOutcome {
		final outcome = source.enqueueReadRequest(request);
		log.push("enqueue:transcript:" + outcomeSummary(outcome));
		return outcome;
	}

	public function completePage(requestId:String, resultJson:String):ResumePickerHostEvent {
		final event = source.completePageRequest(requestId, resultJson);
		log.push("resolve:page:" + event.summary() + ";pending=" + pendingCount());
		return event;
	}

	public function completeRead(requestId:String, resultJson:String):ResumePickerHostEvent {
		final event = source.completeReadRequest(requestId, resultJson);
		log.push("resolve:read:" + event.summary() + ";pending=" + pendingCount());
		return event;
	}

	public function failRead(requestId:String, errorJson:String):ResumePickerHostEvent {
		final event = source.failReadRequest(requestId, errorJson);
		log.push("resolve:read-error:" + event.summary() + ";pending=" + pendingCount());
		return event;
	}

	public function cancelPage(requestId:String, reason:String):ResumePickerHostEvent {
		final event = source.cancelPageRequest(requestId, reason);
		log.push("session:cancel-page:" + event.summary() + ";pending=" + pendingCount());
		return event;
	}

	public function cancelRead(requestId:String, reason:String):ResumePickerHostEvent {
		final event = source.cancelReadRequest(requestId, reason);
		log.push("session:cancel-read:" + event.summary() + ";pending=" + pendingCount());
		return event;
	}

	public function disconnect(message:String):RuntimeClientOutcome {
		final outcome = source.disconnectSession(message);
		log.push("session:disconnect:" + outcomeSummary(outcome));
		return outcome;
	}

	public function pendingCount():Int {
		return source.pendingTransportRequests();
	}

	public function requestSummaries():Array<String> {
		return source.requestSummaries();
	}

	public function transportSummaries():Array<String> {
		return source.transportSummaries();
	}

	public function transportEventSummaries():Array<String> {
		return source.drainedEventSummaries();
	}

	public function fanoutSummaries():Array<String> {
		return log.copy();
	}

	static function outcomeSummary(outcome:RuntimeClientOutcome):String {
		return "ok=" + boolLabel(outcome.ok) + ";code=" + outcome.code + ";request=" + outcome.requestId + ";method=" + outcome.method + ";pending="
			+ outcome.pendingCount + ";message=" + outcome.message;
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
