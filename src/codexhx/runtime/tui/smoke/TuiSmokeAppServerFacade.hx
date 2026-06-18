package codexhx.runtime.tui.smoke;

class TuiSmokeAppServerFacade {
	var eventCount:Int;
	var closed:Bool;

	public function new() {
		this.eventCount = 0;
		this.closed = false;
	}

	public function handle(event:TuiSmokeAppServerEvent, state:TuiSmokeAppState, trace:Array<String>):TuiSmokeExitKind {
		if (closed) {
			trace.push("server.ignored_after_close");
			return TuiSmokeExitKind.Rendered;
		}
		if (event == null || event.kind == TuiSmokeAppServerEventKind.Unknown) {
			trace.push("server.unknown");
			return TuiSmokeExitKind.Rejected;
		}
		eventCount = eventCount + 1;
		return switch event.kind {
			case TuiSmokeAppServerEventKind.ThreadStatus:
				state.updateStatus(event.status);
				trace.push("server.thread_status=" + event.threadId + ":" + event.status);
				TuiSmokeExitKind.Rendered;
			case TuiSmokeAppServerEventKind.AssistantDelta:
				state.appendTranscript(new TuiSmokeTranscriptRow({
					source: TuiSmokeTranscriptSource.Assistant,
					text: event.delta
				}));
				trace.push("server.assistant_delta=" + event.threadId + ":" + event.delta);
				TuiSmokeExitKind.Rendered;
			case TuiSmokeAppServerEventKind.Disconnected:
				state.updateStatus("disconnected");
				trace.push("server.disconnected=" + event.message);
				TuiSmokeExitKind.Rejected;
			case TuiSmokeAppServerEventKind.StreamClosed:
				closed = true;
				trace.push("server.stream_closed");
				TuiSmokeExitKind.Rendered;
			case _:
				trace.push("server.unknown");
				TuiSmokeExitKind.Rejected;
		}
	}

	public function handled():Int {
		return eventCount;
	}
}
