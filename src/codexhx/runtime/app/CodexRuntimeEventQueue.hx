package codexhx.runtime.app;

class CodexRuntimeEventQueue {
	final capacity:Int;
	final events:Array<CodexRuntimeEvent>;
	var nextSequence:Int;
	var skippedBestEffort:Int;

	public function new(capacity:Int) {
		this.capacity = capacity < 1 ? 1 : capacity;
		this.events = [];
		this.nextSequence = 1;
		this.skippedBestEffort = 0;
	}

	public function pendingCount():Int {
		return events.length;
	}

	public function skippedCount():Int {
		return skippedBestEffort;
	}

	public function pushNotification(method:String, payloadJson:String, summary:String):RuntimeQueuePushOutcome {
		final event = CodexRuntimeEvent.notification(nextSeq(), method, payloadJson, summary);
		return push(event);
	}

	public function pushResponse(requestId:String, method:String, payloadJson:String):RuntimeQueuePushOutcome {
		return push(CodexRuntimeEvent.response(nextSeq(), requestId, method, payloadJson));
	}

	public function pushError(requestId:String, method:String, payloadJson:String, summary:String):RuntimeQueuePushOutcome {
		return push(CodexRuntimeEvent.error(nextSeq(), requestId, method, payloadJson, summary));
	}

	public function pushDisconnected(message:String):RuntimeQueuePushOutcome {
		return push(CodexRuntimeEvent.disconnected(nextSeq(), message));
	}

	public function readEvent():RuntimeEventReadOutcome {
		if (events.length == 0)
			return RuntimeEventReadOutcome.empty();
		final event = events[0];
		events.splice(0, 1);
		return RuntimeEventReadOutcome.found(event, events.length);
	}

	public function drainSummaries():Array<String> {
		final summaries:Array<String> = [];
		var outcome = readEvent();
		while (outcome.ok) {
			summaries.push(outcome.event.canonicalSummary());
			outcome = readEvent();
		}
		return summaries;
	}

	function push(event:CodexRuntimeEvent):RuntimeQueuePushOutcome {
		if (event.delivery == CodexRuntimeEventDelivery.Lossless || event.delivery == CodexRuntimeEventDelivery.Control) {
			return pushRequired(event);
		}
		return pushBestEffort(event);
	}

	function pushRequired(event:CodexRuntimeEvent):RuntimeQueuePushOutcome {
		final lagOutcome = flushLagMarker(true);
		if (lagOutcome != null && !lagOutcome.ok)
			return lagOutcome;
		if (events.length >= capacity) {
			return RuntimeQueuePushOutcome.blocked("lossless_backpressure", "lossless event requires consumer capacity", events.length, skippedBestEffort);
		}
		events.push(event);
		return RuntimeQueuePushOutcome.queued(event, events.length, skippedBestEffort);
	}

	function pushBestEffort(event:CodexRuntimeEvent):RuntimeQueuePushOutcome {
		final lagOutcome = flushLagMarker(false);
		if (lagOutcome != null && !lagOutcome.ok) {
			skippedBestEffort = skippedBestEffort + 1;
			return RuntimeQueuePushOutcome.dropped("best_effort_dropped", "best-effort event dropped while lag marker was pending", events.length,
				skippedBestEffort);
		}
		if (events.length >= capacity) {
			skippedBestEffort = skippedBestEffort + 1;
			return RuntimeQueuePushOutcome.dropped("best_effort_dropped", "best-effort event dropped because consumer queue is full", events.length,
				skippedBestEffort);
		}
		events.push(event);
		return RuntimeQueuePushOutcome.queued(event, events.length, skippedBestEffort);
	}

	function flushLagMarker(requiredEventFollows:Bool):RuntimeQueuePushOutcome {
		if (skippedBestEffort == 0)
			return null;
		if (events.length >= capacity) {
			final code = requiredEventFollows ? "lag_marker_backpressure" : "lag_marker_full";
			return RuntimeQueuePushOutcome.blocked(code, "lag marker requires consumer capacity", events.length, skippedBestEffort);
		}
		final lagged = CodexRuntimeEvent.lagged(nextSeq(), skippedBestEffort);
		skippedBestEffort = 0;
		events.push(lagged);
		return RuntimeQueuePushOutcome.queued(lagged, events.length, skippedBestEffort);
	}

	function nextSeq():Int {
		final value = nextSequence;
		nextSequence = nextSequence + 1;
		return value;
	}
}
