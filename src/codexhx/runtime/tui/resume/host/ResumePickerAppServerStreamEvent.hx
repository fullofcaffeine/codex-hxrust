package codexhx.runtime.tui.resume.host;

typedef ResumePickerAppServerStreamEventFields = {
	final generation:Int;
	final kind:ResumePickerAppServerStreamEventKind;
	final requestId:String;
	final threadId:String;
	final payloadJson:String;
	final detail:String;
	final lossless:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerAppServerStreamEvent {
	public final generation:Int;
	@:recordDefault(ResumePickerAppServerStreamEventKind.Unknown)
	public final kind:ResumePickerAppServerStreamEventKind;
	public final requestId:String;
	public final threadId:String;
	public final payloadJson:String;
	public final detail:String;
	public final lossless:Bool;

	public static function pageResult(generation:Int, requestId:String, resultJson:String):ResumePickerAppServerStreamEvent {
		return new ResumePickerAppServerStreamEvent({
			generation: generation,
			kind: ResumePickerAppServerStreamEventKind.PageResult,
			requestId: requestId,
			threadId: "",
			payloadJson: resultJson,
			detail: "thread/list result",
			lossless: true
		});
	}

	public static function readResult(generation:Int, requestId:String, threadId:String, resultJson:String):ResumePickerAppServerStreamEvent {
		return new ResumePickerAppServerStreamEvent({
			generation: generation,
			kind: ResumePickerAppServerStreamEventKind.ReadResult,
			requestId: requestId,
			threadId: threadId,
			payloadJson: resultJson,
			detail: "thread/read result",
			lossless: true
		});
	}

	public static function readError(generation:Int, requestId:String, threadId:String, errorJson:String):ResumePickerAppServerStreamEvent {
		return new ResumePickerAppServerStreamEvent({
			generation: generation,
			kind: ResumePickerAppServerStreamEventKind.ReadError,
			requestId: requestId,
			threadId: threadId,
			payloadJson: errorJson,
			detail: "thread/read error",
			lossless: true
		});
	}

	public static function frameRequested(generation:Int, reason:String):ResumePickerAppServerStreamEvent {
		return new ResumePickerAppServerStreamEvent({
			generation: generation,
			kind: ResumePickerAppServerStreamEventKind.FrameRequested,
			requestId: "",
			threadId: "",
			payloadJson: "",
			detail: reason,
			lossless: false
		});
	}

	public static function progressUpdated(generation:Int, detail:String):ResumePickerAppServerStreamEvent {
		return new ResumePickerAppServerStreamEvent({
			generation: generation,
			kind: ResumePickerAppServerStreamEventKind.ProgressUpdated,
			requestId: "",
			threadId: "",
			payloadJson: "",
			detail: detail,
			lossless: false
		});
	}

	public static function serverRequest(generation:Int, requestId:String, detail:String):ResumePickerAppServerStreamEvent {
		return new ResumePickerAppServerStreamEvent({
			generation: generation,
			kind: ResumePickerAppServerStreamEventKind.ServerRequest,
			requestId: requestId,
			threadId: "",
			payloadJson: "",
			detail: detail,
			lossless: false
		});
	}

	public static function disconnected(generation:Int, message:String):ResumePickerAppServerStreamEvent {
		return new ResumePickerAppServerStreamEvent({
			generation: generation,
			kind: ResumePickerAppServerStreamEventKind.Disconnected,
			requestId: "",
			threadId: "",
			payloadJson: "",
			detail: message,
			lossless: true
		});
	}

	public static function lagged(generation:Int, skipped:Int):ResumePickerAppServerStreamEvent {
		return new ResumePickerAppServerStreamEvent({
			generation: generation,
			kind: ResumePickerAppServerStreamEventKind.Lagged,
			requestId: "",
			threadId: "",
			payloadJson: "",
			detail: "skipped=" + skipped,
			lossless: true
		});
	}

	public function summary():String {
		return "generation=" + generation + ";kind=" + kind + ";request=" + requestId + ";thread=" + threadId + ";detail=" + detail + ";lossless="
			+ (lossless ? "true" : "false");
	}
}
