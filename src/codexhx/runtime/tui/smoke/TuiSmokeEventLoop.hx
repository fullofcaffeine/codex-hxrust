package codexhx.runtime.tui.smoke;

class TuiSmokeEventLoop {
	public static function run(request:TuiSmokeLoopRequest):TuiSmokeLoopOutcome {
		if (request == null || request.frame == null) return rejected("missing_loop_request");
		if (request.frame.allowNetwork || request.frame.allowModelCall) return rejected("live_effects_not_allowed");

		final terminal = new TuiSmokeTerminalFacade(request.frame.terminalMode, []);
		if (!terminal.setup(request.frame.allowLiveTerminal)) return rejected("terminal_setup_rejected");

		final state = new TuiSmokeAppState(request.frame);
		final appQueue = new TuiSmokeAppEventQueue();
		final appServer = new TuiSmokeAppServerFacade();
		final trace:Array<String> = [];
		var snapshot = "";
		var exit = TuiSmokeExitKind.Rendered;
		var renderCount = 0;
		var running = true;

		for (event in request.events) {
			if (!running) continue;
			switch event.kind {
				case TuiSmokeEventKind.Draw:
					final appExit = drainAppEvents(appQueue, state, trace);
					if (appExit != TuiSmokeExitKind.Rendered) {
						exit = appExit;
						running = false;
					}
					if (!running) continue;
					trace.push("tui.draw");
					snapshot = terminal.render(state.frame());
					renderCount = renderCount + 1;
				case TuiSmokeEventKind.Resize:
					final appExit = drainAppEvents(appQueue, state, trace);
					if (appExit != TuiSmokeExitKind.Rendered) {
						exit = appExit;
						running = false;
					}
					if (!running) continue;
					trace.push("tui.resize");
					snapshot = terminal.render(state.frame());
					renderCount = renderCount + 1;
				case TuiSmokeEventKind.StatusUpdate:
					state.updateStatus(event.status);
					trace.push("app.status=" + event.status);
				case TuiSmokeEventKind.InputUpdate:
					state.updateInput(event.input);
					trace.push("app.input=" + event.input);
				case TuiSmokeEventKind.Key:
					final appExit = drainAppEvents(appQueue, state, trace);
					if (appExit != TuiSmokeExitKind.Rendered) {
						exit = appExit;
						running = false;
					}
					if (!running) continue;
					exit = TuiSmokeRunner.exitForKey(event.key);
					trace.push("tui.key=" + event.key);
					if (exit != TuiSmokeExitKind.Rendered) running = false;
				case TuiSmokeEventKind.AppExit:
					exit = event.exitMode == TuiSmokeExitMode.Immediate ? TuiSmokeExitKind.Quit : TuiSmokeExitKind.Cancelled;
					trace.push("app.exit=" + event.exitMode);
					running = false;
				case TuiSmokeEventKind.EnqueueApp:
					final sent = appQueue.send(event.appEvent);
					trace.push(sent ? "queue.enqueue=" + event.appEvent.kind : "queue.enqueue=rejected");
				case TuiSmokeEventKind.AppServer:
					final serverExit = appServer.handle(event.appServerEvent, state, trace);
					if (serverExit != TuiSmokeExitKind.Rendered) {
						exit = serverExit;
						running = false;
					}
				case TuiSmokeEventKind.AppServerRequest:
					final requestExit = appServer.handleRequest(event.appServerRequest, trace);
					if (requestExit != TuiSmokeExitKind.Rendered) {
						exit = requestExit;
						running = false;
					}
				case TuiSmokeEventKind.AppServerResolution:
					final resolutionExit = appServer.handleResolution(event.appServerResolution, trace);
					if (resolutionExit != TuiSmokeExitKind.Rendered) {
						exit = resolutionExit;
						running = false;
					}
				case TuiSmokeEventKind.ThreadNotification:
					final notificationExit = appServer.handleThreadNotification(event.threadNotification, trace);
					if (notificationExit != TuiSmokeExitKind.Rendered) {
						exit = notificationExit;
						running = false;
					}
				case TuiSmokeEventKind.ThreadDelivery:
					final deliveryExit = appServer.handleThreadDelivery(event.threadDelivery, state, trace);
					if (deliveryExit != TuiSmokeExitKind.Rendered) {
						exit = deliveryExit;
						running = false;
					}
				case TuiSmokeEventKind.ThreadReplay:
					final replayExit = appServer.handleThreadReplay(event.threadReplay, state, trace);
					if (replayExit != TuiSmokeExitKind.Rendered) {
						exit = replayExit;
						running = false;
					}
				case _:
					exit = TuiSmokeExitKind.Rejected;
					trace.push("event.unknown");
					running = false;
			}
		}

		terminal.restore();
		final traceText = trace.join("\n");
		final finalSnapshot = snapshot
			+ "\ntrace:\n" + traceText
			+ "\nexit: " + exit
			+ "\nrenders: " + renderCount
			+ "\napp-events: " + appQueue.logged()
			+ "\nserver-events: " + appServer.handled()
			+ "\nserver-requests: " + appServer.handledRequests()
			+ "\nserver-rejections: " + appServer.rejectedRequests()
			+ "\nserver-resolutions: " + appServer.handledResolutions()
			+ "\nserver-stale-resolutions: " + appServer.staleResolutions()
			+ "\nserver-deliveries: " + appServer.deliveredRequests()
			+ "\nserver-evictions: " + appServer.evictedRequests()
			+ "\nthread-notifications: " + appServer.handledThreadNotifications()
			+ "\nthread-notification-deliveries: " + appServer.deliveredThreadNotifications()
			+ "\nthread-notification-evictions: " + appServer.evictedThreadNotifications()
			+ "\nthread-replays: " + appServer.handledThreadReplays()
			+ "\nthread-replay-requests: " + appServer.replayedThreadRequests()
			+ "\nthread-replay-skipped-requests: " + appServer.skippedThreadReplayRequests()
			+ "\nthread-replay-suppressed-notices: " + appServer.suppressedThreadReplayNotices()
			+ "\nthread-replay-turns: " + appServer.replayedThreadTurns()
			+ "\nthread-replay-items: " + appServer.replayedThreadItems()
			+ "\nthread-replay-completions: " + appServer.replayedThreadCompletions()
			+ "\nterminal: restored";
		final ok = exit == request.expectedExit
			&& traceText == request.expectedTrace
			&& finalSnapshot == request.expectedSnapshot
			&& terminal.wasRestored();
		return new TuiSmokeLoopOutcome({
			ok: ok,
			code: ok ? "ok" : "loop_mismatch",
			exit: exit,
			snapshot: finalSnapshot,
			trace: traceText,
			renderCount: renderCount,
			appEventLogCount: appQueue.logged(),
			appServerEventCount: appServer.handled(),
			appServerRequestCount: appServer.handledRequests(),
			appServerRejectedRequestCount: appServer.rejectedRequests(),
			appServerResolutionCount: appServer.handledResolutions(),
			appServerStaleResolutionCount: appServer.staleResolutions(),
			appServerDeliveredRequestCount: appServer.deliveredRequests(),
			appServerEvictedRequestCount: appServer.evictedRequests(),
			threadNotificationCount: appServer.handledThreadNotifications(),
			threadNotificationDeliveryCount: appServer.deliveredThreadNotifications(),
			threadNotificationEvictionCount: appServer.evictedThreadNotifications(),
			threadReplayCount: appServer.handledThreadReplays(),
			threadReplayRequestCount: appServer.replayedThreadRequests(),
			threadReplaySkippedRequestCount: appServer.skippedThreadReplayRequests(),
			threadReplaySuppressedNoticeCount: appServer.suppressedThreadReplayNotices(),
			threadReplayTurnCount: appServer.replayedThreadTurns(),
			threadReplayItemCount: appServer.replayedThreadItems(),
			threadReplayCompletionCount: appServer.replayedThreadCompletions(),
			terminalRestored: terminal.wasRestored()
		});
	}

