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
