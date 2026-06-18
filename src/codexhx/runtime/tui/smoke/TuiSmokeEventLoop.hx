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
