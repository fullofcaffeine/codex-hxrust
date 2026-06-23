package codexhx.runtime.tui.resume.host;

import codexhx.runtime.asyncruntime.AsyncContext;
import codexhx.runtime.asyncruntime.AsyncDeliveryKind;
import codexhx.runtime.asyncruntime.AsyncPoll;
import codexhx.runtime.asyncruntime.AsyncPollSummary;
import codexhx.runtime.asyncruntime.AsyncStreamItem;
import codexhx.runtime.asyncruntime.DeterministicAsyncStream;
import codexhx.runtime.app.RuntimeClientOutcome;

class EventPump {
	var activeGeneration:Int;
	var fanout:StreamFanout;
	final scheduler:FrameSchedulerHandle;
	final stream:DeterministicAsyncStream<StreamEvent>;
	final log:Array<String>;
	var pressureSkippedEvents:Int;
	final rejectedServerRequests:Array<String>;

	public function new(activeGeneration:Int, fanout:StreamFanout, scheduler:FrameSchedulerHandle, capacity:Int) {
		this.activeGeneration = activeGeneration;
		this.fanout = fanout;
		this.scheduler = scheduler;
		this.stream = new DeterministicAsyncStream<StreamEvent>(capacity);
		this.log = [];
		this.pressureSkippedEvents = 0;
		this.rejectedServerRequests = [];
		log.push("session:attach:generation=" + activeGeneration);
	}

	public function attachSession(generation:Int, fanout:StreamFanout):Void {
		this.activeGeneration = generation;
		this.fanout = fanout;
		log.push("session:attach:generation=" + activeGeneration);
	}

	public function enqueue(event:StreamEvent):AsyncPoll<Bool> {
		final delivery = event.lossless ? AsyncDeliveryKind.Lossless : AsyncDeliveryKind.BestEffort;
		final poll = stream.push(event, delivery);
		log.push("enqueue:" + event.summary() + ";poll=" + AsyncPollSummary.summary(poll));
		return poll;
	}

	public function forward(event:StreamEvent):AsyncPoll<Bool> {
		if (event.lossless && pressureSkippedEvents > 0) {
			final lag = StreamEvent.lagged(event.generation, pressureSkippedEvents);
			final lagPoll = stream.push(lag, AsyncDeliveryKind.Lossless);
			log.push("forward:lag:" + lag.summary() + ";poll=" + AsyncPollSummary.summary(lagPoll));
			switch lagPoll {
				case Ready(_, _, _):
					pressureSkippedEvents = 0;
				case _:
					return lagPoll;
			}
		}

		final delivery = event.lossless ? AsyncDeliveryKind.Lossless : AsyncDeliveryKind.BestEffort;
		final poll = stream.push(event, delivery);
		log.push("forward:" + event.summary() + ";poll=" + AsyncPollSummary.summary(poll));
		switch poll {
			case Backpressured(_, _, _):
				if (!event.lossless) {
					pressureSkippedEvents = pressureSkippedEvents + 1;
					if (event.kind == StreamEventKind.ServerRequest) {
						final rejection = "request=" + event.requestId + ";detail=" + event.detail + ";reason=consumer_queue_full";
						rejectedServerRequests.push(rejection);
						log.push("forward:server-request-rejected:" + rejection);
					}
				}
			case _:
		}
		return poll;
	}

	public function dispatchNext(context:AsyncContext):EventPumpDispatch {
		final poll = stream.pollNext(context);
		return switch poll {
			case Ready(item, pendingCount, skippedCount):
				dispatchItem(item, pendingCount, skippedCount);
			case Pending(pendingCount, skippedCount):
				nonEvent(EventPumpDispatchKind.Pending, pendingCount, skippedCount, "pending");
			case Closed(pendingCount, skippedCount):
				nonEvent(EventPumpDispatchKind.Closed, pendingCount, skippedCount, "closed");
			case Backpressured(error, pendingCount, skippedCount):
				nonEvent(EventPumpDispatchKind.Backpressured, pendingCount, skippedCount, error.code + ":" + error.message);
			case Failed(error, pendingCount, skippedCount):
				nonEvent(EventPumpDispatchKind.Failed, pendingCount, skippedCount, error.code + ":" + error.message);
			case Cancelled(reason, pendingCount, skippedCount):
				nonEvent(EventPumpDispatchKind.Cancelled, pendingCount, skippedCount, Std.string(reason));
		}
	}

