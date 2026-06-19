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
				case TuiSmokeEventKind.ResizeDraw:
					final appExit = drainAppEvents(appQueue, state, trace);
					if (appExit != TuiSmokeExitKind.Rendered) {
						exit = appExit;
						running = false;
					}
					if (!running) continue;
					if (event.resizeDraw == null) {
						exit = TuiSmokeExitKind.Rejected;
						trace.push("tui.resize_draw.unknown");
						running = false;
						continue;
					}
					traceResizeDraw(event.resizeDraw, trace);
					trace.push("tui.draw");
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
				case TuiSmokeEventKind.EventStream:
					if (!traceEventStream(event.eventStream, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.TerminalMode:
					if (!traceTerminalMode(event.terminalModePlan, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.AltScreen:
					if (!traceAltScreen(event.altScreen, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.DrawComposition:
					if (!traceDrawComposition(event.drawComposition, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.FrameScheduler:
					if (!traceFrameScheduler(event.frameScheduler, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.DrawDispatch:
					if (!traceDrawDispatch(event.drawDispatch, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.OverlayRouting:
					if (!traceOverlayRouting(event.overlayRouting, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ApprovalOverlay:
					if (!traceApprovalOverlay(event.approvalOverlay, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.UserInputOverlay:
					if (!traceUserInputOverlay(event.userInputOverlay, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.McpElicitationOverlay:
					if (!traceMcpElicitationOverlay(event.mcpElicitationOverlay, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.AppLinkOverlay:
					if (!traceAppLinkOverlay(event.appLinkOverlay, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.HooksBrowser:
					if (!traceHooksBrowser(event.hooksBrowser, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.SlashCommandPopup:
					if (!traceSlashCommandPopup(event.slashCommandPopup, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.FileMentionPopup:
					if (!traceFileMentionPopup(event.fileMentionPopup, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.HistorySearch:
					if (!traceHistorySearch(event.historySearch, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ComposerAttachment:
					if (!traceComposerAttachment(event.composerAttachment, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ComposerSubmission:
					if (!traceComposerSubmission(event.composerSubmission, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ComposerEditing:
					if (!traceComposerEditing(event.composerEditing, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ComposerPopupSync:
					if (!traceComposerPopupSync(event.composerPopupSync, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ComposerPopupKey:
					if (!traceComposerPopupKey(event.composerPopupKey, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ComposerPopupRender:
					if (!traceComposerPopupRender(event.composerPopupRender, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ComposerFooterRender:
					if (!traceComposerFooterRender(event.composerFooterRender, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ComposerTextareaRender:
					if (!traceComposerTextareaRender(event.composerTextareaRender, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ChatWidgetComposerRender:
					if (!traceChatWidgetComposerRender(event.chatWidgetComposerRender, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ChatWidgetActiveStream:
					if (!traceChatWidgetActiveStream(event.chatWidgetActiveStream, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ChatWidgetStreamStatus:
					if (!traceChatWidgetStreamStatus(event.chatWidgetStreamStatus, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ChatWidgetStreamLifecycle:
					if (!traceChatWidgetStreamLifecycle(event.chatWidgetStreamLifecycle, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ChatWidgetInterruptQuit:
					if (!traceChatWidgetInterruptQuit(event.chatWidgetInterruptQuit, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ChatWidgetInterruptedRestore:
					if (!traceChatWidgetInterruptedRestore(event.chatWidgetInterruptedRestore, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.SideConversation:
					if (!traceSideConversation(event.sideConversation, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ClearArchive:
					if (!traceClearArchive(event.clearArchive, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ResumeFork:
					if (!traceResumeFork(event.resumeFork, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.TerminalTitle:
					if (!traceTerminalTitle(event.terminalTitle, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.DesktopNotification:
					if (!traceDesktopNotification(event.desktopNotification, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.TerminalHyperlink:
					if (!traceTerminalHyperlink(event.terminalHyperlink, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.TerminalPaletteProbe:
					if (!traceTerminalPalette(event.terminalPalette, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.TerminalStartupProbe:
					if (!traceTerminalStartupProbe(event.terminalStartupProbe, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ClipboardCopy:
					if (!traceClipboardCopy(event.clipboardCopy, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ClipboardPaste:
					if (!traceClipboardPaste(event.clipboardPaste, trace)) {
						exit = TuiSmokeExitKind.Rejected;
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

	static function traceResizeDraw(action:TuiSmokeResizeDrawAction, trace:Array<String>):Void {
		trace.push(
			"tui.resize_draw.size="
			+ action.sizeText()
			+ ":last=" + action.lastSizeText()
			+ ":width=" + action.widthState()
			+ ":height_changed=" + action.heightChanged()
		);
		if (!action.resizeReflowEnabled) {
			if (action.widthChanged()) trace.push("tui.resize_draw.reflow.clear=disabled");
			return;
		}
		traceSuspendResume(action.suspendResume, trace);
		if (action.shouldRebuildTranscript()) {
			trace.push(
				"tui.resize_draw.reflow.schedule="
				+ "target_width=" + action.targetWidthText()
				+ ":accepted=" + action.scheduleAccepted
			);
			trace.push(action.scheduleAccepted ? "tui.frame.schedule=immediate" : "tui.frame.schedule_in=debounce");
			trace.push("tui.resize_draw.pending_history.clear=true");
		}
		if (!action.pendingReflow) {
			traceViewportResize(action.viewport, trace);
			traceSuspendCursorUpdate(action.suspendResume, action.viewport, trace);
			return;
		}
		if (!action.pendingDue) {
			trace.push("tui.resize_draw.reflow.rearm=" + action.remainingMs + "ms");
			trace.push("tui.frame.schedule_in=" + action.remainingMs + "ms");
			traceViewportResize(action.viewport, trace);
			traceSuspendCursorUpdate(action.suspendResume, action.viewport, trace);
			return;
		}
		if (action.overlayActive) {
			trace.push("tui.resize_draw.reflow.defer=overlay");
			traceViewportResize(action.viewport, trace);
			traceSuspendCursorUpdate(action.suspendResume, action.viewport, trace);
			return;
		}
		if (action.runReflow) {
			trace.push(
				"tui.resize_draw.reflow.run="
				+ "width=" + action.terminalWidth
				+ ":stream_time=" + action.streamTime
				+ ":transcript_cells=" + action.transcriptCells
			);
			traceResizeRepaint(action.repaint, trace);
		}
		if (action.followUpDraw) {
			trace.push("tui.frame.schedule_in=debounce_followup");
		}
		traceViewportResize(action.viewport, trace);
		traceSuspendCursorUpdate(action.suspendResume, action.viewport, trace);
	}

	static function traceResizeRepaint(repaint:TuiSmokeResizeRepaintPlan, trace:Array<String>):Void {
		if (repaint == null) return;
		trace.push("tui.repaint.pending_history.clear=" + repaint.pendingHistoryBatches);
		if (repaint.emptyTranscript) {
			trace.push("tui.repaint.transcript.empty_reset=true");
			return;
		}
		trace.push(
			"tui.repaint.render_source="
			+ "cells=" + repaint.transcriptCellCount
			+ ":rows=" + repaint.reflowedRows
			+ ":row_cap=" + repaint.rowCapText()
		);
		trace.push(
			"tui.repaint.clear="
			+ repaint.clearKind
			+ ":viewport_reset=" + repaint.viewportReset
			+ ":full=" + repaint.needsFullRepaint
		);
		trace.push("tui.repaint.deferred_history.clear=" + repaint.deferredHistoryRows);
		if (repaint.insertRows) {
			trace.push(
				"tui.repaint.insert="
				+ "rows=" + repaint.reflowedRows
				+ ":wrap=" + repaint.wrapPolicy
			);
			trace.push("tui.frame.schedule=history_insert");
		}
	}

	static function traceViewportResize(viewport:TuiSmokeViewportResizePlan, trace:Array<String>):Void {
		if (viewport == null) return;
		trace.push(
			"tui.viewport.resize="
			+ "from=" + viewport.previousAreaText()
			+ ":to=" + viewport.nextAreaText()
			+ ":requested_height=" + viewport.requestedHeight
		);
		trace.push(
			"tui.viewport.height="
			+ "shrank=" + viewport.terminalHeightShrank
			+ ":grew=" + viewport.terminalHeightGrew
			+ ":bottom_aligned=" + viewport.bottomAligned
		);
		if (viewport.scrollBy > 0) {
			if (viewport.terminalHeightShrank) {
				trace.push("tui.viewport.scroll_region_up=suppressed:shrink:rows=" + viewport.scrollBy);
			} else {
				trace.push("tui.viewport.scroll_region_up=0.." + viewport.previousY + ":rows=" + viewport.scrollBy);
			}
		}
		if (viewport.changed()) {
			trace.push("tui.viewport.set_area=" + viewport.nextAreaText());
			trace.push("tui.viewport.clear_after=0," + viewport.clearAfterY);
		} else {
			trace.push("tui.viewport.set_area=unchanged");
		}
		trace.push(
			"tui.viewport.pending_history.flush="
			+ "batches=" + viewport.pendingHistoryBatches
			+ ":rows=" + viewport.pendingHistoryRows
			+ ":mode=" + viewport.insertMode()
			+ ":wrap=" + viewport.wrapPolicy
		);
		if (viewport.needsFullRepaint) {
			trace.push("tui.viewport.invalidate=true");
		}
	}

	static function traceSuspendResume(plan:TuiSmokeSuspendResumePlan, trace:Array<String>):Void {
		if (plan == null || !plan.enabled()) return;
		trace.push(
			"tui.suspend.capture="
			+ "action=" + plan.action
			+ ":alt=" + plan.altScreenActive
			+ ":cursor_y=" + plan.cachedCursorY
		);
		if (plan.leaveAltScreen) {
			trace.push("tui.suspend.leave_alt_screen=true:alt_scroll=" + plan.altScroll);
		}
		trace.push(
			"tui.resume.prepare="
			+ plan.action
			+ ":cursor_y=" + plan.cursorYAfterResume
			+ ":saved=" + plan.savedViewportText()
		);
		switch plan.action {
			case TuiSmokeResumeActionKind.RealignInline:
				trace.push("tui.resume.apply=realign_viewport:" + plan.appliedViewportText());
			case TuiSmokeResumeActionKind.RestoreAlt:
				trace.push(
					"tui.resume.apply=restore_alt_screen:"
					+ plan.appliedViewportText()
					+ ":enter=" + plan.enterAltScreen
					+ ":alt_scroll=" + plan.altScroll
					+ ":clear=" + plan.clearAfterRestore
				);
			case _:
		}
	}

	static function traceSuspendCursorUpdate(
		plan:TuiSmokeSuspendResumePlan,
		viewport:TuiSmokeViewportResizePlan,
		trace:Array<String>
	):Void {
		if (plan == null || !plan.enabled() || viewport == null) return;
		final cursorY = plan.altScreenActive
			? plan.appliedViewportY + plan.appliedViewportHeight - 1
			: viewport.nextY + viewport.nextHeight - 1;
		trace.push("tui.suspend.cursor_y.set=" + cursorY);
	}

	static function traceEventStream(plan:TuiSmokeEventStreamPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveEventSource || !plan.enabled()) {
			trace.push("tui.event_stream.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.event_stream.broker.initial=" + plan.initialState);
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeEventStreamActionKind.CreateStream:
					trace.push(
						"tui.event_stream.create="
						+ "state=" + action.stateAfter
						+ ":draw_subscription=" + action.drawSubscription
						+ ":shared_broker=" + action.sharedBroker
					);
				case TuiSmokeEventStreamActionKind.Pause:
					trace.push(
						"tui.event_stream.pause="
						+ action.stateTransitionText()
						+ ":drop_source=" + action.dropSource
					);
				case TuiSmokeEventStreamActionKind.Resume:
					trace.push(
						"tui.event_stream.resume="
						+ action.stateTransitionText()
						+ ":wake=" + action.wakeResume
					);
				case TuiSmokeEventStreamActionKind.Poll:
					trace.push(
						"tui.event_stream.poll="
						+ action.mappedEvent
						+ ":order=" + action.pollOrder
						+ ":state=" + action.stateTransitionText()
						+ ":recreate_source=" + action.recreateSource
					);
				case TuiSmokeEventStreamActionKind.SourceEvent:
					trace.push(
						"tui.event_stream.map="
						+ action.mappedText()
						+ ":focused=" + action.terminalFocused
						+ ":palette_requery=" + action.paletteRequery
					);
				case TuiSmokeEventStreamActionKind.DrawEvent:
					trace.push("tui.event_stream.draw=ready:lagged=false->draw");
				case TuiSmokeEventStreamActionKind.LaggedDraw:
					trace.push("tui.event_stream.draw=ready:lagged=true->draw");
				case TuiSmokeEventStreamActionKind.FlushStaleInput:
					trace.push("tui.event_stream.flush_stale_input=true");
				case TuiSmokeEventStreamActionKind.RestoreTerminal:
					trace.push("tui.event_stream.restore_terminal=mode_keep_raw:" + action.keepRaw);
				case TuiSmokeEventStreamActionKind.PauseStderr:
					trace.push("tui.event_stream.stderr=pause");
				case TuiSmokeEventStreamActionKind.ResumeStderr:
					trace.push("tui.event_stream.stderr=resume");
				case TuiSmokeEventStreamActionKind.SetModes:
					trace.push("tui.event_stream.set_modes=true");
				case TuiSmokeEventStreamActionKind.LeaveAltScreen:
					trace.push("tui.event_stream.leave_alt_screen=" + action.altScreenActive);
				case TuiSmokeEventStreamActionKind.EnterAltScreen:
					trace.push("tui.event_stream.enter_alt_screen=" + action.altScreenActive);
				case _:
					trace.push("tui.event_stream.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceTerminalMode(plan:TuiSmokeTerminalModePlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveTerminalMode || !plan.enabled()) {
			trace.push("tui.terminal_modes.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.terminal_modes.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeTerminalModeActionKind.Init:
					trace.push(
						"tui.terminal_modes.init="
						+ "stdin=" + action.stdinTerminal
						+ ":stdout=" + action.stdoutTerminal
						+ ":set_modes=" + action.rawMode
						+ ":flush=" + action.flushInput
						+ ":panic_hook=" + action.panicHook
						+ ":keyboard_supported=" + action.supported
					);
				case TuiSmokeTerminalModeActionKind.SetModes:
					trace.push(
						"tui.terminal_modes.set_modes="
						+ "vt=" + action.virtualTerminalProcessing
						+ ":bracketed_paste=" + action.bracketedPaste
						+ ":raw=" + action.rawMode
						+ ":keyboard_push=" + action.pushKeyboardEnhancement
						+ ":focus=" + action.focusChange
					);
				case TuiSmokeTerminalModeActionKind.Restore:
					traceRestore("restore", action, trace);
				case TuiSmokeTerminalModeActionKind.RestoreAfterExit:
					traceRestore("restore_after_exit", action, trace);
				case TuiSmokeTerminalModeActionKind.RestoreKeepRaw:
					traceRestore("restore_keep_raw", action, trace);
				case TuiSmokeTerminalModeActionKind.KeyboardDecision:
					trace.push(
						"tui.keyboard_enhancement.decision="
						+ "disabled=" + action.keyboardEnhancementDisabled
						+ ":env=" + action.envOverride
						+ ":wsl=" + action.wsl
						+ ":vscode=" + action.vscodeTerminal
						+ ":tmux=" + action.tmuxSession
						+ ":tmux_csi_u=" + action.tmuxCsiU
					);
				case TuiSmokeTerminalModeActionKind.KeyboardPush:
					trace.push(
						"tui.keyboard_enhancement.push="
						+ "disambiguate_escape=true:report_event_types=true:report_alternate_keys=true"
					);
				case TuiSmokeTerminalModeActionKind.KeyboardPop:
					trace.push("tui.keyboard_enhancement.pop_stack=" + action.popKeyboardEnhancement);
				case TuiSmokeTerminalModeActionKind.KeyboardReset:
					trace.push("tui.keyboard_enhancement.reset_after_exit=" + action.resetKeyboardEnhancement + ":ansi=ESC[<u");
				case TuiSmokeTerminalModeActionKind.ModifyOtherKeys:
					trace.push(
						"tui.keyboard_enhancement.modify_other_keys="
						+ (action.modifyOtherKeys ? "enable" : "disable")
						+ ":tmux=" + action.tmuxSession
						+ ":csi_u=" + action.tmuxCsiU
					);
				case TuiSmokeTerminalModeActionKind.FlushInput:
					trace.push("tui.terminal_modes.flush_input=" + action.flushInput);
				case TuiSmokeTerminalModeActionKind.PanicHook:
					trace.push("tui.terminal_modes.panic_hook.restore_after_exit=" + action.panicHook);
				case TuiSmokeTerminalModeActionKind.Failure:
					trace.push("tui.terminal_modes.failure=" + action.failureCode + ":supported=" + action.supported);
				case _:
					trace.push("tui.terminal_modes.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceAltScreen(plan:TuiSmokeAltScreenPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveAltScreen || !plan.enabled()) {
			trace.push("tui.alt_screen.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.alt_screen.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeAltScreenActionKind.SetEnabled:
					trace.push("tui.alt_screen.enabled=" + action.enabled);
				case TuiSmokeAltScreenActionKind.Enter:
					if (!action.enabled) {
						trace.push("tui.alt_screen.enter=noop:enabled=false:active=" + action.activeBefore);
					} else {
						trace.push(
							"tui.alt_screen.enter="
							+ "active=" + action.activeTransitionText()
							+ ":terminal=" + action.terminalSizeText()
							+ ":save=" + action.previousViewportText()
							+ ":saved_after=" + action.savedViewportPresentAfter
							+ ":viewport=" + action.appliedViewportText()
							+ ":enter=" + action.enterAlternateScreen
							+ ":alt_scroll=" + action.enableAlternateScroll
							+ ":clear=" + action.clearTerminal
						);
					}
				case TuiSmokeAltScreenActionKind.Leave:
					if (!action.enabled) {
						trace.push("tui.alt_screen.leave=noop:enabled=false:active=" + action.activeBefore);
					} else {
						trace.push(
							"tui.alt_screen.leave="
							+ "active=" + action.activeTransitionText()
							+ ":restore=" + action.savedViewportText()
							+ ":saved_before=" + action.savedViewportPresentBefore
							+ ":saved_after=" + action.savedViewportPresentAfter
							+ ":viewport=" + action.appliedViewportText()
							+ ":leave=" + action.leaveAlternateScreen
							+ ":alt_scroll=" + action.disableAlternateScroll
						);
					}
				case TuiSmokeAltScreenActionKind.ClearForViewportChange:
					trace.push(
						"tui.alt_screen.clear_for_viewport_change="
						+ "from=" + action.previousViewportText()
						+ ":to=" + action.appliedViewportText()
						+ ":clear_after=" + action.clearAfterText()
					);
				case TuiSmokeAltScreenActionKind.Failure:
					trace.push("tui.alt_screen.failure=" + action.failureCode);
				case _:
					trace.push("tui.alt_screen.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceDrawComposition(plan:TuiSmokeDrawCompositionPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveDraw || !plan.enabled()) {
			trace.push("tui.draw_composition.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.draw_composition.plan=headless");
		trace.push(
			"tui.draw_composition.begin="
			+ plan.mode
			+ ":height=" + plan.height
			+ ":terminal=" + plan.terminalSizeText()
			+ ":last=" + plan.lastSizeText()
			+ ":sync_update=" + plan.syncUpdate
			+ ":vt=" + plan.ensureVirtualTerminalProcessing
			+ ":resume=" + plan.preparedResume
		);
		if (plan.mode == TuiSmokeDrawCompositionMode.Legacy) {
			trace.push(
				"tui.draw_composition.pending_viewport="
				+ "computed=" + plan.pendingViewportComputed
				+ ":cursor=" + plan.lastCursorY + "->" + plan.cursorY
				+ ":moved=" + plan.cursorMoved
				+ ":area=" + plan.pendingViewportText()
				+ ":clear=" + plan.terminalClear
			);
		} else if (plan.pendingViewportComputed) {
			trace.push("tui.draw_composition.pending_viewport=rejected_for_resize_reflow");
			return false;
		} else {
			trace.push("tui.draw_composition.pending_viewport=skipped:resize_reflow");
		}
		trace.push(
			"tui.draw_composition.viewport="
			+ "from=" + plan.previousViewportText()
			+ ":to=" + plan.appliedViewportText()
			+ ":clear_before_set=" + plan.clearForViewportChange
			+ ":scroll_up=" + plan.scrollRegionUp
			+ ":region=" + plan.scrollRegionText()
			+ ":rows=" + plan.scrollBy
		);
		trace.push(
			"tui.draw_composition.history_flush="
			+ "batches=" + plan.pendingHistoryBatches
			+ ":rows=" + plan.pendingHistoryRows
			+ ":mode=" + plan.historyInsertMode()
			+ ":wrap=" + plan.wrapPolicy
		);
		trace.push(
			"tui.draw_composition.repaint="
			+ "needs_full=" + plan.needsFullRepaint
			+ ":invalidate=" + plan.invalidateViewport
		);
		trace.push(
			"tui.draw_composition.suspend_cursor="
			+ plan.suspendCursorY
			+ ":alt=" + plan.altScreenActive
		);
		trace.push(
			"tui.draw_composition.terminal_draw="
			+ "autoresize=" + plan.autoresize
			+ ":render=" + plan.renderCallback
			+ ":puts=" + plan.diffPutCount
			+ ":clears=" + plan.diffClearToEndCount
			+ ":cursor=" + plan.cursorText()
			+ ":swap=" + plan.swapBuffers
			+ ":flush=" + plan.backendFlush
		);
		if (plan.failureCode != "") {
			trace.push("tui.draw_composition.failure=" + plan.failureCode);
		}
		return true;
	}

	static function traceFrameScheduler(plan:TuiSmokeFrameSchedulerPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveScheduler || !plan.enabled()) {
			trace.push("tui.frame_scheduler.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.frame_scheduler.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeFrameSchedulerActionKind.CreateRequester:
					trace.push(
						"tui.frame_scheduler.create="
						+ "spawn_task=" + action.spawnedTask
						+ ":broadcast_capacity=" + action.broadcastCapacity
					);
				case TuiSmokeFrameSchedulerActionKind.RequestImmediate:
					trace.push(
						"tui.frame_scheduler.request=immediate"
						+ ":source=" + action.source
						+ ":at=" + action.deadlineText(action.requestMs)
					);
				case TuiSmokeFrameSchedulerActionKind.RequestDelayed:
					trace.push(
						"tui.frame_scheduler.request=delayed"
						+ ":source=" + action.source
						+ ":delay=" + action.delayMs + "ms"
						+ ":at=" + action.deadlineText(action.requestMs)
					);
				case TuiSmokeFrameSchedulerActionKind.ClampDeadline:
					trace.push(
						"tui.frame_scheduler.clamp="
						+ "last=" + action.deadlineText(action.lastEmittedMs)
						+ ":min=" + action.minIntervalMs + "ms"
						+ ":requested=" + action.deadlineText(action.requestMs)
						+ ":clamped=" + action.deadlineText(action.clampedDeadlineMs)
					);
				case TuiSmokeFrameSchedulerActionKind.CoalesceDeadline:
					trace.push(
						"tui.frame_scheduler.coalesce="
						+ "prev=" + action.previousDeadlineText()
						+ ":request=" + action.deadlineText(action.requestMs)
						+ ":next=" + action.nextDeadlineText()
						+ ":requests=" + action.requestCount
						+ ":coalesced=" + action.coalescedCount
					);
				case TuiSmokeFrameSchedulerActionKind.EmitDraw:
					trace.push(
						"tui.frame_scheduler.emit="
						+ "deadline=" + action.nextDeadlineText()
						+ ":draw=" + action.drawSent
						+ ":emitted=" + action.emittedCount
					);
				case TuiSmokeFrameSchedulerActionKind.LaggedDraw:
					trace.push("tui.frame_scheduler.draw_stream=lagged:" + action.lagged + "->draw");
				case TuiSmokeFrameSchedulerActionKind.SenderDropped:
					trace.push("tui.frame_scheduler.sender_dropped=closed:" + action.closed);
				case TuiSmokeFrameSchedulerActionKind.Failure:
					trace.push("tui.frame_scheduler.failure=" + action.failureCode);
				case _:
					trace.push("tui.frame_scheduler.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceDrawDispatch(plan:TuiSmokeDrawDispatchPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveDispatch || !plan.enabled()) {
			trace.push("tui.draw_dispatch.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.draw_dispatch.plan=headless");
		trace.push(
			"tui.draw_dispatch.event="
			+ plan.event
			+ ":resize_reflow=" + plan.resizeReflowEnabled
			+ ":pre_render=" + plan.preRender
			+ ":size_changed=" + plan.sizeChanged
			+ ":status_refresh=" + plan.statusRefresh
		);
		trace.push(
			"tui.draw_dispatch.reflow="
			+ "clear_pending_history=" + plan.clearPendingHistory
			+ ":due=" + plan.reflowDue
			+ ":ran=" + plan.reflowRan
			+ ":rearm=" + plan.rearmDelayMs + "ms"
		);
		if (plan.overlayActive) {
			trace.push(
				"tui.draw_dispatch.overlay="
				+ plan.renderMode
				+ ":handled=" + plan.overlayHandled
				+ ":draw=u16_max"
			);
			return true;
		}
		trace.push(
			"tui.draw_dispatch.pre_admission="
			+ "backtrack_pending=" + plan.backtrackRenderPending
			+ ":backtrack_rebuilt=" + plan.backtrackRebuilt
			+ ":notification=" + plan.pendingNotification
		);
		trace.push(
			"tui.draw_dispatch.paste_burst="
			+ "flushed=" + plan.pasteBurstFlushed
			+ ":capturing=" + plan.pasteBurstCapturing
			+ ":skip=" + plan.pasteBurstSkippedFrame
			+ ":followup=" + plan.pasteBurstFollowupMs + "ms"
		);
		if (plan.pasteBurstSkippedFrame) {
			trace.push("tui.draw_dispatch.render=skipped:continue");
			return true;
		}
		trace.push(
			"tui.draw_dispatch.render="
			+ plan.renderMode
			+ ":pre_draw_tick=" + plan.preDrawTick
			+ ":desired_height=" + plan.desiredHeight
			+ ":area=" + plan.renderedAreaText()
			+ ":cursor=" + plan.cursorSet
		);
		trace.push(
			"tui.draw_dispatch.post_draw="
			+ "ambient_pet=" + plan.ambientPetDraw
			+ ":pet_preview=" + plan.petPreviewDraw
			+ ":pet_clear=" + plan.petPreviewClear
			+ ":external_editor=" + plan.externalEditorLaunch
			+ ":followup_frame=" + plan.followUpFrame
		);
		if (plan.failureCode != "") {
			trace.push("tui.draw_dispatch.failure=" + plan.failureCode);
		}
		return true;
	}

	static function traceOverlayRouting(plan:TuiSmokeOverlayRoutingPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveOverlay || !plan.enabled()) {
			trace.push("tui.overlay_routing.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.overlay_routing.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeOverlayRoutingActionKind.OpenTranscript:
					trace.push(
						"tui.overlay.open=transcript"
						+ ":title=" + action.title
						+ ":cells=" + action.committedCellsAfter
						+ ":enter_alt=" + action.enterAltScreen
						+ ":frame=" + action.frameScheduled
					);
				case TuiSmokeOverlayRoutingActionKind.OpenStatic:
					trace.push(
						"tui.overlay.open=static"
						+ ":title=" + action.title
						+ ":lines=" + action.lineCount
						+ ":enter_alt=" + action.enterAltScreen
						+ ":frame=" + action.frameScheduled
					);
				case TuiSmokeOverlayRoutingActionKind.InsertCommittedCell:
					trace.push(
						"tui.overlay.transcript.insert_cell="
						+ "cells=" + action.cellTransitionText()
						+ ":inserted=" + action.insertedCells
						+ ":pinned=" + action.pinnedTransitionText()
						+ ":frame=" + action.frameScheduled
					);
				case TuiSmokeOverlayRoutingActionKind.ConsolidateCells:
					trace.push(
						"tui.overlay.transcript.consolidate="
						+ "range=" + action.consolidateStart + ".." + action.consolidateEnd
						+ ":cells=" + action.cellTransitionText()
						+ ":pinned=" + action.pinnedTransitionText()
						+ ":frame=" + action.frameScheduled
					);
				case TuiSmokeOverlayRoutingActionKind.SyncLiveTail:
					trace.push(
						"tui.overlay.transcript.live_tail="
						+ "width=" + action.liveTailWidth
						+ ":revision=" + action.liveTailRevision
						+ ":continuation=" + action.liveTailContinuation
						+ ":tick=" + action.liveTailTickText()
						+ ":key_changed=" + action.liveTailKeyChanged
						+ ":computed=" + action.liveTailComputed
						+ ":lines=" + action.liveTailLines
						+ ":pinned=" + action.pinnedTransitionText()
						+ ":frame=" + action.frameScheduled
					);
				case TuiSmokeOverlayRoutingActionKind.Draw, TuiSmokeOverlayRoutingActionKind.Resize:
					trace.push(
						"tui.overlay.draw="
						+ action.overlay
						+ ":event=" + action.kind
						+ ":height=" + action.drawHeightText()
						+ ":area=" + action.renderedAreaText()
						+ ":owns_terminal=" + action.ownsTerminal
					);
				case TuiSmokeOverlayRoutingActionKind.Key:
					trace.push(
						"tui.overlay.key="
						+ action.overlay
						+ ":action=" + action.keyAction
						+ ":done=" + action.doneBefore + "->" + action.doneAfter
						+ ":scroll=" + action.scrollTransitionText()
						+ ":backtrack=" + action.backtrackPreviewText()
						+ ":frame=" + action.frameScheduled
					);
				case TuiSmokeOverlayRoutingActionKind.DoneCleanup:
					trace.push(
						"tui.overlay.done="
						+ action.overlay
						+ ":cleared=" + action.doneAfter
						+ ":leave_alt=" + action.leaveAltScreen
						+ ":deferred_history=" + action.deferredHistoryLines
						+ ":backtrack=" + action.backtrackPreviewText()
						+ ":frame=" + action.frameScheduled
					);
				case TuiSmokeOverlayRoutingActionKind.Failure:
					trace.push("tui.overlay.failure=" + action.failureCode);
				case _:
					trace.push("tui.overlay.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceApprovalOverlay(plan:TuiSmokeApprovalPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveApproval || !plan.enabled()) {
			trace.push("tui.approval.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.approval.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeApprovalActionKind.NoteServerRequest:
					trace.push(
						"tui.approval.pending.note="
						+ action.requestKind
						+ ":request=" + action.requestId
						+ ":approval=" + action.approvalId
						+ ":unsupported=" + action.unsupportedRejected
					);
				case TuiSmokeApprovalActionKind.ShowImmediate:
					trace.push(
						"tui.approval.show=immediate"
						+ ":request=" + action.requestKind
						+ ":title=" + action.promptTitle
						+ ":options=" + action.options
						+ ":views=" + action.viewStackTransitionText()
						+ ":pause_status=" + action.statusTimerPaused
					);
				case TuiSmokeApprovalActionKind.DelayRequest:
					trace.push(
						"tui.approval.delay="
						+ action.requestKind
						+ ":delayed=" + action.delayedTransitionText()
						+ ":remaining=" + action.delayMs + "ms"
						+ ":frame=" + action.frameScheduled
					);
				case TuiSmokeApprovalActionKind.PromoteDelayed:
					trace.push(
						"tui.approval.promote_delayed="
						+ "delayed=" + action.delayedTransitionText()
						+ ":queue=" + action.queueTransitionText()
						+ ":views=" + action.viewStackTransitionText()
						+ ":pause_status=" + action.statusTimerPaused
					);
				case TuiSmokeApprovalActionKind.EnqueueActive:
					trace.push(
						"tui.approval.enqueue_active="
						+ action.requestKind
						+ ":consumed=" + action.consumedByActiveView
						+ ":queue=" + action.queueTransitionText()
						+ ":frame=" + action.frameScheduled
					);
				case TuiSmokeApprovalActionKind.KeyDecision, TuiSmokeApprovalActionKind.ListDecision:
					trace.push(
						"tui.approval.decision="
						+ action.kind
						+ ":key=" + action.keyAction
						+ ":index=" + action.selectedIndex
						+ ":decision=" + action.decision
						+ ":history=" + action.historyCellInserted
						+ ":command=" + action.appCommandSent
						+ ":complete=" + action.completeTransitionText()
					);
				case TuiSmokeApprovalActionKind.Cancel:
					trace.push(
						"tui.approval.cancel="
						+ action.requestKind
						+ ":key=" + action.keyAction
						+ ":decision=" + action.decision
						+ ":command=" + action.appCommandSent
						+ ":queue=" + action.queueTransitionText()
						+ ":complete=" + action.completeTransitionText()
					);
				case TuiSmokeApprovalActionKind.Resolve:
					trace.push(
						"tui.approval.resolve="
						+ action.requestKind
						+ ":request=" + action.requestId
						+ ":approval=" + action.approvalId
						+ ":decision=" + action.decision
						+ ":sent=" + action.resolutionSent
					);
				case TuiSmokeApprovalActionKind.DismissResolved:
					trace.push(
						"tui.approval.dismiss_resolved="
						+ action.requestKind
						+ ":request=" + action.requestId
						+ ":matched=" + action.resolvedDismissed
						+ ":stale=" + action.staleResolution
						+ ":views=" + action.viewStackTransitionText()
						+ ":resume_status=" + action.statusTimerResumed
						+ ":frame=" + action.frameScheduled
						+ ":command=" + action.appCommandSent
					);
				case TuiSmokeApprovalActionKind.UnsupportedReject:
					trace.push(
						"tui.approval.unsupported="
						+ action.requestKind
						+ ":request=" + action.requestId
						+ ":rejected=" + action.unsupportedRejected
						+ ":failure=" + action.failureCode
					);
				case TuiSmokeApprovalActionKind.KeymapConflict:
					trace.push(
						"tui.approval.keymap_conflict="
						+ action.conflictPrevious
						+ "->" + action.conflictAction
						+ ":failure=" + action.failureCode
					);
				case TuiSmokeApprovalActionKind.Failure:
					trace.push("tui.approval.failure=" + action.failureCode);
				case _:
					trace.push("tui.approval.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceUserInputOverlay(plan:TuiSmokeUserInputPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveUserInput || !plan.enabled()) {
			trace.push("tui.user_input.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.user_input.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeUserInputActionKind.NoteServerRequest:
					trace.push(
						"tui.user_input.pending.note="
						+ action.requestKind
						+ ":request=" + action.requestId
						+ ":turn=" + action.turnId
						+ ":item=" + action.itemId
						+ ":questions=" + action.questionCount
						+ ":secret_questions=" + action.secretQuestionCount
						+ ":unsupported=" + action.unsupportedRejected
					);
				case TuiSmokeUserInputActionKind.ShowModal:
					trace.push(
						"tui.user_input.show=modal"
						+ ":request=" + action.requestKind
						+ ":request_id=" + action.requestId
						+ ":questions=" + action.questionCount
						+ ":views=" + action.viewStackTransitionText()
						+ ":pause_status=" + action.statusTimerPaused
						+ ":composer_disabled=" + action.composerDisabled
						+ ":focus=" + action.focus
					);
				case TuiSmokeUserInputActionKind.EnqueueActive:
					trace.push(
						"tui.user_input.enqueue_active="
						+ action.requestKind
						+ ":request=" + action.requestId
						+ ":queue=" + action.queueTransitionText()
						+ ":frame=" + action.frameScheduled
					);
				case TuiSmokeUserInputActionKind.SelectOption:
					trace.push(
						"tui.user_input.select_option="
						+ action.questionId
						+ ":options=" + action.optionCount
						+ ":selected=" + action.selectionTransitionText()
						+ ":answered=" + action.answerTransitionText()
						+ ":focus=" + action.focus
					);
				case TuiSmokeUserInputActionKind.OpenNotes:
					trace.push(
						"tui.user_input.notes=open"
						+ ":question=" + action.questionId
						+ ":selected=" + action.selectedOptionAfter
						+ ":visible=" + action.notesVisible
						+ ":focus=" + action.focus
					);
				case TuiSmokeUserInputActionKind.DraftInput:
					trace.push(
						"tui.user_input.draft="
						+ action.questionId
						+ ":chars=" + action.draftTransitionText()
						+ ":paste_burst=" + action.pendingPasteCount
						+ ":answered=" + action.answerTransitionText()
					);
				case TuiSmokeUserInputActionKind.MoveQuestion:
					trace.push(
						"tui.user_input.move_question="
						+ action.questionTransitionText()
						+ ":saved_draft_chars=" + action.draftCharsBefore
						+ ":restored_draft_chars=" + action.draftCharsAfter
						+ ":focus=" + action.focus
					);
				case TuiSmokeUserInputActionKind.SubmitQuestion:
					trace.push(
						"tui.user_input.submit="
						+ action.questionId
						+ ":answers=" + action.answerCount
						+ ":answered=" + action.answerTransitionText()
						+ ":unanswered=" + action.unansweredTransitionText()
						+ ":command=" + action.appCommandSent
						+ ":history=" + action.historyCellInserted
						+ ":complete=" + action.completeTransitionText()
					);
				case TuiSmokeUserInputActionKind.OpenUnansweredConfirmation:
					trace.push(
						"tui.user_input.confirm_unanswered=open"
						+ ":count=" + action.unansweredBefore
						+ ":focus=" + action.focus
						+ ":frame=" + action.frameScheduled
					);
				case TuiSmokeUserInputActionKind.ConfirmUnanswered:
					trace.push(
						"tui.user_input.confirm_unanswered=choice"
						+ ":unanswered=" + action.unansweredTransitionText()
						+ ":answers=" + action.answerCount
						+ ":command=" + action.appCommandSent
						+ ":complete=" + action.completeTransitionText()
					);
				case TuiSmokeUserInputActionKind.Cancel:
					trace.push(
						"tui.user_input.cancel="
						+ action.requestKind
						+ ":request=" + action.requestId
						+ ":command=" + action.appCommandSent
						+ ":queue=" + action.queueTransitionText()
						+ ":complete=" + action.completeTransitionText()
					);
				case TuiSmokeUserInputActionKind.Resolve:
					trace.push(
						"tui.user_input.resolve="
						+ action.requestKind
						+ ":request=" + action.requestId
						+ ":call=" + action.callId
						+ ":answers=" + action.answerCount
						+ ":sent=" + action.resolutionSent
					);
				case TuiSmokeUserInputActionKind.DismissResolved:
					trace.push(
						"tui.user_input.dismiss_resolved="
						+ action.requestKind
						+ ":request=" + action.requestId
						+ ":matched=" + action.resolvedDismissed
						+ ":stale=" + action.staleResolution
						+ ":queue=" + action.queueTransitionText()
						+ ":views=" + action.viewStackTransitionText()
						+ ":resume_status=" + action.statusTimerResumed
						+ ":frame=" + action.frameScheduled
					);
				case TuiSmokeUserInputActionKind.UnsupportedReject:
					trace.push(
						"tui.user_input.unsupported="
						+ action.requestKind
						+ ":request=" + action.requestId
						+ ":rejected=" + action.unsupportedRejected
						+ ":failure=" + action.failureCode
					);
				case TuiSmokeUserInputActionKind.Failure:
					trace.push("tui.user_input.failure=" + action.failureCode);
				case _:
					trace.push("tui.user_input.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceAppLinkOverlay(plan:TuiSmokeAppLinkPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveBrowser || !plan.enabled()) {
			trace.push("tui.app_link.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.app_link.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeAppLinkActionKind.NoteUrlRequest:
					trace.push(
						"tui.app_link.pending.note="
						+ action.suggestion
						+ ":server=" + action.serverName
						+ ":request=" + action.requestId
						+ ":thread=" + action.threadId
						+ ":message_chars=" + action.messageChars
					);
				case TuiSmokeAppLinkActionKind.ParseUrl:
					trace.push(
						"tui.app_link.parse_url="
						+ action.suggestion
						+ ":scheme=" + action.urlScheme
						+ ":host=" + action.urlHost
						+ ":trusted=" + action.trustedUrl
						+ ":chatgpt_required=" + action.requiresChatgptHost
					);
				case TuiSmokeAppLinkActionKind.ShowLink:
					trace.push(
						"tui.app_link.show="
						+ action.suggestion
						+ ":app=" + action.appId
						+ ":title=" + action.title
						+ ":actions=" + action.actionCount
						+ ":views=" + action.viewStackTransitionText()
						+ ":pause_status=" + action.statusTimerPaused
						+ ":composer_disabled=" + action.composerDisabled
					);
				case TuiSmokeAppLinkActionKind.MoveSelection:
					trace.push(
						"tui.app_link.selection="
						+ action.suggestion
						+ ":screen=" + action.screenBefore
						+ ":selected=" + action.selectionTransitionText()
					);
				case TuiSmokeAppLinkActionKind.OpenExternal:
					trace.push(
						"tui.app_link.open_external="
						+ action.suggestion
						+ ":screen=" + action.screenTransitionText()
						+ ":browser=" + action.browserOpenSent
						+ ":selected=" + action.selectionTransitionText()
					);
				case TuiSmokeAppLinkActionKind.CompleteExternal:
					trace.push(
						"tui.app_link.complete_external="
						+ action.suggestion
						+ ":decision=" + action.decision
						+ ":refresh=" + action.refreshConnectorsSent
						+ ":command=" + action.appCommandSent
						+ ":complete=" + action.completeTransitionText()
					);
				case TuiSmokeAppLinkActionKind.ToggleEnabled:
					trace.push(
						"tui.app_link.toggle_enabled="
						+ action.appId
						+ ":enabled=" + action.enabledTransitionText()
						+ ":event=" + action.setEnabledSent
						+ ":decision=" + action.decision
						+ ":command=" + action.appCommandSent
					);
				case TuiSmokeAppLinkActionKind.Decline:
					trace.push(
						"tui.app_link.decline="
						+ action.suggestion
						+ ":decision=" + action.decision
						+ ":command=" + action.appCommandSent
						+ ":complete=" + action.completeTransitionText()
					);
				case TuiSmokeAppLinkActionKind.Cancel:
					trace.push(
						"tui.app_link.cancel="
						+ action.suggestion
						+ ":decision=" + action.decision
						+ ":command=" + action.appCommandSent
						+ ":complete=" + action.completeTransitionText()
					);
				case TuiSmokeAppLinkActionKind.Resolve:
					trace.push(
						"tui.app_link.resolve="
						+ action.suggestion
						+ ":server=" + action.serverName
						+ ":request=" + action.requestId
						+ ":decision=" + action.decision
						+ ":sent=" + action.resolutionSent
					);
				case TuiSmokeAppLinkActionKind.DismissResolved:
					trace.push(
						"tui.app_link.dismiss_resolved="
						+ action.suggestion
						+ ":server=" + action.serverName
						+ ":request=" + action.requestId
						+ ":matched=" + action.resolvedDismissed
						+ ":stale=" + action.staleResolution
						+ ":views=" + action.viewStackTransitionText()
						+ ":resume_status=" + action.statusTimerResumed
						+ ":frame=" + action.frameScheduled
					);
				case TuiSmokeAppLinkActionKind.UnsupportedReject:
					trace.push(
						"tui.app_link.unsupported="
						+ action.suggestion
						+ ":server=" + action.serverName
						+ ":request=" + action.requestId
						+ ":rejected=" + action.unsupportedRejected
						+ ":failure=" + action.failureCode
					);
				case TuiSmokeAppLinkActionKind.Failure:
					trace.push("tui.app_link.failure=" + action.failureCode);
				case _:
					trace.push("tui.app_link.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceComposerPopupSync(plan:TuiSmokeComposerPopupSyncPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveFileSearch || !plan.enabled()) {
			trace.push("tui.composer_popup_sync.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.composer_popup_sync.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeComposerPopupSyncActionKind.Sync:
					trace.push(
						"tui.composer_popup_sync.sync="
						+ action.popupTransitionText()
						+ ":input=" + action.inputText
						+ ":popups=" + action.popupsEnabled
						+ ":mentions_v2=" + action.mentionsV2Enabled
					);
				case TuiSmokeComposerPopupSyncActionKind.HistorySearchSuppress:
					trace.push(
						"tui.composer_popup_sync.history_search="
						+ action.popupTransitionText()
						+ ":active=" + action.historySearchActive
						+ ":file_query=" + action.currentFileQueryTransitionText()
						+ ":clear_search=" + action.fileSearchCleared
					);
				case TuiSmokeComposerPopupSyncActionKind.PopupsDisabled:
					trace.push(
						"tui.composer_popup_sync.disabled="
						+ action.popupTransitionText()
						+ ":popups=" + action.popupsEnabled
						+ ":cleared=" + action.popupCleared
					);
				case TuiSmokeComposerPopupSyncActionKind.HistoryNavigationSuppress:
					trace.push(
						"tui.composer_popup_sync.history_nav="
						+ action.popupTransitionText()
						+ ":browsing=" + action.browsingHistory
						+ ":file_query=" + action.currentFileQueryTransitionText()
						+ ":clear_search=" + action.fileSearchCleared
					);
				case TuiSmokeComposerPopupSyncActionKind.CommandPopup:
					trace.push(
						"tui.composer_popup_sync.command="
						+ action.query
						+ ":allowed=" + action.commandAllowed
						+ ":popup=" + action.popupTransitionText()
						+ ":created=" + action.commandPopupCreated
						+ ":updated=" + action.commandPopupUpdated
						+ ":dismissed=" + action.commandPopupDismissed
					);
				case TuiSmokeComposerPopupSyncActionKind.FileSearchPopup:
					trace.push(
						"tui.composer_popup_sync.file="
						+ action.query
						+ ":token=" + action.token
						+ ":popup=" + action.popupTransitionText()
						+ ":search=" + action.fileSearchStarted
						+ ":current=" + action.currentFileQueryTransitionText()
						+ ":live=" + !action.noLiveFileSearch
					);
				case TuiSmokeComposerPopupSyncActionKind.MentionPopup:
					trace.push(
						"tui.composer_popup_sync.mention="
						+ action.query
						+ ":popup=" + action.popupTransitionText()
						+ ":candidates=" + action.candidateCount
						+ ":skills=" + action.skillCandidateCount
						+ ":plugins=" + action.pluginCandidateCount
						+ ":apps=" + action.appCandidateCount
					);
				case TuiSmokeComposerPopupSyncActionKind.MentionsV2Popup:
					trace.push(
						"tui.composer_popup_sync.mentions_v2="
						+ action.query
						+ ":token=" + action.token
						+ ":popup=" + action.popupTransitionText()
						+ ":search=" + action.fileSearchStarted
						+ ":files=" + action.fileCandidateCount
						+ ":catalog=" + action.candidateCount
					);
				case TuiSmokeComposerPopupSyncActionKind.ClearFileSearch:
					trace.push(
						"tui.composer_popup_sync.clear_file_search="
						+ "current=" + action.currentFileQueryTransitionText()
						+ ":sent=" + action.fileSearchCleared
						+ ":popup=" + action.popupTransitionText()
					);
				case TuiSmokeComposerPopupSyncActionKind.DismissedToken:
					trace.push(
						"tui.composer_popup_sync.dismissed="
						+ action.token
						+ ":file_match=" + action.dismissedFileTokenMatched
						+ ":mention_match=" + action.dismissedMentionTokenMatched
						+ ":popup=" + action.popupTransitionText()
					);
				case TuiSmokeComposerPopupSyncActionKind.ClearInactivePopup:
					trace.push(
						"tui.composer_popup_sync.clear_inactive="
						+ action.popupTransitionText()
						+ ":file_token=" + action.fileTokenPresent
						+ ":mention_token=" + action.mentionTokenPresent
						+ ":mentions_v2_token=" + action.mentionsV2TokenPresent
					);
				case TuiSmokeComposerPopupSyncActionKind.Failure:
					trace.push(
						"tui.composer_popup_sync.failure="
						+ action.failureCode
						+ ":unsupported=" + action.unsupportedRejected
					);
				case _:
					trace.push("tui.composer_popup_sync.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceComposerPopupRender(plan:TuiSmokeComposerPopupRenderPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveTerminal || plan.allowRatatuiRender || !plan.enabled()) {
			trace.push("tui.composer_popup_render.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.composer_popup_render.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeComposerPopupRenderActionKind.Layout:
					trace.push(
						"tui.composer_popup_render.layout="
						+ action.popup
						+ ":width=" + action.width
						+ ":composer=" + action.composerHeight
						+ ":popup=" + action.popupHeight
						+ ":required=" + action.requiredHeight
						+ ":footer=" + action.footerHeight
						+ ":delegated=" + action.renderDelegated
					);
				case TuiSmokeComposerPopupRenderActionKind.RenderDispatch:
					trace.push(
						"tui.composer_popup_render.dispatch="
						+ action.popup
						+ ":delegated=" + action.renderDelegated
						+ ":ratatui=" + !action.noRatatuiRender
						+ ":terminal=" + !action.noLiveTerminal
					);
				case TuiSmokeComposerPopupRenderActionKind.RenderRows:
					trace.push(
						"tui.composer_popup_render.rows="
						+ action.popup
						+ ":rows=" + action.rowCount
						+ ":visible=" + action.visibleRows
						+ ":max=" + action.maxRows
						+ ":selected=" + action.selectedIndex
						+ ":scroll=" + action.scrollTop
						+ ":window=" + action.windowText()
						+ ":inset=" + action.insetText()
						+ ":wrap=" + action.wrapsDescriptions
					);
				case TuiSmokeComposerPopupRenderActionKind.EmptyState:
					trace.push(
						"tui.composer_popup_render.empty="
						+ action.popup
						+ ":message=" + action.emptyMessage
						+ ":waiting=" + action.waiting
						+ ":visible=" + action.visibleRows
						+ ":no_live=" + action.noLiveTerminal
					);
				case TuiSmokeComposerPopupRenderActionKind.FooterHint:
					trace.push(
						"tui.composer_popup_render.footer="
						+ action.popup
						+ ":mode=" + action.searchMode
						+ ":height=" + action.footerHeight
						+ ":rendered=" + action.footerHintRendered
					);
				case TuiSmokeComposerPopupRenderActionKind.ScrollWindow:
					trace.push(
						"tui.composer_popup_render.scroll="
						+ action.popup
						+ ":selected=" + action.selectedIndex
						+ ":visible=" + action.selectedVisible
						+ ":scroll=" + action.scrollTop
						+ ":window=" + action.windowText()
					);
				case TuiSmokeComposerPopupRenderActionKind.Failure:
					trace.push(
						"tui.composer_popup_render.failure="
						+ action.failureCode
						+ ":unsupported=" + action.unsupportedRejected
					);
				case _:
					trace.push("tui.composer_popup_render.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceChatWidgetInterruptQuit(plan:TuiSmokeChatWidgetInterruptQuitPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveTerminal || plan.allowRatatuiRender || plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.chat_widget_interrupt_quit.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.chat_widget_interrupt_quit.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeChatWidgetInterruptQuitActionKind.CtrlC:
					trace.push(
						"tui.chat_widget_interrupt_quit.ctrl_c="
						+ action.route
						+ ":double_press=" + action.doublePressEnabled
						+ ":bottom_pane=" + action.bottomPaneHandled
						+ ":task=" + action.taskRunning
						+ ":work=" + action.cancellableWorkActive
						+ ":shortcut=" + action.quitShortcutActiveBefore + "->" + action.quitShortcutActiveAfter
						+ ":hint=" + action.quitShortcutHintShown
						+ ":interrupt=" + action.interruptSubmitted
						+ ":exit=" + action.appExitSent
					);
				case TuiSmokeChatWidgetInterruptQuitActionKind.CtrlD:
					trace.push(
						"tui.chat_widget_interrupt_quit.ctrl_d="
						+ action.route
						+ ":composer_empty=" + action.composerEmpty
						+ ":modal=" + action.modalOrPopupActive
						+ ":shortcut=" + action.quitShortcutActiveBefore + "->" + action.quitShortcutActiveAfter
						+ ":matched=" + action.quitShortcutKeyMatched
						+ ":exit=" + action.appExitSent
					);
				case TuiSmokeChatWidgetInterruptQuitActionKind.InterruptKey:
					trace.push(
						"tui.chat_widget_interrupt_quit.interrupt_key="
						+ action.key
						+ ":route=" + action.route
						+ ":pending_steers=" + action.pendingSteersBefore + "->" + action.pendingSteersAfter
						+ ":submit_after=" + action.submitPendingSteersAfterInterrupt
						+ ":review=" + action.reviewMode
						+ ":task=" + action.taskRunning
						+ ":submitted=" + action.interruptSubmitted
					);
				case TuiSmokeChatWidgetInterruptQuitActionKind.ArmQuitShortcut:
					trace.push(
						"tui.chat_widget_interrupt_quit.arm_shortcut="
						+ action.key
						+ ":active=" + action.quitShortcutActiveBefore + "->" + action.quitShortcutActiveAfter
						+ ":hint=" + action.quitShortcutHintShown
						+ ":expired=" + action.quitShortcutExpired
						+ ":redraw=" + action.requestRedraw
					);
				case TuiSmokeChatWidgetInterruptQuitActionKind.RequestQuit:
					trace.push(
						"tui.chat_widget_interrupt_quit.request_quit="
						+ action.exitMode
						+ ":shortcut=" + action.quitShortcutActiveBefore + "->" + action.quitShortcutActiveAfter
						+ ":cleared=" + action.quitShortcutHintCleared
						+ ":app_exit=" + action.appExitSent
					);
				case TuiSmokeChatWidgetInterruptQuitActionKind.ShutdownFeedback:
					trace.push(
						"tui.chat_widget_interrupt_quit.shutdown_feedback="
						+ action.exitMode
						+ ":shown=" + action.shutdownFeedbackShown
						+ ":input_disabled=" + action.inputDisabled
						+ ":server_shutdown=" + action.appServerShutdownRequested
						+ ":pending_thread=" + action.pendingShutdownThreadBefore + "->" + action.pendingShutdownThreadAfter
					);
				case TuiSmokeChatWidgetInterruptQuitActionKind.PrepareInterruptSubmission:
					trace.push(
						"tui.chat_widget_interrupt_quit.prepare_interrupt="
						+ "restore_prompt=" + action.interruptRestoresPrompt
						+ ":cancel_edit=" + action.cancelEditArmedBefore + "->" + action.cancelEditArmedAfter
						+ ":stream_queue=" + action.streamQueueCleared
						+ ":plan_queue=" + action.planStreamQueueCleared
						+ ":tail=" + action.activeTailCleared
						+ ":redraw=" + action.requestRedraw
					);
				case TuiSmokeChatWidgetInterruptQuitActionKind.CancelEditCleanup:
					trace.push(
						"tui.chat_widget_interrupt_quit.cancel_edit="
						+ "cleared=" + action.cancelEditCleared
						+ ":pending_steers=" + action.pendingSteersBefore + "->" + action.pendingSteersAfter
						+ ":redraw=" + action.requestRedraw
					);
				case TuiSmokeChatWidgetInterruptQuitActionKind.Failure:
					trace.push(
						"tui.chat_widget_interrupt_quit.failure="
						+ action.failureCode
						+ ":unsupported=" + action.unsupportedRejected
					);
				case _:
					trace.push("tui.chat_widget_interrupt_quit.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceClearArchive(plan:TuiSmokeClearArchivePlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveTerminal || plan.allowRatatuiRender || plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.clear_archive.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.clear_archive.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeClearArchiveActionKind.ClearTerminalUi:
					trace.push(
						"tui.clear_archive.clear_terminal="
						+ action.mode
						+ ":backend=" + action.clearBackend
						+ ":pending=" + action.pendingHistoryBefore + "->" + action.pendingHistoryAfter
						+ ":header=" + action.headerQueued
					);
				case TuiSmokeClearArchiveActionKind.ResetUiState:
					trace.push(
						"tui.clear_archive.reset_ui="
						+ "transcript=" + action.transcriptCellsBefore + "->" + action.transcriptCellsAfter
						+ ":deferred=" + action.deferredHistoryBefore + "->" + action.deferredHistoryAfter
						+ ":overlay=" + action.overlayCleared
						+ ":backtrack=" + action.backtrackCleared
						+ ":reflow=" + action.reflowCleared
						+ ":replay=" + action.replayBufferCleared
						+ ":skill_warnings=" + action.skillWarningsBefore + "->" + action.skillWarningsAfter
						+ ":session=" + action.sessionPreserved
						+ ":composer=" + action.composerPreserved
					);
				case TuiSmokeClearArchiveActionKind.QueueClearHeader:
					trace.push(
						"tui.clear_archive.header="
						+ "queued=" + action.headerQueued
						+ ":frame=" + action.frameScheduled
						+ ":redraw=" + action.requestRedraw
					);
				case TuiSmokeClearArchiveActionKind.StartFreshSession:
					trace.push(
						"tui.clear_archive.start_fresh="
						+ "source=" + action.sessionStartSource
						+ ":started=" + action.freshSessionStarted
						+ ":initial=" + action.initialUserMessageSubmitted
						+ ":text=" + action.userMessageText
					);
				case TuiSmokeClearArchiveActionKind.SkillWarnings:
					trace.push(
						"tui.clear_archive.skill_warnings="
						+ "active=" + action.activeSkillWarningsBefore + "->" + action.activeSkillWarningsAfter
						+ ":cached=" + action.skillWarningsBefore + "->" + action.skillWarningsAfter
					);
				case TuiSmokeClearArchiveActionKind.ArchiveRequest:
					trace.push(
						"tui.clear_archive.archive_request="
						+ "thread=" + action.threadId
						+ ":active=" + action.activeThreadBefore
						+ ":side=" + action.sideConversationActive
						+ ":requested=" + action.archiveRequested
						+ ":error=" + action.errorInserted
					);
				case TuiSmokeClearArchiveActionKind.ArchiveResult:
					trace.push(
						"tui.clear_archive.archive_result="
						+ "thread=" + action.threadId
						+ ":success=" + action.archiveSucceeded
						+ ":exit=" + action.exitRequested
						+ ":reason=" + action.exitReason
					);
				case TuiSmokeClearArchiveActionKind.ShutdownFeedback:
					trace.push(
						"tui.clear_archive.shutdown_feedback="
						+ "mode=" + action.exitMode
						+ ":shown=" + action.shutdownFeedbackShown
						+ ":input_disabled=" + action.inputDisabled
						+ ":server_shutdown=" + action.appServerShutdownRequested
						+ ":pending_thread=" + action.pendingShutdownThreadBefore + "->" + action.pendingShutdownThreadAfter
					);
				case TuiSmokeClearArchiveActionKind.Failure:
					trace.push(
						"tui.clear_archive.failure="
						+ action.failureCode
						+ ":error=" + action.errorMessage
						+ ":no_live=" + action.noLiveTerminal
						+ ":no_render=" + action.noRatatuiRender
						+ ":no_model=" + action.noModelCall
						+ ":unsupported=" + action.unsupportedRejected
					);
				case _:
					trace.push("tui.clear_archive.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceTerminalPalette(plan:TuiSmokeTerminalPalettePlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveQuery || !plan.enabled()) {
			trace.push("tui.terminal_palette.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.terminal_palette.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeTerminalPaletteActionKind.ParseOscColor:
					if (!action.colorMatches()) {
						trace.push(
							"tui.terminal_palette.osc_color_mismatch="
							+ action.color
							+ ":computed=" + action.computedColor()
						);
						return false;
					}
					trace.push(
						"tui.terminal_palette.osc_color="
						+ "slot=" + action.slot
						+ ":color=" + action.computedColor()
					);
				case TuiSmokeTerminalPaletteActionKind.ParseRgb:
					if (!action.rgbMatches()) {
						trace.push(
							"tui.terminal_palette.rgb_mismatch="
							+ action.color
							+ ":computed=" + action.computedRgb()
						);
						return false;
					}
					trace.push(
						"tui.terminal_palette.rgb="
						+ "payload=" + action.payload
						+ ":color=" + action.computedRgb()
					);
				case TuiSmokeTerminalPaletteActionKind.ParseDefaultColors:
					if (!action.defaultColorsMatch()) {
						trace.push(
							"tui.terminal_palette.default_mismatch="
							+ action.foreground + "/" + action.background
							+ ":computed=" + action.computedForeground() + "/" + action.computedBackground()
						);
						return false;
					}
					trace.push(
						"tui.terminal_palette.default_colors="
						+ "fg=" + action.computedForeground()
						+ ":bg=" + action.computedBackground()
						+ ":valid=" + action.valid
					);
				case TuiSmokeTerminalPaletteActionKind.Cache:
					trace.push(
						"tui.terminal_palette.cache="
						+ "startup_attempted=" + action.startupAttempted
						+ ":startup=" + action.startupValue
						+ ":requery=" + action.requeryRequested
						+ ":result=" + action.cacheResult()
						+ ":skip_unavailable=" + action.skippedBecauseUnavailable
					);
				case TuiSmokeTerminalPaletteActionKind.Failure:
					trace.push(
						"tui.terminal_palette.failure="
						+ action.failureCode
						+ ":live=" + action.liveQueryAllowed
					);
				case _:
					trace.push("tui.terminal_palette.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceTerminalStartupProbe(plan:TuiSmokeTerminalStartupProbePlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveProbe || !plan.enabled()) {
			trace.push("tui.terminal_startup_probe.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.terminal_startup_probe.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeTerminalStartupProbeActionKind.BatchParse:
					if (!action.batchComplete()) {
						trace.push(
							"tui.terminal_startup_probe.batch_mismatch="
							+ "cursor=" + action.parsedCursor()
							+ ":fg=" + action.computedForeground()
							+ ":bg=" + action.computedBackground()
							+ ":keyboard=" + action.parsedKeyboardSupported()
						);
						return false;
					}
					trace.push(
						"tui.terminal_startup_probe.batch="
						+ "cursor=" + action.parsedCursor()
						+ ":fg=" + action.computedForeground()
						+ ":bg=" + action.computedBackground()
						+ ":keyboard=" + action.parsedKeyboardSupported()
						+ ":complete=" + action.complete
					);
				case TuiSmokeTerminalStartupProbeActionKind.KeyboardSupport:
					if (!action.keyboardMatches()) {
						trace.push(
							"tui.terminal_startup_probe.keyboard_mismatch="
							+ "supported=" + action.parsedKeyboardSupported()
							+ ":fallback=" + action.parsedFallbackSeen()
						);
						return false;
					}
					trace.push(
						"tui.terminal_startup_probe.keyboard="
						+ "supported=" + action.keyboardSupported
						+ ":fallback=" + action.fallbackSeen
					);
				case TuiSmokeTerminalStartupProbeActionKind.HandleSource:
					trace.push(
						"tui.terminal_startup_probe.handle="
						+ action.handleSource
						+ ":stdio=" + action.duplicatedStdio
						+ ":tty_fallback=" + action.controllingTerminalFallback
						+ ":flags_restored=" + action.originalFlagsRestored
					);
				case TuiSmokeTerminalStartupProbeActionKind.TimeoutFallback:
					trace.push(
						"tui.terminal_startup_probe.timeout="
						+ "ms=" + action.timeoutMs
						+ ":cursor=" + action.parsedCursor()
						+ ":colors_complete=" + action.defaultColorsComplete()
						+ ":keyboard=" + action.parsedKeyboardSupported()
					);
				case TuiSmokeTerminalStartupProbeActionKind.Failure:
					trace.push(
						"tui.terminal_startup_probe.failure="
						+ action.failureCode
						+ ":live=" + action.liveProbeAllowed
					);
				case _:
					trace.push("tui.terminal_startup_probe.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceClipboardCopy(plan:TuiSmokeClipboardCopyPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveClipboard || plan.allowLiveTerminalWrite || plan.allowProcessSpawn || !plan.enabled()) {
			trace.push("tui.clipboard_copy.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.clipboard_copy.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeClipboardCopyActionKind.Route:
					if (!action.routeMatches()) {
						trace.push("tui.clipboard_copy.route_mismatch=" + action.routedBackend() + ":expected=" + action.expectedBackend);
						return false;
					}
					trace.push(
						"tui.clipboard_copy.route="
						+ action.routedBackend()
						+ ":ssh=" + action.sshSession
						+ ":wsl=" + action.wslSession
						+ ":tmux=" + action.tmuxSession
						+ ":lease=" + action.nativeLease
					);
				case TuiSmokeClipboardCopyActionKind.Osc52Sequence:
					if (!action.rawByteCountMatches() || !action.osc52Matches()) {
						trace.push(
							"tui.clipboard_copy.osc52_mismatch="
							+ "bytes=" + action.text.length
							+ ":sequence=" + action.computedOsc52Sequence()
						);
						return false;
					}
					trace.push(
						"tui.clipboard_copy.osc52="
						+ "bytes=" + action.text.length
						+ ":tmux=" + action.tmuxSession
						+ ":wrapped=" + (action.tmuxSession && action.computedOsc52Sequence().length > 0)
					);
				case TuiSmokeClipboardCopyActionKind.TmuxReady:
					if (!action.tmuxReadyMatches()) {
						trace.push("tui.clipboard_copy.tmux_ready_mismatch=" + action.computedTmuxReady() + ":expected=" + action.expectedReady);
						return false;
					}
					trace.push(
						"tui.clipboard_copy.tmux_ready="
						+ action.computedTmuxReady()
						+ ":set_clipboard=" + StringTools.trim(action.tmuxSetClipboard)
						+ ":missing_ms=" + (action.tmuxInfo.indexOf("Ms: [missing]") >= 0)
					);
				case TuiSmokeClipboardCopyActionKind.Failure:
					trace.push(
						"tui.clipboard_copy.failure="
						+ action.failureCode
						+ ":clipboard=" + action.liveClipboardAllowed
						+ ":terminal=" + action.liveTerminalWriteAllowed
						+ ":process=" + action.processSpawnAllowed
					);
				case _:
					trace.push("tui.clipboard_copy.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceClipboardPaste(plan:TuiSmokeClipboardPastePlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveClipboard || plan.allowProcessSpawn || plan.allowFilesystemMutation || !plan.enabled()) {
			trace.push("tui.clipboard_paste.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.clipboard_paste.plan=headless");
		for (action in plan.actions) {
			if (!action.decisionMatches()) {
				trace.push("tui.clipboard_paste.decision_mismatch=" + action.computedDecision() + ":expected=" + action.expectedDecision);
				return false;
			}
			switch action.kind {
				case TuiSmokeClipboardPasteActionKind.Probe:
					trace.push(
						"tui.clipboard_paste.probe="
						+ action.computedDecision()
						+ ":wsl=" + action.wslSession
						+ ":native_clipboard=" + action.nativeClipboardAvailable
						+ ":native_file=" + action.nativeFileAvailable
						+ ":native_image=" + action.nativeImageAvailable
						+ ":wsl_attempt=" + action.wslFallbackAttempted
					);
				case TuiSmokeClipboardPasteActionKind.ImageAccept:
					if (!action.placeholderMatches() || !action.localImageCountMatches()) {
						trace.push("tui.clipboard_paste.image_mismatch=placeholder=" + action.computedPlaceholder() + ":local_after=" + action.localImageCountAfter);
						return false;
					}
					trace.push(
						"tui.clipboard_paste.image="
						+ action.computedDecision()
						+ ":placeholder=" + action.computedPlaceholder()
						+ ":path=" + action.tempPath
						+ ":format=" + action.formatLabel()
						+ ":dimensions=" + action.width + "x" + action.height
						+ ":bytes=" + action.imageBytes
						+ ":local=" + action.localImageCountBefore + "->" + action.localImageCountAfter
					);
				case TuiSmokeClipboardPasteActionKind.WslPath:
					if (!action.wslPathMatches()) {
						trace.push("tui.clipboard_paste.wsl_path_mismatch=" + action.computedWslPath() + ":expected=" + action.wslPath);
						return false;
					}
					trace.push("tui.clipboard_paste.wsl_path=" + action.windowsPath + "->" + action.computedWslPath());
				case TuiSmokeClipboardPasteActionKind.Refusal:
					trace.push(
						"tui.clipboard_paste.refusal="
						+ action.computedDecision()
						+ ":source=" + action.source
						+ ":bytes=" + action.imageBytes
						+ ":max=" + action.maxImageBytes
					);
				case TuiSmokeClipboardPasteActionKind.Failure:
					trace.push(
						"tui.clipboard_paste.failure="
						+ action.failureCode
						+ ":clipboard=" + action.liveClipboardAllowed
						+ ":process=" + action.processSpawnAllowed
						+ ":filesystem=" + action.filesystemMutationAllowed
					);
				case _:
					trace.push("tui.clipboard_paste.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceTerminalHyperlink(plan:TuiSmokeTerminalHyperlinkPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveTerminal || !plan.enabled()) {
			trace.push("tui.terminal_hyperlink.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.terminal_hyperlink.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeTerminalHyperlinkActionKind.Destination:
					if (!action.destinationMatches() || !action.validWebDestinationMatches()) {
						trace.push("tui.terminal_hyperlink.destination_mismatch");
						return false;
					}
					trace.push(
						"tui.terminal_hyperlink.destination="
						+ "safe=" + action.safeDestination
						+ ":valid=" + action.validWebDestination
					);
				case TuiSmokeTerminalHyperlinkActionKind.Discover:
					if (!action.columnsMatch()) {
						trace.push(
							"tui.terminal_hyperlink.columns_mismatch="
							+ action.startColumn + ".." + action.endColumn
							+ ":computed=" + action.computedStartColumn() + ".." + action.computedEndColumn()
						);
						return false;
					}
					trace.push(
						"tui.terminal_hyperlink.discover="
						+ "columns=" + action.startColumn + ".." + action.endColumn
						+ ":destination=" + action.discoveredDestination()
					);
				case TuiSmokeTerminalHyperlinkActionKind.Decorate:
					if (!action.decoratedMatches() || !action.osc8PairCountMatches()) {
						trace.push("tui.terminal_hyperlink.decorate_mismatch");
						return false;
					}
					trace.push(
						"tui.terminal_hyperlink.decorate="
						+ "valid=" + action.validWebDestination
						+ ":pairs=" + action.computedOsc8PairCount()
						+ ":visible=" + action.text
						+ ":live=" + action.liveWriteAllowed
					);
				case TuiSmokeTerminalHyperlinkActionKind.Strip:
					if (!action.strippedMatches()) {
						trace.push("tui.terminal_hyperlink.strip_mismatch");
						return false;
					}
					trace.push(
						"tui.terminal_hyperlink.strip="
						+ "pairs=" + action.computedOsc8PairCount()
						+ ":visible=" + action.computedStrippedText()
					);
				case TuiSmokeTerminalHyperlinkActionKind.PrefixRemap:
					if (!action.shiftedColumnsMatch()) {
						trace.push("tui.terminal_hyperlink.prefix_mismatch");
						return false;
					}
					trace.push(
						"tui.terminal_hyperlink.prefix_remap="
						+ "prefix=" + action.prefixWidth
						+ ":columns=" + action.startColumn + ".." + action.endColumn
						+ "->" + action.shiftedStartColumn + ".." + action.shiftedEndColumn
					);
				case TuiSmokeTerminalHyperlinkActionKind.Failure:
					trace.push(
						"tui.terminal_hyperlink.failure="
						+ action.failureCode
						+ ":live=" + action.liveWriteAllowed
					);
				case _:
					trace.push("tui.terminal_hyperlink.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceDesktopNotification(plan:TuiSmokeDesktopNotificationPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveNotification || !plan.enabled()) {
			trace.push("tui.desktop_notification.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.desktop_notification.plan=headless");
		for (action in plan.actions) {
			if (!action.backendMatches()) {
				trace.push(
					"tui.desktop_notification.backend_mismatch="
					+ action.backend
					+ ":computed=" + action.computedBackend()
				);
				return false;
			}
			if (!action.shouldEmitMatches()) {
				trace.push(
					"tui.desktop_notification.emit_mismatch="
					+ action.shouldEmit
					+ ":computed=" + action.computedShouldEmit()
				);
				return false;
			}
			if (!action.escapedMessageMatches()) {
				trace.push(
					"tui.desktop_notification.escape_mismatch="
					+ "expected_esc=" + action.messageEscapeCount()
					+ ":computed_esc=" + action.escapedMessageEscapeCount()
				);
				return false;
			}
			switch action.kind {
				case TuiSmokeDesktopNotificationActionKind.DetectBackend:
					trace.push(
						"tui.desktop_notification.detect_backend="
						+ "method=" + action.method
						+ ":terminal=" + action.terminalName
						+ ":mux=" + action.multiplexer
						+ ":backend=" + action.backendTraceName()
					);
				case TuiSmokeDesktopNotificationActionKind.FocusDecision:
					trace.push(
						"tui.desktop_notification.focus_decision="
						+ "condition=" + action.condition
						+ ":focused=" + action.terminalFocused
						+ ":emit=" + action.shouldEmit
					);
				case TuiSmokeDesktopNotificationActionKind.Notify:
					trace.push(
						"tui.desktop_notification.notify="
						+ "method=" + action.method
						+ ":backend=" + action.backendTraceName()
						+ ":condition=" + action.condition
						+ ":focused=" + action.terminalFocused
						+ ":emit=" + action.emitted
						+ ":message_chars=" + action.message.length
						+ ":dcs=" + action.dcsPassthrough
						+ ":esc=" + action.messageEscapeCount() + "->" + action.escapedMessageEscapeCount()
						+ ":live=" + action.liveWriteAllowed
					);
				case TuiSmokeDesktopNotificationActionKind.Failure:
					trace.push(
						"tui.desktop_notification.failure="
						+ action.failureCode
						+ ":live=" + action.liveWriteAllowed
						+ ":disabled=" + action.disabledAfterFailure
					);
				case _:
					trace.push("tui.desktop_notification.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceTerminalTitle(plan:TuiSmokeTerminalTitlePlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveTitleWrite || !plan.enabled()) {
			trace.push("tui.terminal_title.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.terminal_title.plan=headless");
		for (action in plan.actions) {
			if (!action.sanitizedMatches()) {
				trace.push(
					"tui.terminal_title.sanitize_mismatch="
					+ action.sanitizedTitle
					+ ":computed=" + action.computedSanitizedTitle()
				);
				return false;
			}
			switch action.kind {
				case TuiSmokeTerminalTitleActionKind.Set:
					trace.push(
						"tui.terminal_title.set="
						+ "raw_chars=" + action.rawTitle.length
						+ ":sanitized=" + action.sanitizedTitle
						+ ":stdout=" + action.stdoutTerminal
						+ ":applied=" + action.applied
						+ ":last=" + action.lastTitleBefore + "->" + action.lastTitleAfter
						+ ":max=" + action.effectiveMaxChars()
						+ ":live=" + action.liveWriteAllowed
					);
				case TuiSmokeTerminalTitleActionKind.NoVisibleContent:
					trace.push(
						"tui.terminal_title.no_visible_content="
						+ "raw_chars=" + action.rawTitle.length
						+ ":clear=" + action.cleared
						+ ":last=" + action.lastTitleBefore + "->" + action.lastTitleAfter
						+ ":stdout=" + action.stdoutTerminal
					);
				case TuiSmokeTerminalTitleActionKind.SkipDuplicate:
					trace.push(
						"tui.terminal_title.skip_duplicate="
						+ "title=" + action.sanitizedTitle
						+ ":skipped=" + action.duplicateSkipped
						+ ":frame=" + action.frameScheduled
					);
				case TuiSmokeTerminalTitleActionKind.ClearManaged:
					trace.push(
						"tui.terminal_title.clear_managed="
						+ "had_title=" + (action.lastTitleBefore != "")
						+ ":cleared=" + action.cleared
						+ ":last=" + action.lastTitleBefore + "->" + action.lastTitleAfter
						+ ":stdout=" + action.stdoutTerminal
					);
				case TuiSmokeTerminalTitleActionKind.Failure:
					trace.push(
						"tui.terminal_title.failure="
						+ action.failureCode
						+ ":invalid_items=" + action.invalidItemCount
						+ ":live=" + action.liveWriteAllowed
					);
				case _:
					trace.push("tui.terminal_title.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceResumeFork(plan:TuiSmokeResumeForkPlan, trace:Array<String>):Bool {
		if (
			plan == null
			|| plan.allowLiveTerminal
			|| plan.allowRatatuiRender
			|| plan.allowModelCall
			|| plan.allowFilesystemMutation
			|| !plan.enabled()
		) {
			trace.push("tui.resume_fork.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.resume_fork.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeResumeForkActionKind.PickerOpen:
					trace.push(
						"tui.resume_fork.picker_open="
						+ "action=" + action.action
						+ ":source=" + action.source
						+ ":context=" + action.context
						+ ":show_all=" + action.showAll
						+ ":include_non_interactive=" + action.includeNonInteractive
						+ ":remote=" + action.remoteWorkspace
						+ ":alt=" + action.altScreenEntered
					);
				case TuiSmokeResumeForkActionKind.PickerSelection:
					trace.push(
						"tui.resume_fork.picker_selection="
						+ "action=" + action.action
						+ ":selected=" + action.selected
						+ ":target=" + action.threadId
						+ ":label=" + action.targetLabel
						+ ":loaded=" + action.loadedRows
						+ ":page_size=" + action.pageSize
						+ ":exit_alt=" + action.altScreenExited
					);
				case TuiSmokeResumeForkActionKind.Lookup:
					trace.push(
						"tui.resume_fork.lookup="
						+ "id_or_name=" + action.idOrName
						+ ":requested=" + action.lookupRequested
						+ ":success=" + action.lookupSucceeded
						+ ":target=" + action.threadId
					);
				case TuiSmokeResumeForkActionKind.StartupGate:
					trace.push(
						"tui.resume_fork.startup_gate="
						+ "wait_initial=" + action.waitForInitialSession
						+ ":active_events=" + action.activeEventsAllowed
						+ ":paused_goal_prompt=" + action.pausedGoalPromptEligible
					);
				case TuiSmokeResumeForkActionKind.ResumeRequest:
					trace.push(
						"tui.resume_fork.resume_request="
						+ "target=" + action.threadId
						+ ":path=" + action.targetPath
						+ ":cwd=" + action.cwdResolved
						+ ":config_reload=" + action.configReloaded
						+ ":settings=" + action.configRebuilt
						+ ":requested=" + action.resumeRequested
					);
				case TuiSmokeResumeForkActionKind.ResumeAttach:
					trace.push(
						"tui.resume_fork.resume_attach="
						+ "thread=" + action.threadId
						+ ":turns=" + action.turnCount
						+ ":read=" + action.threadReadRequested
						+ ":success=" + action.resumeSucceeded
						+ ":chat_replaced=" + action.chatWidgetReplaced
						+ ":subagents=" + action.subagentsBackfilled
						+ ":notify=" + action.notificationSettingsUpdated
						+ ":file_search=" + action.fileSearchDirUpdated
						+ ":summary=" + action.summaryInserted
						+ ":frame=" + action.frameScheduled
					);
				case TuiSmokeResumeForkActionKind.SameThreadNoOp:
					trace.push(
						"tui.resume_fork.same_thread_noop="
						+ "thread=" + action.threadId
						+ ":active=" + action.sameThreadActive
						+ ":ignored=" + action.ignored
						+ ":info=" + action.infoInserted
					);
				case TuiSmokeResumeForkActionKind.ForkRequest:
					trace.push(
						"tui.resume_fork.fork_request="
						+ "parent=" + action.parentThreadId
						+ ":target=" + action.threadId
						+ ":requested=" + action.forkRequested
						+ ":app_server=" + action.appServerStarted
						+ ":mutation=" + action.appServerMutationRequested
						+ ":current_shutdown=" + action.currentThreadShutdown
					);
				case TuiSmokeResumeForkActionKind.ForkAttach:
					trace.push(
						"tui.resume_fork.fork_attach="
						+ "parent=" + action.parentThreadId
						+ ":child=" + action.childThreadId
						+ ":success=" + action.forkSucceeded
						+ ":chat_replaced=" + action.chatWidgetReplaced
						+ ":primary_enqueued=" + action.primaryThreadEnqueued
						+ ":initial=" + action.initialUserMessageSubmitted
						+ ":summary=" + action.summaryInserted
						+ ":frame=" + action.frameScheduled
					);
				case TuiSmokeResumeForkActionKind.Failure:
					trace.push(
						"tui.resume_fork.failure="
						+ action.failureCode
						+ ":error=" + action.errorMessage
						+ ":source=" + action.source
						+ ":target=" + action.idOrName
						+ ":no_live=" + action.noLiveTerminal
						+ ":no_render=" + action.noRatatuiRender
						+ ":no_model=" + action.noModelCall
						+ ":no_fs=" + action.noFilesystemMutation
						+ ":unsupported=" + action.unsupportedRejected
					);
				case _:
					trace.push("tui.resume_fork.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceSideConversation(plan:TuiSmokeSideConversationPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveTerminal || plan.allowRatatuiRender || plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.side_conversation.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.side_conversation.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeSideConversationActionKind.SyncUi:
					trace.push(
						"tui.side_conversation.sync_ui="
						+ "active=" + action.sideConversationActiveBefore + "->" + action.sideConversationActiveAfter
						+ ":notice_suppressed=" + action.noticeSuppressedBefore + "->" + action.noticeSuppressedAfter
						+ ":rename_blocked=" + action.renameBlockedBefore + "->" + action.renameBlockedAfter
						+ ":parent_main=" + action.parentIsMain
						+ ":status=" + action.status
						+ ":label=" + action.label
					);
				case TuiSmokeSideConversationActionKind.StartBlock:
					trace.push(
						"tui.side_conversation.start_block="
						+ action.blockMessage
						+ ":side_threads=" + action.sideThreadsBefore + "->" + action.sideThreadsAfter
						+ ":restored=" + action.restoredComposer
					);
				case TuiSmokeSideConversationActionKind.ForkThread:
					trace.push(
						"tui.side_conversation.fork="
						+ "parent=" + action.parentThreadId
						+ ":child=" + action.childThreadId
						+ ":side_threads=" + action.sideThreadsBefore + "->" + action.sideThreadsAfter
						+ ":ephemeral=" + action.forkConfigEphemeral
						+ ":developer=" + action.developerInstructionsAdded
						+ ":model=" + action.modelInherited
						+ ":tier=" + action.serviceTierInherited
					);
				case TuiSmokeSideConversationActionKind.InjectBoundary:
					trace.push(
						"tui.side_conversation.inject_boundary="
						+ "child=" + action.childThreadId
						+ ":hidden=" + action.hiddenBoundaryPrompt
						+ ":injected=" + action.boundaryInjected
					);
				case TuiSmokeSideConversationActionKind.SwitchThread:
					trace.push(
						"tui.side_conversation.switch="
						+ "target=" + action.targetThreadId
						+ ":child=" + action.switchedToChild
						+ ":parent=" + action.switchedToParent
						+ ":submitted_initial=" + action.submittedInitialUserMessage
						+ ":redraw=" + action.requestRedraw
					);
				case TuiSmokeSideConversationActionKind.ParentStatusChange:
					trace.push(
						"tui.side_conversation.parent_status="
						+ action.statusChange
						+ ":status=" + action.status
						+ ":actionable=" + action.parentStatusActionable
						+ ":synced=" + action.statusSynced
						+ ":label=" + action.label
					);
				case TuiSmokeSideConversationActionKind.MaybeReturn:
					trace.push(
						"tui.side_conversation.maybe_return="
						+ "overlay=" + action.overlayActive
						+ ":modal=" + action.modalOrPopupActive
						+ ":composer_empty=" + action.composerEmpty
						+ ":requested=" + action.returnRequested
						+ ":returned=" + action.returnedToParent
					);
				case TuiSmokeSideConversationActionKind.RestoreUserMessage:
					trace.push(
						"tui.side_conversation.restore_user_message="
						+ "text=" + action.userMessageText
						+ ":remote_images=" + action.remoteImageCount
						+ ":local_images=" + action.localImageCount
						+ ":mentions=" + action.mentionBindingCount
						+ ":restored=" + action.restoredComposer
					);
				case TuiSmokeSideConversationActionKind.DiscardSide:
					trace.push(
						"tui.side_conversation.discard="
						+ "child=" + action.childThreadId
						+ ":interrupt=" + action.interruptSubmitted
						+ ":startup=" + action.startupInterruptUsed
						+ ":turn=" + action.turnInterruptUsed
						+ ":unsubscribe=" + action.threadUnsubscribed
						+ ":local=" + action.localStateDiscarded
						+ ":listener=" + action.listenerAborted
						+ ":channel=" + action.channelRemoved
						+ ":navigation=" + action.navigationRemoved
						+ ":active_cleared=" + action.activeThreadCleared
						+ ":approvals=" + action.approvalsRefreshed
					);
				case TuiSmokeSideConversationActionKind.Failure:
					trace.push(
						"tui.side_conversation.failure="
						+ action.failureCode
						+ ":error=" + action.errorMessage
						+ ":no_live=" + action.noLiveTerminal
						+ ":no_render=" + action.noRatatuiRender
						+ ":no_model=" + action.noModelCall
						+ ":unsupported=" + action.unsupportedRejected
					);
				case _:
					trace.push("tui.side_conversation.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceChatWidgetInterruptedRestore(plan:TuiSmokeChatWidgetInterruptedRestorePlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveTerminal || plan.allowRatatuiRender || plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.chat_widget_interrupted_restore.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.chat_widget_interrupted_restore.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeChatWidgetInterruptedRestoreActionKind.RecordCancelEditCandidate:
					trace.push(
						"tui.chat_widget_interrupted_restore.record_cancel_edit="
						+ "prompt=" + action.promptText
						+ ":eligible=" + action.cancelEditEligibleBefore + "->" + action.cancelEditEligibleAfter
						+ ":armed=" + action.cancelEditArmedBefore + "->" + action.cancelEditArmedAfter
						+ ":prompt_state=" + action.cancelEditPromptBefore + "->" + action.cancelEditPromptAfter
					);
				case TuiSmokeChatWidgetInterruptedRestoreActionKind.ArmCancelEdit:
					trace.push(
						"tui.chat_widget_interrupted_restore.arm_cancel_edit="
						+ "eligible=" + action.cancelEditEligibleBefore
						+ ":composer_empty=" + action.composerEmpty
						+ ":pending=" + action.pendingSteersBefore
						+ ":queued=" + action.queuedMessagesBefore
						+ ":side=" + action.sideConversationActive
						+ ":armed=" + action.cancelEditArmedBefore + "->" + action.cancelEditArmedAfter
					);
				case TuiSmokeChatWidgetInterruptedRestoreActionKind.InterruptedTurn:
					trace.push(
						"tui.chat_widget_interrupted_restore.interrupted="
						+ action.reason
						+ ":finalized=" + action.finalizedTurn
						+ ":send_pending=" + action.sendPendingSteersImmediately
						+ ":submit_after=" + action.submitPendingSteersAfterInterruptBefore + "->" + action.submitPendingSteersAfterInterruptAfter
						+ ":notice=" + action.noticeInserted
						+ ":suppressed=" + action.noticeSuppressed
						+ ":preview=" + action.pendingPreviewRefreshed
						+ ":redraw=" + action.requestRedraw
					);
				case TuiSmokeChatWidgetInterruptedRestoreActionKind.DrainPendingMessages:
					trace.push(
						"tui.chat_widget_interrupted_restore.drain_pending="
						+ "pending=" + action.pendingSteersBefore + "->" + action.pendingSteersAfter
						+ ":queued=" + action.queuedMessagesBefore + "->" + action.queuedMessagesAfter
						+ ":rejected=" + action.rejectedSteersBefore + "->" + action.rejectedSteersAfter
						+ ":pending_merged=" + action.pendingMerged
						+ ":queued_merged=" + action.queuedMerged
						+ ":composer_merged=" + action.composerMerged
						+ ":text=" + action.restoredText
					);
				case TuiSmokeChatWidgetInterruptedRestoreActionKind.RestoreComposer:
					trace.push(
						"tui.chat_widget_interrupted_restore.restore_composer="
						+ "text=" + action.restoredText
						+ ":remote_images=" + action.remoteImageCount
						+ ":local_images=" + action.localImageCount
						+ ":mentions=" + action.mentionBindingCount
						+ ":restored=" + action.composerRestored
					);
				case TuiSmokeChatWidgetInterruptedRestoreActionKind.RestoreCancelledTurn:
					trace.push(
						"tui.chat_widget_interrupted_restore.restore_cancelled_turn="
						+ "prompt=" + action.promptText
						+ ":event=" + action.cancelledTurnRestoreEventSent
						+ ":rollback=" + action.threadRollbackSent
						+ ":composer=" + action.composerRestored
					);
				case TuiSmokeChatWidgetInterruptedRestoreActionKind.NoticeMode:
					trace.push(
						"tui.chat_widget_interrupted_restore.notice_mode="
						+ action.noticeMode
						+ ":suppressed=" + action.noticeSuppressed
						+ ":text=" + action.noticeText
					);
				case TuiSmokeChatWidgetInterruptedRestoreActionKind.Failure:
					trace.push(
						"tui.chat_widget_interrupted_restore.failure="
						+ action.failureCode
						+ ":no_live=" + action.noLiveTerminal
						+ ":no_render=" + action.noRatatuiRender
						+ ":no_model=" + action.noModelCall
						+ ":unsupported=" + action.unsupportedRejected
					);
				case _:
					trace.push("tui.chat_widget_interrupted_restore.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceChatWidgetStreamLifecycle(plan:TuiSmokeChatWidgetStreamLifecyclePlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveTerminal || plan.allowRatatuiRender || plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.chat_widget_stream_lifecycle.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.chat_widget_stream_lifecycle.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeChatWidgetStreamLifecycleActionKind.StreamingDelta:
					trace.push(
						"tui.chat_widget_stream_lifecycle.delta="
						+ action.delta
						+ ":controller=" + action.activeStreamControllerBefore + "->" + action.activeStreamControllerAfter
						+ ":queued_lines=" + action.queuedLinesBefore + "->" + action.queuedLinesAfter
						+ ":start_animation=" + action.startCommitAnimation
						+ ":catch_up=" + action.catchUpTick
						+ ":redraw=" + action.requestRedraw
					);
				case TuiSmokeChatWidgetStreamLifecycleActionKind.DeferOrHandle:
					trace.push(
						"tui.chat_widget_stream_lifecycle.interrupt="
						+ action.interruptKind
						+ ":controller=" + action.activeStreamControllerBefore
						+ ":queue=" + action.queuedInterruptsBefore + "->" + action.queuedInterruptsAfter
						+ ":queued=" + action.interruptQueued
						+ ":handled=" + action.interruptHandled
						+ ":fifo=" + action.fifoPreserved
					);
				case TuiSmokeChatWidgetStreamLifecycleActionKind.FlushInterruptQueue:
					trace.push(
						"tui.chat_widget_stream_lifecycle.flush_interrupts="
						+ action.flushedInterrupts
						+ ":queue=" + action.queuedInterruptsBefore + "->" + action.queuedInterruptsAfter
						+ ":handled=" + action.interruptHandled
						+ ":fifo=" + action.fifoPreserved
					);
				case TuiSmokeChatWidgetStreamLifecycleActionKind.StreamFinished:
					trace.push(
						"tui.chat_widget_stream_lifecycle.stream_finished="
						+ action.finishReason
						+ ":task_complete_pending=" + action.taskCompletePendingBefore + "->" + action.taskCompletePendingAfter
						+ ":status_hidden=" + action.statusHidden
						+ ":flushed=" + action.flushedInterrupts
						+ ":queue=" + action.queuedInterruptsBefore + "->" + action.queuedInterruptsAfter
					);
				case TuiSmokeChatWidgetStreamLifecycleActionKind.TaskComplete:
					trace.push(
						"tui.chat_widget_stream_lifecycle.task_complete="
						+ action.finishReason
						+ ":stream=" + action.activeStreamControllerBefore + "->" + action.activeStreamControllerAfter
						+ ":plan=" + action.planStreamControllerBefore + "->" + action.planStreamControllerAfter
						+ ":task=" + action.taskRunningBefore + "->" + action.taskRunningAfter
						+ ":status_restore=" + action.pendingStatusRestoreBefore + "->" + action.pendingStatusRestoreAfter
						+ ":status_preserved=" + action.statusPreserved
						+ ":redraw=" + action.requestRedraw
					);
				case TuiSmokeChatWidgetStreamLifecycleActionKind.FinalizeTurn:
					trace.push(
						"tui.chat_widget_stream_lifecycle.finalize_turn="
						+ action.finishReason
						+ ":tail=" + action.activeTailBefore + "->" + action.activeTailAfter
						+ ":stream=" + action.activeStreamControllerBefore + "->" + action.activeStreamControllerAfter
						+ ":plan=" + action.planStreamControllerBefore + "->" + action.planStreamControllerAfter
						+ ":task=" + action.taskRunningBefore + "->" + action.taskRunningAfter
						+ ":adaptive_reset=" + action.adaptiveChunkingReset
						+ ":commands=" + action.runningCommandsCleared
						+ ":suppressed=" + action.suppressedExecCleared
						+ ":wait=" + action.unifiedWaitCleared
						+ ":cancel_edit=" + action.cancelEditCleared
						+ ":rate_limit=" + action.rateLimitPromptChecked
					);
				case TuiSmokeChatWidgetStreamLifecycleActionKind.StopCommitAnimation:
					trace.push(
						"tui.chat_widget_stream_lifecycle.stop_commit_animation="
						+ action.stopCommitAnimation
						+ ":committed=" + action.committedCells
						+ ":queued_lines=" + action.queuedLinesBefore + "->" + action.queuedLinesAfter
					);
				case TuiSmokeChatWidgetStreamLifecycleActionKind.Failure:
					trace.push(
						"tui.chat_widget_stream_lifecycle.failure="
						+ action.failureCode
						+ ":unsupported=" + action.unsupportedRejected
					);
				case _:
					trace.push("tui.chat_widget_stream_lifecycle.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceChatWidgetStreamStatus(plan:TuiSmokeChatWidgetStreamStatusPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveTerminal || plan.allowRatatuiRender || plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.chat_widget_stream_status.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.chat_widget_stream_status.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeChatWidgetStreamStatusActionKind.ReasoningDelta:
					trace.push(
						"tui.chat_widget_stream_status.reasoning_delta="
						+ "delta=" + action.reasoningDelta
						+ ":header=" + action.extractedHeader
						+ ":buffer=" + action.reasoningBufferLength
						+ ":title=" + action.titleKind
						+ ":wait=" + action.unifiedExecWaitActive
						+ ":status=" + action.statusUpdated
						+ ":redraw=" + action.requestRedraw
						+ ":model=" + !action.noModelCall
					);
				case TuiSmokeChatWidgetStreamStatusActionKind.ReasoningSectionBreak:
					trace.push(
						"tui.chat_widget_stream_status.reasoning_break="
						+ "reasoning=" + action.reasoningBufferLength
						+ ":full=" + action.fullReasoningBufferLength
						+ ":cleared=" + action.reasoningCleared
					);
				case TuiSmokeChatWidgetStreamStatusActionKind.ReasoningFinal:
					trace.push(
						"tui.chat_widget_stream_status.reasoning_final="
						+ "history=" + action.historyInserted
						+ ":reasoning=" + action.reasoningBufferLength
						+ ":full=" + action.fullReasoningBufferLength
						+ ":cleared=" + action.reasoningCleared
						+ ":redraw=" + action.requestRedraw
					);
				case TuiSmokeChatWidgetStreamStatusActionKind.RestoreReasoningHeader:
					trace.push(
						"tui.chat_widget_stream_status.restore_header="
						+ action.header
						+ ":title=" + action.titleKind
						+ ":task=" + action.taskRunning
						+ ":status=" + action.statusUpdated
					);
				case TuiSmokeChatWidgetStreamStatusActionKind.AssistantMessageCompleted:
					trace.push(
						"tui.chat_widget_stream_status.message_completed="
						+ action.phase
						+ ":pending_steers=" + action.pendingSteers
						+ ":restore=" + action.pendingRestoreBefore + "->" + action.pendingRestoreAfter
						+ ":idle=" + action.streamIdle
						+ ":status_restored=" + action.statusRestored
					);
				case TuiSmokeChatWidgetStreamStatusActionKind.StreamIdleRestore:
					trace.push(
						"tui.chat_widget_stream_status.idle_restore="
						+ "pending=" + action.pendingRestoreBefore + "->" + action.pendingRestoreAfter
						+ ":task=" + action.taskRunning
						+ ":idle=" + action.streamIdle
						+ ":queued=" + action.queuedLines
						+ ":ensured=" + action.statusEnsured
						+ ":restored=" + action.statusRestored
					);
				case TuiSmokeChatWidgetStreamStatusActionKind.StreamError:
					trace.push(
						"tui.chat_widget_stream_status.stream_error="
						+ action.header
						+ ":details=" + action.details
						+ ":title=" + action.titleKind
						+ ":retry=" + action.retryHeaderRemembered
						+ ":ensured=" + action.statusEnsured
						+ ":max=" + action.detailsMaxLines
					);
				case TuiSmokeChatWidgetStreamStatusActionKind.RunState:
					trace.push(
						"tui.chat_widget_stream_status.run_state="
						+ action.titleKind
						+ ":task=" + action.taskRunning
						+ ":text=" + action.runState
						+ ":title_status=" + action.titleUsesStatus
						+ ":refreshed=" + action.statusSurfacesRefreshed
					);
				case TuiSmokeChatWidgetStreamStatusActionKind.Failure:
					trace.push(
						"tui.chat_widget_stream_status.failure="
						+ action.failureCode
						+ ":unsupported=" + action.unsupportedRejected
					);
				case _:
					trace.push("tui.chat_widget_stream_status.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceChatWidgetActiveStream(plan:TuiSmokeChatWidgetActiveStreamPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveTerminal || plan.allowRatatuiRender || plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.chat_widget_active_stream.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.chat_widget_active_stream.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeChatWidgetActiveStreamActionKind.AgentDelta:
					trace.push(
						"tui.chat_widget_active_stream.agent_delta="
						+ "text=" + action.text
						+ ":stream=" + action.streamControllerPresent
						+ ":width=" + action.streamWidth
						+ ":queued=" + action.streamQueueText()
						+ ":pushed=" + action.pushed
						+ ":commit_animation=" + action.startedCommitAnimation
						+ ":catch_up=" + action.ranCatchUpTick
						+ ":redraw=" + action.requestRedraw
						+ ":model=" + !action.noModelCall
					);
				case TuiSmokeChatWidgetActiveStreamActionKind.PlanDelta:
					trace.push(
						"tui.chat_widget_active_stream.plan_delta="
						+ "text=" + action.text
						+ ":plan_stream=" + action.planStreamControllerPresent
						+ ":width=" + action.planStreamWidth
						+ ":buffer=" + action.planBufferLength
						+ ":queued=" + action.streamQueueText()
						+ ":pushed=" + action.pushed
						+ ":commit_animation=" + action.startedCommitAnimation
						+ ":catch_up=" + action.ranCatchUpTick
						+ ":redraw=" + action.requestRedraw
						+ ":model=" + !action.noModelCall
					);
				case TuiSmokeChatWidgetActiveStreamActionKind.CommitTick:
					trace.push(
						"tui.chat_widget_active_stream.commit_tick="
						+ "queued=" + action.streamQueueText()
						+ ":cells=" + action.committedCells
						+ ":status_hidden=" + action.statusHidden
						+ ":active_tail=" + action.activeTailPresent
						+ ":revision=" + action.revisionText()
					);
				case TuiSmokeChatWidgetActiveStreamActionKind.Resize:
					trace.push(
						"tui.chat_widget_active_stream.resize="
						+ action.previousWidth + "->" + action.width
						+ ":stream_reserved=" + action.streamReservedCols
						+ ":stream_width=" + action.streamWidth
						+ ":plan_reserved=" + action.planReservedCols
						+ ":plan_width=" + action.planStreamWidth
						+ ":tail_synced=" + action.activeTailPresent
						+ ":redraw=" + action.requestRedraw
					);
				case TuiSmokeChatWidgetActiveStreamActionKind.ActiveTail:
					trace.push(
						"tui.chat_widget_active_stream.active_tail="
						+ "present=" + action.activeTailPresent
						+ ":cell=" + action.activeCellPresent
						+ ":hook=" + action.activeHookPresent
						+ ":revision=" + action.revisionAfter
						+ ":continuation=" + action.liveTailPresent
						+ ":animation=" + action.animationTick
						+ ":lines=" + action.transcriptLineCount
						+ ":hyperlinks=" + action.hyperlinkLineCount
					);
				case TuiSmokeChatWidgetActiveStreamActionKind.FlushAnswer:
					trace.push(
						"tui.chat_widget_active_stream.flush_answer="
						+ "live_tail=" + action.liveTailPresent
						+ ":tail_cleared=" + action.activeTailCleared
						+ ":reflow=" + action.scrollbackReflow
						+ ":history=" + action.historyInserted
						+ ":deferred=" + action.deferredHistoryCell
						+ ":consolidate=" + action.sourceConsolidated
					);
				case TuiSmokeChatWidgetActiveStreamActionKind.PlanComplete:
					trace.push(
						"tui.chat_widget_active_stream.plan_complete="
						+ "live_tail=" + action.liveTailPresent
						+ ":buffer=" + action.planBufferLength
						+ ":tail_cleared=" + action.activeTailCleared
						+ ":history=" + action.historyInserted
						+ ":stream_history=" + action.deferredHistoryCell
						+ ":consolidate=" + action.sourceConsolidated
						+ ":restore_pending=" + action.statusRestorePending
						+ ":restored=" + action.statusRestored
					);
				case TuiSmokeChatWidgetActiveStreamActionKind.RenderMode:
					trace.push(
						"tui.chat_widget_active_stream.render_mode="
						+ action.renderMode
						+ ":stream=" + action.streamControllerPresent
						+ ":plan_stream=" + action.planStreamControllerPresent
					);
				case TuiSmokeChatWidgetActiveStreamActionKind.Failure:
					trace.push(
						"tui.chat_widget_active_stream.failure="
						+ action.failureCode
						+ ":unsupported=" + action.unsupportedRejected
					);
				case _:
					trace.push("tui.chat_widget_active_stream.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceChatWidgetComposerRender(plan:TuiSmokeChatWidgetComposerRenderPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveTerminal || plan.allowRatatuiRender || plan.allowLiveDispatch || !plan.enabled()) {
			trace.push("tui.chat_widget_composer_render.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.chat_widget_composer_render.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeChatWidgetComposerRenderActionKind.Composition:
					trace.push(
						"tui.chat_widget_composer_render.composition="
						+ "area=" + action.areaText()
						+ ":reserve=" + action.rightReserve
						+ ":active=" + action.activeCellPresent
						+ ":hook=" + action.activeHookPresent
						+ ":hook_render=" + action.activeHookShouldRender
						+ ":bottom_inset=" + action.bottomPaneInsetTop
						+ ":terminal=" + !action.noLiveTerminal
						+ ":ratatui=" + !action.noRatatuiRender
					);
				case TuiSmokeChatWidgetComposerRenderActionKind.BottomPaneDelegate:
					trace.push(
						"tui.chat_widget_composer_render.bottom_pane="
						+ "reserve=" + action.rightReserve
						+ ":desired=" + action.bottomPaneDesiredHeight
						+ ":cursor=" + action.cursorVisible
						+ ":style=" + action.cursorStyle
						+ ":task=" + action.taskRunning
						+ ":input=" + action.inputEnabled
					);
				case TuiSmokeChatWidgetComposerRenderActionKind.TranscriptArea:
					trace.push(
						"tui.chat_widget_composer_render.transcript="
						+ (action.activeHookShouldRender ? "hook" : "active")
						+ ":width=" + action.transcriptAreaWidth
						+ ":height=" + action.transcriptAreaHeight
						+ ":desired=" + action.activeCellDesiredHeight
						+ ":hook_desired=" + action.activeHookDesiredHeight
						+ ":scroll=" + action.transcriptScrollOffset
					);
				case TuiSmokeChatWidgetComposerRenderActionKind.Cursor:
					trace.push(
						"tui.chat_widget_composer_render.cursor="
						+ action.cursorText()
						+ ":style=" + action.cursorStyle
						+ ":reserve=" + action.rightReserve
						+ ":visible=" + action.cursorVisible
					);
				case TuiSmokeChatWidgetComposerRenderActionKind.InputResult:
					trace.push(
						"tui.chat_widget_composer_render.input="
						+ action.inputResult
						+ ":text=" + action.text
						+ ":action=" + action.queuedAction
						+ ":session=" + action.sessionConfigured
						+ ":plan=" + action.planStreaming
						+ ":shell_only=" + action.onlyUserShellCommandsRunning
						+ ":pending=" + action.userTurnPending
						+ ":submit_now=" + action.shouldSubmitNow
						+ ":queue=" + action.queueTransitionText()
						+ ":status=" + action.statusWorking
						+ ":reasoning_cleared=" + action.reasoningCleared
						+ ":live_dispatch=" + !action.noLiveDispatch
					);
				case TuiSmokeChatWidgetComposerRenderActionKind.QueuePreview:
					trace.push(
						"tui.chat_widget_composer_render.queue_preview="
						+ "queued=" + action.queuedAfter
						+ ":pending_steers=" + action.pendingSteers
						+ ":rejected=" + action.rejectedSteers
						+ ":updated=" + action.previewUpdated
						+ ":autosend=" + !action.autosendSuppressed
						+ ":followup=" + action.followupSubmitted
						+ ":modal=" + action.hadModalOrPopup + "->" + action.modalCleared
					);
				case TuiSmokeChatWidgetComposerRenderActionKind.InputQueueState:
					trace.push(
						"tui.chat_widget_composer_render.input_queue="
						+ "queued=" + action.queuedAfter
						+ ":queued_history=" + action.queuedHistoryRecords
						+ ":pending=" + action.pendingSteers
						+ ":pending_history=" + action.pendingSteerHistoryRecords
						+ ":compare_keys=" + action.pendingSteerCompareKeys
						+ ":rejected=" + action.rejectedSteers
						+ ":rejected_history=" + action.rejectedHistoryRecords
						+ ":followups=" + action.queuedFollowUps
						+ ":fallback=" + action.missingHistoryFallback
						+ ":texts=" + action.previewQueuedText + "|" + action.previewPendingText + "|" + action.previewRejectedText
					);
				case TuiSmokeChatWidgetComposerRenderActionKind.InputQueueClear:
					trace.push(
						"tui.chat_widget_composer_render.input_queue_clear="
						+ "queued=" + action.queueTransitionText()
						+ ":pending=" + action.pendingSteers + "->0"
						+ ":rejected=" + action.rejectedSteers + "->0"
						+ ":user_turn=" + action.userTurnPendingBefore + "->" + action.userTurnPendingAfter
						+ ":submit_after_interrupt=" + action.submitPendingSteersAfterInterruptBefore + "->" + action.submitPendingSteersAfterInterruptAfter
						+ ":autosend=" + action.suppressAutosendBefore + "->" + action.suppressAutosendAfter
					);
				case TuiSmokeChatWidgetComposerRenderActionKind.QueueDrainGate:
					trace.push(
						"tui.chat_widget_composer_render.queue_drain_gate="
						+ "autosend=" + !action.autosendSuppressed
						+ ":pending=" + action.userTurnPending
						+ ":task=" + action.taskRunning
						+ ":queued=" + action.queueTransitionText()
						+ ":action=" + action.queuedAction
						+ ":followup=" + action.followupSubmitted
						+ ":modal=" + action.hadModalOrPopup + "->" + action.modalCleared
						+ ":preview=" + action.previewUpdated
						+ ":live_dispatch=" + !action.noLiveDispatch
					);
				case TuiSmokeChatWidgetComposerRenderActionKind.Frame:
					trace.push(
						"tui.chat_widget_composer_render.frame="
						+ "redraw:scheduled=" + action.frameScheduled
						+ ":pre_draw=" + action.preDrawTick
						+ ":bottom_tick=" + action.bottomPaneTick
						+ ":ambient_reserve=" + action.rightReserve
					);
				case TuiSmokeChatWidgetComposerRenderActionKind.Failure:
					trace.push(
						"tui.chat_widget_composer_render.failure="
						+ action.failureCode
						+ ":unsupported=" + action.unsupportedRejected
					);
				case _:
					trace.push("tui.chat_widget_composer_render.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceComposerTextareaRender(plan:TuiSmokeComposerTextareaRenderPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveTerminal || plan.allowRatatuiRender || !plan.enabled()) {
			trace.push("tui.composer_textarea_render.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.composer_textarea_render.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeComposerTextareaRenderActionKind.Layout:
					trace.push(
						"tui.composer_textarea_render.layout="
						+ "area=" + action.width + "x" + action.height
						+ ":reserve=" + action.textareaRightReserve
						+ ":textarea=" + action.textareaSizeText()
						+ ":remote_height=" + action.remoteImageHeight
						+ ":remote_separator=" + action.remoteImageSeparator
						+ ":popup=" + action.popupHeight
						+ ":footer=" + action.footerTotalHeight
					);
				case TuiSmokeComposerTextareaRenderActionKind.DesiredHeight:
					trace.push(
						"tui.composer_textarea_render.desired="
						+ "width=" + action.width
						+ ":inner=" + action.innerWidth
						+ ":wrapped=" + action.wrappedLineCount
						+ ":remote=" + action.remoteImageHeight
						+ ":separator=" + action.remoteImageSeparator
						+ ":footer=" + action.footerTotalHeight
						+ ":total=" + action.desiredHeight
					);
				case TuiSmokeComposerTextareaRenderActionKind.RemoteImages:
					trace.push(
						"tui.composer_textarea_render.remote_images="
						+ "count=" + action.remoteImageCount
						+ ":height=" + action.remoteImageHeight
						+ ":selected=" + action.selectedRemoteIndex
						+ ":textarea_mutated=" + !action.remoteImagesDoNotMutateTextarea
						+ ":terminal=" + !action.noLiveTerminal
						+ ":ratatui=" + !action.noRatatuiRender
					);
				case TuiSmokeComposerTextareaRenderActionKind.Prompt:
					trace.push(
						"tui.composer_textarea_render.prompt="
						+ action.promptKind
						+ ":text=" + action.promptText
						+ ":input=" + action.inputEnabled
						+ ":bash=" + action.bashMode
					);
				case TuiSmokeComposerTextareaRenderActionKind.Plain:
					trace.push(
						"tui.composer_textarea_render.plain="
						+ "lines=" + action.wrappedLineCount
						+ ":scroll=" + action.scrollBefore + "->" + action.scrollAfter
						+ ":window=" + action.lineWindowText()
						+ ":elements=" + action.elementCount
						+ ":highlights=" + action.highlightCount
					);
				case TuiSmokeComposerTextareaRenderActionKind.Masked:
					trace.push(
						"tui.composer_textarea_render.masked="
						+ "char=" + action.maskChar
						+ ":text_len=" + action.textLength
						+ ":lines=" + action.wrappedLineCount
						+ ":scroll=" + action.scrollBefore + "->" + action.scrollAfter
						+ ":window=" + action.lineWindowText()
					);
				case TuiSmokeComposerTextareaRenderActionKind.Highlighted:
					trace.push(
						"tui.composer_textarea_render.highlighted="
						+ "lines=" + action.wrappedLineCount
						+ ":scroll=" + action.scrollBefore + "->" + action.scrollAfter
						+ ":window=" + action.lineWindowText()
						+ ":elements=" + action.elementCount
						+ ":plugin=" + action.pluginHighlightCount
						+ ":history=" + action.historyHighlightCount
						+ ":render_only=" + action.renderOnlyHighlights
					);
				case TuiSmokeComposerTextareaRenderActionKind.Placeholder:
					trace.push(
						"tui.composer_textarea_render.placeholder="
						+ action.mode
						+ ":text=" + action.placeholderText
						+ ":visible=" + action.placeholderVisible
						+ ":input=" + action.inputEnabled
						+ ":empty=" + action.textareaEmpty
					);
				case TuiSmokeComposerTextareaRenderActionKind.Cursor:
					trace.push(
						"tui.composer_textarea_render.cursor="
						+ action.mode
						+ ":visible=" + action.cursorVisible
						+ ":x=" + action.cursorX
						+ ":y=" + action.cursorY
						+ ":reserve=" + action.textareaRightReserve
						+ ":input=" + action.inputEnabled
						+ ":selected_remote=" + action.selectedRemoteIndex
					);
				case TuiSmokeComposerTextareaRenderActionKind.Failure:
					trace.push(
						"tui.composer_textarea_render.failure="
						+ action.failureCode
						+ ":unsupported=" + action.unsupportedRejected
					);
				case _:
					trace.push("tui.composer_textarea_render.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceComposerFooterRender(plan:TuiSmokeComposerFooterRenderPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveTerminal || plan.allowRatatuiRender || !plan.enabled()) {
			trace.push("tui.composer_footer_render.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.composer_footer_render.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeComposerFooterRenderActionKind.Props:
					trace.push(
						"tui.composer_footer_render.props="
						+ action.modeAfter
						+ ":base=" + action.baseMode
						+ ":focus=" + action.hasInputFocus
						+ ":task=" + action.taskRunning
						+ ":empty=" + action.inputEmpty
						+ ":history=" + action.historySearchActive
						+ ":quit_visible=" + action.quitHintVisible
						+ ":status_enabled=" + action.statusLineEnabled
						+ ":collab=" + action.collaborationModesEnabled
						+ ":indicator=" + action.collaborationIndicatorVisible
					);
				case TuiSmokeComposerFooterRenderActionKind.Height:
					trace.push(
						"tui.composer_footer_render.height="
						+ action.modeAfter
						+ ":" + action.heightText()
						+ ":passive_status=" + action.passiveStatusActive
						+ ":queue=" + action.showQueueHint
					);
				case TuiSmokeComposerFooterRenderActionKind.PassiveStatus, TuiSmokeComposerFooterRenderActionKind.StatusLine:
					trace.push(
						"tui.composer_footer_render.status="
						+ action.statusText
						+ ":enabled=" + action.statusLineEnabled
						+ ":passive=" + action.passiveStatusActive
						+ ":hyperlink=" + action.statusHyperlinkActive
						+ ":mode=" + action.modeAfter
					);
				case TuiSmokeComposerFooterRenderActionKind.ShortcutOverlay:
					trace.push(
						"tui.composer_footer_render.shortcut_overlay="
						+ action.modeTransitionText()
						+ ":key=" + action.keyName
						+ ":active=" + action.shortcutOverlayActive
						+ ":paste_burst=" + action.pasteBurstActive
						+ ":shortcuts=" + action.showShortcutsHint
						+ ":cycle=" + action.showCycleHint
					);
				case TuiSmokeComposerFooterRenderActionKind.QuitShortcut:
					trace.push(
						"tui.composer_footer_render.quit="
						+ action.modeTransitionText()
						+ ":key=" + action.keyName
						+ ":visible=" + action.quitHintVisible
						+ ":expired=" + action.quitHintExpired
						+ ":ctrl_c=" + action.ctrlCQuitHint
					);
				case TuiSmokeComposerFooterRenderActionKind.EscHint:
					trace.push(
						"tui.composer_footer_render.esc="
						+ action.modeTransitionText()
						+ ":key=" + action.keyName
						+ ":backtrack=" + action.escBacktrackHint
					);
				case TuiSmokeComposerFooterRenderActionKind.FooterFallback:
					trace.push(
						"tui.composer_footer_render.fallback="
						+ action.modeAfter
						+ ":lines=" + action.lineCount
						+ ":hints=" + action.hintCount
						+ ":shortcuts=" + action.showShortcutsHint
						+ ":queue=" + action.showQueueHint
						+ ":cycle=" + action.showCycleHint
						+ ":terminal=" + !action.noLiveTerminal
						+ ":ratatui=" + !action.noRatatuiRender
					);
				case TuiSmokeComposerFooterRenderActionKind.Failure:
					trace.push(
						"tui.composer_footer_render.failure="
						+ action.failureCode
						+ ":unsupported=" + action.unsupportedRejected
					);
				case _:
					trace.push("tui.composer_footer_render.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceComposerPopupKey(plan:TuiSmokeComposerPopupKeyPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveInput || plan.allowLiveFileProbe || !plan.enabled()) {
			trace.push("tui.composer_popup_key.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.composer_popup_key.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeComposerPopupKeyActionKind.Dispatch:
					trace.push(
						"tui.composer_popup_key.dispatch="
						+ action.popupBefore
						+ ":key=" + action.keyName
						+ ":popup=" + action.popupTransitionText()
						+ ":consumed=" + action.keyConsumed
						+ ":sync=" + action.syncAfterKey
					);
				case TuiSmokeComposerPopupKeyActionKind.ShortcutOverlay:
					trace.push(
						"tui.composer_popup_key.shortcut_overlay="
						+ action.popupBefore
						+ ":key=" + action.keyName
						+ ":handled=" + action.shortcutOverlayHandled
						+ ":redraw=" + action.redrawRequested
					);
				case TuiSmokeComposerPopupKeyActionKind.FooterEscHint:
					trace.push(
						"tui.composer_popup_key.footer_esc="
						+ action.popupBefore
						+ ":key=" + action.keyName
						+ ":mode_changed=" + action.footerModeChanged
						+ ":popup=" + action.popupTransitionText()
					);
				case TuiSmokeComposerPopupKeyActionKind.MoveSelection:
					trace.push(
						"tui.composer_popup_key.selection="
						+ action.popupBefore
						+ ":key=" + action.keyName
						+ ":selected=" + action.selectionTransitionText()
						+ ":scroll=" + action.scrollTransitionText()
						+ ":matches=" + action.matchCount
					);
				case TuiSmokeComposerPopupKeyActionKind.Dismiss:
					trace.push(
						"tui.composer_popup_key.dismiss="
						+ action.popupBefore
						+ ":key=" + action.keyName
						+ ":token=" + action.token
						+ ":stored=" + action.dismissedTokenStored
						+ ":popup=" + action.popupTransitionText()
						+ ":sync=" + action.syncAfterKey
					);
				case TuiSmokeComposerPopupKeyActionKind.CompleteCommand:
					trace.push(
						"tui.composer_popup_key.command.complete="
						+ action.commandName
						+ ":key=" + action.keyName
						+ ":completed=" + action.commandCompleted
						+ ":inline_args=" + action.inlineArgsPreserved
						+ ":popup=" + action.popupTransitionText()
					);
				case TuiSmokeComposerPopupKeyActionKind.DispatchCommand:
					trace.push(
						"tui.composer_popup_key.command.dispatch="
						+ action.commandName
						+ ":key=" + action.keyName
						+ ":command=" + action.commandDispatched
						+ ":service_tier=" + action.serviceTierDispatched
						+ ":history=" + action.historyStaged
						+ ":text_cleared=" + action.textCleared
					);
				case TuiSmokeComposerPopupKeyActionKind.AcceptFile:
					trace.push(
						"tui.composer_popup_key.file.accept="
						+ action.selectedPath
						+ ":key=" + action.keyName
						+ ":selected=" + action.selectedAvailable
						+ ":draft=" + action.draftUpdated
						+ ":path_inserted=" + action.pathInserted
						+ ":popup=" + action.popupTransitionText()
					);
				case TuiSmokeComposerPopupKeyActionKind.AcceptImage:
					trace.push(
						"tui.composer_popup_key.image.accept="
						+ action.selectedPath
						+ ":key=" + action.keyName
						+ ":dimensions=" + action.imageDimensionsAvailable
						+ ":attached=" + action.imageAttached
						+ ":path_fallback=" + action.pathInserted
						+ ":live_probe=" + !action.liveProbeRejected
					);
				case TuiSmokeComposerPopupKeyActionKind.AcceptMention:
					trace.push(
						"tui.composer_popup_key.mention.accept="
						+ action.insertText
						+ ":key=" + action.keyName
						+ ":path=" + action.selectedPath
						+ ":binding=" + action.mentionBindingStored
						+ ":popup=" + action.popupTransitionText()
					);
				case TuiSmokeComposerPopupKeyActionKind.SwitchMentionMode:
					trace.push(
						"tui.composer_popup_key.mentions_v2.mode="
						+ action.searchModeTransitionText()
						+ ":key=" + action.keyName
						+ ":allowed=" + action.modeSwitchAllowed
						+ ":selected=" + action.selectionTransitionText()
					);
				case TuiSmokeComposerPopupKeyActionKind.AcceptMentionsV2File:
					trace.push(
						"tui.composer_popup_key.mentions_v2.file="
						+ action.selectedPath
						+ ":key=" + action.keyName
						+ ":draft=" + action.draftUpdated
						+ ":popup=" + action.popupTransitionText()
					);
				case TuiSmokeComposerPopupKeyActionKind.AcceptMentionsV2Tool:
					trace.push(
						"tui.composer_popup_key.mentions_v2.tool="
						+ action.insertText
						+ ":key=" + action.keyName
						+ ":path=" + action.selectedPath
						+ ":binding=" + action.mentionBindingStored
						+ ":popup=" + action.popupTransitionText()
					);
				case TuiSmokeComposerPopupKeyActionKind.FallbackEnter:
					trace.push(
						"tui.composer_popup_key.fallback_enter="
						+ action.popupBefore
						+ ":selected=" + action.selectedAvailable
						+ ":submit_without_popup=" + action.submitWithoutPopup
						+ ":without_popup=" + action.fallbackWithoutPopup
						+ ":popup=" + action.popupTransitionText()
					);
				case TuiSmokeComposerPopupKeyActionKind.BasicInput:
					trace.push(
						"tui.composer_popup_key.basic_input="
						+ action.popupBefore
						+ ":key=" + action.keyName
						+ ":forwarded=" + action.inputForwarded
						+ ":sync=" + action.syncAfterKey
					);
				case TuiSmokeComposerPopupKeyActionKind.Failure:
					trace.push(
						"tui.composer_popup_key.failure="
						+ action.failureCode
						+ ":unsupported=" + action.unsupportedRejected
						+ ":live_probe=" + action.liveProbeRejected
					);
				case _:
					trace.push("tui.composer_popup_key.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceComposerEditing(plan:TuiSmokeComposerEditingPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveInput || !plan.enabled()) {
			trace.push("tui.composer_editing.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.composer_editing.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeComposerEditingActionKind.RouteKey:
					trace.push(
						"tui.composer_editing.route="
						+ action.keyName
						+ ":result=" + action.result
						+ ":mode=" + action.modeBefore + "->" + action.modeAfter
						+ ":consumed=" + action.keyConsumed
						+ ":redraw=" + action.needsRedraw
					);
				case TuiSmokeComposerEditingActionKind.RemoteSelection:
					trace.push(
						"tui.composer_editing.remote_selection="
						+ action.keyName
						+ ":remote=" + action.remoteImageAfter
						+ ":selected=" + action.selectedRemoteTransitionText()
						+ ":handled=" + action.remoteSelectionHandled
						+ ":redraw=" + action.needsRedraw
					);
				case TuiSmokeComposerEditingActionKind.ClearRemoteSelection:
					trace.push(
						"tui.composer_editing.remote_clear="
						+ action.keyName
						+ ":selected=" + action.selectedRemoteTransitionText()
						+ ":cleared=" + action.remoteSelectionCleared
					);
				case TuiSmokeComposerEditingActionKind.BashEscape:
					trace.push(
						"tui.composer_editing.bash_escape="
						+ action.keyName
						+ ":mode=" + action.modeBefore + "->" + action.modeAfter
						+ ":disabled=" + action.bashModeDisabled
						+ ":burst_flushed=" + action.pasteBurstFlushed
						+ ":redraw=" + action.needsRedraw
					);
				case TuiSmokeComposerEditingActionKind.VimTransition:
					trace.push(
						"tui.composer_editing.vim="
						+ action.keyName
						+ ":mode=" + action.modeBefore + "->" + action.modeAfter
						+ ":insert_escape=" + action.vimInsertEscapeHandled
						+ ":redraw=" + action.needsRedraw
					);
				case TuiSmokeComposerEditingActionKind.VimNormalShortcut:
					trace.push(
						"tui.composer_editing.vim_shortcut="
						+ action.keyName
						+ ":text=" + action.outputText
						+ ":mode=" + action.modeBefore + "->" + action.modeAfter
						+ ":bash=" + action.bashModeEnabled
					);
				case TuiSmokeComposerEditingActionKind.QueueKey:
					trace.push(
						"tui.composer_editing.queue_key="
						+ action.keyName
						+ ":task=" + action.taskRunning
						+ ":queue_submissions=" + action.queueSubmissions
						+ ":shell=" + action.shellCommand
						+ ":queued=" + action.submissionQueued
					);
				case TuiSmokeComposerEditingActionKind.SubmitKey:
					trace.push(
						"tui.composer_editing.submit_key="
						+ action.keyName
						+ ":queue_submissions=" + action.queueSubmissions
						+ ":submitted=" + action.submissionSubmitted
						+ ":queued=" + action.submissionQueued
					);
				case TuiSmokeComposerEditingActionKind.HistoryNavigate:
					trace.push(
						"tui.composer_editing.history="
						+ action.keyName
						+ ":handled=" + action.historyHandled
						+ ":applied=" + action.historyApplied
						+ ":cursor=" + action.cursorTransitionText()
					);
				case TuiSmokeComposerEditingActionKind.BasicInput:
					trace.push(
						"tui.composer_editing.basic_input="
						+ action.keyName
						+ ":text=" + action.inputText + "->" + action.outputText
						+ ":cursor=" + action.cursorTransitionText()
						+ ":pending=" + action.pendingPasteTransitionText()
						+ ":redraw=" + action.needsRedraw
					);
				case TuiSmokeComposerEditingActionKind.PasteBurstFlush:
					trace.push(
						"tui.composer_editing.burst_flush="
						+ action.keyName
						+ ":active=" + action.pasteBurstActiveBefore + "->" + action.pasteBurstActiveAfter
						+ ":flushed=" + action.pasteBurstFlushed
						+ ":newline=" + action.newlineCaptured
						+ ":window_cleared=" + action.burstWindowCleared
					);
				case TuiSmokeComposerEditingActionKind.ReconcileElements:
					trace.push(
						"tui.composer_editing.reconcile="
						+ action.keyName
						+ ":elements=" + action.elementTransitionText()
						+ ":pending=" + action.pendingPasteTransitionText()
						+ ":local=" + action.localImageTransitionText()
						+ ":pending_pruned=" + action.pendingPastePruned
						+ ":locals_pruned=" + action.localImagesPruned
					);
				case TuiSmokeComposerEditingActionKind.ShortcutOverlay:
					trace.push(
						"tui.composer_editing.shortcut_overlay="
						+ action.keyName
						+ ":handled=" + action.shortcutOverlayHandled
						+ ":redraw=" + action.needsRedraw
					);
				case TuiSmokeComposerEditingActionKind.CtrlD:
					trace.push(
						"tui.composer_editing.ctrl_d="
						+ "empty=" + action.inputText
						+ ":result=" + action.result
						+ ":redraw=" + action.needsRedraw
					);
				case TuiSmokeComposerEditingActionKind.Failure:
					trace.push(
						"tui.composer_editing.failure="
						+ action.failureCode
						+ ":unsupported=" + action.unsupportedRejected
					);
				case _:
					trace.push("tui.composer_editing.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceComposerSubmission(plan:TuiSmokeComposerSubmissionPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveDispatch || !plan.enabled()) {
			trace.push("tui.composer_submission.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.composer_submission.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeComposerSubmissionActionKind.PrepareText:
					trace.push(
						"tui.composer_submission.prepare="
						+ action.result
						+ ":text=" + action.preparedText
						+ ":chars=" + action.charCount + "/" + action.maxChars
						+ ":pending=" + action.pendingTransitionText()
						+ ":elements=" + action.elementTransitionText()
						+ ":trimmed=" + action.textTrimmed
						+ ":expanded=" + action.pendingExpanded
						+ ":cleared=" + action.pendingCleared
					);
				case TuiSmokeComposerSubmissionActionKind.HandleSubmission:
					trace.push(
						"tui.composer_submission.handle="
						+ action.result
						+ ":queue=" + action.shouldQueue
						+ ":validation=" + action.slashValidation
						+ ":burst_flushed=" + action.pasteBurstFlushed
						+ ":vim_normal=" + action.vimNormalEntered
					);
				case TuiSmokeComposerSubmissionActionKind.QueueSubmission:
					trace.push(
						"tui.composer_submission.queue="
						+ action.queuedAction
						+ ":text=" + action.preparedText
						+ ":messages=" + action.queueTransitionText()
						+ ":defer_slash=" + action.slashValidationDeferred
						+ ":queued=" + action.queued
					);
				case TuiSmokeComposerSubmissionActionKind.DispatchBareSlash:
					trace.push(
						"tui.composer_submission.dispatch_bare="
						+ action.commandName
						+ ":result=" + action.result
						+ ":history_staged=" + action.historyStaged
						+ ":history_recorded=" + action.historyRecorded
						+ ":event=" + action.appEventSent
					);
				case TuiSmokeComposerSubmissionActionKind.DispatchSlashArgs:
					trace.push(
						"tui.composer_submission.dispatch_args="
						+ action.commandName
						+ ":args=" + action.argsText
						+ ":result=" + action.result
						+ ":elements=" + action.textElementAfter
						+ ":history_staged=" + action.historyStaged
						+ ":live=" + !action.noLiveDispatch
					);
				case TuiSmokeComposerSubmissionActionKind.PrepareInlineArgs:
					trace.push(
						"tui.composer_submission.inline_args="
						+ action.commandName
						+ ":args=" + action.argsText
						+ ":pending=" + action.pendingTransitionText()
						+ ":elements=" + action.elementTransitionText()
						+ ":trimmed=" + action.textTrimmed
					);
				case TuiSmokeComposerSubmissionActionKind.BuildUserMessage:
					trace.push(
						"tui.composer_submission.user_message="
						+ action.result
						+ ":text=" + action.preparedText
						+ ":local=" + action.localImageTransitionText()
						+ ":remote=" + action.remoteImageTransitionText()
						+ ":local_drained=" + action.localImagesDrained
						+ ":remote_drained=" + action.remoteImagesDrained
					);
				case TuiSmokeComposerSubmissionActionKind.AssembleUserInput:
					trace.push(
						"tui.composer_submission.items="
						+ "order=" + action.itemOrder
						+ ":count=" + action.itemCount
						+ ":remote=" + action.remoteImageItemCount
						+ ":local=" + action.localImageItemCount
						+ ":text=" + action.textItemCount
						+ ":skills=" + action.skillItemCount
						+ ":mentions=" + action.mentionItemCount
						+ ":bindings=" + action.mentionBindingCount
					);
				case TuiSmokeComposerSubmissionActionKind.SubmitUserTurn:
					trace.push(
						"tui.composer_submission.user_turn="
						+ "submitted=" + action.userTurnSubmitted
						+ ":model=" + action.modelName
						+ ":session=" + action.sessionConfigured
						+ ":history=" + action.renderInHistory
						+ ":pending_steer=" + action.pendingSteerQueued
						+ ":display=" + action.displayRecorded
						+ ":cancel_edit=" + action.cancelEditRecorded
						+ ":ide=" + action.ideContextApplied
						+ ":collab=" + action.collaborationModeAttached
						+ ":live=" + !action.noLiveDispatch
					);
				case TuiSmokeComposerSubmissionActionKind.QueueDrain:
					trace.push(
						"tui.composer_submission.queue_drain="
						+ action.queuedAction
						+ ":messages=" + action.queueTransitionText()
						+ ":submitted=" + action.submittedNow
						+ ":status_working=" + action.statusWorking
					);
				case TuiSmokeComposerSubmissionActionKind.RestoreBlockedImages:
					trace.push(
						"tui.composer_submission.restore_blocked_images="
						+ "model_supports_images=" + action.modelSupportsImages
						+ ":local=" + action.localImageAfter
						+ ":remote=" + action.remoteImageAfter
						+ ":restored=" + action.blockedRestored
					);
				case TuiSmokeComposerSubmissionActionKind.RestoreUnavailableModel:
					trace.push(
						"tui.composer_submission.restore_unavailable_model="
						+ "model_available=" + action.modelAvailable
						+ ":text=" + action.preparedText
						+ ":local=" + action.localImageAfter
						+ ":remote=" + action.remoteImageAfter
						+ ":bindings=" + action.mentionBindingCount
						+ ":restored=" + action.blockedRestored
					);
				case TuiSmokeComposerSubmissionActionKind.HistoryRecord:
					trace.push(
						"tui.composer_submission.history="
						+ action.preparedText
						+ ":record=" + action.recordHistory
						+ ":staged=" + action.historyStaged
						+ ":recorded=" + action.historyRecorded
					);
				case TuiSmokeComposerSubmissionActionKind.Failure:
					trace.push(
						"tui.composer_submission.failure="
						+ action.failureCode
						+ ":slash_failed=" + action.slashValidationFailed
						+ ":too_large=" + action.tooLargeRejected
						+ ":empty=" + action.emptySuppressed
						+ ":pending_restored=" + action.pendingRestored
						+ (action.emptySuppressedBeforeDispatch ? ":pre_dispatch_empty=true" : "")
						+ (action.shellCommandSubmitted ? ":shell=true" : "")
						+ (action.noLiveDispatch ? ":no_live=true" : "")
						+ ":unsupported=" + action.unsupportedRejected
					);
				case _:
					trace.push("tui.composer_submission.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceComposerAttachment(plan:TuiSmokeComposerAttachmentPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveFilesystem || plan.allowLiveClipboard || plan.allowProcessSpawn || !plan.enabled()) {
			trace.push("tui.composer_attachment.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.composer_attachment.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeComposerAttachmentActionKind.HandlePaste:
					trace.push(
						"tui.composer_attachment.paste="
						+ action.pasteKind
						+ ":chars=" + action.charCount
						+ ":threshold=" + action.threshold
						+ ":normalized=" + action.normalizedText
						+ ":text_inserted=" + action.textInserted
						+ ":placeholder=" + action.placeholderInserted
						+ ":pending=" + action.pendingTransitionText()
						+ ":redraw=" + action.needsRedraw
						+ (action.explicitPasteClearsBurst ? ":clears_burst=true" : "")
					);
				case TuiSmokeComposerAttachmentActionKind.PasteBurstChar:
					trace.push(
						"tui.composer_attachment.burst_char="
						+ action.inputText
						+ ":state=" + action.burstBefore + "->" + action.burstAfter
						+ ":buffered=" + action.buffered
						+ ":newline=" + action.newlineCaptured
						+ ":pending=" + action.pendingTransitionText()
						+ (action.charIntervalMs > 0 ? ":interval_ms=" + action.charIntervalMs : "")
						+ (action.shortcutOverlaySuppressed ? ":shortcut_suppressed=true" : "")
					);
				case TuiSmokeComposerAttachmentActionKind.PasteBurstFlush:
					trace.push(
						"tui.composer_attachment.burst_flush="
						+ action.pasteKind
						+ ":state=" + action.burstBefore + "->" + action.burstAfter
						+ ":flushed=" + action.flushed
						+ ":chars=" + action.charCount
						+ ":pending=" + action.pendingTransitionText()
						+ ":redraw=" + action.needsRedraw
						+ (action.activeIdleTimeoutMs > 0 ? ":idle_ms=" + action.activeIdleTimeoutMs : "")
					);
				case TuiSmokeComposerAttachmentActionKind.LargePastePlaceholder:
					trace.push(
						"tui.composer_attachment.large_paste="
						+ action.placeholder
						+ ":chars=" + action.charCount
						+ ":pending=" + action.pendingTransitionText()
						+ ":elements=" + action.elementTransitionText()
					);
				case TuiSmokeComposerAttachmentActionKind.ExpandPendingPastes:
					trace.push(
						"tui.composer_attachment.expand_pending="
						+ "pending=" + action.pendingTransitionText()
						+ ":elements=" + action.elementTransitionText()
						+ ":expanded=" + action.pendingExpanded
						+ ":cleared=" + action.pendingCleared
					);
				case TuiSmokeComposerAttachmentActionKind.AttachLocalImage:
					trace.push(
						"tui.composer_attachment.local_image="
						+ action.placeholder
						+ ":path=" + action.path
						+ ":local=" + action.localImageTransitionText()
						+ ":remote=" + action.remoteImageAfter
						+ ":attached=" + action.imageAttached
					);
				case TuiSmokeComposerAttachmentActionKind.SetRemoteImages:
					trace.push(
						"tui.composer_attachment.remote_images="
						+ action.remoteImageTransitionText()
						+ ":selected=" + action.selectedRemoteTransitionText()
						+ ":relabel_locals=" + action.remoteRelabeledLocals
					);
				case TuiSmokeComposerAttachmentActionKind.SelectRemoteImage:
					trace.push(
						"tui.composer_attachment.remote_select="
						+ action.keyName
						+ ":selected=" + action.selectedRemoteTransitionText()
						+ ":redraw=" + action.needsRedraw
					);
				case TuiSmokeComposerAttachmentActionKind.DeleteRemoteImage:
					trace.push(
						"tui.composer_attachment.remote_delete="
						+ action.keyName
						+ ":remote=" + action.remoteImageTransitionText()
						+ ":selected=" + action.selectedRemoteTransitionText()
						+ ":relabel_locals=" + action.remoteRelabeledLocals
					);
				case TuiSmokeComposerAttachmentActionKind.SnapshotDraft:
					trace.push(
						"tui.composer_attachment.snapshot="
						+ action.attachmentKind
						+ ":text_elements=" + action.textElementAfter
						+ ":local=" + action.localImageAfter
						+ ":remote=" + action.remoteImageAfter
						+ ":pending=" + action.pendingAfter
						+ ":stored=" + action.draftSnapshotStored
					);
				case TuiSmokeComposerAttachmentActionKind.RestoreDraft:
					trace.push(
						"tui.composer_attachment.restore="
						+ action.attachmentKind
						+ ":cursor=" + action.cursorTransitionText()
						+ ":local=" + action.localImageTransitionText()
						+ ":remote=" + action.remoteImageTransitionText()
						+ ":pending=" + action.pendingTransitionText()
						+ ":restored=" + action.draftRestored
					);
				case TuiSmokeComposerAttachmentActionKind.ApplyHistoryEntry:
					trace.push(
						"tui.composer_attachment.history_entry="
						+ action.attachmentKind
						+ ":local=" + action.localImageAfter
						+ ":remote=" + action.remoteImageAfter
						+ ":pending=" + action.pendingAfter
						+ ":applied=" + action.historyEntryApplied
					);
				case TuiSmokeComposerAttachmentActionKind.PrepareSubmission:
					trace.push(
						"tui.composer_attachment.prepare_submission="
						+ action.attachmentKind
						+ ":pending=" + action.pendingTransitionText()
						+ ":elements=" + action.elementTransitionText()
						+ ":local_pruned=" + action.localImagesPruned
						+ ":suppressed=" + action.submissionSuppressed
						+ ":prepared=" + action.submissionPrepared
					);
				case TuiSmokeComposerAttachmentActionKind.DrainSubmission:
					trace.push(
						"tui.composer_attachment.drain_submission="
						+ action.attachmentKind
						+ ":local=" + action.localImageTransitionText()
						+ ":remote_taken=" + action.remoteImagesTaken
						+ ":remote=" + action.remoteImageTransitionText()
					);
				case TuiSmokeComposerAttachmentActionKind.InsertSelectedFile:
					trace.push(
						"tui.composer_attachment.selected_file="
						+ action.path
						+ ":image_path=" + action.imagePasteEnabled
						+ ":dimensions_checked=" + action.imageDimensionsChecked
						+ ":attached=" + action.imageAttached
						+ ":fallback=" + action.pathInsertedFallback
						+ ":no_live_fs=" + action.noLiveFilesystem
					);
				case TuiSmokeComposerAttachmentActionKind.FrameSchedule:
					trace.push(
						"tui.composer_attachment.frame="
						+ "scheduled=" + action.frameScheduled
						+ ":redraw=" + action.needsRedraw
						+ ":burst=" + action.burstAfter
						+ (action.followupDelayMs > 0 ? ":delay_ms=" + action.followupDelayMs : "")
					);
				case TuiSmokeComposerAttachmentActionKind.Failure:
					trace.push(
						"tui.composer_attachment.failure="
						+ action.failureCode
						+ ":no_live_clipboard=" + action.noLiveClipboard
						+ ":no_process=" + action.noProcessSpawn
						+ ":no_live_fs=" + action.noLiveFilesystem
						+ ":unsupported=" + action.unsupportedRejected
					);
				case _:
					trace.push("tui.composer_attachment.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceHistorySearch(plan:TuiSmokeHistorySearchPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveHistoryLookup || !plan.enabled()) {
			trace.push("tui.history_search.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.history_search.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeHistorySearchActionKind.Begin:
					trace.push(
						"tui.history_search.begin="
						+ action.keyName
						+ ":active=" + action.activeTransitionText()
						+ ":status=" + action.statusAfter
						+ ":original=" + action.originalDraft
						+ ":paste_flushed=" + action.pasteFlushed
						+ ":file_query_cleared=" + action.fileQueryCleared
						+ ":popups_cleared=" + action.popupsCleared
						+ ":remote_images_cleared=" + action.remoteImageSelectionCleared
						+ ":search_reset=" + action.searchReset
					);
				case TuiSmokeHistorySearchActionKind.QueryEdit:
					trace.push(
						"tui.history_search.query="
						+ action.queryTransitionText()
						+ ":status=" + action.statusTransitionText()
						+ ":restore_original=" + action.draftRestored
						+ ":direction=" + action.direction
					);
				case TuiSmokeHistorySearchActionKind.SearchResult:
					trace.push(
						"tui.history_search.result="
						+ action.result
						+ ":status=" + action.statusTransitionText()
						+ ":preview=" + action.previewText
						+ ":matches=" + action.matchCount
						+ ":selected=" + action.selectionTransitionText()
						+ ":draft_previewed=" + action.draftPreviewed
						+ ":draft_restored=" + action.draftRestored
					);
				case TuiSmokeHistorySearchActionKind.Navigate:
					trace.push(
						"tui.history_search.navigate="
						+ action.direction
						+ ":result=" + action.result
						+ ":status=" + action.statusTransitionText()
						+ ":selected=" + action.selectionTransitionText()
						+ ":preview=" + action.previewText
					);
				case TuiSmokeHistorySearchActionKind.Accept:
					trace.push(
						"tui.history_search.accept="
						+ action.acceptedText
						+ ":active=" + action.activeTransitionText()
						+ ":status=" + action.statusTransitionText()
						+ ":cursor=" + action.cursorTransitionText()
						+ ":draft_accepted=" + action.draftAccepted
						+ ":search_reset=" + action.searchReset
					);
				case TuiSmokeHistorySearchActionKind.Cancel:
					trace.push(
						"tui.history_search.cancel="
						+ action.keyName
						+ ":active=" + action.activeTransitionText()
						+ ":restored=" + action.restoredText
						+ ":navigation_reset=" + action.navigationReset
						+ ":ctrl_c=" + action.ctrlCConsumed
						+ ":redraw=" + action.redrawRequested
					);
				case TuiSmokeHistorySearchActionKind.LookupRequest:
					trace.push(
						"tui.history_search.lookup_request="
						+ "offset=" + action.persistentOffset
						+ ":log=" + action.logId
						+ ":direction=" + action.direction
						+ ":pending=" + action.pendingStored
						+ ":live=" + !action.noLiveLookup
					);
				case TuiSmokeHistorySearchActionKind.LookupResponse:
					trace.push(
						"tui.history_search.lookup_response="
						+ "offset=" + action.persistentOffset
						+ ":log=" + action.logId
						+ ":result=" + action.result
						+ ":status=" + action.statusTransitionText()
						+ ":preview=" + action.previewText
					);
				case TuiSmokeHistorySearchActionKind.FooterRender:
					trace.push(
						"tui.history_search.footer="
						+ action.footerLine
						+ ":mode=" + action.footerMode
						+ ":status=" + action.statusAfter
					);
				case TuiSmokeHistorySearchActionKind.Highlight:
					trace.push(
						"tui.history_search.highlight="
						+ action.queryAfter
						+ ":ranges=" + action.highlightCount
						+ ":preview=" + action.previewText
					);
				case TuiSmokeHistorySearchActionKind.Keymap:
					trace.push(
						"tui.history_search.keymap="
						+ action.keyName
						+ ":remapped=" + action.remapped
						+ ":fallback_suppressed=" + action.fallbackSuppressed
						+ ":consumed=" + action.keyConsumed
					);
				case TuiSmokeHistorySearchActionKind.SuppressPopups:
					trace.push(
						"tui.history_search.suppress_popups="
						+ "file_query_cleared=" + action.fileQueryCleared
						+ ":popups_cleared=" + action.popupsCleared
						+ ":frame=" + action.frameScheduled
					);
				case TuiSmokeHistorySearchActionKind.Failure:
					trace.push(
						"tui.history_search.failure="
						+ action.failureCode
						+ ":unsupported=" + action.unsupportedRejected
					);
				case _:
					trace.push("tui.history_search.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceFileMentionPopup(plan:TuiSmokeFileMentionPopupPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveFileSearch || !plan.enabled()) {
			trace.push("tui.file_mention_popup.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.file_mention_popup.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeFileMentionPopupActionKind.Sync:
					trace.push(
						"tui.file_mention_popup.sync="
						+ action.inputText
						+ ":token=" + action.token
						+ ":query=" + action.query
						+ ":popup=" + action.popupTransitionText()
						+ ":mentions_v2=" + action.mentionsV2Enabled
						+ ":redraw=" + action.redrawRequested
					);
				case TuiSmokeFileMentionPopupActionKind.ActivateFile:
					trace.push(
						"tui.file_mention_popup.file.activate="
						+ action.query
						+ ":created=" + action.popupCreated
						+ ":popup=" + action.popupTransitionText()
						+ ":rows=" + action.rowCount
						+ ":max_rows=" + action.maxRows
					);
				case TuiSmokeFileMentionPopupActionKind.FileSearchStart:
					trace.push(
						"tui.file_mention_popup.file.search_start="
						+ action.query
						+ ":sent=" + action.queryStartSent
						+ ":same_query_skipped=" + action.sameQuerySkipped
						+ ":live_rejected=" + action.liveSearchRejected
					);
				case TuiSmokeFileMentionPopupActionKind.FileSearchResult:
					trace.push(
						"tui.file_mention_popup.file.result="
						+ action.query
						+ ":accepted=" + action.resultAccepted
						+ ":stale=" + action.resultStale
						+ ":matches=" + action.matchCount
						+ ":visible=" + action.visibleCount
						+ ":rows=" + action.rowCount
						+ ":selected=" + action.selectionTransitionText()
						+ ":scroll=" + action.scrollTransitionText()
					);
				case TuiSmokeFileMentionPopupActionKind.MoveSelection:
					trace.push(
						"tui.file_mention_popup.selection="
						+ action.popupAfter
						+ ":selected=" + action.selectionTransitionText()
						+ ":scroll=" + action.scrollTransitionText()
					);
				case TuiSmokeFileMentionPopupActionKind.InsertFile:
					trace.push(
						"tui.file_mention_popup.file.insert="
						+ action.selectedPath
						+ ":candidate=" + action.candidateKind
						+ ":draft=" + action.draftUpdated
						+ ":popup=" + action.popupTransitionText()
						+ ":frame=" + action.frameScheduled
					);
				case TuiSmokeFileMentionPopupActionKind.DismissFile:
					trace.push(
						"tui.file_mention_popup.file.dismiss="
						+ action.token
						+ ":stored=" + action.dismissedTokenStored
						+ ":popup=" + action.popupTransitionText()
						+ ":redraw=" + action.redrawRequested
					);
				case TuiSmokeFileMentionPopupActionKind.ActivateMention:
					trace.push(
						"tui.file_mention_popup.mention.activate="
						+ action.query
						+ ":created=" + action.popupCreated
						+ ":popup=" + action.popupTransitionText()
						+ ":mode=" + action.searchModeAfter
						+ ":files=" + action.fileCandidateCount
						+ ":dirs=" + action.directoryCandidateCount
						+ ":skills=" + action.skillCandidateCount
						+ ":plugins=" + action.pluginCandidateCount
						+ ":tools=" + action.toolCandidateCount
					);
				case TuiSmokeFileMentionPopupActionKind.SwitchMentionMode:
					trace.push(
						"tui.file_mention_popup.mention.mode="
						+ action.searchModeTransitionText()
						+ ":query=" + action.query
						+ ":selected=" + action.selectionTransitionText()
					);
				case TuiSmokeFileMentionPopupActionKind.InsertMention:
					trace.push(
						"tui.file_mention_popup.mention.insert="
						+ action.insertText
						+ ":candidate=" + action.candidateKind
						+ ":path=" + action.selectedPath
						+ ":binding=" + action.bindingStored
						+ ":draft=" + action.draftUpdated
						+ ":popup=" + action.popupTransitionText()
					);
				case TuiSmokeFileMentionPopupActionKind.DismissMention:
					trace.push(
						"tui.file_mention_popup.mention.dismiss="
						+ action.token
						+ ":stored=" + action.dismissedTokenStored
						+ ":popup=" + action.popupTransitionText()
						+ ":redraw=" + action.redrawRequested
					);
				case TuiSmokeFileMentionPopupActionKind.ClearQuery:
					trace.push(
						"tui.file_mention_popup.file.clear_query="
						+ action.query
						+ ":sent=" + action.queryClearSent
						+ ":popup=" + action.popupTransitionText()
					);
				case TuiSmokeFileMentionPopupActionKind.Hide:
					trace.push(
						"tui.file_mention_popup.hide="
						+ action.inputText
						+ ":popup=" + action.popupTransitionText()
						+ ":reason=" + action.failureCode
					);
				case TuiSmokeFileMentionPopupActionKind.SuppressSlash:
					trace.push(
						"tui.file_mention_popup.suppress_slash="
						+ action.inputText
						+ ":token=" + action.token
						+ ":suppressed=" + action.slashPopupSuppressed
						+ ":popup=" + action.popupTransitionText()
					);
				case TuiSmokeFileMentionPopupActionKind.Failure:
					trace.push(
						"tui.file_mention_popup.failure="
						+ action.failureCode
						+ ":live_rejected=" + action.liveSearchRejected
						+ ":unsupported=" + action.unsupportedRejected
					);
				case _:
					trace.push("tui.file_mention_popup.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceSlashCommandPopup(plan:TuiSmokeSlashPopupPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveInput || !plan.enabled()) {
			trace.push("tui.slash_popup.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.slash_popup.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeSlashPopupActionKind.Sync:
					trace.push(
						"tui.slash_popup.sync="
						+ action.inputText
						+ ":filter=" + action.filterText
						+ ":active=" + action.activeTransitionText()
						+ ":file_query_cleared=" + action.currentFileQueryCleared
						+ ":redraw=" + action.redrawRequested
					);
				case TuiSmokeSlashPopupActionKind.Activate:
					trace.push(
						"tui.slash_popup.activate="
						+ action.filterText
						+ ":match=" + action.matchKind
						+ ":created=" + action.popupCreated
						+ ":commands=" + action.totalCommands
						+ ":visible=" + action.visibleCount
						+ ":aliases_hidden=" + action.hiddenAliasCount
					);
				case TuiSmokeSlashPopupActionKind.Render:
					trace.push(
						"tui.slash_popup.render="
						+ action.filterText
						+ ":rows=" + action.rowCount
						+ ":matches=" + action.matchedCount
						+ ":services=" + action.serviceTierCount
						+ ":disabled=" + action.disabledCount
					);
				case TuiSmokeSlashPopupActionKind.Filter:
					trace.push(
						"tui.slash_popup.filter="
						+ action.filterText
						+ ":match=" + action.matchKind
						+ ":matches=" + action.matchedCount
						+ ":selected=" + action.selectionTransitionText()
						+ ":scroll=" + action.scrollTransitionText()
					);
				case TuiSmokeSlashPopupActionKind.MoveSelection:
					trace.push(
						"tui.slash_popup.selection="
						+ action.filterText
						+ ":selected=" + action.selectionTransitionText()
						+ ":scroll=" + action.scrollTransitionText()
					);
				case TuiSmokeSlashPopupActionKind.Complete:
					trace.push(
						"tui.slash_popup.complete="
						+ action.commandName
						+ ":kind=" + action.commandKind
						+ ":completion=" + action.completionKind
						+ ":draft_preserved=" + action.draftPreserved
						+ ":text_cleared=" + action.textCleared
					);
				case TuiSmokeSlashPopupActionKind.Dispatch:
					trace.push(
						"tui.slash_popup.dispatch="
						+ action.commandName
						+ ":kind=" + action.commandKind
						+ ":command=" + action.commandDispatched
						+ ":service_tier=" + action.serviceTierDispatched
						+ ":history=" + action.historyStaged + "->" + action.historyRecorded
						+ ":text_cleared=" + action.textCleared
					);
				case TuiSmokeSlashPopupActionKind.RejectUnavailable:
					trace.push(
						"tui.slash_popup.unavailable="
						+ action.commandName
						+ ":task_running=" + action.taskRunning
						+ ":rejected=" + action.unsupportedRejected
						+ ":history=" + action.historyStaged + "->" + action.historyRecorded
					);
				case TuiSmokeSlashPopupActionKind.Dismiss:
					trace.push(
						"tui.slash_popup.dismiss="
						+ action.filterText
						+ ":active=" + action.activeTransitionText()
						+ ":dismissed=" + action.popupDismissed
						+ ":draft_preserved=" + action.draftPreserved
						+ ":redraw=" + action.redrawRequested
					);
				case TuiSmokeSlashPopupActionKind.Hide:
					trace.push(
						"tui.slash_popup.hide="
						+ action.inputText
						+ ":active=" + action.activeTransitionText()
						+ ":reason=" + action.failureCode
					);
				case TuiSmokeSlashPopupActionKind.SuppressInterrupt:
					trace.push(
						"tui.slash_popup.suppress_interrupt="
						+ action.filterText
						+ ":task_running=" + action.taskRunning
						+ ":active=" + action.activeAfter
						+ ":suppressed=" + action.interruptSuppressed
					);
				case TuiSmokeSlashPopupActionKind.Failure:
					trace.push(
						"tui.slash_popup.failure="
						+ action.failureCode
						+ ":rejected=" + action.unsupportedRejected
					);
				case _:
					trace.push("tui.slash_popup.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceHooksBrowser(plan:TuiSmokeHooksBrowserPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveHooks || !plan.enabled()) {
			trace.push("tui.hooks_browser.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.hooks_browser.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeHooksBrowserActionKind.OpenBrowser:
					trace.push(
						"tui.hooks_browser.open="
						+ action.pageAfter
						+ ":events=" + action.eventCount
						+ ":hooks=" + action.hookCount
						+ ":needs_review=" + action.needsReviewCount
						+ ":selected=" + action.selectionTransitionText()
						+ ":frame=" + action.frameScheduled
					);
				case TuiSmokeHooksBrowserActionKind.RenderEvents:
					trace.push(
						"tui.hooks_browser.render_events="
						+ "events=" + action.eventCount
						+ ":installed=" + action.installedCount
						+ ":active=" + action.activeCount
						+ ":needs_review=" + action.needsReviewCount
						+ ":warnings=" + action.warningCount
						+ ":errors=" + action.errorCount
						+ ":rows=" + action.visibleRows
						+ ":rendered=" + action.rendered
					);
				case TuiSmokeHooksBrowserActionKind.MoveSelection:
					trace.push(
						"tui.hooks_browser.selection="
						+ action.pageBefore
						+ ":event=" + action.eventName
						+ ":selected=" + action.selectionTransitionText()
						+ ":scroll=" + action.scrollTransitionText()
					);
				case TuiSmokeHooksBrowserActionKind.OpenEvent:
					trace.push(
						"tui.hooks_browser.open_event="
						+ action.eventName
						+ ":page=" + action.pageTransitionText()
						+ ":handlers=" + action.hookCount
						+ ":selected=" + action.selectionTransitionText()
						+ ":frame=" + action.frameScheduled
					);
				case TuiSmokeHooksBrowserActionKind.ReturnToEvents:
					trace.push(
						"tui.hooks_browser.return="
						+ action.eventName
						+ ":page=" + action.pageTransitionText()
						+ ":selected=" + action.selectionTransitionText()
						+ ":frame=" + action.frameScheduled
					);
				case TuiSmokeHooksBrowserActionKind.RenderHandlers:
					trace.push(
						"tui.hooks_browser.render_handlers="
						+ action.eventName
						+ ":handlers=" + action.hookCount
						+ ":active=" + action.activeCount
						+ ":needs_review=" + action.needsReviewCount
						+ ":rows=" + action.visibleRows
						+ ":details=" + action.detailLines
						+ ":command_lines=" + action.commandDetailLines
						+ ":rendered=" + action.rendered
					);
				case TuiSmokeHooksBrowserActionKind.ToggleHook:
					trace.push(
						"tui.hooks_browser.toggle="
						+ action.hookKey
						+ ":event=" + action.eventName
						+ ":source=" + action.hookSource
						+ ":enabled=" + action.enabledTransitionText()
						+ ":sent=" + action.setHookEnabledSent
					);
				case TuiSmokeHooksBrowserActionKind.TrustHook:
					trace.push(
						"tui.hooks_browser.trust="
						+ action.hookKey
						+ ":event=" + action.eventName
						+ ":trust=" + action.trustTransitionText()
						+ ":sent=" + action.trustHookSent
						+ ":frame=" + action.frameScheduled
					);
				case TuiSmokeHooksBrowserActionKind.TrustAll:
					trace.push(
						"tui.hooks_browser.trust_all="
						+ action.eventName
						+ ":updates=" + action.updatesCount
						+ ":needs_review=" + action.needsReviewCount
						+ ":sent=" + action.trustHooksSent
						+ ":frame=" + action.frameScheduled
					);
				case TuiSmokeHooksBrowserActionKind.ManagedNoOp:
					trace.push(
						"tui.hooks_browser.managed_noop="
						+ action.hookKey
						+ ":event=" + action.eventName
						+ ":managed=" + action.managed
						+ ":enabled=" + action.enabledTransitionText()
						+ ":sent=" + action.setHookEnabledSent
					);
				case TuiSmokeHooksBrowserActionKind.ReviewNoOp:
					trace.push(
						"tui.hooks_browser.review_noop="
						+ action.hookKey
						+ ":event=" + action.eventName
						+ ":needs_review=" + action.needsReview
						+ ":trust=" + action.trustTransitionText()
						+ ":sent=" + action.setHookEnabledSent
					);
				case TuiSmokeHooksBrowserActionKind.Close:
					trace.push(
						"tui.hooks_browser.close="
						+ action.pageBefore
						+ ":complete=" + action.completeTransitionText()
						+ ":frame=" + action.frameScheduled
					);
				case TuiSmokeHooksBrowserActionKind.Failure:
					trace.push(
						"tui.hooks_browser.failure="
						+ action.failureCode
						+ ":warnings=" + action.warningCount
						+ ":errors=" + action.errorCount
						+ ":rejected=" + action.unsupportedRejected
					);
				case _:
					trace.push("tui.hooks_browser.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceMcpElicitationOverlay(plan:TuiSmokeMcpElicitationPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveElicitation || !plan.enabled()) {
			trace.push("tui.mcp_elicitation.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.mcp_elicitation.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeMcpElicitationActionKind.NoteServerRequest:
					trace.push(
						"tui.mcp_elicitation.pending.note="
						+ action.mode
						+ ":server=" + action.serverName
						+ ":request=" + action.requestId
						+ ":thread=" + action.threadId
						+ ":message_chars=" + action.messageChars
						+ ":unsupported=" + action.unsupportedRejected
					);
				case TuiSmokeMcpElicitationActionKind.ParseForm:
					trace.push(
						"tui.mcp_elicitation.parse="
						+ action.mode
						+ ":fields=" + action.fieldCount
						+ ":required=" + action.requiredFieldCount
						+ ":optional=" + action.optionalFieldCount
						+ ":secret=" + action.secretFieldCount
						+ ":approval_params=" + action.approvalDisplayParamCount
					);
				case TuiSmokeMcpElicitationActionKind.ShowModal:
					trace.push(
						"tui.mcp_elicitation.show=modal"
						+ ":mode=" + action.mode
						+ ":server=" + action.serverName
						+ ":request=" + action.requestId
						+ ":fields=" + action.fieldCount
						+ ":views=" + action.viewStackTransitionText()
						+ ":pause_status=" + action.statusTimerPaused
						+ ":composer_disabled=" + action.composerDisabled
						+ ":focus=" + action.hasInputFocus
					);
				case TuiSmokeMcpElicitationActionKind.ShowAppLink:
					trace.push(
						"tui.mcp_elicitation.show=app_link"
						+ ":server=" + action.serverName
						+ ":request=" + action.requestId
						+ ":tool=" + action.toolId
						+ ":name=" + action.toolName
						+ ":install_url=" + action.toolSuggestionHasInstallUrl
						+ ":views=" + action.viewStackTransitionText()
						+ ":pause_status=" + action.statusTimerPaused
					);
				case TuiSmokeMcpElicitationActionKind.EnqueueActive:
					trace.push(
						"tui.mcp_elicitation.enqueue_active="
						+ action.mode
						+ ":request=" + action.requestId
						+ ":queue=" + action.queueTransitionText()
						+ ":frame=" + action.frameScheduled
					);
				case TuiSmokeMcpElicitationActionKind.SelectOption:
					trace.push(
						"tui.mcp_elicitation.select="
						+ action.fieldId
						+ ":input=" + action.fieldInput
						+ ":options=" + action.optionCount
						+ ":selected=" + action.selectionTransitionText()
						+ ":answered=" + action.answerTransitionText()
					);
				case TuiSmokeMcpElicitationActionKind.DraftInput:
					trace.push(
						"tui.mcp_elicitation.draft="
						+ action.fieldId
						+ ":input=" + action.fieldInput
						+ ":chars=" + action.draftTransitionText()
						+ ":paste_burst=" + action.pendingPasteCount
						+ ":answered=" + action.answerTransitionText()
					);
				case TuiSmokeMcpElicitationActionKind.MoveField:
					trace.push(
						"tui.mcp_elicitation.move_field="
						+ action.fieldTransitionText()
						+ ":saved_draft_chars=" + action.draftCharsBefore
						+ ":restored_draft_chars=" + action.draftCharsAfter
						+ ":input=" + action.fieldInput
					);
				case TuiSmokeMcpElicitationActionKind.ValidationError:
					trace.push(
						"tui.mcp_elicitation.validation="
						+ action.failureCode
						+ ":required_unanswered=" + action.requiredUnansweredBefore
						+ ":jump=" + action.fieldTransitionText()
					);
				case TuiSmokeMcpElicitationActionKind.Submit:
					trace.push(
						"tui.mcp_elicitation.submit="
						+ action.mode
						+ ":decision=" + action.decision
						+ ":content_fields=" + action.contentFieldCount
						+ ":meta_persisted=" + action.metaPersisted
						+ ":required_unanswered=" + action.requiredUnansweredTransitionText()
						+ ":command=" + action.appCommandSent
						+ ":complete=" + action.completeTransitionText()
					);
				case TuiSmokeMcpElicitationActionKind.Cancel:
					trace.push(
						"tui.mcp_elicitation.cancel="
						+ action.mode
						+ ":server=" + action.serverName
						+ ":request=" + action.requestId
						+ ":command=" + action.appCommandSent
						+ ":complete=" + action.completeTransitionText()
					);
				case TuiSmokeMcpElicitationActionKind.Resolve:
					trace.push(
						"tui.mcp_elicitation.resolve="
						+ action.mode
						+ ":server=" + action.serverName
						+ ":request=" + action.requestId
						+ ":decision=" + action.decision
						+ ":content_fields=" + action.contentFieldCount
						+ ":meta_persisted=" + action.metaPersisted
						+ ":sent=" + action.resolutionSent
					);
				case TuiSmokeMcpElicitationActionKind.DismissResolved:
					trace.push(
						"tui.mcp_elicitation.dismiss_resolved="
						+ action.mode
						+ ":server=" + action.serverName
						+ ":request=" + action.requestId
						+ ":matched=" + action.resolvedDismissed
						+ ":stale=" + action.staleResolution
						+ ":queue=" + action.queueTransitionText()
						+ ":views=" + action.viewStackTransitionText()
						+ ":resume_status=" + action.statusTimerResumed
						+ ":frame=" + action.frameScheduled
					);
				case TuiSmokeMcpElicitationActionKind.UnsupportedReject:
					trace.push(
						"tui.mcp_elicitation.unsupported="
						+ action.mode
						+ ":server=" + action.serverName
						+ ":request=" + action.requestId
						+ ":rejected=" + action.unsupportedRejected
						+ ":failure=" + action.failureCode
					);
				case TuiSmokeMcpElicitationActionKind.Failure:
					trace.push("tui.mcp_elicitation.failure=" + action.failureCode);
				case _:
					trace.push("tui.mcp_elicitation.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceRestore(label:String, action:TuiSmokeTerminalModeAction, trace:Array<String>):Void {
		trace.push(
			"tui.terminal_modes." + label + "="
			+ "raw=" + action.rawModeRestore
			+ ":keyboard=" + action.keyboardRestore
			+ ":disable_bracketed_paste=" + action.bracketedPaste
			+ ":disable_focus=" + action.focusChange
			+ ":cursor_default=" + action.cursorDefault
			+ ":cursor_show=" + action.cursorShow
			+ ":stderr_finish=" + action.terminalStderrFinish
		);
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
