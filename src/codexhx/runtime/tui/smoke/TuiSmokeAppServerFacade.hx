package codexhx.runtime.tui.smoke;

class TuiSmokeAppServerFacade {
	var eventCount:Int;
	var requestCount:Int;
	var rejectedRequestCount:Int;
	var resolutionCount:Int;
	var staleResolutionCount:Int;
	var deliveredRequestCount:Int;
	var evictedRequestCount:Int;
	var threadNotificationCount:Int;
	var deliveredNotificationCount:Int;
	var evictedNotificationCount:Int;
	var threadReplayCount:Int;
	var replayedRequestCount:Int;
	var skippedReplayRequestCount:Int;
	var suppressedReplayNoticeCount:Int;
	var replayedTurnCount:Int;
	var replayedItemCount:Int;
	var replayedCompletionCount:Int;
	var closed:Bool;
	var primaryThreadId:String;
	var activeThreadId:String;
	final pendingRequests:Array<TuiSmokeAppServerRequest>;
	final queuedRequests:Array<TuiSmokeAppServerRequest>;
	final queuedNotifications:Array<TuiSmokeThreadNotification>;
	final bufferedEvents:Array<TuiSmokeThreadBufferedEvent>;

	public function new() {
		this.eventCount = 0;
		this.requestCount = 0;
		this.rejectedRequestCount = 0;
		this.resolutionCount = 0;
		this.staleResolutionCount = 0;
		this.deliveredRequestCount = 0;
		this.evictedRequestCount = 0;
		this.threadNotificationCount = 0;
		this.deliveredNotificationCount = 0;
		this.evictedNotificationCount = 0;
		this.threadReplayCount = 0;
		this.replayedRequestCount = 0;
		this.skippedReplayRequestCount = 0;
		this.suppressedReplayNoticeCount = 0;
		this.replayedTurnCount = 0;
		this.replayedItemCount = 0;
		this.replayedCompletionCount = 0;
		this.closed = false;
		this.primaryThreadId = "";
		this.activeThreadId = "";
		this.pendingRequests = [];
		this.queuedRequests = [];
		this.queuedNotifications = [];
		this.bufferedEvents = [];
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

	public function handleRequest(request:TuiSmokeAppServerRequest, trace:Array<String>):TuiSmokeExitKind {
		if (closed) {
			trace.push("server.request.ignored_after_close");
			return TuiSmokeExitKind.Rendered;
		}
		if (request == null || request.kind == TuiSmokeAppServerRequestKind.Unknown) {
			trace.push("server.request.unknown");
			return TuiSmokeExitKind.Rejected;
		}
		final unsupported = unsupportedReason(request.kind);
		if (unsupported.length > 0) {
			rejectedRequestCount = rejectedRequestCount + 1;
			trace.push("server.request.reject=" + request.requestId + ":" + unsupported);
			return TuiSmokeExitKind.Rendered;
		}
		if (!isThreadBound(request.kind)) {
			trace.push("server.request.threadless=" + request.kind + ":" + request.requestId);
			return TuiSmokeExitKind.Rendered;
		}
		if (request.threadId.length == 0) {
			trace.push("server.request.missing_thread=" + request.kind + ":" + request.requestId);
			return TuiSmokeExitKind.Rendered;
		}
		requestCount = requestCount + 1;
		pendingRequests.push(request);
		queuedRequests.push(request);
		bufferedEvents.push(TuiSmokeThreadBufferedEvent.requestEvent(request));
		final target = targetForThread(request.threadId);
		final deliveryState = activeThreadId == request.threadId ? "active" : "buffered";
		trace.push("server.request." + request.kind + "=" + request.requestId + ":" + request.threadId + ":" + target + ":" + request.displayId() + ":"
			+ deliveryState);
		return TuiSmokeExitKind.Rendered;
	}

	public function handleThreadNotification(notification:TuiSmokeThreadNotification, trace:Array<String>):TuiSmokeExitKind {
		if (closed) {
			trace.push("thread.notification.ignored_after_close");
			return TuiSmokeExitKind.Rendered;
		}
		if (notification == null || notification.kind == TuiSmokeThreadNotificationKind.Unknown) {
			trace.push("thread.notification.unknown");
			return TuiSmokeExitKind.Rejected;
		}
		if (notification.threadId.length == 0) {
			trace.push("thread.notification.missing_thread=" + notification.kind + ":" + notification.notificationId);
			return TuiSmokeExitKind.Rendered;
		}
		threadNotificationCount = threadNotificationCount + 1;
		queuedNotifications.push(notification);
		bufferedEvents.push(TuiSmokeThreadBufferedEvent.notificationEvent(notification));
		final target = targetForThread(notification.threadId);
		final deliveryState = activeThreadId == notification.threadId ? "active" : "buffered";
		trace.push("thread.notification." + notification.kind + "=" + notification.notificationId + ":" + notification.threadId + ":" + target + ":"
			+ notification.displayText() + ":" + deliveryState);
		return TuiSmokeExitKind.Rendered;
	}

	public function handleThreadReplay(action:TuiSmokeThreadReplayAction, state:TuiSmokeAppState, trace:Array<String>):TuiSmokeExitKind {
		if (closed) {
			trace.push("thread.replay.ignored_after_close");
			return TuiSmokeExitKind.Rendered;
		}
		if (action == null || action.kind == TuiSmokeThreadReplayActionKind.Unknown) {
			trace.push("thread.replay.unknown");
			return TuiSmokeExitKind.Rejected;
		}
		return switch action.kind {
			case TuiSmokeThreadReplayActionKind.SnapshotActive:
				if (action.threadId.length > 0) {
					activeThreadId = action.threadId;
					trace.push("thread.replay.active=" + activeThreadId);
				}
				replayActiveSnapshot(action, state, trace);
				TuiSmokeExitKind.Rendered;
			case _:
				trace.push("thread.replay.unknown");
				TuiSmokeExitKind.Rejected;
		}
	}

	public function handleThreadDelivery(action:TuiSmokeThreadDeliveryAction, state:TuiSmokeAppState, trace:Array<String>):TuiSmokeExitKind {
		if (closed) {
			trace.push("thread.delivery.ignored_after_close");
			return TuiSmokeExitKind.Rendered;
		}
		if (action == null || action.kind == TuiSmokeThreadDeliveryActionKind.Unknown) {
			trace.push("thread.delivery.unknown");
			return TuiSmokeExitKind.Rejected;
		}
		return switch action.kind {
			case TuiSmokeThreadDeliveryActionKind.DrainActive:
				deliverActive(state, trace);
				TuiSmokeExitKind.Rendered;
			case TuiSmokeThreadDeliveryActionKind.SwitchActive:
				if (action.threadId.length == 0) {
					trace.push("thread.active.stale=");
				} else {
					activeThreadId = action.threadId;
					trace.push("thread.active=" + activeThreadId);
					deliverActive(state, trace);
				}
				TuiSmokeExitKind.Rendered;
			case TuiSmokeThreadDeliveryActionKind.EvictQueued:
				evictQueued(action.requestId, trace);
				TuiSmokeExitKind.Rendered;
			case TuiSmokeThreadDeliveryActionKind.EvictNotification:
				evictNotification(action.requestId, trace);
				TuiSmokeExitKind.Rendered;
			case _:
				trace.push("thread.delivery.unknown");
				TuiSmokeExitKind.Rejected;
		}
	}

	public function handleResolution(resolution:TuiSmokeAppServerResolution, trace:Array<String>):TuiSmokeExitKind {
		if (closed) {
			trace.push("server.resolution.ignored_after_close");
			return TuiSmokeExitKind.Rendered;
		}
		if (resolution == null || resolution.kind == TuiSmokeAppServerResolutionKind.Unknown) {
			staleResolutionCount = staleResolutionCount + 1;
			trace.push("server.resolution.unknown");
			return TuiSmokeExitKind.Rendered;
		}
		final request = resolution.kind == TuiSmokeAppServerResolutionKind.ServerRequestResolved ? takePendingByRequestId(resolution.requestId) : takePendingForResolution(resolution);
		if (request == null) {
			staleResolutionCount = staleResolutionCount + 1;
			trace.push("server.resolution.stale=" + resolution.kind + ":" + resolutionKey(resolution));
			return TuiSmokeExitKind.Rendered;
		}
		resolutionCount = resolutionCount + 1;
		trace.push("server.resolution."
			+ resolution.kind
			+ "="
			+ request.requestId
			+ ":"
			+ request.displayId()
			+ ":"
			+ resolutionSummary(resolution));
		return TuiSmokeExitKind.Rendered;
	}

	public function handled():Int {
		return eventCount;
	}

	public function handledRequests():Int {
		return requestCount;
	}

	public function rejectedRequests():Int {
		return rejectedRequestCount;
	}

	public function handledResolutions():Int {
		return resolutionCount;
	}

	public function staleResolutions():Int {
		return staleResolutionCount;
	}

	public function deliveredRequests():Int {
		return deliveredRequestCount;
	}

	public function evictedRequests():Int {
		return evictedRequestCount;
	}

	public function handledThreadNotifications():Int {
		return threadNotificationCount;
	}

	public function deliveredThreadNotifications():Int {
		return deliveredNotificationCount;
	}

	public function evictedThreadNotifications():Int {
		return evictedNotificationCount;
	}

	public function handledThreadReplays():Int {
		return threadReplayCount;
	}

	public function replayedThreadRequests():Int {
		return replayedRequestCount;
	}

	public function skippedThreadReplayRequests():Int {
		return skippedReplayRequestCount;
	}

	public function suppressedThreadReplayNotices():Int {
		return suppressedReplayNoticeCount;
	}

	public function replayedThreadTurns():Int {
		return replayedTurnCount;
	}

	public function replayedThreadItems():Int {
		return replayedItemCount;
	}

	public function replayedThreadCompletions():Int {
		return replayedCompletionCount;
	}

	function deliverActive(state:TuiSmokeAppState, trace:Array<String>):Void {
		if (activeThreadId.length == 0) {
			trace.push("thread.deliver.stale=no_active");
			return;
		}
		var delivered = 0;
		var i = 0;
		while (i < bufferedEvents.length) {
			final event = bufferedEvents[i];
			final request = event.request;
			final notification = event.notification;
			if (request != null && request.threadId == activeThreadId) {
				bufferedEvents.splice(i, 1);
				removeQueuedRequest(request.requestId);
				delivered = delivered + 1;
				deliveredRequestCount = deliveredRequestCount + 1;
				trace.push("thread.deliver=" + activeThreadId + ":" + request.requestId + ":" + request.displayId());
			} else if (notification != null && notification.threadId == activeThreadId) {
				bufferedEvents.splice(i, 1);
				removeQueuedNotification(notification.notificationId);
				delivered = delivered + 1;
				deliveredNotificationCount = deliveredNotificationCount + 1;
				applyDeliveredNotification(notification, state);
				trace.push("thread.deliver.notification=" + activeThreadId + ":" + notification.notificationId + ":" + notification.displayText());
				if (isChatWidgetSuppressed(notification)) {
					trace.push("thread.deliver.notification_suppressed=" + activeThreadId + ":" + notification.notificationId + ":" + notification.kind);
				}
			} else {
				i = i + 1;
			}
		}
		if (delivered == 0)
			trace.push("thread.deliver.empty=" + activeThreadId);
	}

	function replayActiveSnapshot(action:TuiSmokeThreadReplayAction, state:TuiSmokeAppState, trace:Array<String>):Void {
		if (activeThreadId.length == 0) {
			trace.push("thread.replay.stale=no_active");
			return;
		}
		threadReplayCount = threadReplayCount + 1;
		final suppressNotices = snapshotHasPendingInteractiveRequest(activeThreadId);
		final traceEnvelope = hasReplayEnvelope(action);
		final shouldBufferReplay = action.shouldBufferReplay(snapshotHasBufferedEvent(activeThreadId));
		if (shouldBufferReplay) {
			trace.push("thread.replay.buffer.begin=" + activeThreadId);
			traceReplayBufferPlan(action, trace);
		}
		if (suppressNotices)
			trace.push("thread.replay.pending_interactive=" + activeThreadId);
		if (action.session != null)
			replaySession(action.session, suppressNotices, trace);
		if (traceEnvelope)
			trace.push("thread.replay.autosend_suppressed=true");
		if (action.inputState != null)
			restoreInputState(action.inputState, state, trace);
		var replayed = 0;
		for (turn in action.turns) {
			replayTurn(turn, state, trace);
			replayed = replayed + 1;
		}
		for (request in action.snapshotRequests) {
			if (replaySnapshotRequest(request, action, trace))
				replayed = replayed + 1;
		}
		for (event in bufferedEvents) {
			final request = event.request;
			final notification = event.notification;
			if (request != null && request.threadId == activeThreadId) {
				if (isPendingRequest(request)) {
					replayed = replayed + 1;
					replayedRequestCount = replayedRequestCount + 1;
					trace.push("thread.replay.request=" + activeThreadId + ":" + request.requestId + ":" + request.displayId() + ":thread_snapshot");
					traceReplayRequestSurface(request, action, trace);
				} else {
					skippedReplayRequestCount = skippedReplayRequestCount + 1;
					trace.push("thread.replay.skip.request=" + activeThreadId + ":" + request.requestId + ":" + request.displayId() + ":non_pending");
				}
			} else if (notification != null && notification.threadId == activeThreadId) {
				if (suppressNotices && isNotice(notification)) {
					suppressedReplayNoticeCount = suppressedReplayNoticeCount + 1;
					trace.push("thread.replay.notice_suppressed="
						+ activeThreadId
						+ ":"
						+ notification.notificationId
						+ ":"
						+ notification.displayText());
				} else {
					replayed = replayed + 1;
					applyDeliveredNotification(notification, state);
					trace.push("thread.replay.notification=" + activeThreadId + ":" + notification.notificationId + ":" + notification.displayText()
						+ ":thread_snapshot");
					if (isChatWidgetSuppressed(notification)) {
						trace.push("thread.replay.notification_suppressed=" + activeThreadId + ":" + notification.notificationId + ":" + notification.kind);
					}
				}
			}
		}
		for (snapshotEvent in action.snapshotEvents) {
			if (replaySnapshotEvent(snapshotEvent, suppressNotices, state, trace))
				replayed = replayed + 1;
		}
		if (replayed == 0)
			trace.push("thread.replay.empty=" + activeThreadId);
		traceReplayBufferFlush(action, trace);
		if (shouldBufferReplay)
			trace.push("thread.replay.buffer.end=" + activeThreadId);
		if (traceEnvelope)
			trace.push("thread.replay.autosend_suppressed=false");
		if (action.inputState != null && action.inputState.pendingInitialSubmit) {
			trace.push("thread.replay.initial_submit=" + activeThreadId);
		}
		if (action.resumeRestoredQueue && action.inputState != null && action.inputState.hasQueuedUserMessage()) {
			trace.push("thread.replay.resume_queue=" + activeThreadId + ":" + action.inputState.queuedUserMessageCount);
		}
	}

	function replaySnapshotRequest(request:TuiSmokeAppServerRequest, action:TuiSmokeThreadReplayAction, trace:Array<String>):Bool {
		if (request == null || request.threadId != activeThreadId)
			return false;
		if (!request.canReplaySurface()) {
			if (action.traceRequestSurfaces) {
				trace.push("thread.replay.request_surface_suppressed="
					+ activeThreadId
					+ ":"
					+ request.requestId
					+ ":"
					+ request.kind
					+ ":thread_snapshot");
			}
			return false;
		}
		replayedRequestCount = replayedRequestCount + 1;
		trace.push("thread.replay.request=" + activeThreadId + ":" + request.requestId + ":" + request.displayId() + ":thread_snapshot");
		traceReplayRequestSurface(request, action, trace);
		return true;
	}

	function traceReplayBufferPlan(action:TuiSmokeThreadReplayAction, trace:Array<String>):Void {
		final replayBuffer = action.replayBuffer;
		if (replayBuffer == null || !replayBuffer.enabled())
			return;
		trace.push("thread.replay.buffer.plan=" + activeThreadId + ":" + replayBuffer.kind + ":size=" + replayBuffer.sizeText() + ":previous="
			+ replayBuffer.previousSizeText() + ":max_rows=" + replayBuffer.maxRowsText() + ":tail=" + replayBuffer.renderFromTranscriptTail);
	}

	function traceReplayBufferFlush(action:TuiSmokeThreadReplayAction, trace:Array<String>):Void {
		final replayBuffer = action.replayBuffer;
		if (replayBuffer == null || !replayBuffer.enabled())
			return;
		if (replayBuffer.flushAfterReplay) {
			trace.push("thread.replay.buffer.flush=" + activeThreadId + ":" + replayBuffer.kind + ":retained_rows=" + replayBuffer.retainedRows
				+ ":max_rows=" + replayBuffer.maxRowsText() + ":tail=" + replayBuffer.renderFromTranscriptTail);
		}
		if (replayBuffer.shouldScheduleReflow()) {
			trace.push("thread.replay.reflow.schedule=" + activeThreadId + ":from=" + replayBuffer.previousSizeText() + ":to=" + replayBuffer.sizeText()
				+ ":target_width=" + replayBuffer.targetWidthText() + ":height_changed=" + replayBuffer.heightChanged());
		}
		if (replayBuffer.reflowAfterFlush) {
			trace.push("thread.replay.reflow.run=" + activeThreadId + ":width=" + replayBuffer.targetWidthText() + ":source=transcript");
		}
	}

	function replaySnapshotEvent(event:TuiSmokeThreadReplayEvent, suppressNotices:Bool, state:TuiSmokeAppState, trace:Array<String>):Bool {
		if (event == null || event.threadId != activeThreadId)
			return false;
		return switch event.kind {
			case TuiSmokeThreadReplayEventKind.Notification:
				replaySnapshotNotification(event, suppressNotices, state, trace);
			case TuiSmokeThreadReplayEventKind.HistoryEntryResponse:
				replayHistoryEntryResponse(event, state, trace);
			case TuiSmokeThreadReplayEventKind.FeedbackSubmission:
				replayFeedbackSubmission(event, state, trace);
			case _:
				false;
		}
	}

	function replaySnapshotNotification(event:TuiSmokeThreadReplayEvent, suppressNotices:Bool, state:TuiSmokeAppState, trace:Array<String>):Bool {
		final notification = event.notification;
		if (notification == null)
			return false;
		if (suppressNotices && isNotice(notification)) {
			suppressedReplayNoticeCount = suppressedReplayNoticeCount + 1;
			trace.push("thread.replay.notice_suppressed="
				+ activeThreadId
				+ ":"
				+ notification.notificationId
				+ ":"
				+ notification.displayText());
			return false;
		}
		applyDeliveredNotification(notification, state);
		trace.push("thread.replay.notification="
			+ activeThreadId
			+ ":"
			+ notification.notificationId
			+ ":"
			+ notification.displayText()
			+ ":thread_snapshot");
		if (isChatWidgetSuppressed(notification)) {
			trace.push("thread.replay.notification_suppressed=" + activeThreadId + ":" + notification.notificationId + ":" + notification.kind);
		}
		return true;
	}

	function replayHistoryEntryResponse(event:TuiSmokeThreadReplayEvent, state:TuiSmokeAppState, trace:Array<String>):Bool {
		state.appendTranscript(new TuiSmokeTranscriptRow({
			source: TuiSmokeTranscriptSource.System,
			text: "history: " + event.displayText()
		}));
		trace.push("thread.replay.history_entry=" + activeThreadId + ":" + event.eventId + ":" + event.displayText() + ":thread_snapshot");
		return true;
	}

	function replayFeedbackSubmission(event:TuiSmokeThreadReplayEvent, state:TuiSmokeAppState, trace:Array<String>):Bool {
		final prefix = event.success ? "feedback: " : "feedback-error: ";
		state.appendTranscript(new TuiSmokeTranscriptRow({
			source: TuiSmokeTranscriptSource.System,
			text: prefix + event.displayText()
		}));
		trace.push("thread.replay.feedback=" + activeThreadId + ":" + event.eventId + ":" + event.category + ":" + (event.success ? "ok" : "error") + ":"
			+ event.displayText() + ":logs=" + event.includeLogs + ":thread_snapshot");
		return true;
	}

	function traceReplayRequestSurface(request:TuiSmokeAppServerRequest, action:TuiSmokeThreadReplayAction, trace:Array<String>):Void {
		if (!action.traceRequestSurfaces)
			return;
		trace.push("thread.replay.request_surface=" + activeThreadId + ":" + request.requestId + ":" + request.replaySurface() + ":" + request.displayId()
			+ ":thread_snapshot");
	}

	function hasReplayEnvelope(action:TuiSmokeThreadReplayAction):Bool {
		return action.session != null || action.inputState != null || action.snapshotRequests.length > 0 || action.snapshotEvents.length > 0
			|| action.replayBuffer != null || action.traceRequestSurfaces || action.resizeReflowEnabled || action.resumeRestoredQueue;
	}

	function replaySession(session:TuiSmokeThreadSession, suppressNotices:Bool, trace:Array<String>):Void {
		final display = session.displayFor(suppressNotices);
		trace.push("thread.replay.session=" + session.threadId + ":" + display + ":" + session.model + ":" + session.title);
	}

	function restoreInputState(inputState:TuiSmokeThreadInputState, state:TuiSmokeAppState, trace:Array<String>):Void {
		state.updateInput(inputState.composerText);
		if (inputState.taskRunning)
			state.updateStatus("working");
		trace.push("thread.replay.input=" + activeThreadId + ":" + inputState.composerText + ":task_running=" + inputState.taskRunning + ":queued="
			+ inputState.queuedUserMessageCount + ":initial_submit=" + inputState.pendingInitialSubmit);
	}

	function replayTurn(turn:TuiSmokeThreadTurn, state:TuiSmokeAppState, trace:Array<String>):Void {
		replayedTurnCount = replayedTurnCount + 1;
		trace.push("thread.replay.turn=" + activeThreadId + ":" + turn.turnId + ":" + turn.status + ":thread_snapshot");
		if (turn.status == TuiSmokeThreadTurnStatus.InProgress)
			state.updateStatus("working");
		for (item in turn.items) {
			replayItem(turn.turnId, item, state, trace);
		}
		if (turn.isTerminal()) {
			replayedCompletionCount = replayedCompletionCount + 1;
			trace.push("thread.replay.turn_complete=" + activeThreadId + ":" + turn.turnId + ":" + turn.status + ":thread_snapshot");
		}
	}

	function replayItem(turnId:String, item:TuiSmokeThreadItem, state:TuiSmokeAppState, trace:Array<String>):Void {
		replayedItemCount = replayedItemCount + 1;
		if (item.kind != TuiSmokeThreadItemKind.Unknown) {
			state.appendTranscript(new TuiSmokeTranscriptRow({
				source: item.transcriptSource(),
				text: item.text
			}));
		}
		trace.push("thread.replay.item="
			+ activeThreadId
			+ ":"
			+ turnId
			+ ":"
			+ item.itemId
			+ ":"
			+ item.kind
			+ ":"
			+ item.text
			+ ":thread_snapshot");
	}

	function evictQueued(requestId:String, trace:Array<String>):Void {
		if (requestId.length == 0) {
			trace.push("thread.evict.stale=");
			return;
		}
		var i = 0;
		while (i < queuedRequests.length) {
			final request = queuedRequests[i];
			if (request.requestId == requestId) {
				queuedRequests.splice(i, 1);
				removePendingRequest(request.requestId);
				removeBufferedRequest(requestId);
				evictedRequestCount = evictedRequestCount + 1;
				trace.push("thread.evict=" + requestId + ":" + request.displayId());
				return;
			}
			i = i + 1;
		}
		trace.push("thread.evict.stale=" + requestId);
	}

	public function evictNotification(notificationId:String, trace:Array<String>):Void {
		if (notificationId.length == 0) {
			trace.push("thread.notification.evict.stale=");
			return;
		}
		var i = 0;
		while (i < queuedNotifications.length) {
			final notification = queuedNotifications[i];
			if (notification.notificationId == notificationId) {
				queuedNotifications.splice(i, 1);
				removeBufferedNotification(notificationId);
				evictedNotificationCount = evictedNotificationCount + 1;
				trace.push("thread.notification.evict=" + notificationId + ":" + notification.displayText());
				return;
			}
			i = i + 1;
		}
		trace.push("thread.notification.evict.stale=" + notificationId);
	}

	function applyDeliveredNotification(notification:TuiSmokeThreadNotification, state:TuiSmokeAppState):Void {
		switch notification.kind {
			case TuiSmokeThreadNotificationKind.ThreadStatus:
				state.updateStatus(notification.status);
			case TuiSmokeThreadNotificationKind.AssistantDelta:
				state.appendTranscript(new TuiSmokeTranscriptRow({
					source: TuiSmokeTranscriptSource.Assistant,
					text: notification.delta
				}));
			case TuiSmokeThreadNotificationKind.Warning:
				state.appendTranscript(new TuiSmokeTranscriptRow({
					source: TuiSmokeTranscriptSource.System,
					text: notification.message
				}));
			case TuiSmokeThreadNotificationKind.ThreadArchived | TuiSmokeThreadNotificationKind.ThreadUnarchived:
				return;
			case TuiSmokeThreadNotificationKind.ThreadClosed:
				state.updateStatus("closed");
			case _:
		}
	}

	function snapshotHasBufferedEvent(threadId:String):Bool {
		for (event in bufferedEvents) {
			final request = event.request;
			final notification = event.notification;
			if (request != null && request.threadId == threadId)
				return true;
			if (notification != null && notification.threadId == threadId)
				return true;
		}
		return false;
	}

	function snapshotHasPendingInteractiveRequest(threadId:String):Bool {
		for (event in bufferedEvents) {
			final request = event.request;
			if (request != null && request.threadId == threadId && isPendingRequest(request) && isThreadBound(request.kind)) {
				return true;
			}
		}
		return false;
	}

	function isPendingRequest(request:TuiSmokeAppServerRequest):Bool {
		if (request == null || request.requestId.length == 0)
			return false;
		for (pending in pendingRequests) {
			if (pending.requestId == request.requestId)
				return true;
		}
		return false;
	}

	function removePendingRequest(requestId:String):Void {
		if (requestId.length == 0)
			return;
		var i = 0;
		while (i < pendingRequests.length) {
			if (pendingRequests[i].requestId == requestId) {
				pendingRequests.splice(i, 1);
			} else {
				i = i + 1;
			}
		}
	}

	function removeQueuedRequest(requestId:String):Void {
		if (requestId.length == 0)
			return;
		var i = 0;
		while (i < queuedRequests.length) {
			if (queuedRequests[i].requestId == requestId) {
				queuedRequests.splice(i, 1);
			} else {
				i = i + 1;
			}
		}
	}

	function removeQueuedNotification(notificationId:String):Void {
		if (notificationId.length == 0)
			return;
		var i = 0;
		while (i < queuedNotifications.length) {
			if (queuedNotifications[i].notificationId == notificationId) {
				queuedNotifications.splice(i, 1);
			} else {
				i = i + 1;
			}
		}
	}

	function removeBufferedRequest(requestId:String):Void {
		if (requestId.length == 0)
			return;
		var i = 0;
		while (i < bufferedEvents.length) {
			final request = bufferedEvents[i].request;
			if (request != null && request.requestId == requestId) {
				bufferedEvents.splice(i, 1);
			} else {
				i = i + 1;
			}
		}
	}

	function removeBufferedNotification(notificationId:String):Void {
		if (notificationId.length == 0)
			return;
		var i = 0;
		while (i < bufferedEvents.length) {
			final notification = bufferedEvents[i].notification;
			if (notification != null && notification.notificationId == notificationId) {
				bufferedEvents.splice(i, 1);
			} else {
				i = i + 1;
			}
		}
	}

	static function isNotice(notification:TuiSmokeThreadNotification):Bool {
		return notification.kind == TuiSmokeThreadNotificationKind.Warning;
	}

	static function isChatWidgetSuppressed(notification:TuiSmokeThreadNotification):Bool {
		return notification.kind == TuiSmokeThreadNotificationKind.ThreadArchived
			|| notification.kind == TuiSmokeThreadNotificationKind.ThreadUnarchived;
	}

	function takePendingForResolution(resolution:TuiSmokeAppServerResolution):Null<TuiSmokeAppServerRequest> {
		final requestKind = requestKindForResolution(resolution.kind);
		if (requestKind == TuiSmokeAppServerRequestKind.Unknown)
			return null;
		final key = resolution.id;
		var i = 0;
		while (i < pendingRequests.length) {
			final request = pendingRequests[i];
			if (request.kind == requestKind && pendingResolutionKey(request, resolution.kind) == key) {
				pendingRequests.splice(i, 1);
				return request;
			}
			i = i + 1;
		}
		return null;
	}

	function takePendingByRequestId(requestId:String):Null<TuiSmokeAppServerRequest> {
		if (requestId.length == 0)
			return null;
		var i = 0;
		while (i < pendingRequests.length) {
			final request = pendingRequests[i];
			if (request.requestId == requestId) {
				pendingRequests.splice(i, 1);
				return request;
			}
			i = i + 1;
		}
		return null;
	}

	function targetForThread(threadId:String):String {
		if (primaryThreadId.length == 0) {
			primaryThreadId = threadId;
			activeThreadId = threadId;
			return "primary";
		}
		return primaryThreadId == threadId ? "primary" : "side";
	}

	static function isThreadBound(kind:TuiSmokeAppServerRequestKind):Bool {
		return switch kind {
			case TuiSmokeAppServerRequestKind.CommandApproval | TuiSmokeAppServerRequestKind.FileChangeApproval | TuiSmokeAppServerRequestKind.PermissionsApproval | TuiSmokeAppServerRequestKind.ToolUserInput | TuiSmokeAppServerRequestKind.McpElicitation:
				true;
			case _:
				false;
		}
	}

	static function unsupportedReason(kind:TuiSmokeAppServerRequestKind):String {
		return switch kind {
			case TuiSmokeAppServerRequestKind.DynamicToolCall:
				"Dynamic tool calls are not available in TUI yet.";
			case TuiSmokeAppServerRequestKind.AttestationGenerate:
				"Attestation generation is not available in TUI.";
			case TuiSmokeAppServerRequestKind.LegacyPatchApproval:
				"Legacy patch approval requests are not available in TUI yet.";
			case TuiSmokeAppServerRequestKind.LegacyCommandApproval:
				"Legacy command approval requests are not available in TUI yet.";
			case _:
				"";
		}
	}

	static function requestKindForResolution(kind:TuiSmokeAppServerResolutionKind):TuiSmokeAppServerRequestKind {
		return switch kind {
			case TuiSmokeAppServerResolutionKind.CommandApproval:
				TuiSmokeAppServerRequestKind.CommandApproval;
			case TuiSmokeAppServerResolutionKind.FileChangeApproval:
				TuiSmokeAppServerRequestKind.FileChangeApproval;
			case TuiSmokeAppServerResolutionKind.PermissionsApproval:
				TuiSmokeAppServerRequestKind.PermissionsApproval;
			case TuiSmokeAppServerResolutionKind.ToolUserInput:
				TuiSmokeAppServerRequestKind.ToolUserInput;
			case _:
				TuiSmokeAppServerRequestKind.Unknown;
		}
	}

	static function pendingResolutionKey(request:TuiSmokeAppServerRequest, kind:TuiSmokeAppServerResolutionKind):String {
		return kind == TuiSmokeAppServerResolutionKind.ToolUserInput ? request.turnId : request.displayId();
	}

	static function resolutionKey(resolution:TuiSmokeAppServerResolution):String {
		return resolution.requestId.length > 0 ? resolution.requestId : resolution.id;
	}

	static function resolutionSummary(resolution:TuiSmokeAppServerResolution):String {
		return switch resolution.kind {
			case TuiSmokeAppServerResolutionKind.CommandApproval | TuiSmokeAppServerResolutionKind.FileChangeApproval | TuiSmokeAppServerResolutionKind.PermissionsApproval:
				resolution.decision.length > 0 ? resolution.decision : "resolved";
			case TuiSmokeAppServerResolutionKind.ToolUserInput:
				resolution.response.length > 0 ? resolution.response : "answered";
			case TuiSmokeAppServerResolutionKind.ServerRequestResolved:
				"dismissed";
			case _:
				"unknown";
		}
	}
}