	public function summaries():Array<String> {
		return log.copy();
	}

	public function rejectedRequestSummaries():Array<String> {
		return rejectedServerRequests.copy();
	}

	public function skippedBestEffortEvents():Int {
		return pressureSkippedEvents;
	}

	function dispatchItem(item:AsyncStreamItem<StreamEvent>, pendingCount:Int, skippedCount:Int):EventPumpDispatch {
		final event = item.value;
		if (event.generation != activeGeneration) {
			final hostEvent = ResumePickerHostEvent.failed(event.requestId, event.threadId, "stale_app_server_event_ignored",
				"eventGeneration="
				+ event.generation
				+ ";activeGeneration="
				+ activeGeneration
				+ ";kind="
				+ event.kind);
			final summary = "dispatch:stale:sequence=" + item.sequence + ";event=" + event.summary() + ";active=" + activeGeneration + ";pending="
				+ pendingCount + ";skipped=" + skippedCount;
			log.push(summary);
			return new EventPumpDispatch({
				kind: EventPumpDispatchKind.StaleIgnored,
				generation: event.generation,
				activeGeneration: activeGeneration,
				sequence: item.sequence,
				hostEvent: hostEvent,
				summary: summary
			});
		}

		final hostEvent = activeHostEvent(event);
		final summary = "dispatch:active:sequence=" + item.sequence + ";event=" + event.summary() + ";host=" + hostEvent.summary() + ";pending="
			+ pendingCount + ";skipped=" + skippedCount;
		log.push(summary);
		return new EventPumpDispatch({
			kind: EventPumpDispatchKind.Dispatched,
			generation: event.generation,
			activeGeneration: activeGeneration,
			sequence: item.sequence,
			hostEvent: hostEvent,
			summary: summary
		});
	}

	function activeHostEvent(event:StreamEvent):ResumePickerHostEvent {
		return switch event.kind {
			case PageResult:
				fanout.completePage(event.requestId, event.payloadJson);
			case ReadResult:
				fanout.completeRead(event.requestId, event.payloadJson);
			case ReadError:
				fanout.failRead(event.requestId, event.payloadJson);
			case FrameRequested:
				scheduler.requestFrame(event.detail);
				ResumePickerHostEvent.frameRequested(event.detail);
			case ProgressUpdated:
				ResumePickerHostEvent.frameRequested(event.detail);
			case ServerRequest:
				ResumePickerHostEvent.serverRequestDelivered(event.requestId, event.detail);
			case Disconnected:
				final outcome = fanout.disconnect(event.detail);
				disconnectEvent(outcome, event.detail);
			case Lagged:
				ResumePickerHostEvent.failed("", "", "app_server_stream_lagged", event.detail);
			case Unknown:
				ResumePickerHostEvent.failed(event.requestId, event.threadId, "unknown_app_server_stream_event", event.detail);
		}
	}

	function disconnectEvent(outcome:RuntimeClientOutcome, message:String):ResumePickerHostEvent {
		final code = outcome.ok ? "app_server_stream_disconnected" : "app_server_stream_disconnect_failed";
		return ResumePickerHostEvent.failed("", "", code, message + ";transport=" + outcome.code);
	}

	function nonEvent(kind:EventPumpDispatchKind, pendingCount:Int, skippedCount:Int, message:String):EventPumpDispatch {
		final summary = "dispatch:"
			+ kind
			+ ";active="
			+ activeGeneration
			+ ";pending="
			+ pendingCount
			+ ";skipped="
			+ skippedCount
			+ ";message="
			+ message;
		log.push(summary);
		return new EventPumpDispatch({
			kind: kind,
			generation: activeGeneration,
			activeGeneration: activeGeneration,
			sequence: 0,
			hostEvent: null,
			summary: summary
		});
	}
}