	static function drainAppEvents(
		appQueue:TuiSmokeAppEventQueue,
		state:TuiSmokeAppState,
		trace:Array<String>
	):TuiSmokeExitKind {
		while (appQueue.hasNext()) {
			final event = appQueue.next();
			if (event == null) return TuiSmokeExitKind.Rendered;
			switch event.kind {
				case TuiSmokeAppEventKind.StartupStatus:
					state.updateStatus(event.status);
					trace.push("app.event.startup_status=" + event.status);
				case TuiSmokeAppEventKind.CommitTick:
					trace.push("app.event.commit_tick");
				case TuiSmokeAppEventKind.Exit:
					trace.push("app.event.exit=" + event.exitMode);
					return event.exitMode == TuiSmokeExitMode.Immediate ? TuiSmokeExitKind.Quit : TuiSmokeExitKind.Cancelled;
				case _:
					trace.push("app.event.unknown");
					return TuiSmokeExitKind.Rejected;
			}
		}
		return TuiSmokeExitKind.Rendered;
	}

	static function rejected(code:String):TuiSmokeLoopOutcome {
		return new TuiSmokeLoopOutcome({
			ok: false,
			code: code,
			exit: TuiSmokeExitKind.Rejected,
			snapshot: "",
			trace: "",
			renderCount: 0,
			appEventLogCount: 0,
			appServerEventCount: 0,
			appServerRequestCount: 0,
			appServerRejectedRequestCount: 0,
			appServerResolutionCount: 0,
			appServerStaleResolutionCount: 0,
			appServerDeliveredRequestCount: 0,
			appServerEvictedRequestCount: 0,
			threadNotificationCount: 0,
			threadNotificationDeliveryCount: 0,
			threadNotificationEvictionCount: 0,
			threadReplayCount: 0,
			threadReplayRequestCount: 0,
			threadReplaySkippedRequestCount: 0,
			threadReplaySuppressedNoticeCount: 0,
			threadReplayTurnCount: 0,
			threadReplayItemCount: 0,
			threadReplayCompletionCount: 0,
			terminalRestored: false
		});
	}
}
