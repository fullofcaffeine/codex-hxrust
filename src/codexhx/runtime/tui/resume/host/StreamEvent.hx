package codexhx.runtime.tui.resume.host;

typedef StreamEventFields = {
	final generation:Int;
	final kind:StreamEventKind;
	final requestId:String;
	final threadId:String;
	final payloadJson:String;
	final detail:String;
	final lossless:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class StreamEvent {
	public final generation:Int;
	@:recordDefault(StreamEventKind.Unknown)
	public final kind:StreamEventKind;
	public final requestId:String;
	public final threadId:String;
	public final payloadJson:String;
	public final detail:String;
	public final lossless:Bool;

	public static function pageResult(generation:Int, requestId:String, resultJson:String):StreamEvent {
		return new StreamEvent({
			generation: generation,
			kind: StreamEventKind.PageResult,
			requestId: requestId,
			threadId: "",
			payloadJson: resultJson,
			detail: "thread/list result",
			lossless: true
		});
	}

	public static function readResult(generation:Int, requestId:String, threadId:String, resultJson:String):StreamEvent {
		return new StreamEvent({
			generation: generation,
			kind: StreamEventKind.ReadResult,
			requestId: requestId,
			threadId: threadId,
			payloadJson: resultJson,
			detail: "thread/read result",
			lossless: true
		});
	}

	public static function readError(generation:Int, requestId:String, threadId:String, errorJson:String):StreamEvent {
		return new StreamEvent({
			generation: generation,
			kind: StreamEventKind.ReadError,
			requestId: requestId,
			threadId: threadId,
			payloadJson: errorJson,
			detail: "thread/read error",
			lossless: true
		});
	}

	public static function frameRequested(generation:Int, reason:String):StreamEvent {
		return new StreamEvent({
			generation: generation,
			kind: StreamEventKind.FrameRequested,
			requestId: "",
			threadId: "",
			payloadJson: "",
			detail: reason,
			lossless: false
		});
	}

	public static function progressUpdated(generation:Int, detail:String):StreamEvent {
		return new StreamEvent({
			generation: generation,
			kind: StreamEventKind.ProgressUpdated,
			requestId: "",
			threadId: "",
			payloadJson: "",
			detail: detail,
			lossless: false
		});
	}

	public static function serverRequest(generation:Int, requestId:String, detail:String):StreamEvent {
		return new StreamEvent({
			generation: generation,
			kind: StreamEventKind.ServerRequest,
			requestId: requestId,
			threadId: "",
			payloadJson: "",
			detail: detail,
			lossless: false
		});
	}

	public static function disconnected(generation:Int, message:String):StreamEvent {
		return new StreamEvent({
			generation: generation,
			kind: StreamEventKind.Disconnected,
			requestId: "",
			threadId: "",
			payloadJson: "",
			detail: message,
			lossless: true
		});
	}

	public static function lagged(generation:Int, skipped:Int):StreamEvent {
		return new StreamEvent({
			generation: generation,
			kind: StreamEventKind.Lagged,
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
