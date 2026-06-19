package codexhx.runtime.tui.resume.host;

typedef ResumePickerHostEventFields = {
	final kind:ResumePickerHostEventKind;
	final requestId:String;
	final threadId:String;
	final detail:String;
	final failureCode:String;
	final failureMessage:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerHostEvent {
	@:recordDefault(ResumePickerHostEventKind.Unknown)
	public final kind:ResumePickerHostEventKind;
	public final requestId:String;
	public final threadId:String;
	public final detail:String;
	public final failureCode:String;
	public final failureMessage:String;

	public static function pageLoaded(response:ResumePickerThreadListResponse):ResumePickerHostEvent {
		return new ResumePickerHostEvent({
			kind: ResumePickerHostEventKind.PageLoaded,
			requestId: response.requestId,
			threadId: "",
			detail: response.summary(),
			failureCode: "",
			failureMessage: ""
		});
	}

	public static function previewLoaded(response:ResumePickerThreadReadResponse):ResumePickerHostEvent {
		return new ResumePickerHostEvent({
			kind: ResumePickerHostEventKind.PreviewLoaded,
			requestId: response.requestId,
			threadId: response.threadId,
			detail: response.summary(),
			failureCode: "",
			failureMessage: ""
		});
	}

	public static function transcriptLoaded(response:ResumePickerThreadReadResponse):ResumePickerHostEvent {
		return new ResumePickerHostEvent({
			kind: ResumePickerHostEventKind.TranscriptLoaded,
			requestId: response.requestId,
			threadId: response.threadId,
			detail: response.summary(),
			failureCode: "",
			failureMessage: ""
		});
	}

	public static function frameRequested(reason:String):ResumePickerHostEvent {
		return new ResumePickerHostEvent({
			kind: ResumePickerHostEventKind.FrameRequested,
			requestId: "",
			threadId: "",
			detail: reason,
			failureCode: "",
			failureMessage: ""
		});
	}

	public static function failed(requestId:String, threadId:String, code:String, message:String):ResumePickerHostEvent {
		return new ResumePickerHostEvent({
			kind: ResumePickerHostEventKind.Failed,
			requestId: requestId,
			threadId: threadId,
			detail: "",
			failureCode: code,
			failureMessage: message
		});
	}

	public function summary():String {
		final failure = failureCode.length == 0 ? "none" : failureCode + ":" + failureMessage;
		return "kind=" + kind + ";request=" + requestId + ";thread=" + threadId + ";detail=" + detail + ";failure=" + failure;
	}
}
