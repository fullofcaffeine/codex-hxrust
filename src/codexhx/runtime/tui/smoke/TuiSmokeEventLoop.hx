package codexhx.runtime.tui.smoke;

import haxe.json.Value;

private typedef TuiSmokeParsedGitActionMarkdown = {
	final visibleMarkdown:String;
	final directives:Array<TuiSmokeGitActionDirectiveExpectation>;
	final lastCreatedBranchCwd:String;
}

private typedef TuiSmokeStrippedGitActionLine = {
	final visible:String;
	final directives:Array<TuiSmokeGitActionDirectiveExpectation>;
}

private typedef TuiSmokeParsedQuotedValue = {
	final value:String;
	final rest:String;
}

private typedef TuiSmokeLiveWrapState = {
	var targetWidth:Int;
	var currentLine:String;
	var rows:Array<TuiSmokeLiveWrapRow>;
}

private typedef TuiSmokeLiveWrapPrefix = {
	final prefix:String;
	final suffix:String;
	final width:Int;
}

private typedef TuiSmokeScrollState = {
	var selectedIdx:Int;
	var scrollTop:Int;
}

private typedef TuiSmokeStatusSurfacePreviewEntry = {
	final item:String;
	var text:String;
	var isPlaceholder:Bool;
}

private typedef TuiSmokePromptArgsResult = {
	final present:Bool;
	final name:String;
	final rest:String;
	final restOffset:Int;
}

private typedef TuiSmokeFileSearchPopupState = {
	var displayQuery:String;
	var pendingQuery:String;
	var waiting:Bool;
	var matches:Array<String>;
	var selectedIndex:Int;
	var scrollTop:Int;
}

private typedef TuiSmokeSkillPopupState = {
	var query:String;
	var mentions:Array<TuiSmokeSkillPopupMention>;
	var selectedIndex:Int;
	var scrollTop:Int;
}

private typedef TuiSmokeSkillPopupMatch = {
	final index:Int;
	final display:Bool;
	final score:Int;
}

class TuiSmokeEventLoop {
	public static function run(request:TuiSmokeLoopRequest):TuiSmokeLoopOutcome {
		if (request == null || request.frame == null)
			return rejected("missing_loop_request");
		if (request.frame.allowNetwork || request.frame.allowModelCall)
			return rejected("live_effects_not_allowed");

		final terminal = new TuiSmokeTerminalFacade(request.frame.terminalMode, []);
		if (!terminal.setup(request.frame.allowLiveTerminal))
			return rejected("terminal_setup_rejected");

		final state = new TuiSmokeAppState(request.frame);
		final appQueue = new TuiSmokeAppEventQueue();
		final appServer = new TuiSmokeAppServerFacade();
		final trace:Array<String> = [];
		var snapshot = "";
		var exit = TuiSmokeExitKind.Rendered;
		var renderCount = 0;
		var running = true;

		for (event in request.events) {
			if (!running)
				continue;
			switch event.kind {
				case TuiSmokeEventKind.Draw:
					final appExit = drainAppEvents(appQueue, state, trace);
					if (appExit != TuiSmokeExitKind.Rendered) {
						exit = appExit;
						running = false;
					}
					if (!running)
						continue;
					trace.push("tui.draw");
					snapshot = terminal.render(state.frame());
					renderCount = renderCount + 1;
				case TuiSmokeEventKind.Resize:
					final appExit = drainAppEvents(appQueue, state, trace);
					if (appExit != TuiSmokeExitKind.Rendered) {
						exit = appExit;
						running = false;
					}
					if (!running)
						continue;
					trace.push("tui.resize");
					snapshot = terminal.render(state.frame());
					renderCount = renderCount + 1;
				case TuiSmokeEventKind.ResizeDraw:
					final appExit = drainAppEvents(appQueue, state, trace);
					if (appExit != TuiSmokeExitKind.Rendered) {
						exit = appExit;
						running = false;
					}
					if (!running)
						continue;
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
					if (!running)
						continue;
					exit = TuiSmokeRunner.exitForKey(event.key);
					trace.push("tui.key=" + event.key);
					if (exit != TuiSmokeExitKind.Rendered)
						running = false;
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
				case TuiSmokeEventKind.ChatWidgetMcpStartup:
					if (!traceMcpStartup(event.chatWidgetMcpStartup, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ChatWidgetStatusSurface:
					if (!traceStatusSurface(event.chatWidgetStatusSurface, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ChatWidgetStatusSurfaceRender:
					if (!traceStatusSurfaceRender(event.chatWidgetStatusSurfaceRender, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ChatWidgetStatusState:
					if (!traceStatusState(event.chatWidgetStatusState, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ChatWidgetCommandLifecycle:
					if (!traceCommandLifecycle(event.chatWidgetCommandLifecycle, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ChatWidgetToolLifecycle:
					if (!traceToolLifecycle(event.chatWidgetToolLifecycle, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ChatWidgetHookLifecycle:
					if (!traceHookLifecycle(event.chatWidgetHookLifecycle, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ChatWidgetInputSubmission:
					if (!traceInputSubmission(event.chatWidgetInputSubmission, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ChatWidgetTurnRuntime:
					if (!traceTurnRuntime(event.chatWidgetTurnRuntime, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ChatWidgetSessionFlow:
					if (!traceSessionFlow(event.chatWidgetSessionFlow, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ChatWidgetReplayProtocol:
					if (!traceReplayProtocol(event.chatWidgetReplayProtocol, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ChatWidgetRateLimit:
					if (!traceRateLimit(event.chatWidgetRateLimit, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ChatWidgetWindowsSandbox:
					if (!traceWindowsSandbox(event.chatWidgetWindowsSandbox, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ChatWidgetPermissionSelection:
					if (!tracePermissionSelection(event.chatWidgetPermissionSelection, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ChatWidgetModelSettings:
					if (!traceModelSettings(event.chatWidgetModelSettings, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.GoalDisplay:
					if (!traceGoalDisplay(event.goalDisplay, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.GitActionDirectives:
					if (!traceGitActionDirectives(event.gitActionDirectives, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ThreadTranscript:
					if (!traceThreadTranscript(event.threadTranscript, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.LineTruncation:
					if (!traceLineTruncation(event.lineTruncation, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.MarkdownTextMerge:
					if (!traceMarkdownTextMerge(event.markdownTextMerge, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.TextFormatting:
					if (!traceTextFormatting(event.textFormatting, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.LiveWrap:
					if (!traceLiveWrap(event.liveWrap, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.Wrapping:
					if (!traceWrapping(event.wrapping, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ScrollState:
					if (!traceScrollState(event.scrollState, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.SelectionTabs:
					if (!traceSelectionTabs(event.selectionTabs, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ActionRequiredTitle:
					if (!traceActionRequiredTitle(event.actionRequiredTitle, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.PopupConsts:
					if (!tracePopupConsts(event.popupConsts, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.StatusLineStyle:
					if (!traceStatusLineStyle(event.statusLineStyle, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.StatusSurfacePreview:
					if (!traceStatusSurfacePreview(event.statusSurfacePreview, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.PendingInputPreview:
					if (!tracePendingInputPreview(event.pendingInputPreview, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.PendingThreadApprovals:
					if (!tracePendingThreadApprovals(event.pendingThreadApprovals, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.PromptArgs:
					if (!tracePromptArgs(event.promptArgs, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.UnifiedExecFooter:
					if (!traceUnifiedExecFooter(event.unifiedExecFooter, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.FileSearchPopup:
					if (!traceFileSearchPopup(event.fileSearchPopup, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.SkillPopup:
					if (!traceSkillPopup(event.skillPopup, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ChatWidgetGoalMenu:
					if (!traceGoalMenu(event.chatWidgetGoalMenu, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ChatWidgetReviewMode:
					if (!traceReviewMode(event.chatWidgetReviewMode, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ChatWidgetTranscriptHistory:
					if (!traceTranscriptHistory(event.chatWidgetTranscriptHistory, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ChatWidgetTranscriptOverlay:
					if (!traceTranscriptOverlay(event.chatWidgetTranscriptOverlay, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ChatWidgetBacktrackOverlay:
					if (!traceBacktrackOverlay(event.chatWidgetBacktrackOverlay, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ChatWidgetKeymapRawOutput:
					if (!traceKeymapRawOutput(event.chatWidgetKeymapRawOutput, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ChatWidgetRawOutputRender:
					if (!traceRawOutputRender(event.chatWidgetRawOutputRender, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ChatWidgetSlashCommand:
					if (!traceSlashCommand(event.chatWidgetSlashCommand, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.ChatWidgetStatusCard:
					if (!traceStatusCard(event.chatWidgetStatusCard, trace)) {
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
				case TuiSmokeEventKind.SessionArchiveCommand:
					if (!traceSessionArchiveCommand(event.sessionArchiveCommand, trace)) {
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
				case TuiSmokeEventKind.BrowserOpen:
					if (!traceBrowserOpen(event.browserOpen, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.DesktopThread:
					if (!traceDesktopThread(event.desktopThread, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.TerminalVisualization:
					if (!traceTerminalVisualization(event.terminalVisualization, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.AgentStatus:
					if (!traceAgentStatus(event.agentStatus, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.AgentNavigation:
					if (!traceAgentNavigation(event.agentNavigation, trace)) {
						exit = TuiSmokeExitKind.Rejected;
						running = false;
					}
				case TuiSmokeEventKind.LoadedThreads:
					if (!traceLoadedThreads(event.loadedThreads, trace)) {
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
		final finalSnapshot = snapshot + "\ntrace:\n" + traceText + "\nexit: " + exit + "\nrenders: " + renderCount + "\napp-events: " + appQueue.logged()
			+ "\nserver-events: " + appServer.handled() + "\nserver-requests: " + appServer.handledRequests() + "\nserver-rejections: "
			+ appServer.rejectedRequests() + "\nserver-resolutions: " + appServer.handledResolutions() + "\nserver-stale-resolutions: "
			+ appServer.staleResolutions() + "\nserver-deliveries: " + appServer.deliveredRequests() + "\nserver-evictions: " + appServer.evictedRequests()
			+ "\nthread-notifications: " + appServer.handledThreadNotifications() + "\nthread-notification-deliveries: "
			+ appServer.deliveredThreadNotifications() + "\nthread-notification-evictions: " + appServer.evictedThreadNotifications() + "\nthread-replays: "
			+ appServer.handledThreadReplays() + "\nthread-replay-requests: " + appServer.replayedThreadRequests() + "\nthread-replay-skipped-requests: "
			+ appServer.skippedThreadReplayRequests() + "\nthread-replay-suppressed-notices: " + appServer.suppressedThreadReplayNotices()
			+ "\nthread-replay-turns: " + appServer.replayedThreadTurns() + "\nthread-replay-items: " + appServer.replayedThreadItems()
			+ "\nthread-replay-completions: " + appServer.replayedThreadCompletions() + "\nterminal: restored";
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

	static function drainAppEvents(appQueue:TuiSmokeAppEventQueue, state:TuiSmokeAppState, trace:Array<String>):TuiSmokeExitKind {
		while (appQueue.hasNext()) {
			final event = appQueue.next();
			if (event == null)
				return TuiSmokeExitKind.Rendered;
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
		trace.push("tui.resize_draw.size=" + action.sizeText() + ":last=" + action.lastSizeText() + ":width=" + action.widthState() + ":height_changed="
			+ action.heightChanged());
		if (!action.resizeReflowEnabled) {
			if (action.widthChanged())
				trace.push("tui.resize_draw.reflow.clear=disabled");
			return;
		}
		traceSuspendResume(action.suspendResume, trace);
		if (action.shouldRebuildTranscript()) {
			trace.push("tui.resize_draw.reflow.schedule=" + "target_width=" + action.targetWidthText() + ":accepted=" + action.scheduleAccepted);
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
			trace.push("tui.resize_draw.reflow.run=" + "width=" + action.terminalWidth + ":stream_time=" + action.streamTime + ":transcript_cells="
				+ action.transcriptCells);
			traceResizeRepaint(action.repaint, trace);
		}
		if (action.followUpDraw) {
			trace.push("tui.frame.schedule_in=debounce_followup");
		}
		traceViewportResize(action.viewport, trace);
		traceSuspendCursorUpdate(action.suspendResume, action.viewport, trace);
	}

	static function traceResizeRepaint(repaint:TuiSmokeResizeRepaintPlan, trace:Array<String>):Void {
		if (repaint == null)
			return;
		trace.push("tui.repaint.pending_history.clear=" + repaint.pendingHistoryBatches);
		if (repaint.emptyTranscript) {
			trace.push("tui.repaint.transcript.empty_reset=true");
			return;
		}
		trace.push("tui.repaint.render_source=" + "cells=" + repaint.transcriptCellCount + ":rows=" + repaint.reflowedRows + ":row_cap=" +
			repaint.rowCapText());
		trace.push("tui.repaint.clear="
			+ repaint.clearKind
			+ ":viewport_reset="
			+ repaint.viewportReset
			+ ":full="
			+ repaint.needsFullRepaint);
		trace.push("tui.repaint.deferred_history.clear=" + repaint.deferredHistoryRows);
		if (repaint.insertRows) {
			trace.push("tui.repaint.insert=" + "rows=" + repaint.reflowedRows + ":wrap=" + repaint.wrapPolicy);
			trace.push("tui.frame.schedule=history_insert");
		}
	}

	static function traceViewportResize(viewport:TuiSmokeViewportResizePlan, trace:Array<String>):Void {
		if (viewport == null)
			return;
		trace.push("tui.viewport.resize=" + "from=" + viewport.previousAreaText() + ":to=" + viewport.nextAreaText() + ":requested_height="
			+ viewport.requestedHeight);
		trace.push("tui.viewport.height=" + "shrank=" + viewport.terminalHeightShrank + ":grew=" + viewport.terminalHeightGrew + ":bottom_aligned="
			+ viewport.bottomAligned);
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
		trace.push("tui.viewport.pending_history.flush=" + "batches=" + viewport.pendingHistoryBatches + ":rows=" + viewport.pendingHistoryRows + ":mode="
			+ viewport.insertMode() + ":wrap=" + viewport.wrapPolicy);
		if (viewport.needsFullRepaint) {
			trace.push("tui.viewport.invalidate=true");
		}
	}

	static function traceSuspendResume(plan:TuiSmokeSuspendResumePlan, trace:Array<String>):Void {
		if (plan == null || !plan.enabled())
			return;
		trace.push("tui.suspend.capture=" + "action=" + plan.action + ":alt=" + plan.altScreenActive + ":cursor_y=" + plan.cachedCursorY);
		if (plan.leaveAltScreen) {
			trace.push("tui.suspend.leave_alt_screen=true:alt_scroll=" + plan.altScroll);
		}
		trace.push("tui.resume.prepare=" + plan.action + ":cursor_y=" + plan.cursorYAfterResume + ":saved=" + plan.savedViewportText());
		switch plan.action {
			case TuiSmokeResumeActionKind.RealignInline:
				trace.push("tui.resume.apply=realign_viewport:" + plan.appliedViewportText());
			case TuiSmokeResumeActionKind.RestoreAlt:
				trace.push("tui.resume.apply=restore_alt_screen:" + plan.appliedViewportText() + ":enter=" + plan.enterAltScreen + ":alt_scroll="
					+ plan.altScroll + ":clear=" + plan.clearAfterRestore);
			case _:
		}
	}

	static function traceSuspendCursorUpdate(plan:TuiSmokeSuspendResumePlan, viewport:TuiSmokeViewportResizePlan, trace:Array<String>):Void {
		if (plan == null || !plan.enabled() || viewport == null)
			return;
		final cursorY = plan.altScreenActive ? plan.appliedViewportY + plan.appliedViewportHeight - 1 : viewport.nextY + viewport.nextHeight - 1;
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
					trace.push("tui.event_stream.create=" + "state=" + action.stateAfter + ":draw_subscription=" + action.drawSubscription
						+ ":shared_broker=" + action.sharedBroker);
				case TuiSmokeEventStreamActionKind.Pause:
					trace.push("tui.event_stream.pause=" + action.stateTransitionText() + ":drop_source=" + action.dropSource);
				case TuiSmokeEventStreamActionKind.Resume:
					trace.push("tui.event_stream.resume=" + action.stateTransitionText() + ":wake=" + action.wakeResume);
				case TuiSmokeEventStreamActionKind.Poll:
					trace.push("tui.event_stream.poll=" + action.mappedEvent + ":order=" + action.pollOrder + ":state=" + action.stateTransitionText()
						+ ":recreate_source=" + action.recreateSource);
				case TuiSmokeEventStreamActionKind.SourceEvent:
					trace.push("tui.event_stream.map=" + action.mappedText() + ":focused=" + action.terminalFocused + ":palette_requery="
						+ action.paletteRequery);
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
					trace.push("tui.terminal_modes.init=" + "stdin=" + action.stdinTerminal + ":stdout=" + action.stdoutTerminal + ":set_modes="
						+ action.rawMode + ":flush=" + action.flushInput + ":panic_hook=" + action.panicHook + ":keyboard_supported=" + action.supported);
				case TuiSmokeTerminalModeActionKind.SetModes:
					trace.push("tui.terminal_modes.set_modes=" + "vt=" + action.virtualTerminalProcessing + ":bracketed_paste=" + action.bracketedPaste
						+ ":raw=" + action.rawMode + ":keyboard_push=" + action.pushKeyboardEnhancement + ":focus=" + action.focusChange);
				case TuiSmokeTerminalModeActionKind.Restore:
					traceRestore("restore", action, trace);
				case TuiSmokeTerminalModeActionKind.RestoreAfterExit:
					traceRestore("restore_after_exit", action, trace);
				case TuiSmokeTerminalModeActionKind.RestoreKeepRaw:
					traceRestore("restore_keep_raw", action, trace);
				case TuiSmokeTerminalModeActionKind.KeyboardDecision:
					trace.push("tui.keyboard_enhancement.decision=" + "disabled=" + action.keyboardEnhancementDisabled + ":env=" + action.envOverride
						+ ":wsl=" + action.wsl + ":vscode=" + action.vscodeTerminal + ":tmux=" + action.tmuxSession + ":tmux_csi_u=" + action.tmuxCsiU);
				case TuiSmokeTerminalModeActionKind.KeyboardPush:
					trace.push("tui.keyboard_enhancement.push=" + "disambiguate_escape=true:report_event_types=true:report_alternate_keys=true");
				case TuiSmokeTerminalModeActionKind.KeyboardPop:
					trace.push("tui.keyboard_enhancement.pop_stack=" + action.popKeyboardEnhancement);
				case TuiSmokeTerminalModeActionKind.KeyboardReset:
					trace.push("tui.keyboard_enhancement.reset_after_exit=" + action.resetKeyboardEnhancement + ":ansi=ESC[<u");
				case TuiSmokeTerminalModeActionKind.ModifyOtherKeys:
					trace.push("tui.keyboard_enhancement.modify_other_keys=" + (action.modifyOtherKeys ? "enable" : "disable") + ":tmux="
						+ action.tmuxSession + ":csi_u=" + action.tmuxCsiU);
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
						trace.push("tui.alt_screen.enter=" + "active=" + action.activeTransitionText() + ":terminal=" + action.terminalSizeText() + ":save="
							+ action.previousViewportText() + ":saved_after=" + action.savedViewportPresentAfter + ":viewport="
							+ action.appliedViewportText() + ":enter=" + action.enterAlternateScreen + ":alt_scroll=" + action.enableAlternateScroll
							+ ":clear=" + action.clearTerminal);
					}
				case TuiSmokeAltScreenActionKind.Leave:
					if (!action.enabled) {
						trace.push("tui.alt_screen.leave=noop:enabled=false:active=" + action.activeBefore);
					} else {
						trace.push("tui.alt_screen.leave=" + "active=" + action.activeTransitionText() + ":restore=" + action.savedViewportText()
							+ ":saved_before=" + action.savedViewportPresentBefore + ":saved_after=" + action.savedViewportPresentAfter + ":viewport="
							+ action.appliedViewportText() + ":leave=" + action.leaveAlternateScreen + ":alt_scroll=" + action.disableAlternateScroll);
					}
				case TuiSmokeAltScreenActionKind.ClearForViewportChange:
					trace.push("tui.alt_screen.clear_for_viewport_change=" + "from=" + action.previousViewportText() + ":to=" + action.appliedViewportText()
						+ ":clear_after=" + action.clearAfterText());
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
		trace.push("tui.draw_composition.begin=" + plan.mode + ":height=" + plan.height + ":terminal=" + plan.terminalSizeText() + ":last="
			+ plan.lastSizeText() + ":sync_update=" + plan.syncUpdate + ":vt=" + plan.ensureVirtualTerminalProcessing + ":resume=" + plan.preparedResume);
		if (plan.mode == TuiSmokeDrawCompositionMode.Legacy) {
			trace.push("tui.draw_composition.pending_viewport=" + "computed=" + plan.pendingViewportComputed + ":cursor=" + plan.lastCursorY + "->"
				+ plan.cursorY + ":moved=" + plan.cursorMoved + ":area=" + plan.pendingViewportText() + ":clear=" + plan.terminalClear);
		} else if (plan.pendingViewportComputed) {
			trace.push("tui.draw_composition.pending_viewport=rejected_for_resize_reflow");
			return false;
		} else {
			trace.push("tui.draw_composition.pending_viewport=skipped:resize_reflow");
		}
		trace.push("tui.draw_composition.viewport=" + "from=" + plan.previousViewportText() + ":to=" + plan.appliedViewportText() + ":clear_before_set="
			+ plan.clearForViewportChange + ":scroll_up=" + plan.scrollRegionUp + ":region=" + plan.scrollRegionText() + ":rows=" + plan.scrollBy);
		trace.push("tui.draw_composition.history_flush=" + "batches=" + plan.pendingHistoryBatches + ":rows=" + plan.pendingHistoryRows + ":mode="
			+ plan.historyInsertMode() + ":wrap=" + plan.wrapPolicy);
		trace.push("tui.draw_composition.repaint=" + "needs_full=" + plan.needsFullRepaint + ":invalidate=" + plan.invalidateViewport);
		trace.push("tui.draw_composition.suspend_cursor=" + plan.suspendCursorY + ":alt=" + plan.altScreenActive);
		trace.push("tui.draw_composition.terminal_draw=" + "autoresize=" + plan.autoresize + ":render=" + plan.renderCallback + ":puts=" + plan.diffPutCount
			+ ":clears=" + plan.diffClearToEndCount + ":cursor=" + plan.cursorText() + ":swap=" + plan.swapBuffers + ":flush=" + plan.backendFlush);
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
					trace.push("tui.frame_scheduler.create=" + "spawn_task=" + action.spawnedTask + ":broadcast_capacity=" + action.broadcastCapacity);
				case TuiSmokeFrameSchedulerActionKind.RequestImmediate:
					trace.push("tui.frame_scheduler.request=immediate" + ":source=" + action.source + ":at=" + action.deadlineText(action.requestMs));
				case TuiSmokeFrameSchedulerActionKind.RequestDelayed:
					trace.push("tui.frame_scheduler.request=delayed" + ":source=" + action.source + ":delay=" + action.delayMs + "ms" + ":at="
						+ action.deadlineText(action.requestMs));
				case TuiSmokeFrameSchedulerActionKind.ClampDeadline:
					trace.push("tui.frame_scheduler.clamp=" + "last=" + action.deadlineText(action.lastEmittedMs) + ":min=" + action.minIntervalMs + "ms"
						+ ":requested=" + action.deadlineText(action.requestMs) + ":clamped=" + action.deadlineText(action.clampedDeadlineMs));
				case TuiSmokeFrameSchedulerActionKind.CoalesceDeadline:
					trace.push("tui.frame_scheduler.coalesce=" + "prev=" + action.previousDeadlineText() + ":request="
						+ action.deadlineText(action.requestMs) + ":next=" + action.nextDeadlineText() + ":requests=" + action.requestCount + ":coalesced="
						+ action.coalescedCount);
				case TuiSmokeFrameSchedulerActionKind.EmitDraw:
					trace.push("tui.frame_scheduler.emit=" + "deadline=" + action.nextDeadlineText() + ":draw=" + action.drawSent + ":emitted="
						+ action.emittedCount);
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
		trace.push("tui.draw_dispatch.event=" + plan.event + ":resize_reflow=" + plan.resizeReflowEnabled + ":pre_render=" + plan.preRender
			+ ":size_changed=" + plan.sizeChanged + ":status_refresh=" + plan.statusRefresh);
		trace.push("tui.draw_dispatch.reflow=" + "clear_pending_history=" + plan.clearPendingHistory + ":due=" + plan.reflowDue + ":ran=" + plan.reflowRan
			+ ":rearm=" + plan.rearmDelayMs + "ms");
		if (plan.overlayActive) {
			trace.push("tui.draw_dispatch.overlay=" + plan.renderMode + ":handled=" + plan.overlayHandled + ":draw=u16_max");
			return true;
		}
		trace.push("tui.draw_dispatch.pre_admission=" + "backtrack_pending=" + plan.backtrackRenderPending + ":backtrack_rebuilt=" + plan.backtrackRebuilt
			+ ":notification=" + plan.pendingNotification);
		trace.push("tui.draw_dispatch.paste_burst=" + "flushed=" + plan.pasteBurstFlushed + ":capturing=" + plan.pasteBurstCapturing + ":skip="
			+ plan.pasteBurstSkippedFrame + ":followup=" + plan.pasteBurstFollowupMs + "ms");
		if (plan.pasteBurstSkippedFrame) {
			trace.push("tui.draw_dispatch.render=skipped:continue");
			return true;
		}
		trace.push("tui.draw_dispatch.render=" + plan.renderMode + ":pre_draw_tick=" + plan.preDrawTick + ":desired_height=" + plan.desiredHeight + ":area="
			+ plan.renderedAreaText() + ":cursor=" + plan.cursorSet);
		trace.push("tui.draw_dispatch.post_draw=" + "ambient_pet=" + plan.ambientPetDraw + ":pet_preview=" + plan.petPreviewDraw + ":pet_clear="
			+ plan.petPreviewClear + ":external_editor=" + plan.externalEditorLaunch + ":followup_frame=" + plan.followUpFrame);
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
					trace.push("tui.overlay.open=transcript" + ":title=" + action.title + ":cells=" + action.committedCellsAfter + ":enter_alt="
						+ action.enterAltScreen + ":frame=" + action.frameScheduled);
				case TuiSmokeOverlayRoutingActionKind.OpenStatic:
					trace.push("tui.overlay.open=static" + ":title=" + action.title + ":lines=" + action.lineCount + ":enter_alt=" + action.enterAltScreen
						+ ":frame=" + action.frameScheduled);
				case TuiSmokeOverlayRoutingActionKind.InsertCommittedCell:
					trace.push("tui.overlay.transcript.insert_cell=" + "cells=" + action.cellTransitionText() + ":inserted=" + action.insertedCells
						+ ":pinned=" + action.pinnedTransitionText() + ":frame=" + action.frameScheduled);
				case TuiSmokeOverlayRoutingActionKind.ConsolidateCells:
					trace.push("tui.overlay.transcript.consolidate=" + "range=" + action.consolidateStart + ".." + action.consolidateEnd + ":cells="
						+ action.cellTransitionText() + ":pinned=" + action.pinnedTransitionText() + ":frame=" + action.frameScheduled);
				case TuiSmokeOverlayRoutingActionKind.SyncLiveTail:
					trace.push("tui.overlay.transcript.live_tail=" + "width=" + action.liveTailWidth + ":revision=" + action.liveTailRevision
						+ ":continuation=" + action.liveTailContinuation + ":tick=" + action.liveTailTickText() + ":key_changed=" + action.liveTailKeyChanged
						+ ":computed=" + action.liveTailComputed + ":lines=" + action.liveTailLines + ":pinned=" + action.pinnedTransitionText() + ":frame="
						+ action.frameScheduled);
				case TuiSmokeOverlayRoutingActionKind.Draw, TuiSmokeOverlayRoutingActionKind.Resize:
					trace.push("tui.overlay.draw=" + action.overlay + ":event=" + action.kind + ":height=" + action.drawHeightText() + ":area="
						+ action.renderedAreaText() + ":owns_terminal=" + action.ownsTerminal);
				case TuiSmokeOverlayRoutingActionKind.Key:
					trace.push("tui.overlay.key=" + action.overlay + ":action=" + action.keyAction + ":done=" + action.doneBefore + "->" + action.doneAfter
						+ ":scroll=" + action.scrollTransitionText() + ":backtrack=" + action.backtrackPreviewText() + ":frame=" + action.frameScheduled);
				case TuiSmokeOverlayRoutingActionKind.DoneCleanup:
					trace.push("tui.overlay.done=" + action.overlay + ":cleared=" + action.doneAfter + ":leave_alt=" + action.leaveAltScreen
						+ ":deferred_history=" + action.deferredHistoryLines + ":backtrack=" + action.backtrackPreviewText() + ":frame=" +
						action.frameScheduled);
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
					trace.push("tui.approval.pending.note=" + action.requestKind + ":request=" + action.requestId + ":approval=" + action.approvalId
						+ ":unsupported=" + action.unsupportedRejected);
				case TuiSmokeApprovalActionKind.ShowImmediate:
					trace.push("tui.approval.show=immediate" + ":request=" + action.requestKind + ":title=" + action.promptTitle + ":options="
						+ action.options + ":views=" + action.viewStackTransitionText() + ":pause_status=" + action.statusTimerPaused);
				case TuiSmokeApprovalActionKind.DelayRequest:
					trace.push("tui.approval.delay=" + action.requestKind + ":delayed=" + action.delayedTransitionText() + ":remaining=" + action.delayMs
						+ "ms" + ":frame=" + action.frameScheduled);
				case TuiSmokeApprovalActionKind.PromoteDelayed:
					trace.push("tui.approval.promote_delayed=" + "delayed=" + action.delayedTransitionText() + ":queue=" + action.queueTransitionText()
						+ ":views=" + action.viewStackTransitionText() + ":pause_status=" + action.statusTimerPaused);
				case TuiSmokeApprovalActionKind.EnqueueActive:
					trace.push("tui.approval.enqueue_active=" + action.requestKind + ":consumed=" + action.consumedByActiveView + ":queue="
						+ action.queueTransitionText() + ":frame=" + action.frameScheduled);
				case TuiSmokeApprovalActionKind.KeyDecision, TuiSmokeApprovalActionKind.ListDecision:
					trace.push("tui.approval.decision=" + action.kind + ":key=" + action.keyAction + ":index=" + action.selectedIndex + ":decision="
						+ action.decision + ":history=" + action.historyCellInserted + ":command=" + action.appCommandSent + ":complete="
						+ action.completeTransitionText());
				case TuiSmokeApprovalActionKind.Cancel:
					trace.push("tui.approval.cancel=" + action.requestKind + ":key=" + action.keyAction + ":decision=" + action.decision + ":command="
						+ action.appCommandSent + ":queue=" + action.queueTransitionText() + ":complete=" + action.completeTransitionText());
				case TuiSmokeApprovalActionKind.Resolve:
					trace.push("tui.approval.resolve=" + action.requestKind + ":request=" + action.requestId + ":approval=" + action.approvalId
						+ ":decision=" + action.decision + ":sent=" + action.resolutionSent);
				case TuiSmokeApprovalActionKind.DismissResolved:
					trace.push("tui.approval.dismiss_resolved=" + action.requestKind + ":request=" + action.requestId + ":matched="
						+ action.resolvedDismissed + ":stale=" + action.staleResolution + ":views=" + action.viewStackTransitionText() + ":resume_status="
						+ action.statusTimerResumed + ":frame=" + action.frameScheduled + ":command=" + action.appCommandSent);
				case TuiSmokeApprovalActionKind.UnsupportedReject:
					trace.push("tui.approval.unsupported=" + action.requestKind + ":request=" + action.requestId + ":rejected=" + action.unsupportedRejected
						+ ":failure=" + action.failureCode);
				case TuiSmokeApprovalActionKind.KeymapConflict:
					trace.push("tui.approval.keymap_conflict="
						+ action.conflictPrevious
						+ "->"
						+ action.conflictAction
						+ ":failure="
						+ action.failureCode);
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
					trace.push("tui.user_input.pending.note=" + action.requestKind + ":request=" + action.requestId + ":turn=" + action.turnId + ":item="
						+ action.itemId + ":questions=" + action.questionCount + ":secret_questions=" + action.secretQuestionCount + ":unsupported="
						+ action.unsupportedRejected);
				case TuiSmokeUserInputActionKind.ShowModal:
					trace.push("tui.user_input.show=modal" + ":request=" + action.requestKind + ":request_id=" + action.requestId + ":questions="
						+ action.questionCount + ":views=" + action.viewStackTransitionText() + ":pause_status=" + action.statusTimerPaused
						+ ":composer_disabled=" + action.composerDisabled + ":focus=" + action.focus);
				case TuiSmokeUserInputActionKind.EnqueueActive:
					trace.push("tui.user_input.enqueue_active=" + action.requestKind + ":request=" + action.requestId + ":queue="
						+ action.queueTransitionText() + ":frame=" + action.frameScheduled);
				case TuiSmokeUserInputActionKind.SelectOption:
					trace.push("tui.user_input.select_option=" + action.questionId + ":options=" + action.optionCount + ":selected="
						+ action.selectionTransitionText() + ":answered=" + action.answerTransitionText() + ":focus=" + action.focus);
				case TuiSmokeUserInputActionKind.OpenNotes:
					trace.push("tui.user_input.notes=open" + ":question=" + action.questionId + ":selected=" + action.selectedOptionAfter + ":visible="
						+ action.notesVisible + ":focus=" + action.focus);
				case TuiSmokeUserInputActionKind.DraftInput:
					trace.push("tui.user_input.draft=" + action.questionId + ":chars=" + action.draftTransitionText() + ":paste_burst="
						+ action.pendingPasteCount + ":answered=" + action.answerTransitionText());
				case TuiSmokeUserInputActionKind.MoveQuestion:
					trace.push("tui.user_input.move_question=" + action.questionTransitionText() + ":saved_draft_chars=" + action.draftCharsBefore
						+ ":restored_draft_chars=" + action.draftCharsAfter + ":focus=" + action.focus);
				case TuiSmokeUserInputActionKind.SubmitQuestion:
					trace.push("tui.user_input.submit=" + action.questionId + ":answers=" + action.answerCount + ":answered="
						+ action.answerTransitionText() + ":unanswered=" + action.unansweredTransitionText() + ":command=" + action.appCommandSent
						+ ":history=" + action.historyCellInserted + ":complete=" + action.completeTransitionText());
				case TuiSmokeUserInputActionKind.OpenUnansweredConfirmation:
					trace.push("tui.user_input.confirm_unanswered=open" + ":count=" + action.unansweredBefore + ":focus=" + action.focus + ":frame="
						+ action.frameScheduled);
				case TuiSmokeUserInputActionKind.ConfirmUnanswered:
					trace.push("tui.user_input.confirm_unanswered=choice" + ":unanswered=" + action.unansweredTransitionText() + ":answers="
						+ action.answerCount + ":command=" + action.appCommandSent + ":complete=" + action.completeTransitionText());
				case TuiSmokeUserInputActionKind.Cancel:
					trace.push("tui.user_input.cancel=" + action.requestKind + ":request=" + action.requestId + ":command=" + action.appCommandSent
						+ ":queue=" + action.queueTransitionText() + ":complete=" + action.completeTransitionText());
				case TuiSmokeUserInputActionKind.Resolve:
					trace.push("tui.user_input.resolve=" + action.requestKind + ":request=" + action.requestId + ":call=" + action.callId + ":answers="
						+ action.answerCount + ":sent=" + action.resolutionSent);
				case TuiSmokeUserInputActionKind.DismissResolved:
					trace.push("tui.user_input.dismiss_resolved=" + action.requestKind + ":request=" + action.requestId + ":matched="
						+ action.resolvedDismissed + ":stale=" + action.staleResolution + ":queue=" + action.queueTransitionText() + ":views="
						+ action.viewStackTransitionText() + ":resume_status=" + action.statusTimerResumed + ":frame=" + action.frameScheduled);
				case TuiSmokeUserInputActionKind.UnsupportedReject:
					trace.push("tui.user_input.unsupported=" + action.requestKind + ":request=" + action.requestId + ":rejected="
						+ action.unsupportedRejected + ":failure=" + action.failureCode);
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
					trace.push("tui.app_link.pending.note=" + action.suggestion + ":server=" + action.serverName + ":request=" + action.requestId
						+ ":thread=" + action.threadId + ":message_chars=" + action.messageChars);
				case TuiSmokeAppLinkActionKind.ParseUrl:
					trace.push("tui.app_link.parse_url=" + action.suggestion + ":scheme=" + action.urlScheme + ":host=" + action.urlHost + ":trusted="
						+ action.trustedUrl + ":chatgpt_required=" + action.requiresChatgptHost);
				case TuiSmokeAppLinkActionKind.ShowLink:
					trace.push("tui.app_link.show=" + action.suggestion + ":app=" + action.appId + ":title=" + action.title + ":actions="
						+ action.actionCount + ":views=" + action.viewStackTransitionText() + ":pause_status=" + action.statusTimerPaused
						+ ":composer_disabled=" + action.composerDisabled);
				case TuiSmokeAppLinkActionKind.MoveSelection:
					trace.push("tui.app_link.selection=" + action.suggestion + ":screen=" + action.screenBefore + ":selected="
						+ action.selectionTransitionText());
				case TuiSmokeAppLinkActionKind.OpenExternal:
					trace.push("tui.app_link.open_external=" + action.suggestion + ":screen=" + action.screenTransitionText() + ":browser="
						+ action.browserOpenSent + ":selected=" + action.selectionTransitionText());
				case TuiSmokeAppLinkActionKind.CompleteExternal:
					trace.push("tui.app_link.complete_external=" + action.suggestion + ":decision=" + action.decision + ":refresh="
						+ action.refreshConnectorsSent + ":command=" + action.appCommandSent + ":complete=" + action.completeTransitionText());
				case TuiSmokeAppLinkActionKind.ToggleEnabled:
					trace.push("tui.app_link.toggle_enabled=" + action.appId + ":enabled=" + action.enabledTransitionText() + ":event="
						+ action.setEnabledSent + ":decision=" + action.decision + ":command=" + action.appCommandSent);
				case TuiSmokeAppLinkActionKind.Decline:
					trace.push("tui.app_link.decline=" + action.suggestion + ":decision=" + action.decision + ":command=" + action.appCommandSent
						+ ":complete=" + action.completeTransitionText());
				case TuiSmokeAppLinkActionKind.Cancel:
					trace.push("tui.app_link.cancel=" + action.suggestion + ":decision=" + action.decision + ":command=" + action.appCommandSent
						+ ":complete=" + action.completeTransitionText());
				case TuiSmokeAppLinkActionKind.Resolve:
					trace.push("tui.app_link.resolve=" + action.suggestion + ":server=" + action.serverName + ":request=" + action.requestId + ":decision="
						+ action.decision + ":sent=" + action.resolutionSent);
				case TuiSmokeAppLinkActionKind.DismissResolved:
					trace.push("tui.app_link.dismiss_resolved=" + action.suggestion + ":server=" + action.serverName + ":request=" + action.requestId
						+ ":matched=" + action.resolvedDismissed + ":stale=" + action.staleResolution + ":views=" + action.viewStackTransitionText()
						+ ":resume_status=" + action.statusTimerResumed + ":frame=" + action.frameScheduled);
				case TuiSmokeAppLinkActionKind.UnsupportedReject:
					trace.push("tui.app_link.unsupported=" + action.suggestion + ":server=" + action.serverName + ":request=" + action.requestId
						+ ":rejected=" + action.unsupportedRejected + ":failure=" + action.failureCode);
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
					trace.push("tui.composer_popup_sync.sync=" + action.popupTransitionText() + ":input=" + action.inputText + ":popups="
						+ action.popupsEnabled + ":mentions_v2=" + action.mentionsV2Enabled);
				case TuiSmokeComposerPopupSyncActionKind.HistorySearchSuppress:
					trace.push("tui.composer_popup_sync.history_search=" + action.popupTransitionText() + ":active=" + action.historySearchActive
						+ ":file_query=" + action.currentFileQueryTransitionText() + ":clear_search=" + action.fileSearchCleared);
				case TuiSmokeComposerPopupSyncActionKind.PopupsDisabled:
					trace.push("tui.composer_popup_sync.disabled=" + action.popupTransitionText() + ":popups=" + action.popupsEnabled + ":cleared="
						+ action.popupCleared);
				case TuiSmokeComposerPopupSyncActionKind.HistoryNavigationSuppress:
					trace.push("tui.composer_popup_sync.history_nav=" + action.popupTransitionText() + ":browsing=" + action.browsingHistory
						+ ":file_query=" + action.currentFileQueryTransitionText() + ":clear_search=" + action.fileSearchCleared);
				case TuiSmokeComposerPopupSyncActionKind.CommandPopup:
					trace.push("tui.composer_popup_sync.command=" + action.query + ":allowed=" + action.commandAllowed + ":popup="
						+ action.popupTransitionText() + ":created=" + action.commandPopupCreated + ":updated=" + action.commandPopupUpdated + ":dismissed="
						+ action.commandPopupDismissed);
				case TuiSmokeComposerPopupSyncActionKind.FileSearchPopup:
					trace.push("tui.composer_popup_sync.file=" + action.query + ":token=" + action.token + ":popup=" + action.popupTransitionText()
						+ ":search=" + action.fileSearchStarted + ":current=" + action.currentFileQueryTransitionText() + ":live=" + !action.noLiveFileSearch);
				case TuiSmokeComposerPopupSyncActionKind.MentionPopup:
					trace.push("tui.composer_popup_sync.mention=" + action.query + ":popup=" + action.popupTransitionText() + ":candidates="
						+ action.candidateCount + ":skills=" + action.skillCandidateCount + ":plugins=" + action.pluginCandidateCount + ":apps="
						+ action.appCandidateCount);
				case TuiSmokeComposerPopupSyncActionKind.MentionsV2Popup:
					trace.push("tui.composer_popup_sync.mentions_v2=" + action.query + ":token=" + action.token + ":popup=" + action.popupTransitionText()
						+ ":search=" + action.fileSearchStarted + ":files=" + action.fileCandidateCount + ":catalog=" + action.candidateCount);
				case TuiSmokeComposerPopupSyncActionKind.ClearFileSearch:
					trace.push("tui.composer_popup_sync.clear_file_search=" + "current=" + action.currentFileQueryTransitionText() + ":sent="
						+ action.fileSearchCleared + ":popup=" + action.popupTransitionText());
				case TuiSmokeComposerPopupSyncActionKind.DismissedToken:
					trace.push("tui.composer_popup_sync.dismissed=" + action.token + ":file_match=" + action.dismissedFileTokenMatched + ":mention_match="
						+ action.dismissedMentionTokenMatched + ":popup=" + action.popupTransitionText());
				case TuiSmokeComposerPopupSyncActionKind.ClearInactivePopup:
					trace.push("tui.composer_popup_sync.clear_inactive=" + action.popupTransitionText() + ":file_token=" + action.fileTokenPresent
						+ ":mention_token=" + action.mentionTokenPresent + ":mentions_v2_token=" + action.mentionsV2TokenPresent);
				case TuiSmokeComposerPopupSyncActionKind.Failure:
					trace.push("tui.composer_popup_sync.failure=" + action.failureCode + ":unsupported=" + action.unsupportedRejected);
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
					trace.push("tui.composer_popup_render.layout=" + action.popup + ":width=" + action.width + ":composer=" + action.composerHeight
						+ ":popup=" + action.popupHeight + ":required=" + action.requiredHeight + ":footer=" + action.footerHeight + ":delegated="
						+ action.renderDelegated);
				case TuiSmokeComposerPopupRenderActionKind.RenderDispatch:
					trace.push("tui.composer_popup_render.dispatch=" + action.popup + ":delegated=" + action.renderDelegated + ":ratatui="
						+ !action.noRatatuiRender + ":terminal=" + !action.noLiveTerminal);
				case TuiSmokeComposerPopupRenderActionKind.RenderRows:
					trace.push("tui.composer_popup_render.rows=" + action.popup + ":rows=" + action.rowCount + ":visible=" + action.visibleRows + ":max="
						+ action.maxRows + ":selected=" + action.selectedIndex + ":scroll=" + action.scrollTop + ":window=" + action.windowText() + ":inset="
						+ action.insetText() + ":wrap=" + action.wrapsDescriptions);
				case TuiSmokeComposerPopupRenderActionKind.EmptyState:
					trace.push("tui.composer_popup_render.empty=" + action.popup + ":message=" + action.emptyMessage + ":waiting=" + action.waiting
						+ ":visible=" + action.visibleRows + ":no_live=" + action.noLiveTerminal);
				case TuiSmokeComposerPopupRenderActionKind.FooterHint:
					trace.push("tui.composer_popup_render.footer=" + action.popup + ":mode=" + action.searchMode + ":height=" + action.footerHeight
						+ ":rendered=" + action.footerHintRendered);
				case TuiSmokeComposerPopupRenderActionKind.ScrollWindow:
					trace.push("tui.composer_popup_render.scroll=" + action.popup + ":selected=" + action.selectedIndex + ":visible="
						+ action.selectedVisible + ":scroll=" + action.scrollTop + ":window=" + action.windowText());
				case TuiSmokeComposerPopupRenderActionKind.Failure:
					trace.push("tui.composer_popup_render.failure=" + action.failureCode + ":unsupported=" + action.unsupportedRejected);
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
					trace.push("tui.chat_widget_interrupt_quit.ctrl_c=" + action.route + ":double_press=" + action.doublePressEnabled + ":bottom_pane="
						+ action.bottomPaneHandled + ":task=" + action.taskRunning + ":work=" + action.cancellableWorkActive + ":shortcut="
						+ action.quitShortcutActiveBefore + "->" + action.quitShortcutActiveAfter + ":hint=" + action.quitShortcutHintShown + ":interrupt="
						+ action.interruptSubmitted + ":exit=" + action.appExitSent);
				case TuiSmokeChatWidgetInterruptQuitActionKind.CtrlD:
					trace.push("tui.chat_widget_interrupt_quit.ctrl_d=" + action.route + ":composer_empty=" + action.composerEmpty + ":modal="
						+ action.modalOrPopupActive + ":shortcut=" + action.quitShortcutActiveBefore + "->" + action.quitShortcutActiveAfter + ":matched="
						+ action.quitShortcutKeyMatched + ":exit=" + action.appExitSent);
				case TuiSmokeChatWidgetInterruptQuitActionKind.InterruptKey:
					trace.push("tui.chat_widget_interrupt_quit.interrupt_key=" + action.key + ":route=" + action.route + ":pending_steers="
						+ action.pendingSteersBefore + "->" + action.pendingSteersAfter + ":submit_after=" + action.submitPendingSteersAfterInterrupt
						+ ":review=" + action.reviewMode + ":task=" + action.taskRunning + ":submitted=" + action.interruptSubmitted);
				case TuiSmokeChatWidgetInterruptQuitActionKind.ArmQuitShortcut:
					trace.push("tui.chat_widget_interrupt_quit.arm_shortcut=" + action.key + ":active=" + action.quitShortcutActiveBefore + "->"
						+ action.quitShortcutActiveAfter + ":hint=" + action.quitShortcutHintShown + ":expired=" + action.quitShortcutExpired + ":redraw="
						+ action.requestRedraw);
				case TuiSmokeChatWidgetInterruptQuitActionKind.RequestQuit:
					trace.push("tui.chat_widget_interrupt_quit.request_quit=" + action.exitMode + ":shortcut=" + action.quitShortcutActiveBefore + "->"
						+ action.quitShortcutActiveAfter + ":cleared=" + action.quitShortcutHintCleared + ":app_exit=" + action.appExitSent);
				case TuiSmokeChatWidgetInterruptQuitActionKind.ShutdownFeedback:
					trace.push("tui.chat_widget_interrupt_quit.shutdown_feedback=" + action.exitMode + ":shown=" + action.shutdownFeedbackShown
						+ ":input_disabled=" + action.inputDisabled + ":server_shutdown=" + action.appServerShutdownRequested + ":pending_thread="
						+ action.pendingShutdownThreadBefore + "->" + action.pendingShutdownThreadAfter);
				case TuiSmokeChatWidgetInterruptQuitActionKind.PrepareInterruptSubmission:
					trace.push("tui.chat_widget_interrupt_quit.prepare_interrupt=" + "restore_prompt=" + action.interruptRestoresPrompt + ":cancel_edit="
						+ action.cancelEditArmedBefore + "->" + action.cancelEditArmedAfter + ":stream_queue=" + action.streamQueueCleared + ":plan_queue="
						+ action.planStreamQueueCleared + ":tail=" + action.activeTailCleared + ":redraw=" + action.requestRedraw);
				case TuiSmokeChatWidgetInterruptQuitActionKind.CancelEditCleanup:
					trace.push("tui.chat_widget_interrupt_quit.cancel_edit=" + "cleared=" + action.cancelEditCleared + ":pending_steers="
						+ action.pendingSteersBefore + "->" + action.pendingSteersAfter + ":redraw=" + action.requestRedraw);
				case TuiSmokeChatWidgetInterruptQuitActionKind.Failure:
					trace.push("tui.chat_widget_interrupt_quit.failure=" + action.failureCode + ":unsupported=" + action.unsupportedRejected);
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
					trace.push("tui.clear_archive.clear_terminal=" + action.mode + ":backend=" + action.clearBackend + ":pending="
						+ action.pendingHistoryBefore + "->" + action.pendingHistoryAfter + ":header=" + action.headerQueued);
				case TuiSmokeClearArchiveActionKind.ResetUiState:
					trace.push("tui.clear_archive.reset_ui=" + "transcript=" + action.transcriptCellsBefore + "->" + action.transcriptCellsAfter
						+ ":deferred=" + action.deferredHistoryBefore + "->" + action.deferredHistoryAfter + ":overlay=" + action.overlayCleared
						+ ":backtrack=" + action.backtrackCleared + ":reflow=" + action.reflowCleared + ":replay=" + action.replayBufferCleared
						+ ":skill_warnings=" + action.skillWarningsBefore + "->" + action.skillWarningsAfter + ":session=" + action.sessionPreserved
						+ ":composer=" + action.composerPreserved);
				case TuiSmokeClearArchiveActionKind.QueueClearHeader:
					trace.push("tui.clear_archive.header=" + "queued=" + action.headerQueued + ":frame=" + action.frameScheduled + ":redraw="
						+ action.requestRedraw);
				case TuiSmokeClearArchiveActionKind.StartFreshSession:
					trace.push("tui.clear_archive.start_fresh=" + "source=" + action.sessionStartSource + ":started=" + action.freshSessionStarted
						+ ":initial=" + action.initialUserMessageSubmitted + ":text=" + action.userMessageText);
				case TuiSmokeClearArchiveActionKind.SkillWarnings:
					trace.push("tui.clear_archive.skill_warnings=" + "active=" + action.activeSkillWarningsBefore + "->" + action.activeSkillWarningsAfter
						+ ":cached=" + action.skillWarningsBefore + "->" + action.skillWarningsAfter);
				case TuiSmokeClearArchiveActionKind.ArchiveRequest:
					trace.push("tui.clear_archive.archive_request=" + "thread=" + action.threadId + ":active=" + action.activeThreadBefore + ":side="
						+ action.sideConversationActive + ":requested=" + action.archiveRequested + ":error=" + action.errorInserted);
				case TuiSmokeClearArchiveActionKind.ArchiveResult:
					trace.push("tui.clear_archive.archive_result=" + "thread=" + action.threadId + ":success=" + action.archiveSucceeded + ":exit="
						+ action.exitRequested + ":reason=" + action.exitReason);
				case TuiSmokeClearArchiveActionKind.ArchivedGuidance:
					trace.push("tui.clear_archive.archived_guidance=" + "action=" + action.mode + ":thread=" + action.threadId + ":path="
						+ action.archivedSessionPath + ":command=" + action.unarchiveCommand + ":error=" + action.errorInserted);
				case TuiSmokeClearArchiveActionKind.UnarchiveCommand:
					trace.push("tui.clear_archive.unarchive_command=" + "thread=" + action.threadId + ":requested=" + action.unarchiveRequested
						+ ":success=" + action.unarchiveSucceeded + ":exit=" + action.exitRequested);
				case TuiSmokeClearArchiveActionKind.ShutdownFeedback:
					trace.push("tui.clear_archive.shutdown_feedback=" + "mode=" + action.exitMode + ":shown=" + action.shutdownFeedbackShown
						+ ":input_disabled=" + action.inputDisabled + ":server_shutdown=" + action.appServerShutdownRequested + ":pending_thread="
						+ action.pendingShutdownThreadBefore + "->" + action.pendingShutdownThreadAfter);
				case TuiSmokeClearArchiveActionKind.Failure:
					trace.push("tui.clear_archive.failure=" + action.failureCode + ":error=" + action.errorMessage + ":no_live=" + action.noLiveTerminal
						+ ":no_render=" + action.noRatatuiRender + ":no_model=" + action.noModelCall + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.clear_archive.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceSessionArchiveCommand(plan:TuiSmokeSessionArchiveCommandPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveTerminal || plan.allowModelCall || plan.allowAppServerMutation || plan.allowFilesystemMutation || !plan.enabled()) {
			trace.push("tui.session_archive_command.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.session_archive_command.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeSessionArchiveCommandActionKind.ResolveUuid:
					trace.push("tui.session_archive_command.resolve_uuid=" + "action=" + action.action + ":target=" + action.target + ":parsed="
						+ action.uuidParsed + ":thread=" + action.threadId + ":lookup=" + action.lookupRequested);
				case TuiSmokeSessionArchiveCommandActionKind.LookupPage:
					trace.push("tui.session_archive_command.lookup_page=" + "action=" + action.action + ":scope=" + action.searchScope + ":archived="
						+ action.archivedScope + ":include_non_interactive=" + action.includeNonInteractive + ":target=" + action.target + ":cursor="
						+ action.cursor + ":next=" + action.nextCursor + ":rows=" + action.rowCount + ":limit=" + action.pageSize);
				case TuiSmokeSessionArchiveCommandActionKind.ResolveName:
					trace.push("tui.session_archive_command.resolve_name=" + "action=" + action.action + ":target=" + action.target + ":scope="
						+ action.searchScope + ":matched=" + action.exactNameMatched + ":resolved=" + action.resolved + ":thread=" + action.threadId
						+ ":name=" + action.threadName);
				case TuiSmokeSessionArchiveCommandActionKind.ThreadListRequest:
					trace.push("tui.session_archive_command.thread_list_request=" + "id=" + action.requestId + ":method=" + action.method + ":action="
						+ action.action + ":scope=" + action.searchScope + ":archived=" + action.archivedScope + ":include_non_interactive="
						+ action.includeNonInteractive + ":cursor=" + action.cursor + ":limit=" + action.pageSize + ":sort=" + action.sortKey + ":direction="
						+ action.sortDirection + ":state_db_only=" + action.useStateDbOnly + ":search=" + action.target);
				case TuiSmokeSessionArchiveCommandActionKind.ThreadListResponse:
					trace.push("tui.session_archive_command.thread_list_response=" + "id=" + action.requestId + ":method=" + action.method + ":rows="
						+ action.rowCount + ":next=" + action.nextCursor + ":backwards=" + action.backwardsCursor);
				case TuiSmokeSessionArchiveCommandActionKind.ThreadListRow:
					trace.push("tui.session_archive_command.thread_list_row=" + "id=" + action.requestId + ":idx=" + action.rowIndex + ":thread="
						+ action.threadId + ":name=" + action.threadName + ":display=" + action.displayPreview + ":source=" + action.sourceKind + ":cwd="
						+ action.cwd + ":path=" + action.path + ":branch=" + action.gitBranch + ":created=" + action.createdAt + ":updated="
						+ action.updatedAt + ":archived_match=" + action.archivedMatchesFilter + ":accepted=" + action.rowAccepted);
				case TuiSmokeSessionArchiveCommandActionKind.ThreadListRowRejected:
					trace.push("tui.session_archive_command.thread_list_row_rejected=" + "id=" + action.requestId + ":idx=" + action.rowIndex + ":thread="
						+ action.threadId + ":reason=" + action.errorMessage + ":valid_thread=" + action.validThreadId + ":accepted=" + action.rowAccepted);
				case TuiSmokeSessionArchiveCommandActionKind.RpcRequest:
					trace.push("tui.session_archive_command.rpc_request=" + "id=" + action.requestId + ":method=" + action.method + ":action="
						+ action.action + ":thread=" + action.threadId + ":valid=" + action.validThreadId + ":archive=" + action.archiveRequested
						+ ":unarchive=" + action.unarchiveRequested);
				case TuiSmokeSessionArchiveCommandActionKind.RpcResponse:
					trace.push("tui.session_archive_command.rpc_response=" + "id=" + action.requestId + ":method=" + action.method + ":empty="
						+ action.responseEmpty + ":thread=" + action.responseThreadId + ":name=" + action.responseThreadName + ":has_thread="
						+ action.responseHasThread + ":success=" + action.mutationSucceeded);
				case TuiSmokeSessionArchiveCommandActionKind.CommandResult:
					trace.push("tui.session_archive_command.result=" + "action=" + action.action + ":thread=" + action.threadId + ":name="
						+ action.threadName + ":archive=" + action.archiveRequested + ":unarchive=" + action.unarchiveRequested + ":success="
						+ action.mutationSucceeded + ":message=" + action.successMessage);
				case TuiSmokeSessionArchiveCommandActionKind.Failure:
					trace.push("tui.session_archive_command.failure=" + action.failureCode + ":error=" + action.errorMessage + ":no_live="
						+ action.noLiveTerminal + ":no_model=" + action.noModelCall + ":no_app_server=" + action.noAppServerMutation + ":no_fs="
						+ action.noFilesystemMutation + ":wrapped=" + action.errorWrapped + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.session_archive_command.unknown");
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
						trace.push("tui.terminal_palette.osc_color_mismatch=" + action.color + ":computed=" + action.computedColor());
						return false;
					}
					trace.push("tui.terminal_palette.osc_color=" + "slot=" + action.slot + ":color=" + action.computedColor());
				case TuiSmokeTerminalPaletteActionKind.ParseRgb:
					if (!action.rgbMatches()) {
						trace.push("tui.terminal_palette.rgb_mismatch=" + action.color + ":computed=" + action.computedRgb());
						return false;
					}
					trace.push("tui.terminal_palette.rgb=" + "payload=" + action.payload + ":color=" + action.computedRgb());
				case TuiSmokeTerminalPaletteActionKind.ParseDefaultColors:
					if (!action.defaultColorsMatch()) {
						trace.push("tui.terminal_palette.default_mismatch=" + action.foreground + "/" + action.background + ":computed="
							+ action.computedForeground() + "/" + action.computedBackground());
						return false;
					}
					trace.push("tui.terminal_palette.default_colors=" + "fg=" + action.computedForeground() + ":bg=" + action.computedBackground()
						+ ":valid=" + action.valid);
				case TuiSmokeTerminalPaletteActionKind.Cache:
					trace.push("tui.terminal_palette.cache=" + "startup_attempted=" + action.startupAttempted + ":startup=" + action.startupValue
						+ ":requery=" + action.requeryRequested + ":result=" + action.cacheResult() + ":skip_unavailable=" + action.skippedBecauseUnavailable);
				case TuiSmokeTerminalPaletteActionKind.Failure:
					trace.push("tui.terminal_palette.failure=" + action.failureCode + ":live=" + action.liveQueryAllowed);
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
						trace.push("tui.terminal_startup_probe.batch_mismatch=" + "cursor=" + action.parsedCursor() + ":fg=" + action.computedForeground()
							+ ":bg=" + action.computedBackground() + ":keyboard=" + action.parsedKeyboardSupported());
						return false;
					}
					trace.push("tui.terminal_startup_probe.batch=" + "cursor=" + action.parsedCursor() + ":fg=" + action.computedForeground() + ":bg="
						+ action.computedBackground() + ":keyboard=" + action.parsedKeyboardSupported() + ":complete=" + action.complete);
				case TuiSmokeTerminalStartupProbeActionKind.KeyboardSupport:
					if (!action.keyboardMatches()) {
						trace.push("tui.terminal_startup_probe.keyboard_mismatch=" + "supported=" + action.parsedKeyboardSupported() + ":fallback="
							+ action.parsedFallbackSeen());
						return false;
					}
					trace.push("tui.terminal_startup_probe.keyboard=" + "supported=" + action.keyboardSupported + ":fallback=" + action.fallbackSeen);
				case TuiSmokeTerminalStartupProbeActionKind.HandleSource:
					trace.push("tui.terminal_startup_probe.handle=" + action.handleSource + ":stdio=" + action.duplicatedStdio + ":tty_fallback="
						+ action.controllingTerminalFallback + ":flags_restored=" + action.originalFlagsRestored);
				case TuiSmokeTerminalStartupProbeActionKind.TimeoutFallback:
					trace.push("tui.terminal_startup_probe.timeout=" + "ms=" + action.timeoutMs + ":cursor=" + action.parsedCursor() + ":colors_complete="
						+ action.defaultColorsComplete() + ":keyboard=" + action.parsedKeyboardSupported());
				case TuiSmokeTerminalStartupProbeActionKind.Failure:
					trace.push("tui.terminal_startup_probe.failure=" + action.failureCode + ":live=" + action.liveProbeAllowed);
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
					trace.push("tui.clipboard_copy.route=" + action.routedBackend() + ":ssh=" + action.sshSession + ":wsl=" + action.wslSession + ":tmux="
						+ action.tmuxSession + ":lease=" + action.nativeLease);
				case TuiSmokeClipboardCopyActionKind.Osc52Sequence:
					if (!action.rawByteCountMatches() || !action.osc52Matches()) {
						trace.push("tui.clipboard_copy.osc52_mismatch=" + "bytes=" + action.text.length + ":sequence=" + action.computedOsc52Sequence());
						return false;
					}
					trace.push("tui.clipboard_copy.osc52="
						+ "bytes="
						+ action.text.length
						+ ":tmux="
						+ action.tmuxSession
						+ ":wrapped="
						+ (action.tmuxSession && action.computedOsc52Sequence().length > 0));
				case TuiSmokeClipboardCopyActionKind.TmuxReady:
					if (!action.tmuxReadyMatches()) {
						trace.push("tui.clipboard_copy.tmux_ready_mismatch=" + action.computedTmuxReady() + ":expected=" + action.expectedReady);
						return false;
					}
					trace.push("tui.clipboard_copy.tmux_ready=" + action.computedTmuxReady() + ":set_clipboard=" + StringTools.trim(action.tmuxSetClipboard)
						+ ":missing_ms=" + (action.tmuxInfo.indexOf("Ms: [missing]") >= 0));
				case TuiSmokeClipboardCopyActionKind.Failure:
					trace.push("tui.clipboard_copy.failure=" + action.failureCode + ":clipboard=" + action.liveClipboardAllowed + ":terminal="
						+ action.liveTerminalWriteAllowed + ":process=" + action.processSpawnAllowed);
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
					trace.push("tui.clipboard_paste.probe=" + action.computedDecision() + ":wsl=" + action.wslSession + ":native_clipboard="
						+ action.nativeClipboardAvailable + ":native_file=" + action.nativeFileAvailable + ":native_image=" + action.nativeImageAvailable
						+ ":wsl_attempt=" + action.wslFallbackAttempted);
				case TuiSmokeClipboardPasteActionKind.ImageAccept:
					if (!action.placeholderMatches() || !action.localImageCountMatches()) {
						trace.push("tui.clipboard_paste.image_mismatch=placeholder=" + action.computedPlaceholder() + ":local_after="
							+ action.localImageCountAfter);
						return false;
					}
					trace.push("tui.clipboard_paste.image=" + action.computedDecision() + ":placeholder=" + action.computedPlaceholder() + ":path="
						+ action.tempPath + ":format=" + action.formatLabel() + ":dimensions=" + action.width + "x" + action.height + ":bytes="
						+ action.imageBytes + ":local=" + action.localImageCountBefore + "->" + action.localImageCountAfter);
				case TuiSmokeClipboardPasteActionKind.WslPath:
					if (!action.wslPathMatches()) {
						trace.push("tui.clipboard_paste.wsl_path_mismatch=" + action.computedWslPath() + ":expected=" + action.wslPath);
						return false;
					}
					trace.push("tui.clipboard_paste.wsl_path=" + action.windowsPath + "->" + action.computedWslPath());
				case TuiSmokeClipboardPasteActionKind.Refusal:
					trace.push("tui.clipboard_paste.refusal=" + action.computedDecision() + ":source=" + action.source + ":bytes=" + action.imageBytes
						+ ":max=" + action.maxImageBytes);
				case TuiSmokeClipboardPasteActionKind.Failure:
					trace.push("tui.clipboard_paste.failure=" + action.failureCode + ":clipboard=" + action.liveClipboardAllowed + ":process="
						+ action.processSpawnAllowed + ":filesystem=" + action.filesystemMutationAllowed);
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
					trace.push("tui.terminal_hyperlink.destination=" + "safe=" + action.safeDestination + ":valid=" + action.validWebDestination);
				case TuiSmokeTerminalHyperlinkActionKind.Discover:
					if (!action.columnsMatch()) {
						trace.push("tui.terminal_hyperlink.columns_mismatch=" + action.startColumn + ".." + action.endColumn + ":computed="
							+ action.computedStartColumn() + ".." + action.computedEndColumn());
						return false;
					}
					trace.push("tui.terminal_hyperlink.discover=" + "columns=" + action.startColumn + ".." + action.endColumn + ":destination="
						+ action.discoveredDestination());
				case TuiSmokeTerminalHyperlinkActionKind.Decorate:
					if (!action.decoratedMatches() || !action.osc8PairCountMatches()) {
						trace.push("tui.terminal_hyperlink.decorate_mismatch");
						return false;
					}
					trace.push("tui.terminal_hyperlink.decorate=" + "valid=" + action.validWebDestination + ":pairs=" + action.computedOsc8PairCount()
						+ ":visible=" + action.text + ":live=" + action.liveWriteAllowed);
				case TuiSmokeTerminalHyperlinkActionKind.Strip:
					if (!action.strippedMatches()) {
						trace.push("tui.terminal_hyperlink.strip_mismatch");
						return false;
					}
					trace.push("tui.terminal_hyperlink.strip="
						+ "pairs="
						+ action.computedOsc8PairCount()
						+ ":visible="
						+ action.computedStrippedText());
				case TuiSmokeTerminalHyperlinkActionKind.PrefixRemap:
					if (!action.shiftedColumnsMatch()) {
						trace.push("tui.terminal_hyperlink.prefix_mismatch");
						return false;
					}
					trace.push("tui.terminal_hyperlink.prefix_remap=" + "prefix=" + action.prefixWidth + ":columns=" + action.startColumn + ".."
						+ action.endColumn + "->" + action.shiftedStartColumn + ".." + action.shiftedEndColumn);
				case TuiSmokeTerminalHyperlinkActionKind.Failure:
					trace.push("tui.terminal_hyperlink.failure=" + action.failureCode + ":live=" + action.liveWriteAllowed);
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
				trace.push("tui.desktop_notification.backend_mismatch=" + action.backend + ":computed=" + action.computedBackend());
				return false;
			}
			if (!action.shouldEmitMatches()) {
				trace.push("tui.desktop_notification.emit_mismatch=" + action.shouldEmit + ":computed=" + action.computedShouldEmit());
				return false;
			}
			if (!action.escapedMessageMatches()) {
				trace.push("tui.desktop_notification.escape_mismatch=" + "expected_esc=" + action.messageEscapeCount() + ":computed_esc="
					+ action.escapedMessageEscapeCount());
				return false;
			}
			switch action.kind {
				case TuiSmokeDesktopNotificationActionKind.DetectBackend:
					trace.push("tui.desktop_notification.detect_backend=" + "method=" + action.method + ":terminal=" + action.terminalName + ":mux="
						+ action.multiplexer + ":backend=" + action.backendTraceName());
				case TuiSmokeDesktopNotificationActionKind.FocusDecision:
					trace.push("tui.desktop_notification.focus_decision=" + "condition=" + action.condition + ":focused=" + action.terminalFocused
						+ ":emit=" + action.shouldEmit);
				case TuiSmokeDesktopNotificationActionKind.Notify:
					trace.push("tui.desktop_notification.notify=" + "method=" + action.method + ":backend=" + action.backendTraceName() + ":condition="
						+ action.condition + ":focused=" + action.terminalFocused + ":emit=" + action.emitted + ":message_chars=" + action.message.length
						+ ":dcs=" + action.dcsPassthrough + ":esc=" + action.messageEscapeCount() + "->" + action.escapedMessageEscapeCount() + ":live="
						+ action.liveWriteAllowed);
				case TuiSmokeDesktopNotificationActionKind.Failure:
					trace.push("tui.desktop_notification.failure=" + action.failureCode + ":live=" + action.liveWriteAllowed + ":disabled="
						+ action.disabledAfterFailure);
				case _:
					trace.push("tui.desktop_notification.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceDesktopThread(plan:TuiSmokeDesktopThreadPlan, trace:Array<String>):Bool {
		if (plan == null || !plan.enabled()) {
			trace.push("tui.desktop_thread.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.desktop_thread.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeDesktopThreadActionKind.Opened:
					trace.push("tui.desktop_thread.opened=thread=" + action.threadId + ":url=" + action.url + ":opened=" + action.opened + ":info="
						+ action.infoInserted + ":message=" + action.message + ":live=" + !action.noLiveDesktopLaunch);
				case TuiSmokeDesktopThreadActionKind.OpenFailed:
					trace.push("tui.desktop_thread.open_failed=thread=" + action.threadId + ":url=" + action.url + ":error=" + action.errorMessage
						+ ":inserted=" + action.errorInserted + ":message=" + action.message + ":live=" + !action.noLiveDesktopLaunch);
				case TuiSmokeDesktopThreadActionKind.Failure:
					trace.push("tui.desktop_thread.failure=" + action.errorMessage + ":no_live=" + action.noLiveDesktopLaunch + ":no_model="
						+ action.noModelCall + ":no_app_server=" + action.noAppServerMutation + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.desktop_thread.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceBrowserOpen(plan:TuiSmokeBrowserOpenPlan, trace:Array<String>):Bool {
		if (plan == null || !plan.enabled()) {
			trace.push("tui.browser_open.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.browser_open.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeBrowserOpenActionKind.Opened:
					trace.push("tui.browser_open.opened=url=" + action.url + ":opened=" + action.opened + ":info=" + action.infoInserted + ":message="
						+ action.message + ":live=" + !action.noLiveBrowserLaunch);
				case TuiSmokeBrowserOpenActionKind.OpenFailed:
					trace.push("tui.browser_open.open_failed=url=" + action.url + ":error=" + action.errorMessage + ":inserted=" + action.errorInserted
						+ ":message=" + action.message + ":live=" + !action.noLiveBrowserLaunch);
				case TuiSmokeBrowserOpenActionKind.Failure:
					trace.push("tui.browser_open.failure=" + action.errorMessage + ":no_live=" + action.noLiveBrowserLaunch + ":no_model="
						+ action.noModelCall + ":no_app_server=" + action.noAppServerMutation + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.browser_open.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceTerminalVisualization(plan:TuiSmokeTerminalVisualizationPlan, trace:Array<String>):Bool {
		if (plan == null || !plan.enabled()) {
			trace.push("tui.terminal_visualization.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.terminal_visualization.plan=headless");
		for (action in plan.actions) {
			if (!action.instructionsMatch()) {
				trace.push("tui.terminal_visualization.mismatch=expected:" + action.expectedInstructions.length + ":computed:"
					+ action.computedInstructions().length);
				return false;
			}
			switch action.kind {
				case TuiSmokeTerminalVisualizationActionKind.Merge:
					trace.push("tui.terminal_visualization.merge=feature=" + action.featureEnabled + ":control=" + action.usedControl
						+ ":developer_fallback=" + action.usedDeveloperFallback + ":appended=" + action.appendedTerminalInstructions + ":empty="
						+ action.generatedFromEmpty + ":chars=" + action.computedInstructions().length);
				case TuiSmokeTerminalVisualizationActionKind.Failure:
					trace.push("tui.terminal_visualization.failure=" + action.failureCode + ":no_model=" + action.noModelCall + ":no_app_server="
						+ action.noAppServerMutation + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.terminal_visualization.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceAgentStatus(plan:TuiSmokeAgentStatusPlan, trace:Array<String>):Bool {
		if (plan == null || !plan.enabled()) {
			trace.push("tui.agent_status.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.agent_status.plan=headless");
		for (action in plan.actions) {
			if (!action.displayMatches()) {
				trace.push("tui.agent_status.mismatch=id="
					+ action.itemId
					+ ":expected="
					+ action.displayText
					+ ":computed="
					+ action.computedDisplayText());
				return false;
			}
			switch action.kind {
				case TuiSmokeAgentStatusActionKind.Empty:
					trace.push("tui.agent_status.empty=rendered=" + action.emptyState + ":message=No sub-agents running.");
				case TuiSmokeAgentStatusActionKind.Item:
					trace.push("tui.agent_status.item=" + action.itemKind + ":id=" + action.itemId + ":accepted=" + action.accepted + ":duplicate="
						+ action.duplicate + ":display=" + action.computedDisplayText() + ":raw_reasoning_hidden=" + action.rawReasoningHidden
						+ ":aggregated_output_hidden=" + action.aggregatedOutputHidden + ":collapsed=" + action.whitespaceCollapsed);
				case TuiSmokeAgentStatusActionKind.Thread:
					trace.push("tui.agent_status.thread=" + action.agentPath + ":items=" + action.previewItemCount + ":lines=" + action.previewLineCount
						+ ":max_lines=" + action.maxPreviewLines + ":max_items=" + action.maxPreviewItems);
				case TuiSmokeAgentStatusActionKind.Failure:
					trace.push("tui.agent_status.failure=" + action.failureCode + ":no_model=" + action.noModelCall + ":no_app_server="
						+ action.noAppServerMutation + ":no_fs=" + action.noFilesystemMutation + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.agent_status.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceAgentNavigation(plan:TuiSmokeAgentNavigationPlan, trace:Array<String>):Bool {
		if (plan == null || !plan.enabled()) {
			trace.push("tui.agent_navigation.rejected=live_or_missing");
			return false;
		}
		final state = new TuiSmokeAgentNavigationState();
		trace.push("tui.agent_navigation.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeAgentNavigationActionKind.Upsert:
					state.upsert(action.threadId, action.agentNickname, action.agentRole, action.isClosed);
					trace.push("tui.agent_navigation.upsert=" + action.threadId + ":closed=" + action.isClosed + ":order=" + state.orderedThreadIds()
						.join("|"));
				case TuiSmokeAgentNavigationActionKind.RecordActivity:
					state.recordActivity(action.threadId, action.agentPath, action.isRunning);
					trace.push("tui.agent_navigation.activity=" + action.threadId + ":path=" + action.agentPath + ":running=" + action.isRunning);
				case TuiSmokeAgentNavigationActionKind.SetRunning:
					state.setRunning(action.threadId, action.isRunning);
					trace.push("tui.agent_navigation.running=" + action.threadId + ":running=" + action.isRunning);
				case TuiSmokeAgentNavigationActionKind.SetAgentPath:
					state.setAgentPath(action.threadId, action.agentPath);
					trace.push("tui.agent_navigation.path=" + action.threadId + ":path=" + action.agentPath);
				case TuiSmokeAgentNavigationActionKind.MarkClosed:
					state.markClosed(action.threadId);
					trace.push("tui.agent_navigation.closed=" + action.threadId + ":order=" + state.orderedThreadIds().join("|"));
				case TuiSmokeAgentNavigationActionKind.Remove:
					state.remove(action.threadId);
					trace.push("tui.agent_navigation.remove=" + action.threadId + ":order=" + state.orderedThreadIds().join("|"));
				case TuiSmokeAgentNavigationActionKind.Clear:
					state.clear();
					trace.push("tui.agent_navigation.clear=order=" + state.orderedThreadIds().join("|"));
				case TuiSmokeAgentNavigationActionKind.Ordered:
					final actual = state.orderedThreadIds();
					if (!stringArraysEqual(actual, action.expectedOrder)) {
						trace.push("tui.agent_navigation.order_mismatch=expected:" + action.expectedOrder.join("|") + ":actual:" + actual.join("|"));
						return false;
					}
					trace.push("tui.agent_navigation.order=" + actual.join("|"));
				case TuiSmokeAgentNavigationActionKind.Adjacent:
					final actual = state.adjacentThreadId(action.currentThreadId, action.direction);
					if (actual != action.expectedThreadId) {
						trace.push("tui.agent_navigation.adjacent_mismatch=expected:" + action.expectedThreadId + ":actual:" + actual);
						return false;
					}
					trace.push("tui.agent_navigation.adjacent=" + action.currentThreadId + ":" + action.direction + "=>" + actual);
				case TuiSmokeAgentNavigationActionKind.ActiveLabel:
					final actual = state.activeAgentLabel(action.currentThreadId, action.primaryThreadId);
					if (actual != action.expectedLabel) {
						trace.push("tui.agent_navigation.label_mismatch=expected:" + action.expectedLabel + ":actual:" + actual);
						return false;
					}
					trace.push("tui.agent_navigation.label=" + action.currentThreadId + ":primary=" + action.primaryThreadId + ":label=" + actual);
				case TuiSmokeAgentNavigationActionKind.HasNonPrimary:
					final actual = state.hasNonPrimaryThread(action.primaryThreadId);
					if (actual != action.expectedHasNonPrimary) {
						trace.push("tui.agent_navigation.non_primary_mismatch=expected:" + action.expectedHasNonPrimary + ":actual:" + actual);
						return false;
					}
					trace.push("tui.agent_navigation.non_primary=" + actual + ":primary=" + action.primaryThreadId);
				case TuiSmokeAgentNavigationActionKind.Subtitle:
					final actual = TuiSmokeAgentNavigationState.pickerSubtitle();
					if (actual != action.expectedSubtitle) {
						trace.push("tui.agent_navigation.subtitle_mismatch=expected:" + action.expectedSubtitle + ":actual:" + actual);
						return false;
					}
					trace.push("tui.agent_navigation.subtitle=" + actual);
				case TuiSmokeAgentNavigationActionKind.Failure:
					trace.push("tui.agent_navigation.failure=" + action.failureCode + ":no_model=" + action.noModelCall + ":no_app_server="
						+ action.noAppServerMutation + ":no_fs=" + action.noFilesystemMutation + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.agent_navigation.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceLoadedThreads(plan:TuiSmokeLoadedThreadsPlan, trace:Array<String>):Bool {
		if (plan == null || !plan.enabled()) {
			trace.push("tui.loaded_threads.rejected=live_or_missing");
			return false;
		}
		final discovered = plan.discovered();
		if (!plan.expectedMatches(discovered)) {
			trace.push("tui.loaded_threads.mismatch=expected:" + plan.summary(plan.expected) + ":actual:" + plan.summary(discovered));
			return false;
		}
		final invalidSkipped = plan.invalidSkipped();
		final unrelatedSkipped = plan.unrelatedSkipped(discovered);
		final nonSpawnSkipped = plan.nonSpawnSkipped();
		if (invalidSkipped != plan.expectedInvalidSkipped
			|| unrelatedSkipped != plan.expectedUnrelatedSkipped
			|| nonSpawnSkipped != plan.expectedNonSpawnSkipped) {
			trace.push("tui.loaded_threads.skip_mismatch=invalid:"
				+ invalidSkipped
				+ ":unrelated:"
				+ unrelatedSkipped
				+ ":non_spawn:"
				+ nonSpawnSkipped);
			return false;
		}
		trace.push("tui.loaded_threads.plan=headless");
		trace.push("tui.loaded_threads.primary=" + plan.primaryThreadId + ":discovered=" + plan.summary(discovered));
		trace.push("tui.loaded_threads.skipped=invalid:"
			+ invalidSkipped
			+ ":unrelated:"
			+ unrelatedSkipped
			+ ":non_spawn:"
			+ nonSpawnSkipped);
		trace.push("tui.loaded_threads.failure=" + plan.failureCode + ":no_model=" + plan.noModelCall + ":no_app_server=" + plan.noAppServerRequest
			+ ":no_fs=" + plan.noFilesystemMutation + ":unsupported=" + plan.unsupportedRejected);
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
				trace.push("tui.terminal_title.sanitize_mismatch=" + action.sanitizedTitle + ":computed=" + action.computedSanitizedTitle());
				return false;
			}
			switch action.kind {
				case TuiSmokeTerminalTitleActionKind.Set:
					trace.push("tui.terminal_title.set=" + "raw_chars=" + action.rawTitle.length + ":sanitized=" + action.sanitizedTitle + ":stdout="
						+ action.stdoutTerminal + ":applied=" + action.applied + ":last=" + action.lastTitleBefore + "->" + action.lastTitleAfter + ":max="
						+ action.effectiveMaxChars() + ":live=" + action.liveWriteAllowed);
				case TuiSmokeTerminalTitleActionKind.NoVisibleContent:
					trace.push("tui.terminal_title.no_visible_content=" + "raw_chars=" + action.rawTitle.length + ":clear=" + action.cleared + ":last="
						+ action.lastTitleBefore + "->" + action.lastTitleAfter + ":stdout=" + action.stdoutTerminal);
				case TuiSmokeTerminalTitleActionKind.SkipDuplicate:
					trace.push("tui.terminal_title.skip_duplicate=" + "title=" + action.sanitizedTitle + ":skipped=" + action.duplicateSkipped + ":frame="
						+ action.frameScheduled);
				case TuiSmokeTerminalTitleActionKind.ClearManaged:
					trace.push("tui.terminal_title.clear_managed=" + "had_title=" + (action.lastTitleBefore != "") + ":cleared=" + action.cleared + ":last="
						+ action.lastTitleBefore + "->" + action.lastTitleAfter + ":stdout=" + action.stdoutTerminal);
				case TuiSmokeTerminalTitleActionKind.Failure:
					trace.push("tui.terminal_title.failure=" + action.failureCode + ":invalid_items=" + action.invalidItemCount + ":live="
						+ action.liveWriteAllowed);
				case _:
					trace.push("tui.terminal_title.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceResumeFork(plan:TuiSmokeResumeForkPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveTerminal || plan.allowRatatuiRender || plan.allowModelCall || plan.allowFilesystemMutation || !plan.enabled()) {
			trace.push("tui.resume_fork.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.resume_fork.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeResumeForkActionKind.PickerOpen:
					trace.push("tui.resume_fork.picker_open=" + "action=" + action.action + ":source=" + action.source + ":context=" + action.context
						+ ":show_all=" + action.showAll + ":include_non_interactive=" + action.includeNonInteractive + ":remote=" + action.remoteWorkspace
						+ ":alt=" + action.altScreenEntered);
				case TuiSmokeResumeForkActionKind.PickerPageRequest:
					trace.push("tui.resume_fork.picker_page_request=" + "action=" + action.action + ":token=" + action.requestToken + ":search_token="
						+ action.searchToken + ":query=" + action.query + ":cursor=" + action.cursor + ":cwd=" + action.cwdFilter + ":show_all="
						+ action.showAll + ":sort=" + action.sortKey + ":search_active=" + action.searchActive + ":frame=" + action.frameScheduled);
				case TuiSmokeResumeForkActionKind.PickerPageIngest:
					trace.push("tui.resume_fork.picker_page_ingest=" + "token=" + action.requestToken + ":stale=" + action.staleIgnored + ":scanned="
						+ action.scannedRows + ":accepted=" + action.acceptedRows + ":invalid=" + action.invalidRows + ":loaded=" + action.loadedRows
						+ ":filtered=" + action.filteredRows + ":next=" + action.nextCursor + ":has_next=" + action.nextCursorPresent + ":scan_cap="
						+ action.reachedScanCap + ":page_down=" + action.pendingPageDownCompleted);
				case TuiSmokeResumeForkActionKind.PickerSearchContinue:
					trace.push("tui.resume_fork.picker_search_continue=" + "token=" + action.searchToken + ":query=" + action.query + ":filtered="
						+ action.filteredRows + ":next=" + action.nextCursorPresent + ":scan_cap=" + action.reachedScanCap + ":requested="
						+ action.lookupRequested + ":search_active=" + action.searchActive);
				case TuiSmokeResumeForkActionKind.PickerSortToggle:
					trace.push("tui.resume_fork.picker_sort_toggle=" + action.sortKeyBefore + "->" + action.sortKeyAfter + ":reset="
						+ action.lookupRequested + ":loaded=" + action.loadedRows + ":filtered=" + action.filteredRows + ":frame=" + action.frameScheduled);
				case TuiSmokeResumeForkActionKind.PickerFilterToggle:
					trace.push("tui.resume_fork.picker_filter_toggle=" + action.filterModeBefore + "->" + action.filterModeAfter + ":cwd="
						+ action.cwdFilter + ":show_all=" + action.showAll + ":reset=" + action.lookupRequested + ":frame=" + action.frameScheduled);
				case TuiSmokeResumeForkActionKind.PickerPreviewToggle:
					trace.push("tui.resume_fork.picker_preview_toggle=" + "selected=" + action.selectedIndex + ":thread=" + action.threadId + ":expanded="
						+ action.expandedThreadId + ":cache=" + action.previewCacheBefore + "->" + action.previewCacheAfter + ":inserted="
						+ action.cacheInserted + ":toggled=" + action.expansionToggled + ":frame=" + action.frameScheduled);
				case TuiSmokeResumeForkActionKind.PickerPreviewRequest:
					trace.push("tui.resume_fork.picker_preview_request=" + "thread=" + action.threadId + ":include_turns=" + action.includeTurns
						+ ":thread_read=" + action.threadReadRequested + ":app_server=" + action.appServerStarted + ":no_model=" + action.noModelCall
						+ ":no_fs=" + action.noFilesystemMutation);
				case TuiSmokeResumeForkActionKind.PickerPreviewComplete:
					trace.push("tui.resume_fork.picker_preview_complete=" + "thread=" + action.threadId + ":state=" + action.previewState + ":cache="
						+ action.previewCacheBefore + "->" + action.previewCacheAfter + ":lines=" + action.previewLineCount + ":user=" + action.userLineCount
						+ ":assistant=" + action.assistantLineCount + ":selected=" + action.selected + ":frame=" + action.frameScheduled);
				case TuiSmokeResumeForkActionKind.PickerPreviewRender:
					trace.push("tui.resume_fork.picker_preview_render=" + "thread=" + action.threadId + ":expanded=" + action.expandedThreadId + ":state="
						+ action.previewState + ":selected=" + action.selected + ":rendered=" + action.previewRendered + ":lines=" + action.previewLineCount
						+ ":no_render=" + action.noRatatuiRender);
				case TuiSmokeResumeForkActionKind.PickerTranscriptOpen:
					trace.push("tui.resume_fork.picker_transcript_open=" + "selected=" + action.selectedIndex + ":thread=" + action.threadId + ":cache="
						+ action.transcriptCacheBefore + "->" + action.transcriptCacheAfter + ":pending=" + action.pendingThreadId + ":loading_frame="
						+ action.loadingFrameShown + ":frame=" + action.frameScheduled);
				case TuiSmokeResumeForkActionKind.PickerTranscriptRequest:
					trace.push("tui.resume_fork.picker_transcript_request=" + "thread=" + action.threadId + ":include_turns=" + action.includeTurns
						+ ":thread_read=" + action.threadReadRequested + ":app_server=" + action.appServerStarted + ":no_model=" + action.noModelCall
						+ ":no_fs=" + action.noFilesystemMutation);
				case TuiSmokeResumeForkActionKind.PickerTranscriptLoadingFrame:
					trace.push("tui.resume_fork.picker_transcript_loading_frame=" + "pending=" + action.pendingThreadId + ":shown="
						+ action.loadingFrameShown + ":overlay=" + action.overlayOpened + ":frame=" + action.frameScheduled);
				case TuiSmokeResumeForkActionKind.PickerTranscriptComplete:
					trace.push("tui.resume_fork.picker_transcript_complete=" + "thread=" + action.threadId + ":state=" + action.transcriptState + ":cache="
						+ action.transcriptCacheBefore + "->" + action.transcriptCacheAfter + ":cells=" + action.transcriptCellCount + ":user="
						+ action.userLineCount + ":assistant=" + action.assistantLineCount + ":plan=" + action.planCellCount + ":reasoning="
						+ action.reasoningCellCount + ":fallback=" + action.fallbackCellCount + ":pending=" + action.pendingThreadId + ":frame="
						+ action.frameScheduled);
				case TuiSmokeResumeForkActionKind.PickerTranscriptOverlayOpen:
					trace.push("tui.resume_fork.picker_transcript_overlay_open=" + "thread=" + action.threadId + ":state=" + action.transcriptState
						+ ":loading_frame=" + action.loadingFrameShown + ":overlay=" + action.overlayOpened + ":pending=" + action.pendingThreadId
						+ ":cells=" + action.transcriptCellCount + ":frame=" + action.frameScheduled);
				case TuiSmokeResumeForkActionKind.PickerKeyboardMove:
					trace.push("tui.resume_fork.picker_keyboard_move=" + "key=" + action.keyName + ":selected=" + action.selectedBefore + "->"
						+ action.selectedAfter + ":scroll=" + action.scrollTopBefore + "->" + action.scrollTopAfter + ":view_rows=" + action.viewRows
						+ ":loaded=" + action.loadedRows + ":load_more=" + action.loadMoreRequested + ":frame=" + action.frameScheduled);
				case TuiSmokeResumeForkActionKind.PickerQueryClear:
					trace.push("tui.resume_fork.picker_query_clear=" + "key=" + action.keyName + ":query=" + action.queryBefore + "->" + action.queryAfter
						+ ":selected=" + action.selectedBefore + "->" + action.selectedAfter + ":start_fresh=" + action.startFresh + ":frame="
						+ action.frameScheduled);
				case TuiSmokeResumeForkActionKind.PickerLoadMoreTrigger:
					trace.push("tui.resume_fork.picker_load_more_trigger=" + "key=" + action.keyName + ":cursor=" + action.nextCursor + ":requested="
						+ action.loadMoreRequested + ":pending_target=" + action.selectedAfter + ":search_active=" + action.searchActive + ":frame="
						+ action.frameScheduled);
				case TuiSmokeResumeForkActionKind.PickerTranscriptLoadingKey:
					trace.push("tui.resume_fork.picker_transcript_loading_key=" + "key=" + action.keyName + ":pending=" + action.pendingThreadId
						+ ":consumed=" + action.keyConsumed + ":exit=" + action.altScreenExited);
				case TuiSmokeResumeForkActionKind.PickerOverlayClose:
					trace.push("tui.resume_fork.picker_overlay_close=" + "key=" + action.keyName + ":overlay=" + action.overlayOpened + "->"
						+ action.overlayClosed + ":frame=" + action.frameScheduled);
				case TuiSmokeResumeForkActionKind.PickerMetadataFailure:
					trace.push("tui.resume_fork.picker_metadata_failure=" + "key=" + action.keyName + ":path=" + action.targetPath + ":thread="
						+ action.threadId + ":error=" + action.errorMessage + ":frame=" + action.frameScheduled);
				case TuiSmokeResumeForkActionKind.PickerDensityToggle:
					trace.push("tui.resume_fork.picker_density_toggle=" + action.densityBefore + "->" + action.densityAfter + ":key=" + action.keyName
						+ ":query_preserved=" + action.queryPreserved + ":persist_configured=" + action.persistenceConfigured + ":persist_attempted="
						+ action.persistenceAttempted + ":persist_success=" + action.persistenceSucceeded + ":inline_error=" + action.inlineErrorShown
						+ ":frame=" + action.frameScheduled);
				case TuiSmokeResumeForkActionKind.PickerToolbarFocus:
					trace.push("tui.resume_fork.picker_toolbar_focus=" + "key=" + action.keyName + ":" + action.toolbarFocusBefore + "->"
						+ action.toolbarFocusAfter + ":frame=" + action.frameScheduled);
				case TuiSmokeResumeForkActionKind.PickerToolbarActivate:
					trace.push("tui.resume_fork.picker_toolbar_activate=" + "focus=" + action.toolbarFocusBefore + ":key=" + action.keyName + ":sort="
						+ action.sortKeyBefore + "->" + action.sortKeyAfter + ":filter=" + action.filterModeBefore + "->" + action.filterModeAfter + ":cwd="
						+ action.cwdFilter + ":show_all=" + action.showAll + ":query_preserved=" + action.queryPreserved + ":reset=" + action.lookupRequested
						+ ":frame=" + action.frameScheduled);
				case TuiSmokeResumeForkActionKind.PickerToolbarRender:
					trace.push("tui.resume_fork.picker_toolbar_render=" + "mode=" + action.toolbarRenderMode + ":focus=" + action.toolbarFocusAfter
						+ ":sort=" + action.sortKey + ":filter=" + action.filterModeAfter + ":cwd_present=" + (action.cwdFilter != ""));
				case TuiSmokeResumeForkActionKind.PickerFooterProgress:
					trace.push("tui.resume_fork.picker_footer_progress=" + "label=" + action.footerProgressLabel + ":percent=" + action.footerPercent
						+ ":frozen=" + action.frozenFooterPercent + ":loading=" + action.loadingPending + ":width=" + action.footerWidth);
				case TuiSmokeResumeForkActionKind.PickerFooterHints:
					trace.push("tui.resume_fork.picker_footer_hints=" + "mode=" + action.footerHintMode + ":query=" + action.query + ":loading="
						+ action.loadingPending + ":compact=" + action.compactFallback + ":key_only=" + action.keyOnlyFallback + ":width=" +
						action.footerWidth);
				case TuiSmokeResumeForkActionKind.PickerListRenderState:
					trace.push("tui.resume_fork.picker_list_render_state=" + "above=" + action.moreAbove + ":below=" + action.moreBelow + ":loading="
						+ action.loadingPending + ":loading_older=" + action.loadingOlderShown + ":loaded=" + action.loadedRows + ":view_rows="
						+ action.viewRows);
				case TuiSmokeResumeForkActionKind.PickerEmptyState:
					trace.push("tui.resume_fork.picker_empty_state=" + action.emptyStateMessage + ":query=" + action.query + ":search_active="
						+ action.searchActive + ":loading=" + action.loadingPending + ":scan_cap=" + action.reachedScanCap + ":scanned=" + action.scannedRows);
				case TuiSmokeResumeForkActionKind.PickerTranscriptLoadingOverlay:
					trace.push("tui.resume_fork.picker_transcript_loading_overlay=" + action.loadingOverlayMessage + ":pending=" + action.pendingThreadId
						+ ":shown=" + action.loadingFrameShown + ":no_render=" + action.noRatatuiRender);
				case TuiSmokeResumeForkActionKind.PickerSelection:
					trace.push("tui.resume_fork.picker_selection=" + "action=" + action.action + ":selected=" + action.selected + ":target="
						+ action.threadId + ":label=" + action.targetLabel + ":loaded=" + action.loadedRows + ":page_size=" + action.pageSize + ":exit_alt="
						+ action.altScreenExited);
				case TuiSmokeResumeForkActionKind.Lookup:
					trace.push("tui.resume_fork.lookup=" + "id_or_name=" + action.idOrName + ":requested=" + action.lookupRequested + ":success="
						+ action.lookupSucceeded + ":target=" + action.threadId);
				case TuiSmokeResumeForkActionKind.StartupGate:
					trace.push("tui.resume_fork.startup_gate=" + "wait_initial=" + action.waitForInitialSession + ":active_events="
						+ action.activeEventsAllowed + ":paused_goal_prompt=" + action.pausedGoalPromptEligible);
				case TuiSmokeResumeForkActionKind.ResumeRequest:
					trace.push("tui.resume_fork.resume_request=" + "target=" + action.threadId + ":path=" + action.targetPath + ":cwd=" + action.cwdResolved
						+ ":config_reload=" + action.configReloaded + ":settings=" + action.configRebuilt + ":requested=" + action.resumeRequested);
				case TuiSmokeResumeForkActionKind.ResumeAttach:
					trace.push("tui.resume_fork.resume_attach=" + "thread=" + action.threadId + ":turns=" + action.turnCount + ":read="
						+ action.threadReadRequested + ":success=" + action.resumeSucceeded + ":chat_replaced=" + action.chatWidgetReplaced + ":subagents="
						+ action.subagentsBackfilled + ":notify=" + action.notificationSettingsUpdated + ":file_search=" + action.fileSearchDirUpdated
						+ ":summary=" + action.summaryInserted + ":frame=" + action.frameScheduled);
				case TuiSmokeResumeForkActionKind.SameThreadNoOp:
					trace.push("tui.resume_fork.same_thread_noop=" + "thread=" + action.threadId + ":active=" + action.sameThreadActive + ":ignored="
						+ action.ignored + ":info=" + action.infoInserted);
				case TuiSmokeResumeForkActionKind.ForkRequest:
					trace.push("tui.resume_fork.fork_request=" + "parent=" + action.parentThreadId + ":target=" + action.threadId + ":requested="
						+ action.forkRequested + ":app_server=" + action.appServerStarted + ":mutation=" + action.appServerMutationRequested
						+ ":current_shutdown=" + action.currentThreadShutdown);
				case TuiSmokeResumeForkActionKind.ForkAttach:
					trace.push("tui.resume_fork.fork_attach=" + "parent=" + action.parentThreadId + ":child=" + action.childThreadId + ":success="
						+ action.forkSucceeded + ":chat_replaced=" + action.chatWidgetReplaced + ":primary_enqueued=" + action.primaryThreadEnqueued
						+ ":initial=" + action.initialUserMessageSubmitted + ":summary=" + action.summaryInserted + ":frame=" + action.frameScheduled);
				case TuiSmokeResumeForkActionKind.Failure:
					trace.push("tui.resume_fork.failure=" + action.failureCode + ":error=" + action.errorMessage + ":source=" + action.source + ":target="
						+ action.idOrName + ":no_live=" + action.noLiveTerminal + ":no_render=" + action.noRatatuiRender + ":no_model=" + action.noModelCall
						+ ":no_fs=" + action.noFilesystemMutation + ":unsupported=" + action.unsupportedRejected);
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
					trace.push("tui.side_conversation.sync_ui=" + "active=" + action.sideConversationActiveBefore + "->"
						+ action.sideConversationActiveAfter + ":notice_suppressed=" + action.noticeSuppressedBefore + "->" + action.noticeSuppressedAfter
						+ ":rename_blocked=" + action.renameBlockedBefore + "->" + action.renameBlockedAfter + ":parent_main=" + action.parentIsMain
						+ ":status=" + action.status + ":label=" + action.label);
				case TuiSmokeSideConversationActionKind.StartBlock:
					trace.push("tui.side_conversation.start_block=" + action.blockMessage + ":side_threads=" + action.sideThreadsBefore + "->"
						+ action.sideThreadsAfter + ":restored=" + action.restoredComposer);
				case TuiSmokeSideConversationActionKind.ForkThread:
					trace.push("tui.side_conversation.fork=" + "parent=" + action.parentThreadId + ":child=" + action.childThreadId + ":side_threads="
						+ action.sideThreadsBefore + "->" + action.sideThreadsAfter + ":ephemeral=" + action.forkConfigEphemeral + ":developer="
						+ action.developerInstructionsAdded + ":model=" + action.modelInherited + ":tier=" + action.serviceTierInherited);
				case TuiSmokeSideConversationActionKind.InjectBoundary:
					trace.push("tui.side_conversation.inject_boundary=" + "child=" + action.childThreadId + ":hidden=" + action.hiddenBoundaryPrompt
						+ ":injected=" + action.boundaryInjected);
				case TuiSmokeSideConversationActionKind.SwitchThread:
					trace.push("tui.side_conversation.switch=" + "target=" + action.targetThreadId + ":child=" + action.switchedToChild + ":parent="
						+ action.switchedToParent + ":submitted_initial=" + action.submittedInitialUserMessage + ":redraw=" + action.requestRedraw);
				case TuiSmokeSideConversationActionKind.ParentStatusChange:
					trace.push("tui.side_conversation.parent_status=" + action.statusChange + ":status=" + action.status + ":actionable="
						+ action.parentStatusActionable + ":synced=" + action.statusSynced + ":label=" + action.label);
				case TuiSmokeSideConversationActionKind.MaybeReturn:
					trace.push("tui.side_conversation.maybe_return=" + "overlay=" + action.overlayActive + ":modal=" + action.modalOrPopupActive
						+ ":composer_empty=" + action.composerEmpty + ":requested=" + action.returnRequested + ":returned=" + action.returnedToParent);
				case TuiSmokeSideConversationActionKind.RestoreUserMessage:
					trace.push("tui.side_conversation.restore_user_message=" + "text=" + action.userMessageText + ":remote_images="
						+ action.remoteImageCount + ":local_images=" + action.localImageCount + ":mentions=" + action.mentionBindingCount + ":restored="
						+ action.restoredComposer);
				case TuiSmokeSideConversationActionKind.DiscardSide:
					trace.push("tui.side_conversation.discard=" + "child=" + action.childThreadId + ":interrupt=" + action.interruptSubmitted + ":startup="
						+ action.startupInterruptUsed + ":turn=" + action.turnInterruptUsed + ":unsubscribe=" + action.threadUnsubscribed + ":local="
						+ action.localStateDiscarded + ":listener=" + action.listenerAborted + ":channel=" + action.channelRemoved + ":navigation="
						+ action.navigationRemoved + ":active_cleared=" + action.activeThreadCleared + ":approvals=" + action.approvalsRefreshed);
				case TuiSmokeSideConversationActionKind.Failure:
					trace.push("tui.side_conversation.failure=" + action.failureCode + ":error=" + action.errorMessage + ":no_live=" + action.noLiveTerminal
						+ ":no_render=" + action.noRatatuiRender + ":no_model=" + action.noModelCall + ":unsupported=" + action.unsupportedRejected);
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
					trace.push("tui.chat_widget_interrupted_restore.record_cancel_edit="
						+ "prompt="
						+ action.promptText
						+ ":eligible="
						+ action.cancelEditEligibleBefore
						+ "->"
						+ action.cancelEditEligibleAfter
						+ ":armed="
						+ action.cancelEditArmedBefore
						+ "->"
						+ action.cancelEditArmedAfter
						+ ":prompt_state="
						+ action.cancelEditPromptBefore
						+ "->"
						+ action.cancelEditPromptAfter);
				case TuiSmokeChatWidgetInterruptedRestoreActionKind.RecordVisibleTurnActivity:
					trace.push("tui.chat_widget_interrupted_restore.visible_turn_activity="
						+ "eligible="
						+ action.cancelEditEligibleBefore
						+ "->"
						+ action.cancelEditEligibleAfter
						+ ":armed="
						+ action.cancelEditArmedBefore
						+ "->"
						+ action.cancelEditArmedAfter
						+ ":prompt_state="
						+ action.cancelEditPromptBefore
						+ "->"
						+ action.cancelEditPromptAfter);
				case TuiSmokeChatWidgetInterruptedRestoreActionKind.ArmCancelEdit:
					trace.push("tui.chat_widget_interrupted_restore.arm_cancel_edit=" + "eligible=" + action.cancelEditEligibleBefore + ":composer_empty="
						+ action.composerEmpty + ":pending=" + action.pendingSteersBefore + ":queued=" + action.queuedMessagesBefore + ":side="
						+ action.sideConversationActive + ":armed=" + action.cancelEditArmedBefore + "->" + action.cancelEditArmedAfter);
				case TuiSmokeChatWidgetInterruptedRestoreActionKind.TakeCancelEdit:
					trace.push("tui.chat_widget_interrupted_restore.take_cancel_edit=" + "reason=" + action.reason + ":eligible="
						+ action.cancelEditEligibleBefore + "->" + action.cancelEditEligibleAfter + ":armed=" + action.cancelEditArmedBefore + "->"
						+ action.cancelEditArmedAfter + ":prompt_state=" + action.cancelEditPromptBefore + "->" + action.cancelEditPromptAfter + ":taken="
						+ action.cancelEditPromptTaken);
				case TuiSmokeChatWidgetInterruptedRestoreActionKind.ClearCancelEdit:
					trace.push("tui.chat_widget_interrupted_restore.clear_cancel_edit=" + "eligible=" + action.cancelEditEligibleBefore + "->"
						+ action.cancelEditEligibleAfter + ":armed=" + action.cancelEditArmedBefore + "->" + action.cancelEditArmedAfter + ":prompt_state="
						+ action.cancelEditPromptBefore + "->" + action.cancelEditPromptAfter);
				case TuiSmokeChatWidgetInterruptedRestoreActionKind.InitialUserMessage:
					trace.push("tui.chat_widget_interrupted_restore.initial_message=" + action.initialMessage + ":submitted="
						+ action.initialMessageSubmitted + ":suppressed=" + action.initialMessageSuppressed + ":sandbox_blocked="
						+ action.elevatedSandboxBlocked + ":queued=" + action.queuedMessagesBefore + "->" + action.queuedMessagesAfter);
				case TuiSmokeChatWidgetInterruptedRestoreActionKind.InterruptedTurn:
					trace.push("tui.chat_widget_interrupted_restore.interrupted=" + action.reason + ":finalized=" + action.finalizedTurn + ":send_pending="
						+ action.sendPendingSteersImmediately + ":submit_after=" + action.submitPendingSteersAfterInterruptBefore + "->"
						+ action.submitPendingSteersAfterInterruptAfter + ":notice=" + action.noticeInserted + ":suppressed=" + action.noticeSuppressed
						+ ":preview=" + action.pendingPreviewRefreshed + ":redraw=" + action.requestRedraw);
				case TuiSmokeChatWidgetInterruptedRestoreActionKind.QueuePopNext:
					trace.push("tui.chat_widget_interrupted_restore.queue_pop_next=" + "source=" + action.queueSource + ":order=" + action.popOrder
						+ ":queued=" + action.queuedMessagesBefore + "->" + action.queuedMessagesAfter + ":rejected=" + action.rejectedSteersBefore + "->"
						+ action.rejectedSteersAfter + ":history=" + action.historyRecord + ":fallback=" + action.historyFallback + ":override="
						+ action.historyOverrideApplied + ":text=" + action.restoredText);
				case TuiSmokeChatWidgetInterruptedRestoreActionKind.QueuePopLatest:
					trace.push("tui.chat_widget_interrupted_restore.queue_pop_latest=" + "source=" + action.queueSource + ":order=" + action.popOrder
						+ ":queued=" + action.queuedMessagesBefore + "->" + action.queuedMessagesAfter + ":rejected=" + action.rejectedSteersBefore + "->"
						+ action.rejectedSteersAfter + ":history=" + action.historyRecord + ":fallback=" + action.historyFallback + ":override="
						+ action.historyOverrideApplied + ":text=" + action.restoredText);
				case TuiSmokeChatWidgetInterruptedRestoreActionKind.EnqueueRejectedSteer:
					trace.push("tui.chat_widget_interrupted_restore.enqueue_rejected=" + "success=" + action.enqueueRejectedSteerSucceeded + ":pending="
						+ action.pendingSteersBefore + "->" + action.pendingSteersAfter + ":rejected=" + action.rejectedSteersBefore + "->"
						+ action.rejectedSteersAfter + ":history=" + action.rejectedSteerHistoryRecords + ":preview=" + action.pendingPreviewRefreshed);
				case TuiSmokeChatWidgetInterruptedRestoreActionKind.CaptureThreadInputState:
					trace.push("tui.chat_widget_interrupted_restore.capture_thread_input="
						+ "composer="
						+ action.composerText
						+ ":remote_images="
						+ action.remoteImageCount
						+ ":local_images="
						+ action.localImageCount
						+ ":elements="
						+ action.textElementCount
						+ ":mentions="
						+ action.mentionBindingCount
						+ ":pastes="
						+ action.pendingPasteCount
						+ ":pending="
						+ action.pendingSteersBefore
						+ ":pending_history="
						+ action.pendingSteerHistoryRecords
						+ ":compare_keys="
						+ action.pendingSteerCompareKeys
						+ ":rejected="
						+ action.rejectedSteersBefore
						+ ":rejected_history="
						+ action.rejectedSteerHistoryRecords
						+ ":queued="
						+ action.queuedMessagesBefore
						+ ":queued_history="
						+ action.queuedUserMessageHistoryRecords
						+ ":user_turn_pending="
						+ action.userTurnPendingBefore
						+ ":mode="
						+ action.currentCollaborationMode
						+ ":active_mode="
						+ action.activeCollaborationMode
						+ ":task="
						+ action.taskRunningBefore
						+ ":agent="
						+ action.agentTurnRunningBefore
						+ ":sleep="
						+ action.sleepInhibitorRunningBefore);
				case TuiSmokeChatWidgetInterruptedRestoreActionKind.RestoreThreadInputState:
					trace.push("tui.chat_widget_interrupted_restore.restore_thread_input="
						+ "present="
						+ action.inputStatePresent
						+ ":cleared="
						+ action.inputStateCleared
						+ ":composer="
						+ action.composerText
						+ "->"
						+ action.restoredText
						+ ":pending="
						+ action.pendingSteersBefore
						+ "->"
						+ action.pendingSteersAfter
						+ ":pending_history="
						+ action.pendingSteerHistoryRecords
						+ ":compare_keys="
						+ action.pendingSteerCompareKeys
						+ ":rejected="
						+ action.rejectedSteersBefore
						+ "->"
						+ action.rejectedSteersAfter
						+ ":rejected_history="
						+ action.rejectedSteerHistoryRecords
						+ ":queued="
						+ action.queuedMessagesBefore
						+ "->"
						+ action.queuedMessagesAfter
						+ ":queued_history="
						+ action.queuedUserMessageHistoryRecords
						+ ":user_turn_pending="
						+ action.userTurnPendingBefore
						+ "->"
						+ action.userTurnPendingAfter
						+ ":mode="
						+ action.currentCollaborationMode
						+ ":active_mode="
						+ action.activeCollaborationMode
						+ ":mode_restored="
						+ action.collaborationModeRestored
						+ ":agent="
						+ action.agentTurnRunningBefore
						+ "->"
						+ action.agentTurnRunningAfter
						+ ":task="
						+ action.taskRunningBefore
						+ "->"
						+ action.taskRunningAfter
						+ ":sleep="
						+ action.sleepInhibitorRunningBefore
						+ "->"
						+ action.sleepInhibitorRunningAfter
						+ ":remote_cleared="
						+ action.remoteImagesCleared
						+ ":pastes_cleared="
						+ action.pendingPastesCleared
						+ ":model_surfaces="
						+ action.modelSurfacesRefreshed
						+ ":status_surfaces="
						+ action.statusSurfacesRefreshed
						+ ":preview="
						+ action.pendingPreviewRefreshed
						+ ":redraw="
						+ action.requestRedraw);
				case TuiSmokeChatWidgetInterruptedRestoreActionKind.DrainPendingMessages:
					trace.push("tui.chat_widget_interrupted_restore.drain_pending=" + "pending=" + action.pendingSteersBefore + "->"
						+ action.pendingSteersAfter + ":queued=" + action.queuedMessagesBefore + "->" + action.queuedMessagesAfter + ":rejected="
						+ action.rejectedSteersBefore + "->" + action.rejectedSteersAfter + ":pending_merged=" + action.pendingMerged + ":queued_merged="
						+ action.queuedMerged + ":composer_merged=" + action.composerMerged + ":text=" + action.restoredText);
				case TuiSmokeChatWidgetInterruptedRestoreActionKind.RestoreComposer:
					trace.push("tui.chat_widget_interrupted_restore.restore_composer=" + "text=" + action.restoredText + ":remote_images="
						+ action.remoteImageCount + ":local_images=" + action.localImageCount + ":mentions=" + action.mentionBindingCount + ":restored="
						+ action.composerRestored);
				case TuiSmokeChatWidgetInterruptedRestoreActionKind.RestoreMessageShape:
					trace.push("tui.chat_widget_interrupted_restore.restore_shape=" + "text=" + action.restoredText + ":remote_images="
						+ action.remoteImageCount + ":local_images=" + action.localImageCount + ":labels=" + action.localImageLabelsBefore + "->"
						+ action.localImageLabelsAfter + ":remapped=" + action.localPlaceholdersRemapped + ":elements=" + action.textElementCount
						+ ":ranges=" + action.textElementRanges + ":rebased=" + action.textElementsRebased + ":mentions=" + action.mentionBindingCount
						+ ":cursor_end=" + action.cursorAtEnd);
				case TuiSmokeChatWidgetInterruptedRestoreActionKind.RestoreCancelledTurn:
					trace.push("tui.chat_widget_interrupted_restore.restore_cancelled_turn="
						+ "prompt="
						+ action.promptText
						+ ":event="
						+ action.cancelledTurnRestoreEventSent
						+ ":rollback="
						+ action.threadRollbackSent
						+ ":composer="
						+ action.composerRestored);
				case TuiSmokeChatWidgetInterruptedRestoreActionKind.NoticeMode:
					trace.push("tui.chat_widget_interrupted_restore.notice_mode=" + action.noticeMode + ":suppressed=" + action.noticeSuppressed + ":text="
						+ action.noticeText);
				case TuiSmokeChatWidgetInterruptedRestoreActionKind.QueueAutosend:
					trace.push("tui.chat_widget_interrupted_restore.queue_autosend=" + "suppressed=" + action.queueAutosendSuppressed);
				case TuiSmokeChatWidgetInterruptedRestoreActionKind.RetryStatus:
					trace.push("tui.chat_widget_interrupted_restore.retry_status=" + "current=" + action.currentStatusHeader + ":message="
						+ action.noticeText + ":details=" + action.retryDetails + ":will_retry=" + action.willRetry + ":replay=" + action.fromReplay
						+ ":remembered=" + action.retryStatusRemembered + ":stored=" + action.retryStatusHeaderBefore + "->" + action.retryStatusHeaderAfter
						+ ":shown=" + action.retryStatusShown + ":visible=" + action.statusIndicatorVisible + ":taken=" + action.retryStatusTaken
						+ ":restored=" + action.retryStatusRestored + ":header=" + action.restoredStatusHeader);
				case TuiSmokeChatWidgetInterruptedRestoreActionKind.Failure:
					trace.push("tui.chat_widget_interrupted_restore.failure=" + action.failureCode + ":no_live=" + action.noLiveTerminal + ":no_render="
						+ action.noRatatuiRender + ":no_model=" + action.noModelCall + ":unsupported=" + action.unsupportedRejected);
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
					trace.push("tui.chat_widget_stream_lifecycle.delta=" + action.delta + ":controller=" + action.activeStreamControllerBefore + "->"
						+ action.activeStreamControllerAfter + ":queued_lines=" + action.queuedLinesBefore + "->" + action.queuedLinesAfter
						+ ":start_animation=" + action.startCommitAnimation + ":catch_up=" + action.catchUpTick + ":redraw=" + action.requestRedraw);
				case TuiSmokeChatWidgetStreamLifecycleActionKind.DeferOrHandle:
					trace.push("tui.chat_widget_stream_lifecycle.interrupt=" + action.interruptKind + ":controller=" + action.activeStreamControllerBefore
						+ ":queue=" + action.queuedInterruptsBefore + "->" + action.queuedInterruptsAfter + ":queued=" + action.interruptQueued + ":handled="
						+ action.interruptHandled + ":fifo=" + action.fifoPreserved);
				case TuiSmokeChatWidgetStreamLifecycleActionKind.FlushInterruptQueue:
					trace.push("tui.chat_widget_stream_lifecycle.flush_interrupts=" + action.flushedInterrupts + ":queue=" + action.queuedInterruptsBefore
						+ "->" + action.queuedInterruptsAfter + ":handled=" + action.interruptHandled + ":fifo=" + action.fifoPreserved);
				case TuiSmokeChatWidgetStreamLifecycleActionKind.StreamFinished:
					trace.push("tui.chat_widget_stream_lifecycle.stream_finished=" + action.finishReason + ":task_complete_pending="
						+ action.taskCompletePendingBefore + "->" + action.taskCompletePendingAfter + ":status_hidden=" + action.statusHidden + ":flushed="
						+ action.flushedInterrupts + ":queue=" + action.queuedInterruptsBefore + "->" + action.queuedInterruptsAfter);
				case TuiSmokeChatWidgetStreamLifecycleActionKind.TaskComplete:
					trace.push("tui.chat_widget_stream_lifecycle.task_complete=" + action.finishReason + ":stream=" + action.activeStreamControllerBefore
						+ "->" + action.activeStreamControllerAfter + ":plan=" + action.planStreamControllerBefore + "->" + action.planStreamControllerAfter
						+ ":task=" + action.taskRunningBefore + "->" + action.taskRunningAfter + ":status_restore=" + action.pendingStatusRestoreBefore
						+ "->" + action.pendingStatusRestoreAfter + ":status_preserved=" + action.statusPreserved + ":redraw=" + action.requestRedraw);
				case TuiSmokeChatWidgetStreamLifecycleActionKind.FinalizeTurn:
					trace.push("tui.chat_widget_stream_lifecycle.finalize_turn=" + action.finishReason + ":tail=" + action.activeTailBefore + "->"
						+ action.activeTailAfter + ":stream=" + action.activeStreamControllerBefore + "->" + action.activeStreamControllerAfter + ":plan="
						+ action.planStreamControllerBefore + "->" + action.planStreamControllerAfter + ":task=" + action.taskRunningBefore + "->"
						+ action.taskRunningAfter + ":adaptive_reset=" + action.adaptiveChunkingReset + ":commands=" + action.runningCommandsCleared
						+ ":suppressed=" + action.suppressedExecCleared + ":wait=" + action.unifiedWaitCleared + ":cancel_edit=" + action.cancelEditCleared
						+ ":rate_limit=" + action.rateLimitPromptChecked);
				case TuiSmokeChatWidgetStreamLifecycleActionKind.StopCommitAnimation:
					trace.push("tui.chat_widget_stream_lifecycle.stop_commit_animation="
						+ action.stopCommitAnimation
						+ ":committed="
						+ action.committedCells
						+ ":queued_lines="
						+ action.queuedLinesBefore
						+ "->"
						+ action.queuedLinesAfter);
				case TuiSmokeChatWidgetStreamLifecycleActionKind.Failure:
					trace.push("tui.chat_widget_stream_lifecycle.failure=" + action.failureCode + ":unsupported=" + action.unsupportedRejected);
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
					trace.push("tui.chat_widget_stream_status.reasoning_delta=" + "delta=" + action.reasoningDelta + ":header=" + action.extractedHeader
						+ ":buffer=" + action.reasoningBufferLength + ":title=" + action.titleKind + ":wait=" + action.unifiedExecWaitActive + ":status="
						+ action.statusUpdated + ":redraw=" + action.requestRedraw + ":model=" + !action.noModelCall);
				case TuiSmokeChatWidgetStreamStatusActionKind.ReasoningSectionBreak:
					trace.push("tui.chat_widget_stream_status.reasoning_break=" + "reasoning=" + action.reasoningBufferLength + ":full="
						+ action.fullReasoningBufferLength + ":cleared=" + action.reasoningCleared);
				case TuiSmokeChatWidgetStreamStatusActionKind.ReasoningFinal:
					trace.push("tui.chat_widget_stream_status.reasoning_final=" + "history=" + action.historyInserted + ":reasoning="
						+ action.reasoningBufferLength + ":full=" + action.fullReasoningBufferLength + ":cleared=" + action.reasoningCleared + ":redraw="
						+ action.requestRedraw);
				case TuiSmokeChatWidgetStreamStatusActionKind.RestoreReasoningHeader:
					trace.push("tui.chat_widget_stream_status.restore_header=" + action.header + ":title=" + action.titleKind + ":task="
						+ action.taskRunning + ":status=" + action.statusUpdated);
				case TuiSmokeChatWidgetStreamStatusActionKind.AssistantMessageCompleted:
					trace.push("tui.chat_widget_stream_status.message_completed=" + action.phase + ":pending_steers=" + action.pendingSteers + ":restore="
						+ action.pendingRestoreBefore + "->" + action.pendingRestoreAfter + ":idle=" + action.streamIdle + ":status_restored="
						+ action.statusRestored);
				case TuiSmokeChatWidgetStreamStatusActionKind.StreamIdleRestore:
					trace.push("tui.chat_widget_stream_status.idle_restore=" + "pending=" + action.pendingRestoreBefore + "->" + action.pendingRestoreAfter
						+ ":task=" + action.taskRunning + ":idle=" + action.streamIdle + ":queued=" + action.queuedLines + ":ensured=" + action.statusEnsured
						+ ":restored=" + action.statusRestored);
				case TuiSmokeChatWidgetStreamStatusActionKind.StreamError:
					trace.push("tui.chat_widget_stream_status.stream_error=" + action.header + ":details=" + action.details + ":title=" + action.titleKind
						+ ":retry=" + action.retryHeaderRemembered + ":ensured=" + action.statusEnsured + ":max=" + action.detailsMaxLines);
				case TuiSmokeChatWidgetStreamStatusActionKind.RunState:
					trace.push("tui.chat_widget_stream_status.run_state=" + action.titleKind + ":task=" + action.taskRunning + ":text=" + action.runState
						+ ":title_status=" + action.titleUsesStatus + ":refreshed=" + action.statusSurfacesRefreshed);
				case TuiSmokeChatWidgetStreamStatusActionKind.Failure:
					trace.push("tui.chat_widget_stream_status.failure=" + action.failureCode + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.chat_widget_stream_status.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceMcpStartup(plan:TuiSmokeMcpStartupPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveTerminal || plan.allowRatatuiRender || plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.chat_widget_mcp_startup.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.chat_widget_mcp_startup.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeMcpStartupActionKind.SetExpectedServers:
					trace.push("tui.chat_widget_mcp_startup.expected=" + action.expectedServers + ":count=" + action.expectedCount + ":ignore="
						+ action.ignoreUntilNextStartBefore + "->" + action.ignoreUntilNextStartAfter);
				case TuiSmokeMcpStartupActionKind.StatusUpdate:
					trace.push("tui.chat_widget_mcp_startup.update=" + action.server + ":" + action.status + ":complete=" + action.completeWhenSettled
						+ ":ignore=" + action.ignoreUntilNextStartBefore + "->" + action.ignoreUntilNextStartAfter + ":pending=" + action.pendingCountBefore
						+ "->" + action.pendingCountAfter + ":active=" + action.activeCountBefore + "->" + action.activeCountAfter + ":starting="
						+ action.startingServers + ":header=" + action.header + ":warning=" + action.warningInserted + ":duplicate="
						+ action.duplicateWarningSuppressed + ":task=" + action.taskRunningBefore + "->" + action.taskRunningAfter + ":redraw="
						+ action.requestRedraw);
				case TuiSmokeMcpStartupActionKind.FinishAfterLag:
					trace.push("tui.chat_widget_mcp_startup.finish_after_lag=" + "active=" + action.activeServers + ":failed=" + action.failedServers
						+ ":cancelled=" + action.cancelledServers + ":ignore=" + action.ignoreUntilNextStartBefore + "->" + action.ignoreUntilNextStartAfter
						+ ":allow_terminal=" + action.allowTerminalOnlyBefore + "->" + action.allowTerminalOnlyAfter + ":summary=" + action.summaryInserted
						+ ":text=" + action.summaryText + ":task=" + action.taskRunningBefore + "->" + action.taskRunningAfter + ":drain="
						+ action.queuedInputDrainRequested + ":submitted=" + action.queuedInputSubmitted + ":redraw=" + action.requestRedraw);
				case TuiSmokeMcpStartupActionKind.FinishStartup:
					trace.push("tui.chat_widget_mcp_startup.finish=" + "failed=" + action.failedServers + ":cancelled=" + action.cancelledServers
						+ ":owned=" + action.statusHeaderOwned + ":restore_status=" + action.statusRestored + ":ignore=" + action.ignoreUntilNextStartBefore
						+ "->" + action.ignoreUntilNextStartAfter + ":summary=" + action.summaryInserted + ":task=" + action.taskRunningBefore + "->"
						+ action.taskRunningAfter + ":drain=" + action.queuedInputDrainRequested + ":redraw=" + action.requestRedraw);
				case TuiSmokeMcpStartupActionKind.PendingRoundPromotion:
					trace.push("tui.chat_widget_mcp_startup.pending_round=" + action.pendingServers + ":count=" + action.pendingCountBefore + "->"
						+ action.pendingCountAfter + ":activated=" + action.pendingRoundActivated + ":saw_starting=" + action.sawStartingBefore + "->"
						+ action.sawStartingAfter + ":allow_terminal=" + action.allowTerminalOnlyBefore + "->" + action.allowTerminalOnlyAfter + ":active="
						+ action.activeCountBefore + "->" + action.activeCountAfter + ":task=" + action.taskRunningBefore + "->" + action.taskRunningAfter
						+ ":redraw=" + action.requestRedraw);
				case TuiSmokeMcpStartupActionKind.Failure:
					trace.push("tui.chat_widget_mcp_startup.failure=" + action.failureCode + ":no_live=" + action.noLiveTerminal + ":no_render="
						+ action.noRatatuiRender + ":no_model=" + action.noModelCall + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.chat_widget_mcp_startup.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceStatusSurface(plan:TuiSmokeStatusSurfacePlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveTerminal || plan.allowRatatuiRender || plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.chat_widget_status_surface.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.chat_widget_status_surface.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeStatusSurfaceActionKind.RefreshSurfaces:
					trace.push("tui.chat_widget_status_surface.refresh=" + "status_items=" + action.statusLineItems + ":title_items="
						+ action.terminalTitleItems + ":status_invalid=" + action.invalidStatusLineItems + ":title_invalid="
						+ action.invalidTerminalTitleItems + ":status_warn=" + action.statusInvalidWarningInserted + ":status_warn_suppressed="
						+ action.statusInvalidWarningSuppressed + ":title_warn=" + action.titleInvalidWarningInserted + ":title_warn_suppressed="
						+ action.titleInvalidWarningSuppressed + ":branch=uses:" + action.usesGitBranch + ",reset:" + action.branchReset + ",request:"
						+ action.branchRequested + ":git_summary=uses:" + action.usesGitSummary + ",reset:" + action.gitSummaryReset + ",request:"
						+ action.gitSummaryRequested + ":line=" + action.statusLineText + ":segments=" + action.statusLineSegmentCount + ":enabled="
						+ action.statusLineEnabled + ":hyperlink=" + action.statusLineHyperlink + ":hyperlink_cleared=" + action.hyperlinkCleared + ":title="
						+ action.terminalTitle + ":terminal_set=" + action.terminalTitleSet + ":terminal_clear=" + action.terminalTitleCleared + ":frame="
						+ action.frameScheduled);
				case TuiSmokeStatusSurfaceActionKind.RefreshTerminalTitle:
					trace.push("tui.chat_widget_status_surface.refresh_title=" + "items=" + action.terminalTitleItems + ":empty="
						+ action.terminalTitleEmptySelection + ":title=" + action.terminalTitle + ":last=" + action.lastTerminalTitleBefore + "->"
						+ action.lastTerminalTitleAfter + ":set=" + action.terminalTitleSet + ":clear=" + action.terminalTitleCleared + ":duplicate="
						+ action.terminalTitleSkippedDuplicate + ":no_visible=" + action.terminalTitleNoVisibleContent + ":frame=" + action.frameScheduled
						+ ":delay_ms=" + action.frameDelayMs);
				case TuiSmokeStatusSurfaceActionKind.SetStatus:
					trace.push("tui.chat_widget_status_surface.set_status=" + "header=" + action.statusHeader + ":details=" + action.statusDetails
						+ ":title_uses=" + action.titleUsesStatus + ":refreshed=" + action.statusSurfacesRefreshed);
				case TuiSmokeStatusSurfaceActionKind.SetupStatusLine:
					trace.push("tui.chat_widget_status_surface.setup_status_line=" + "items=" + action.configuredItems + ":committed="
						+ action.statusLineSetupCommitted + ":cancelled=" + action.statusLineSetupCancelled + ":refreshed=" + action.statusSurfacesRefreshed);
				case TuiSmokeStatusSurfaceActionKind.StatusLineBranch:
					trace.push("tui.chat_widget_status_surface.branch_update=" + "cwd=" + action.cwd + ":branch=" + action.branch + ":stale="
						+ action.branchStaleIgnored + ":refreshed=" + action.statusSurfacesRefreshed);
				case TuiSmokeStatusSurfaceActionKind.StatusLineGitSummary:
					trace.push("tui.chat_widget_status_surface.git_summary_update=" + "cwd=" + action.cwd + ":summary=" + action.gitSummary + ":stale="
						+ action.gitSummaryStaleIgnored + ":refreshed=" + action.statusSurfacesRefreshed);
				case TuiSmokeStatusSurfaceActionKind.PreviewTerminalTitle:
					trace.push("tui.chat_widget_status_surface.preview_title=" + "original=" + action.originalItems + ":preview=" + action.configuredItems
						+ ":started=" + action.terminalTitlePreviewStarted + ":refreshed=" + action.statusSurfacesRefreshed);
				case TuiSmokeStatusSurfaceActionKind.RevertTerminalTitlePreview:
					trace.push("tui.chat_widget_status_surface.revert_title=" + "original=" + action.originalItems + ":reverted="
						+ action.terminalTitlePreviewReverted + ":refreshed=" + action.statusSurfacesRefreshed);
				case TuiSmokeStatusSurfaceActionKind.SetupTerminalTitle:
					trace.push("tui.chat_widget_status_surface.setup_title=" + "items=" + action.configuredItems + ":committed="
						+ action.terminalTitleSetupCommitted + ":original_cleared=" + action.originalSnapshotCleared + ":refreshed="
						+ action.statusSurfacesRefreshed);
				case TuiSmokeStatusSurfaceActionKind.Failure:
					trace.push("tui.chat_widget_status_surface.failure=" + action.failureCode + ":no_live=" + action.noLiveTerminal + ":no_render="
						+ action.noRatatuiRender + ":no_model=" + action.noModelCall + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.chat_widget_status_surface.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceStatusSurfaceRender(plan:TuiSmokeStatusSurfaceRenderPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowRatatuiRender || plan.allowModelCall || plan.allowAppServerMutation || !plan.enabled()) {
			trace.push("tui.chat_widget_status_surface_render.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.chat_widget_status_surface_render.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeStatusSurfaceRenderActionKind.SelectItems:
					trace.push("tui.chat_widget_status_surface_render.select=" + "surface=" + action.surface + ":items=" + action.itemIds + ":count="
						+ action.itemCount + ":visible=" + action.visibleCount + ":status_line=" + action.statusLineEnabled + ":title="
						+ action.terminalTitleEnabled);
				case TuiSmokeStatusSurfaceRenderActionKind.Indicator:
					trace.push("tui.chat_widget_status_surface_render.indicator=" + action.indicator + ":model=" + action.model + ":branch=" + action.branch
						+ ":git=" + action.gitSummary + ":raw=" + action.rawOutputLabel + ":model_visible=" + action.modelVisible + ":branch_visible="
						+ action.branchVisible + ":git_visible=" + action.gitSummaryVisible + ":raw_visible=" + action.rawOutputVisible
						+ ":activity_visible=" + action.activityVisible + ":segments=" + action.segmentCount + ":branch_request=" + action.branchRequested
						+ ":git_request=" + action.gitSummaryRequested + ":hyperlink=" + action.hyperlinkAnnotated);
				case TuiSmokeStatusSurfaceRenderActionKind.Warning:
					trace.push("tui.chat_widget_status_surface_render.warning=" + action.warningCode + ":message=" + action.warningMessage + ":visible="
						+ action.warningsVisible + ":deduped=" + action.warningDeduped + ":count=" + action.warningCount + ":dedupe_count=" +
						action.dedupeCount);
				case TuiSmokeStatusSurfaceRenderActionKind.Preview:
					trace.push("tui.chat_widget_status_surface_render.preview=" + action.surface + ":items=" + action.previewItems + ":started="
						+ action.previewStarted + ":committed=" + action.previewCommitted + ":reverted=" + action.previewReverted);
				case TuiSmokeStatusSurfaceRenderActionKind.Refresh:
					trace.push("tui.chat_widget_status_surface_render.refresh=" + "run=" + action.runState + ":header=" + action.statusHeader + ":details="
						+ action.statusDetails + ":text=" + action.renderedText + ":revision=" + action.revisionBefore + "->" + action.revisionAfter
						+ ":redraw=" + action.redrawRequested + ":frame=" + action.frameScheduled);
				case TuiSmokeStatusSurfaceRenderActionKind.Failure:
					trace.push("tui.chat_widget_status_surface_render.failure=" + action.failureCode + ":no_render=" + action.noRatatuiRender + ":no_model="
						+ action.noModelCall + ":no_app_server=" + action.noAppServerMutation + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.chat_widget_status_surface_render.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceStatusState(plan:TuiSmokeStatusStatePlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveTerminal || plan.allowRatatuiRender || plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.chat_widget_status_state.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.chat_widget_status_state.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeStatusStateActionKind.DefaultState:
					trace.push("tui.chat_widget_status_state.default=" + "header=" + action.header + ":details=" + action.details + ":max="
						+ action.detailsMaxLines + ":title_kind=" + action.terminalTitleStatusKind + ":guardian_empty=" + action.guardianEmpty
						+ ":pending_restore=false");
				case TuiSmokeStatusStateActionKind.SetStatus:
					trace.push("tui.chat_widget_status_state.set_status=" + "header=" + action.header + ":details=" + action.details + ":max="
						+ action.detailsMaxLines + ":guardian_review=" + action.guardianReviewHeader);
				case TuiSmokeStatusStateActionKind.GuardianStartOrUpdate:
					trace.push("tui.chat_widget_status_state.guardian_start=" + "id=" + action.id + ":detail=" + action.detail + ":entries="
						+ action.entries + ":count=" + action.entryCount + ":header=" + action.header + ":details=" + action.details + ":max="
						+ action.detailsMaxLines + ":overflow=" + action.overflowCount + ":status=" + action.statusPresent);
				case TuiSmokeStatusStateActionKind.GuardianFinish:
					trace.push("tui.chat_widget_status_state.guardian_finish=" + "id=" + action.id + ":changed=" + action.changed + ":entries="
						+ action.entries + ":count=" + action.entryCount + ":empty=" + action.guardianEmpty + ":status=" + action.statusPresent + ":header="
						+ action.header + ":details=" + action.details);
				case TuiSmokeStatusStateActionKind.RetryHeaderRemember:
					trace.push("tui.chat_widget_status_state.retry_remember=" + "current=" + action.header + ":before=" + action.retryHeaderBefore
						+ ":after=" + action.retryHeaderAfter + ":remembered=" + action.retryHeaderRemembered);
				case TuiSmokeStatusStateActionKind.RetryHeaderTake:
					trace.push("tui.chat_widget_status_state.retry_take=" + "before=" + action.retryHeaderBefore + ":taken=" + action.takenHeader
						+ ":after=" + action.retryHeaderAfter + ":took=" + action.retryHeaderTaken);
				case TuiSmokeStatusStateActionKind.TerminalTitleStatusKind:
					trace.push("tui.chat_widget_status_state.title_kind=" + action.terminalTitleStatusKind);
				case TuiSmokeStatusStateActionKind.Failure:
					trace.push("tui.chat_widget_status_state.failure=" + action.failureCode + ":no_live=" + action.noLiveTerminal + ":no_render="
						+ action.noRatatuiRender + ":no_model=" + action.noModelCall + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.chat_widget_status_state.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceCommandLifecycle(plan:TuiSmokeCommandLifecyclePlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveTerminal || plan.allowProcessSpawn || plan.allowRatatuiRender || plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.chat_widget_command_lifecycle.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.chat_widget_command_lifecycle.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeCommandLifecycleActionKind.ProcessBegin:
					trace.push("tui.chat_widget_command_lifecycle.process_begin=" + action.callId + ":process=" + action.processId + ":command="
						+ action.commandDisplay + ":count=" + action.processCountBefore + "->" + action.processCountAfter + ":footer="
						+ action.footerProcesses + ":synced=" + action.footerSynced);
				case TuiSmokeCommandLifecycleActionKind.OutputChunk:
					trace.push("tui.chat_widget_command_lifecycle.output=" + action.callId + ":tracked=" + action.outputTracked + ":chunks="
						+ action.recentChunkCountBefore + "->" + action.recentChunkCountAfter + ":recent=" + action.recentChunks + ":trimmed="
						+ action.recentChunksTrimmed + ":redraw=" + action.requestRedraw);
				case TuiSmokeCommandLifecycleActionKind.ProcessEnd:
					trace.push("tui.chat_widget_command_lifecycle.process_end=" + action.callId + ":process=" + action.processId + ":count="
						+ action.processCountBefore + "->" + action.processCountAfter + ":footer=" + action.footerProcesses + ":synced=" + action.footerSynced);
				case TuiSmokeCommandLifecycleActionKind.CommandStarted:
					trace.push("tui.chat_widget_command_lifecycle.started=" + action.callId + ":source=" + action.source + ":command=" + action.command
						+ ":parsed=" + action.parsedKind + ":task=" + action.taskRunning + ":unified=" + action.unifiedSource + ":startup="
						+ action.startupSource + ":standard=" + action.standardToolCall + ":status=" + action.statusEnsured + ":running="
						+ action.runningCommandCountBefore + "->" + action.runningCommandCountAfter + ":grouped=" + action.commandGrouped
						+ ":wait_duplicate=" + action.waitDuplicateSuppressed + ":suppressed=" + action.suppressedExecCall + ":redraw=" + action.requestRedraw);
				case TuiSmokeCommandLifecycleActionKind.TerminalInteraction:
					trace.push("tui.chat_widget_command_lifecycle.terminal_interaction="
						+ action.processId
						+ ":stdin="
						+ action.stdin
						+ ":display="
						+ action.commandDisplay
						+ ":task="
						+ action.taskRunning
						+ ":status="
						+ action.statusHeader
						+ ":details="
						+ action.statusDetails
						+ ":created="
						+ action.waitStreakCreated
						+ ":updated="
						+ action.waitStreakUpdated
						+ ":flushed="
						+ action.waitStreakFlushed
						+ ":history="
						+ action.historyInserted
						+ ":redraw="
						+ action.requestRedraw);
				case TuiSmokeCommandLifecycleActionKind.CommandCompleted:
					trace.push("tui.chat_widget_command_lifecycle.completed=" + action.callId + ":source=" + action.source + ":target=" + action.endTarget
						+ ":exit=" + action.exitCode + ":duration_ms=" + action.durationMs + ":running=" + action.runningCommandCountBefore + "->"
						+ action.runningCommandCountAfter + ":active=" + action.activeCell + ":flushed=" + action.activeCellFlushed + ":history="
						+ action.historyInserted + ":redraw=" + action.activeCellRedrawn + ":suppressed_after_task=" + action.suppressedAfterTaskComplete
						+ ":drain=" + action.queuedInputDrainRequested + ":work=" + action.hadWorkActivity);
				case TuiSmokeCommandLifecycleActionKind.Failure:
					trace.push("tui.chat_widget_command_lifecycle.failure=" + action.failureCode + ":no_live=" + action.noLiveTerminal + ":no_process="
						+ action.noProcessSpawn + ":no_render=" + action.noRatatuiRender + ":no_model=" + action.noModelCall + ":unsupported="
						+ action.unsupportedRejected);
				case _:
					trace.push("tui.chat_widget_command_lifecycle.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceToolLifecycle(plan:TuiSmokeToolLifecyclePlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveToolExecution || plan.allowFilesystemMutation || plan.allowNetwork || plan.allowRatatuiRender
			|| plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.chat_widget_tool_lifecycle.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.chat_widget_tool_lifecycle.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeToolLifecycleActionKind.PatchApplyBegin:
					trace.push("tui.chat_widget_tool_lifecycle.patch_begin=" + "changes=" + action.changeCount + ":history=" + action.historyInserted
						+ ":activity=" + action.visibleTurnActivityRecorded);
				case TuiSmokeToolLifecycleActionKind.FileChangeCompleted:
					trace.push("tui.chat_widget_tool_lifecycle.file_change=" + action.status + ":failure_history=" + action.historyInserted + ":work="
						+ action.hadWorkActivity + ":queued_completed=" + action.queuedToCompleted);
				case TuiSmokeToolLifecycleActionKind.ViewImage:
					trace.push("tui.chat_widget_tool_lifecycle.view_image=" + action.path + ":answer_flush=" + action.answerStreamFlushed + ":history="
						+ action.historyInserted + ":redraw=" + action.requestRedraw);
				case TuiSmokeToolLifecycleActionKind.ImageGeneration:
					trace.push("tui.chat_widget_tool_lifecycle.image_generation=" + action.callId + ":prompt=" + action.revisedPrompt + ":path="
						+ action.savedPath + ":answer_flush=" + action.answerStreamFlushed + ":history=" + action.historyInserted + ":redraw="
						+ action.requestRedraw);
				case TuiSmokeToolLifecycleActionKind.McpToolStarted:
					trace.push("tui.chat_widget_tool_lifecycle.mcp_start=" + action.callId + ":server=" + action.server + ":tool=" + action.tool
						+ ":active=" + action.activeCellBefore + "->" + action.activeCellAfter + ":answer_flush=" + action.answerStreamFlushed + ":flushed="
						+ action.activeCellFlushed + ":redraw=" + action.requestRedraw);
				case TuiSmokeToolLifecycleActionKind.McpToolCompleted:
					trace.push("tui.chat_widget_tool_lifecycle.mcp_complete=" + action.callId + ":result=" + action.resultKind + ":matched="
						+ action.activeCellMatched + ":duration_ms=" + action.durationMs + ":error=" + action.errorMessage + ":flushed="
						+ action.activeCellFlushed + ":extra=" + action.extraHistoryInserted + ":work=" + action.hadWorkActivity);
				case TuiSmokeToolLifecycleActionKind.WebSearch:
					trace.push("tui.chat_widget_tool_lifecycle.web_search=" + action.callId + ":query=" + action.query + ":action=" + action.action
						+ ":matched=" + action.activeCellMatched + ":active=" + action.activeCellBefore + "->" + action.activeCellAfter + ":history="
						+ action.historyInserted + ":redraw=" + action.requestRedraw + ":work=" + action.hadWorkActivity);
				case TuiSmokeToolLifecycleActionKind.CollabEvent:
					trace.push("tui.chat_widget_tool_lifecycle.collab_event=" + action.summary + ":answer_flush=" + action.answerStreamFlushed + ":history="
						+ action.historyInserted + ":redraw=" + action.requestRedraw);
				case TuiSmokeToolLifecycleActionKind.CollabAgentTool:
					trace.push("tui.chat_widget_tool_lifecycle.collab_agent_tool=" + action.callId + ":tool=" + action.collabTool + ":status="
						+ action.collabStatus + ":spawn_cache=" + action.pendingSpawnCountBefore + "->" + action.pendingSpawnCountAfter + ":cached="
						+ action.spawnRequestCached + ":removed=" + action.spawnRequestRemoved + ":history=" + action.historyInserted);
				case TuiSmokeToolLifecycleActionKind.SubAgentActivity:
					trace.push("tui.chat_widget_tool_lifecycle.sub_agent=" + action.threadId + ":summary=" + action.summary + ":history="
						+ action.historyInserted);
				case TuiSmokeToolLifecycleActionKind.QueuedItemDispatch:
					trace.push("tui.chat_widget_tool_lifecycle.queued_dispatch=" + action.itemKind + ":started=" + action.queuedToStarted + ":completed="
						+ action.queuedToCompleted + ":started_count=" + action.queuedStartedCount + ":completed_count=" + action.queuedCompletedCount);
				case TuiSmokeToolLifecycleActionKind.Failure:
					trace.push("tui.chat_widget_tool_lifecycle.failure=" + action.failureCode + ":no_tool=" + action.noLiveToolExecution + ":no_fs="
						+ action.noFilesystemMutation + ":no_network=" + action.noNetwork + ":no_render=" + action.noRatatuiRender + ":no_model="
						+ action.noModelCall + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.chat_widget_tool_lifecycle.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceHookLifecycle(plan:TuiSmokeHookLifecyclePlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveHookExecution || plan.allowFilesystemMutation || plan.allowRatatuiRender || plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.chat_widget_hook_lifecycle.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.chat_widget_hook_lifecycle.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeHookLifecycleActionKind.HookStarted:
					trace.push("tui.chat_widget_hook_lifecycle.started=" + action.runId + ":hook=" + action.hookName + ":event=" + action.eventKind
						+ ":active=" + action.activeCellPresentBefore + "->" + action.activeCellPresentAfter + ":runs=" + action.activeRunCountBefore + "->"
						+ action.activeRunCountAfter + ":existing=" + action.existingActiveCell + ":completed_flush=" + action.completedOutputFlushed
						+ ":answer_flush=" + action.answerStreamFlushed + ":activity=" + action.visibleTurnActivityRecorded + ":revision="
						+ action.revisionBefore + "->" + action.revisionAfter + ":redraw=" + action.requestRedraw);
				case TuiSmokeHookLifecycleActionKind.HookCompleted:
					trace.push("tui.chat_widget_hook_lifecycle.completed=" + action.runId + ":hook=" + action.hookName + ":status=" + action.status
						+ ":matched=" + action.completedExistingRun + ":added=" + action.addedCompletedRun + ":created=" + action.createdCompletedCell
						+ ":empty=" + action.completedCellEmpty + ":output_flush=" + action.completedOutputFlushed + ":finish_idle=" + action.finishIdle
						+ ":history=" + action.historyInserted + ":active=" + action.activeCellPresentBefore + "->" + action.activeCellPresentAfter
						+ ":revision=" + action.revisionBefore + "->" + action.revisionAfter + ":redraw=" + action.requestRedraw);
				case TuiSmokeHookLifecycleActionKind.FlushCompletedOutput:
					trace.push("tui.chat_widget_hook_lifecycle.flush_completed=" + "taken=" + action.persistentOutputTaken + ":empty_after="
						+ action.activeCellEmpty + ":cleared=" + action.activeCellCleared + ":history=" + action.historyInserted + ":separator="
						+ action.needsFinalSeparator + ":cells=" + action.historyCellCount + ":revision=" + action.revisionBefore + "->" +
						action.revisionAfter);
				case TuiSmokeHookLifecycleActionKind.FinishActiveCell:
					trace.push("tui.chat_widget_hook_lifecycle.finish_active=" + "empty=" + action.activeCellEmpty + ":should_flush=" + action.shouldFlush
						+ ":cleared=" + action.activeCellCleared + ":history=" + action.historyInserted + ":separator=" + action.needsFinalSeparator
						+ ":revision=" + action.revisionBefore + "->" + action.revisionAfter);
				case TuiSmokeHookLifecycleActionKind.UpdateDueVisibility:
					trace.push("tui.chat_widget_hook_lifecycle.visibility=" + "advanced=" + action.advancedVisibility + ":finish_idle=" + action.finishIdle
						+ ":active=" + action.activeCellPresentBefore + "->" + action.activeCellPresentAfter + ":revision=" + action.revisionBefore + "->"
						+ action.revisionAfter);
				case TuiSmokeHookLifecycleActionKind.ScheduleTimer:
					trace.push("tui.chat_widget_hook_lifecycle.timer=" + "visible=" + action.visibleRunningRun + ":frame=" + action.frameScheduled
						+ ":delay_ms=" + action.timerDelayMs + ":deadline=" + action.deadlineScheduled);
				case TuiSmokeHookLifecycleActionKind.HooksListFetch:
					trace.push("tui.chat_widget_hook_lifecycle.fetch_hooks=" + "cwd=" + action.cwd + ":requested=" + action.fetchRequested + ":count="
						+ action.fetchCount);
				case TuiSmokeHookLifecycleActionKind.HooksLoaded:
					trace.push("tui.chat_widget_hook_lifecycle.hooks_loaded=" + "cwd=" + action.cwd + ":loaded=" + action.loadedCwd + ":stale="
						+ action.staleCwdIgnored + ":error=" + action.errorInserted + ":browser=" + action.browserOpened + ":redraw=" + action.requestRedraw
						+ ":message=" + action.errorMessage);
				case TuiSmokeHookLifecycleActionKind.OpenHooksBrowser:
					trace.push("tui.chat_widget_hook_lifecycle.open_browser=" + action.browserEntry + ":browser=" + action.browserOpened + ":redraw="
						+ action.requestRedraw);
				case TuiSmokeHookLifecycleActionKind.Failure:
					trace.push("tui.chat_widget_hook_lifecycle.failure=" + action.failureCode + ":no_hook=" + action.noLiveHookExecution + ":no_fs="
						+ action.noFilesystemMutation + ":no_render=" + action.noRatatuiRender + ":no_model=" + action.noModelCall + ":unsupported="
						+ action.unsupportedRejected);
				case _:
					trace.push("tui.chat_widget_hook_lifecycle.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceInputSubmission(plan:TuiSmokeInputSubmissionPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveProcess || plan.allowFilesystemMutation || plan.allowRatatuiRender || plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.chat_widget_input_submission.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.chat_widget_input_submission.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeInputSubmissionActionKind.TurnStart:
					trace.push("tui.chat_widget_input_submission.turn_start=" + "agent=" + action.agentTurnRunningBefore + "->"
						+ action.agentTurnRunningAfter + ":sleep=" + action.sleepTurnRunningBefore + "->" + action.sleepTurnRunningAfter + ":prevent_idle="
						+ action.preventIdleSleep);
				case TuiSmokeInputSubmissionActionKind.TurnFinish:
					trace.push("tui.chat_widget_input_submission.turn_finish=" + "agent=" + action.agentTurnRunningBefore + "->"
						+ action.agentTurnRunningAfter + ":sleep=" + action.sleepTurnRunningBefore + "->" + action.sleepTurnRunningAfter);
				case TuiSmokeInputSubmissionActionKind.TurnRestore:
					trace.push("tui.chat_widget_input_submission.turn_restore=" + "agent=" + action.agentTurnRunningBefore + "->"
						+ action.agentTurnRunningAfter + ":sleep=" + action.sleepTurnRunningBefore + "->" + action.sleepTurnRunningAfter + ":source="
						+ action.source);
				case TuiSmokeInputSubmissionActionKind.TurnReset:
					trace.push("tui.chat_widget_input_submission.turn_reset=" + "agent=" + action.agentTurnRunningBefore + "->"
						+ action.agentTurnRunningAfter + ":budget=" + action.budgetCountBefore + "->" + action.budgetCountAfter);
				case TuiSmokeInputSubmissionActionKind.PreventIdleSleep:
					trace.push("tui.chat_widget_input_submission.prevent_idle=" + action.preventIdleSleep + ":agent=" + action.agentTurnRunningAfter
						+ ":sleep=" + action.sleepTurnRunningAfter);
				case TuiSmokeInputSubmissionActionKind.BudgetLimited:
					trace.push("tui.chat_widget_input_submission.budget_limited=" + action.text + ":blocked=" + action.blocked + ":budget="
						+ action.budgetCountBefore + "->" + action.budgetCountAfter);
				case TuiSmokeInputSubmissionActionKind.ComposerSubmission:
					trace.push("tui.chat_widget_input_submission.composer=" + action.source + ":text=" + action.text + ":local=" + action.localImages
						+ ":remote=" + action.remoteImages + ":mentions=" + action.mentionBindings + ":configured=" + action.sessionConfigured
						+ ":plan_stream=" + action.planStreaming + ":queued=" + action.queued + ":submitted=" + action.submitted + ":reasoning="
						+ action.reasoningCleared + ":status=" + action.statusSet);
				case TuiSmokeInputSubmissionActionKind.PreSessionQueue:
					trace.push("tui.chat_widget_input_submission.pre_session_queue=" + action.text + ":configured=" + action.sessionConfigured + ":queued="
						+ action.queuedBefore + "->" + action.queuedAfter + ":preview=" + action.pendingPreviewRefreshed);
				case TuiSmokeInputSubmissionActionKind.EmptySubmission:
					trace.push("tui.chat_widget_input_submission.empty=" + "rejected=" + action.emptyRejected + ":accepted=" + action.accepted + ":queued="
						+ action.queued + ":submitted=" + action.submitted);
				case TuiSmokeInputSubmissionActionKind.BlockedImageRestore:
					trace.push("tui.chat_widget_input_submission.blocked_image=" + "model_supports=" + action.modelSupportsImages + ":local="
						+ action.localImages + ":remote=" + action.remoteImages + ":restored=" + action.restoredComposer + ":warning="
						+ action.warningInserted + ":redraw=" + action.requestRedraw);
				case TuiSmokeInputSubmissionActionKind.ShellEscape:
					trace.push("tui.chat_widget_input_submission.shell=" + action.shellCommand + ":allow=" + action.shellEscapeAllowed + ":help="
						+ action.shellHelpInserted + ":run=" + action.shellRunCommand + ":history=" + action.shellHistoryInserted + ":accepted="
						+ action.accepted);
				case TuiSmokeInputSubmissionActionKind.UserInputAssembly:
					trace.push("tui.chat_widget_input_submission.items=" + action.itemsSummary + ":text=" + action.text + ":remote=" + action.remoteImages
						+ ":local=" + action.localImages + ":elements=" + action.textElements + ":count=" + action.itemsCount);
				case TuiSmokeInputSubmissionActionKind.MentionRouting:
					trace.push("tui.chat_widget_input_submission.mentions=" + action.mentionsSummary + ":bindings=" + action.mentionBindings + ":skills="
						+ action.skillsCount + ":plugins=" + action.pluginsCount + ":apps=" + action.appsCount + ":dedupe=" + action.duplicatesSkipped);
				case TuiSmokeInputSubmissionActionKind.SubmitUserTurn:
					trace.push("tui.chat_widget_input_submission.submit_turn=" + action.model + ":mode=" + action.collaborationMode + ":items="
						+ action.itemsCount + ":accepted=" + action.accepted + ":op=" + action.appCommandCreated + ":history_append="
						+ action.historyAppended + ":mentions_encoded=" + action.mentionsEncoded + ":ide=" + action.ideContextApplied + ":separator="
						+ action.finalSeparatorCleared);
				case TuiSmokeInputSubmissionActionKind.PendingSteer:
					trace.push("tui.chat_widget_input_submission.pending_steer=" + action.previewText + ":render_history=" + action.renderInHistory
						+ ":pending=" + action.pendingSteersBefore + "->" + action.pendingSteersAfter + ":preview=" + action.pendingPreviewRefreshed);
				case TuiSmokeInputSubmissionActionKind.HistoryRender:
					trace.push("tui.chat_widget_input_submission.history=" + action.historyRecord + ":render=" + action.renderInHistory + ":history="
						+ action.historyBefore + "->" + action.historyAfter + ":display=" + action.displayInserted + ":cancel_edit="
						+ action.cancelEditRecorded + ":pending_start=" + action.userTurnPendingStart);
				case TuiSmokeInputSubmissionActionKind.QueueDrain:
					trace.push("tui.chat_widget_input_submission.queue_drain=" + action.action + ":queued=" + action.queuedBefore + "->"
						+ action.queuedAfter + ":submitted=" + action.submitted + ":preview=" + action.pendingPreviewRefreshed + ":task=" + action.taskRunning);
				case TuiSmokeInputSubmissionActionKind.Failure:
					trace.push("tui.chat_widget_input_submission.failure=" + action.failureCode + ":error=" + action.errorMessage + ":model_available="
						+ action.modelAvailable + ":no_process=" + action.noLiveProcess + ":no_fs=" + action.noFilesystemMutation + ":no_render="
						+ action.noRatatuiRender + ":no_model=" + action.noModelCall + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.chat_widget_input_submission.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceTurnRuntime(plan:TuiSmokeTurnRuntimePlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveProcess || plan.allowFilesystemMutation || plan.allowRatatuiRender || plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.chat_widget_turn_runtime.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.chat_widget_turn_runtime.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeTurnRuntimeActionKind.TaskRunningState:
					trace.push("tui.chat_widget_turn_runtime.task_running=" + "agent=" + action.agentTurnRunning + ":mcp=" + action.mcpStartupRunning
						+ ":bottom=" + action.taskRunningBefore + "->" + action.taskRunningAfter + ":nudge=true:surfaces=true");
				case TuiSmokeTurnRuntimeActionKind.TaskStarted:
					trace.push("tui.chat_widget_turn_runtime.task_started=" + "pending=" + action.pendingStartBefore + "->" + action.pendingStartAfter
						+ ":transcript=" + action.transcriptReset + ":chunking=" + action.adaptiveChunkingReset + ":plan_stream=" + action.planStreamCleared
						+ ":metrics=" + action.runtimeMetricsReset + ":telemetry=" + action.telemetryReset + ":quit=" + action.quitHintCleared + ":hook="
						+ action.activeHookCellBefore + "->" + action.activeHookCellAfter + ":status=" + action.statusHeaderSet + ":interrupt="
						+ action.interruptHintVisible + ":title=" + action.terminalTitleWorking + ":reasoning=" + action.reasoningCleared + ":pet="
						+ action.petKind + ":redraw=" + action.requestRedraw);
				case TuiSmokeTurnRuntimeActionKind.RuntimeMetrics:
					trace.push("tui.chat_widget_turn_runtime.metrics=" + action.runtimeDelta + ":merged=" + action.metricsMerged + ":websocket="
						+ action.websocketTimingLogged + ":history=" + action.historyInserted);
				case TuiSmokeTurnRuntimeActionKind.TaskCompleted:
					trace.push("tui.chat_widget_turn_runtime.task_completed=" + "last=" + action.lastAgentMessage + ":copy=" + action.copySource
						+ ":notify=" + action.notificationResponse + ":answer_flush=" + action.answerStreamFlushed + ":plan_final=" + action.planFinalized
						+ ":plan_consolidated=" + action.planConsolidated + ":wait_flush=" + action.waitStreakFlushed + ":runtime="
						+ action.runtimeMetricsAttached + ":separator=" + action.finalSeparatorInserted + ":elapsed=" + action.elapsedSeconds + ":replay="
						+ action.fromReplay);
				case TuiSmokeTurnRuntimeActionKind.CompletionCleanup:
					trace.push("tui.chat_widget_turn_runtime.cleanup=" + "pending=" + action.pendingStartBefore + "->" + action.pendingStartAfter + ":turn="
						+ action.agentTurnRunning + ":task=" + action.taskRunningAfter + ":commands=" + action.runningCommandsBefore + "->"
						+ action.runningCommandsAfter + ":suppressed=" + action.suppressedExecBefore + "->" + action.suppressedExecAfter + ":status_refresh="
						+ action.statusLineRefreshRequested + ":git_refresh=" + action.gitSummaryRefreshRequested + ":pet=" + action.petKind + ":redraw="
						+ action.requestRedraw);
				case TuiSmokeTurnRuntimeActionKind.FollowUpBoundary:
					trace.push("tui.chat_widget_turn_runtime.follow_up=" + "queued=" + action.queuedFollowUps + ":started=" + action.followUpStarted
						+ ":goal=" + action.activeGoal + ":notify=" + action.notificationQueued + ":pending=" + action.pendingSteersBefore + "->"
						+ action.pendingSteersAfter + ":preview=" + action.pendingPreviewRefreshed);
				case TuiSmokeTurnRuntimeActionKind.PlanImplementationPrompt:
					trace.push("tui.chat_widget_turn_runtime.plan_prompt=" + "eligible=" + action.planPromptEligible + ":mode=" + action.mode
						+ ":plan_seen=" + action.planSeen + ":modal=" + action.modalActive + ":rate_limit=" + action.rateLimitPending + ":opened="
						+ action.promptOpened + ":notify=" + action.notificationQueued + ":context=" + action.contextLabel);
				case TuiSmokeTurnRuntimeActionKind.RateLimitPrompt:
					trace.push("tui.chat_widget_turn_runtime.rate_limit=" + action.status + ":shown=" + action.rateLimitPromptShown + ":task="
						+ action.taskRunningAfter + ":opened=" + action.promptOpened);
				case TuiSmokeTurnRuntimeActionKind.Notification:
					trace.push("tui.chat_widget_turn_runtime.notification=" + action.notificationKind + ":allowed=" + action.allowed + ":priority="
						+ action.priority + ":existing=" + action.existingPriority + ":stored=" + action.stored + ":posted=" + action.posted + ":display="
						+ action.display + ":redraw=" + action.requestRedraw);
				case TuiSmokeTurnRuntimeActionKind.Warning:
					trace.push("tui.chat_widget_turn_runtime.warning=" + action.source + ":displayed=" + action.warningDisplayed + ":deduped="
						+ action.warningDeduped + ":history=" + action.historyInserted + ":redraw=" + action.requestRedraw);
				case TuiSmokeTurnRuntimeActionKind.FinalizeTurn:
					trace.push("tui.chat_widget_turn_runtime.finalize=" + "active_cell=" + action.activeCellFinalized + ":hook=" + action.activeHookCleared
						+ ":turn=" + action.agentTurnRunning + ":task=" + action.taskRunningAfter + ":commands=" + action.runningCommandsBefore + "->"
						+ action.runningCommandsAfter + ":streams=" + action.streamsCleared + ":cancel=" + action.cancelEditCleared + ":status_refresh="
						+ action.statusLineRefreshRequested + ":rate_prompt=" + action.rateLimitPromptShown);
				case TuiSmokeTurnRuntimeActionKind.NonRetryError:
					trace.push("tui.chat_widget_turn_runtime.error=" + action.errorKind + ":message=" + action.message + ":error_cell="
						+ action.errorInserted + ":cyber=" + action.cyberPolicy + ":owner_nudge=" + action.ownerNudgeOpened + ":queue_drain="
						+ action.queueDrainAttempted + ":pet=" + action.petKind);
				case TuiSmokeTurnRuntimeActionKind.PlanUpdate:
					trace.push("tui.chat_widget_turn_runtime.plan_update=" + action.planItemsCompleted + "/" + action.planItemsTotal + ":progress="
						+ action.planProgressRecorded + ":history=" + action.historyInserted + ":surfaces=true");
				case TuiSmokeTurnRuntimeActionKind.InterruptedMessage:
					trace.push("tui.chat_widget_turn_runtime.interrupted=" + action.source + ":message=" + action.message);
				case TuiSmokeTurnRuntimeActionKind.Failure:
					trace.push("tui.chat_widget_turn_runtime.failure=" + action.failureCode + ":no_process=" + action.noLiveProcess + ":no_fs="
						+ action.noFilesystemMutation + ":no_render=" + action.noRatatuiRender + ":no_model=" + action.noModelCall + ":unsupported="
						+ action.unsupportedRejected);
				case _:
					trace.push("tui.chat_widget_turn_runtime.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceSessionFlow(plan:TuiSmokeSessionFlowPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowFilesystemMutation || plan.allowNetwork || plan.allowRatatuiRender || plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.chat_widget_session_flow.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.chat_widget_session_flow.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeSessionFlowActionKind.ConfigureSession:
					trace.push("tui.chat_widget_session_flow.configure=" + action.display + ":thread=" + action.previousThreadId + "->" + action.threadId
						+ ":name=" + action.threadName + ":history=" + action.logId + "/" + action.historyEntryCount + ":copy_reset="
						+ action.copyHistoryReset + ":queue_clear=" + action.queueSubmissionsCleared + ":review_reset=" + action.reviewDenialsReset
						+ ":turn_reset=" + action.turnLifecycleReset + ":goal_clear=" + action.goalStatusCleared + ":cwd=" + action.cwd + ":roots="
						+ action.workspaceRoots + ":approval=" + action.approvalPolicy + ":permission=" + action.activePermissionProfile + ":fallback="
						+ action.permissionFallbackApplied + ":model=" + action.model + ":effort=" + action.reasoningEffort + ":collab="
						+ action.collaborationMode + ":mask=" + action.collaborationMaskInitialized + ":effective=" + action.effectiveCollaborationSet);
				case TuiSmokeSessionFlowActionKind.SessionHeader:
					trace.push("tui.chat_widget_session_flow.header=" + action.display + ":inserted=" + action.sessionInfoInserted + ":cleared="
						+ action.activeSessionHeaderCleared + ":revision=" + action.activeCellRevisionBumped + ":service=" + action.serviceTier
						+ ":copy_source_reset=" + action.copySourceReset + ":redraw=" + action.requestRedraw + ":suppress=" + action.suppressRedraw);
				case TuiSmokeSessionFlowActionKind.SkillsConnectors:
					trace.push("tui.chat_widget_session_flow.skills_connectors=" + "cleared=" + action.skillsCleared + ":reload="
						+ action.skillsReloadRequested + ":skills=" + action.skillsCount + ":connectors=" + action.connectorCount + ":prefetch="
						+ action.connectorsPrefetched + ":service_cmd=" + action.serviceTierCommandsSynced + ":personality_cmd="
						+ action.personalityCommandSynced + ":plugins_cmd=" + action.pluginsCommandSynced + ":goal_cmd=" + action.goalCommandSynced
						+ ":plugin_mentions=" + action.pluginMentionsRefreshed);
				case TuiSmokeSessionFlowActionKind.InitialUserMessage:
					trace.push("tui.chat_widget_session_flow.initial_message=" + action.initialMessage + ":submitted=" + action.initialMessageSubmitted
						+ ":suppressed=" + action.initialMessageSuppressed + ":sandbox_blocked=" + action.elevatedSandboxBlocked + ":queued="
						+ action.queuedBefore + "->" + action.queuedAfter);
				case TuiSmokeSessionFlowActionKind.ForkedThreadEvent:
					trace.push("tui.chat_widget_session_flow.fork_notice=" + action.forkedFromId + ":title=" + action.forkParentTitle + ":inserted="
						+ action.forkNoticeInserted + ":display=" + action.display);
				case TuiSmokeSessionFlowActionKind.ThreadNameUpdated:
					trace.push("tui.chat_widget_session_flow.thread_name=" + action.threadId + ":matched=" + action.threadMatched + ":name="
						+ action.threadName + ":confirm=" + action.renameConfirmationInserted + ":surfaces=" + action.statusSurfacesRefreshed + ":redraw="
						+ action.requestRedraw + ":drain=" + action.queuedInputDrainAttempted);
				case TuiSmokeSessionFlowActionKind.Failure:
					trace.push("tui.chat_widget_session_flow.failure=" + action.failureCode + ":error=" + action.errorMessage + ":no_fs="
						+ action.noFilesystemMutation + ":no_network=" + action.noNetwork + ":no_render=" + action.noRatatuiRender + ":no_model="
						+ action.noModelCall + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.chat_widget_session_flow.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceGoalDisplay(plan:TuiSmokeGoalDisplayPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowRatatuiRender || plan.allowModelCall || plan.allowAppServerMutation || !plan.enabled()) {
			trace.push("tui.goal_display.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.goal_display.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeGoalDisplayActionKind.Elapsed:
					final elapsed = formatGoalElapsedSeconds(action.seconds);
					if (elapsed != action.expectedElapsed) {
						trace.push("tui.goal_display.elapsed_mismatch=seconds=" + action.seconds + ":expected=" + action.expectedElapsed + ":actual=" +
							elapsed);
						return false;
					}
					trace.push("tui.goal_display.elapsed=seconds=" + action.seconds + ":label=" + elapsed);
				case TuiSmokeGoalDisplayActionKind.StatusLabel:
					final label = goalStatusLabel(action.status);
					if (label != action.expectedLabel) {
						trace.push("tui.goal_display.status_mismatch=status=" + action.status + ":expected=" + action.expectedLabel + ":actual=" + label);
						return false;
					}
					trace.push("tui.goal_display.status=" + action.status + ":label=" + label);
				case TuiSmokeGoalDisplayActionKind.UsageSummary:
					final summary = goalUsageSummary(action.objective, action.timeUsedSeconds, action.hasTokenBudget, action.tokensUsed, action.tokenBudget);
					if (summary != action.expectedSummary) {
						trace.push("tui.goal_display.summary_mismatch=status="
							+ action.status
							+ ":expected="
							+ action.expectedSummary
							+ ":actual="
							+ summary);
						return false;
					}
					trace.push("tui.goal_display.summary=" + action.status + ":time=" + action.timeUsedSeconds + ":budget=" + action.hasTokenBudget
						+ ":tokens=" + action.tokensUsed + "/" + action.tokenBudget + ":text=" + summary);
				case TuiSmokeGoalDisplayActionKind.Failure:
					trace.push("tui.goal_display.failure=" + action.failureCode + ":no_render=" + action.noRatatuiRender + ":no_model=" + action.noModelCall
						+ ":no_app_server=" + action.noAppServerMutation + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.goal_display.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceGitActionDirectives(plan:TuiSmokeGitActionDirectivePlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowGitMutation || plan.allowFilesystemMutation || plan.allowNetwork || plan.allowGithubCall
			|| plan.allowTerminalMutation || !plan.enabled()) {
			trace.push("tui.git_action_directives.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.git_action_directives.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeGitActionDirectiveActionKind.Parse:
					final parsed = parseAssistantMarkdownDirectives(action.markdown, action.cwd);
					if (parsed.visibleMarkdown != action.expectedVisibleMarkdown) {
						trace.push("tui.git_action_directives.visible_mismatch=" + action.name + ":expected=" + traceText(action.expectedVisibleMarkdown)
							+ ":actual=" + traceText(parsed.visibleMarkdown));
						return false;
					}
					if (!gitActionDirectivesMatch(parsed.directives, action.expectedDirectives)) {
						trace.push("tui.git_action_directives.action_mismatch=" + action.name + ":expected="
							+ gitActionDirectiveTrace(action.expectedDirectives) + ":actual=" + gitActionDirectiveTrace(parsed.directives));
						return false;
					}
					if (parsed.lastCreatedBranchCwd != action.expectedLastCreatedBranchCwd) {
						trace.push("tui.git_action_directives.last_branch_mismatch=" + action.name + ":expected=" + action.expectedLastCreatedBranchCwd
							+ ":actual=" + parsed.lastCreatedBranchCwd);
						return false;
					}
					trace.push("tui.git_action_directives.parse=" + action.name + ":visible=" + traceText(parsed.visibleMarkdown) + ":actions="
						+ gitActionDirectiveTrace(parsed.directives) + ":last_branch=" + parsed.lastCreatedBranchCwd);
				case TuiSmokeGitActionDirectiveActionKind.Failure:
					trace.push("tui.git_action_directives.failure=" + action.failureCode + ":no_git=" + action.noGitMutation + ":no_fs="
						+ action.noFilesystemMutation + ":no_network=" + action.noNetwork + ":no_github=" + action.noGithubCall + ":no_terminal="
						+ action.noTerminalMutation + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.git_action_directives.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceThreadTranscript(plan:TuiSmokeThreadTranscriptPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowAppServerRead || plan.allowRatatuiRender || plan.allowFilesystemMutation || plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.thread_transcript.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.thread_transcript.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeThreadTranscriptActionKind.Project:
					final cells = threadToTranscriptCells(action.items, action.cwd, action.rawReasoningVisibility);
					if (!threadTranscriptCellsMatch(cells, action.expectedCells)) {
						trace.push("tui.thread_transcript.cell_mismatch=" + action.name + ":expected=" + threadTranscriptCellTrace(action.expectedCells)
							+ ":actual=" + threadTranscriptCellTrace(cells));
						return false;
					}
					trace.push("tui.thread_transcript.project=" + action.name + ":visibility=" + action.rawReasoningVisibility + ":cells="
						+ threadTranscriptCellTrace(cells));
				case TuiSmokeThreadTranscriptActionKind.Failure:
					trace.push("tui.thread_transcript.failure=" + action.failureCode + ":no_read=" + action.noAppServerRead + ":no_render="
						+ action.noRatatuiRender + ":no_fs=" + action.noFilesystemMutation + ":no_model=" + action.noModelCall + ":unsupported="
						+ action.unsupportedRejected);
				case _:
					trace.push("tui.thread_transcript.unknown");
					return false;
			}
		}
		return true;
	}

	static function threadToTranscriptCells(items:Array<TuiSmokeThreadTranscriptItem>, cwd:String,
			rawReasoningVisibility:String):Array<TuiSmokeThreadTranscriptCell> {
		final cells:Array<TuiSmokeThreadTranscriptCell> = [];
		for (item in items) {
			switch item.kind {
				case TuiSmokeThreadTranscriptItemKind.UserMessage:
					cells.push(threadTranscriptCell(TuiSmokeThreadTranscriptCellKind.User, item.text));
				case TuiSmokeThreadTranscriptItemKind.AgentMessage:
					final parsed = parseAssistantMarkdownDirectives(item.text, cwd);
					if (StringTools.trim(parsed.visibleMarkdown) != "")
						cells.push(threadTranscriptCell(TuiSmokeThreadTranscriptCellKind.AgentMarkdown, parsed.visibleMarkdown));
				case TuiSmokeThreadTranscriptItemKind.Plan:
					if (StringTools.trim(item.text) != "")
						cells.push(threadTranscriptCell(TuiSmokeThreadTranscriptCellKind.Plan, item.text));
				case TuiSmokeThreadTranscriptItemKind.Reasoning:
					final reasoningText = rawReasoningVisibility == "visible"
						&& item.content.length > 0 ? item.content.join("\n\n") : item.summary.join("\n\n");
					if (StringTools.trim(reasoningText) != "")
						cells.push(threadTranscriptCell(TuiSmokeThreadTranscriptCellKind.Reasoning, reasoningText));
				case _:
					final fallback = fallbackTranscriptCell(item);
					if (fallback != null)
						cells.push(fallback);
			}
		}
		if (cells.length == 0)
			cells.push(threadTranscriptCell(TuiSmokeThreadTranscriptCellKind.Plain, "No transcript content available"));
		return cells;
	}

	static function fallbackTranscriptCell(item:TuiSmokeThreadTranscriptItem):Null<TuiSmokeThreadTranscriptCell> {
		final lines:Array<String> = [];
		switch item.kind {
			case TuiSmokeThreadTranscriptItemKind.HookPrompt:
				for (fragment in item.fragments)
					lines.push("hook prompt: " + StringTools.trim(fragment));
			case TuiSmokeThreadTranscriptItemKind.CommandExecution:
				lines.push("$ " + item.command);
				lines.push("status: " + item.status + (item.exitCode == "" ? "" : middleDot("exit " + item.exitCode)));
				if (StringTools.trim(item.aggregatedOutput) != "") {
					for (line in item.aggregatedOutput.split("\n"))
						lines.push("  " + StringTools.rtrim(line));
				}
			case TuiSmokeThreadTranscriptItemKind.FileChange:
				lines.push("file changes: " + item.status + middleDot(Std.string(item.changesCount) + " changes"));
			case TuiSmokeThreadTranscriptItemKind.McpToolCall:
				lines.push("mcp tool: " + item.server + "/" + item.tool + middleDot(item.status));
			case TuiSmokeThreadTranscriptItemKind.DynamicToolCall:
				final name = item.namespace == "" ? item.tool : item.namespace + "/" + item.tool;
				lines.push("tool: " + name + middleDot(item.status));
			case TuiSmokeThreadTranscriptItemKind.WebSearch:
				lines.push("web search: " + item.query);
			case TuiSmokeThreadTranscriptItemKind.ImageView:
				lines.push("image: " + item.path);
			case TuiSmokeThreadTranscriptItemKind.ImageGeneration:
				lines.push("image generation: " + item.status + (item.savedPath == "" ? "" : middleDot(item.savedPath)));
			case TuiSmokeThreadTranscriptItemKind.EnteredReviewMode:
				lines.push("review started: " + item.review);
			case TuiSmokeThreadTranscriptItemKind.ExitedReviewMode:
				lines.push("review finished: " + item.review);
			case TuiSmokeThreadTranscriptItemKind.ContextCompaction:
				lines.push("context compacted");
			case _:
		}
		return lines.length == 0 ? null : threadTranscriptCell(TuiSmokeThreadTranscriptCellKind.Plain, lines.join("\n"));
	}

	static function middleDot(text:String):String {
		return " " + String.fromCharCode(0xb7) + " " + text;
	}

	static function threadTranscriptCell(kind:TuiSmokeThreadTranscriptCellKind, text:String):TuiSmokeThreadTranscriptCell {
		return new TuiSmokeThreadTranscriptCell({kind: kind, text: text});
	}

	static function threadTranscriptCellsMatch(left:Array<TuiSmokeThreadTranscriptCell>, right:Array<TuiSmokeThreadTranscriptCell>):Bool {
		if (left.length != right.length)
			return false;
		for (index in 0...left.length) {
			if (threadTranscriptCellKey(left[index]) != threadTranscriptCellKey(right[index]))
				return false;
		}
		return true;
	}

	static function threadTranscriptCellTrace(cells:Array<TuiSmokeThreadTranscriptCell>):String {
		if (cells.length == 0)
			return "<none>";
		final out:Array<String> = [];
		for (cell in cells)
			out.push(cell.kind + "(" + traceText(cell.text) + ")");
		return out.join("|");
	}

	static function threadTranscriptCellKey(cell:TuiSmokeThreadTranscriptCell):String {
		return cell.kind + "\t" + cell.text;
	}

	static function traceLineTruncation(plan:TuiSmokeLineTruncationPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowRatatuiRender || plan.allowTerminalMutation || plan.allowFilesystemMutation || plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.line_truncation.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.line_truncation.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeLineTruncationActionKind.Width:
					final width = lineTruncationWidth(action.spans);
					if (width != action.expectedWidth) {
						trace.push("tui.line_truncation.width_mismatch=" + action.name + ":expected=" + action.expectedWidth + ":actual=" + width);
						return false;
					}
					trace.push("tui.line_truncation.width=" + action.name + ":width=" + width + ":spans=" + lineTruncationSpanTrace(action.spans));
				case TuiSmokeLineTruncationActionKind.Truncate:
					final spans = truncateLineToWidth(action.spans, action.maxWidth);
					if (!lineTruncationSpansMatch(spans, action.expectedSpans)) {
						trace.push("tui.line_truncation.truncate_mismatch=" + action.name + ":expected=" + lineTruncationSpanTrace(action.expectedSpans)
							+ ":actual=" + lineTruncationSpanTrace(spans));
						return false;
					}
					trace.push("tui.line_truncation.truncate=" + action.name + ":max=" + action.maxWidth + ":spans=" + lineTruncationSpanTrace(spans));
				case TuiSmokeLineTruncationActionKind.Ellipsis:
					final spans = truncateLineWithEllipsisIfOverflow(action.spans, action.maxWidth);
					if (!lineTruncationSpansMatch(spans, action.expectedSpans)) {
						trace.push("tui.line_truncation.ellipsis_mismatch=" + action.name + ":expected=" + lineTruncationSpanTrace(action.expectedSpans)
							+ ":actual=" + lineTruncationSpanTrace(spans));
						return false;
					}
					trace.push("tui.line_truncation.ellipsis=" + action.name + ":max=" + action.maxWidth + ":spans=" + lineTruncationSpanTrace(spans));
				case TuiSmokeLineTruncationActionKind.Failure:
					trace.push("tui.line_truncation.failure=" + action.failureCode + ":no_render=" + action.noRatatuiRender + ":no_terminal="
						+ action.noTerminalMutation + ":no_fs=" + action.noFilesystemMutation + ":no_model=" + action.noModelCall + ":unsupported="
						+ action.unsupportedRejected);
				case _:
					trace.push("tui.line_truncation.unknown");
					return false;
			}
		}
		return true;
	}

	static function truncateLineWithEllipsisIfOverflow(spans:Array<TuiSmokeLineTruncationSpan>, maxWidth:Int):Array<TuiSmokeLineTruncationSpan> {
		if (maxWidth <= 0)
			return [];
		if (lineTruncationWidth(spans) <= maxWidth)
			return copyLineTruncationSpans(spans);
		final truncated = truncateLineToWidth(spans, maxWidth - 1);
		final ellipsisStyle = truncated.length == 0 ? "" : truncated[truncated.length - 1].style;
		truncated.push(lineTruncationSpan(String.fromCharCode(0x2026), ellipsisStyle));
		return truncated;
	}

	static function truncateLineToWidth(spans:Array<TuiSmokeLineTruncationSpan>, maxWidth:Int):Array<TuiSmokeLineTruncationSpan> {
		if (maxWidth <= 0)
			return [];
		final out:Array<TuiSmokeLineTruncationSpan> = [];
		var used = 0;
		for (span in spans) {
			if (used >= maxWidth)
				break;
			final spanWidth = lineTruncationSpanWidth(span);
			if (used + spanWidth <= maxWidth) {
				out.push(lineTruncationSpan(span.text, span.style));
				used += spanWidth;
				continue;
			}
			var text = "";
			var index = 0;
			while (index < span.text.length) {
				final character = span.text.charAt(index);
				final width = lineTruncationCharacterWidth(character);
				if (used + width > maxWidth)
					break;
				text += character;
				used += width;
				index++;
			}
			if (text != "")
				out.push(lineTruncationSpan(text, span.style));
			break;
		}
		return out;
	}

	static function copyLineTruncationSpans(spans:Array<TuiSmokeLineTruncationSpan>):Array<TuiSmokeLineTruncationSpan> {
		final out:Array<TuiSmokeLineTruncationSpan> = [];
		for (span in spans)
			out.push(lineTruncationSpan(span.text, span.style));
		return out;
	}

	static function lineTruncationWidth(spans:Array<TuiSmokeLineTruncationSpan>):Int {
		var width = 0;
		for (span in spans)
			width += lineTruncationSpanWidth(span);
		return width;
	}

	static function lineTruncationSpanWidth(span:TuiSmokeLineTruncationSpan):Int {
		var width = 0;
		var index = 0;
		while (index < span.text.length) {
			width += lineTruncationCharacterWidth(span.text.charAt(index));
			index++;
		}
		return width;
	}

	static function lineTruncationCharacterWidth(character:String):Int {
		return character.length == 0 ? 0 : (character.charCodeAt(0) == 0x754c ? 2 : 1);
	}

	static function lineTruncationSpansMatch(left:Array<TuiSmokeLineTruncationSpan>, right:Array<TuiSmokeLineTruncationSpan>):Bool {
		if (left.length != right.length)
			return false;
		for (index in 0...left.length) {
			if (lineTruncationSpanKey(left[index]) != lineTruncationSpanKey(right[index]))
				return false;
		}
		return true;
	}

	static function lineTruncationSpanTrace(spans:Array<TuiSmokeLineTruncationSpan>):String {
		if (spans.length == 0)
			return "<none>";
		final out:Array<String> = [];
		for (span in spans)
			out.push((span.style == "" ? "<default>" : span.style) + "[" + traceText(span.text) + "]");
		return out.join("|");
	}

	static function lineTruncationSpanKey(span:TuiSmokeLineTruncationSpan):String {
		return span.style + "\t" + span.text;
	}

	static function lineTruncationSpan(text:String, style:String):TuiSmokeLineTruncationSpan {
		return new TuiSmokeLineTruncationSpan({text: text, style: style});
	}

	static function traceMarkdownTextMerge(plan:TuiSmokeMarkdownTextMergePlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowTerminalMutation || plan.allowFilesystemMutation || plan.allowNetwork || plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.markdown_text_merge.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.markdown_text_merge.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeMarkdownTextMergeActionKind.Merge:
					final events = mergeDecodedMarkdownText(action.events);
					if (!markdownTextEventsMatch(events, action.expectedEvents)) {
						trace.push("tui.markdown_text_merge.merge_mismatch=" + action.name + ":expected=" + markdownTextEventTrace(action.expectedEvents)
							+ ":actual=" + markdownTextEventTrace(events));
						return false;
					}
					trace.push("tui.markdown_text_merge.merge=" + action.name + ":events=" + markdownTextEventTrace(events));
				case TuiSmokeMarkdownTextMergeActionKind.Failure:
					trace.push("tui.markdown_text_merge.failure=" + action.failureCode + ":no_terminal=" + action.noTerminalMutation + ":no_fs="
						+ action.noFilesystemMutation + ":no_network=" + action.noNetwork + ":no_model=" + action.noModelCall + ":unsupported="
						+ action.unsupportedRejected);
				case _:
					trace.push("tui.markdown_text_merge.unknown");
					return false;
			}
		}
		return true;
	}

	static function mergeDecodedMarkdownText(events:Array<TuiSmokeMarkdownTextEvent>):Array<TuiSmokeMarkdownTextEvent> {
		final out:Array<TuiSmokeMarkdownTextEvent> = [];
		var index = 0;
		while (index < events.length) {
			final event = events[index];
			if (event.kind != TuiSmokeMarkdownTextEventKind.Text
				|| index + 1 >= events.length
				|| events[index + 1].kind != TuiSmokeMarkdownTextEventKind.Text) {
				out.push(markdownTextEvent(event.kind, event.text, event.start, event.end));
				index++;
				continue;
			}

			final start = event.start;
			var end = event.end;
			var text = event.text;
			index++;
			while (index < events.length && events[index].kind == TuiSmokeMarkdownTextEventKind.Text) {
				final next = events[index];
				text += next.text;
				end = next.end;
				index++;
			}
			out.push(markdownTextEvent(TuiSmokeMarkdownTextEventKind.Text, text, start, end));
		}
		return out;
	}

	static function markdownTextEventsMatch(left:Array<TuiSmokeMarkdownTextEvent>, right:Array<TuiSmokeMarkdownTextEvent>):Bool {
		if (left.length != right.length)
			return false;
		for (index in 0...left.length) {
			if (markdownTextEventKey(left[index]) != markdownTextEventKey(right[index]))
				return false;
		}
		return true;
	}

	static function markdownTextEventTrace(events:Array<TuiSmokeMarkdownTextEvent>):String {
		if (events.length == 0)
			return "<none>";
		final out:Array<String> = [];
		for (event in events)
			out.push(event.kind + "[" + traceText(event.text) + "]@" + event.start + ".." + event.end);
		return out.join("|");
	}

	static function markdownTextEventKey(event:TuiSmokeMarkdownTextEvent):String {
		return event.kind + "\t" + event.text + "\t" + event.start + "\t" + event.end;
	}

	static function markdownTextEvent(kind:TuiSmokeMarkdownTextEventKind, text:String, start:Int, end:Int):TuiSmokeMarkdownTextEvent {
		return new TuiSmokeMarkdownTextEvent({
			kind: kind,
			text: text,
			start: start,
			end: end
		});
	}

	static function traceTextFormatting(plan:TuiSmokeTextFormattingPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowTerminalMutation || plan.allowFilesystemMutation || plan.allowNetwork || plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.text_formatting.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.text_formatting.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeTextFormattingActionKind.Capitalize:
					final actual = capitalizeFirst(action.input);
					if (!textFormattingExpected(action, actual, trace, "capitalize"))
						return false;
					trace.push("tui.text_formatting.capitalize=" + action.name + ":result=" + traceText(actual));
				case TuiSmokeTextFormattingActionKind.JsonCompact:
					final result = formatJsonCompact(action.input);
					final actual = result == null ? action.input : result;
					if (result != null != action.expectedFormatted || !textFormattingExpected(action, actual, trace, "json_compact"))
						return false;
					trace.push("tui.text_formatting.json_compact=" + action.name + ":formatted=" + (result != null) + ":result=" + traceText(actual));
				case TuiSmokeTextFormattingActionKind.TruncateText:
					final actual = truncateTextByScalar(action.input, action.maxGraphemes);
					if (!textFormattingExpected(action, actual, trace, "truncate_text"))
						return false;
					trace.push("tui.text_formatting.truncate_text=" + action.name + ":max=" + action.maxGraphemes + ":result=" + traceText(actual));
				case TuiSmokeTextFormattingActionKind.ToolResult:
					final actual = formatAndTruncateToolResult(action.input, action.maxLines, action.lineWidth);
					if (!textFormattingExpected(action, actual, trace, "tool_result"))
						return false;
					trace.push("tui.text_formatting.tool_result=" + action.name + ":lines=" + action.maxLines + ":width=" + action.lineWidth + ":result="
						+ traceText(actual));
				case TuiSmokeTextFormattingActionKind.CenterPath:
					final actual = centerTruncatePath(action.input, action.maxWidth);
					if (!textFormattingExpected(action, actual, trace, "center_path"))
						return false;
					trace.push("tui.text_formatting.center_path=" + action.name + ":max=" + action.maxWidth + ":result=" + traceText(actual));
				case TuiSmokeTextFormattingActionKind.ProperJoin:
					final actual = properJoin(action.items);
					if (!textFormattingExpected(action, actual, trace, "proper_join"))
						return false;
					trace.push("tui.text_formatting.proper_join=" + action.name + ":result=" + traceText(actual));
				case TuiSmokeTextFormattingActionKind.Failure:
					trace.push("tui.text_formatting.failure=" + action.failureCode + ":no_terminal=" + action.noTerminalMutation + ":no_fs="
						+ action.noFilesystemMutation + ":no_network=" + action.noNetwork + ":no_model=" + action.noModelCall + ":unsupported="
						+ action.unsupportedRejected);
				case _:
					trace.push("tui.text_formatting.unknown");
					return false;
			}
		}
		return true;
	}

	static function textFormattingExpected(action:TuiSmokeTextFormattingAction, actual:String, trace:Array<String>, label:String):Bool {
		if (actual == action.expected)
			return true;
		trace.push("tui.text_formatting."
			+ label
			+ "_mismatch="
			+ action.name
			+ ":expected="
			+ traceText(action.expected)
			+ ":actual="
			+ traceText(actual));
		return false;
	}

	static function capitalizeFirst(input:String):String {
		return input.length == 0 ? "" : uppercaseAscii(input.charAt(0)) + input.substr(1);
	}

	static function formatAndTruncateToolResult(text:String, maxLines:Int, lineWidth:Int):String {
		final maxGraphemes = intMax(0, maxLines * lineWidth - maxLines);
		final formatted = formatJsonCompact(text);
		return truncateTextByScalar(formatted == null ? text : formatted, maxGraphemes);
	}

	static function formatJsonCompact(text:String):Null<String> {
		final parsed = try codexhx.protocol.json.CodexJson.parse(text) catch (_:Dynamic) null;
		if (parsed == null)
			return null;
		if (!parsed.ok)
			return null;
		return jsonCompactValue(parsed.value);
	}

	static function jsonCompactValue(value:Value):String {
		return switch value {
			case JNull:
				"null";
			case JBool(value):
				Std.string(value);
			case JNumber(value):
				jsonNumberString(value);
			case JString(value):
				jsonQuote(value);
			case JArray(values):
				final out:Array<String> = [];
				for (item in values)
					out.push(jsonCompactValue(item));
				"[" + out.join(", ") + "]";
			case JObject(keys, values):
				final out:Array<String> = [];
				for (index in 0...keys.length)
					out.push(jsonQuote(keys[index]) + ": " + jsonCompactValue(values[index]));
				"{" + out.join(", ") + "}";
		}
	}

	static function jsonNumberString(value:Float):String {
		final asInt = Std.int(value);
		return value == asInt ? Std.string(asInt) : Std.string(value);
	}

	static function jsonQuote(value:String):String {
		var out = "\"";
		var index = 0;
		while (index < value.length) {
			final ch = value.charAt(index);
			out += switch ch {
				case "\"": "\\\"";
				case "\\": "\\\\";
				case "\n": "\\n";
				case "\r": "\\r";
				case "\t": "\\t";
				case _: ch;
			}
			index++;
		}
		return out + "\"";
	}

	static function truncateTextByScalar(text:String, maxGraphemes:Int):String {
		if (maxGraphemes < 0)
			maxGraphemes = 0;
		if (text.length <= maxGraphemes)
			return text;
		if (maxGraphemes >= 3)
			return text.substr(0, maxGraphemes - 3) + "...";
		return text.substr(0, maxGraphemes);
	}

	static function centerTruncatePath(path:String, maxWidth:Int):String {
		if (maxWidth <= 0)
			return "";
		if (displayWidth(path) <= maxWidth)
			return path;
		final hasLeadingSep = StringTools.startsWith(path, "/");
		final hasTrailingSep = StringTools.endsWith(path, "/");
		final rawSegments = path.split("/");
		if (hasLeadingSep && rawSegments.length > 0 && rawSegments[0] == "")
			rawSegments.shift();
		if (hasTrailingSep && rawSegments.length > 0 && rawSegments[rawSegments.length - 1] == "")
			rawSegments.pop();
		if (rawSegments.length == 0)
			return hasLeadingSep ? "/" : ellipsis();

		final segmentCount = rawSegments.length;
		final desiredSuffix = segmentCount > 1 ? intMin(2, segmentCount - 1) : 0;
		final combos:Array<{left:Int, right:Int}> = [];
		for (left in 1...segmentCount + 1) {
			final minRight = left == segmentCount ? 0 : 1;
			for (right in minRight...segmentCount - left + 1)
				combos.push({left: left, right: right});
		}
		combos.sort(function(a, b) {
			final aPriority = a.right >= desiredSuffix ? 1 : 0;
			final bPriority = b.right >= desiredSuffix ? 1 : 0;
			if (aPriority != bPriority)
				return bPriority - aPriority;
			if (a.left != b.left)
				return b.left - a.left;
			if (a.right != b.right)
				return b.right - a.right;
			return (b.left + b.right) - (a.left + a.right);
		});

		for (combo in combos) {
			final segments:Array<{
				original:String,
				text:String,
				truncatable:Bool,
				isSuffix:Bool
			}> = [];
			for (index in 0...combo.left)
				segments.push({
					original: rawSegments[index],
					text: rawSegments[index],
					truncatable: true,
					isSuffix: false
				});
			final needEllipsis = combo.left + combo.right < segmentCount;
			if (needEllipsis)
				segments.push({
					original: ellipsis(),
					text: ellipsis(),
					truncatable: false,
					isSuffix: false
				});
			if (combo.right > 0) {
				for (index in segmentCount - combo.right...segmentCount)
					segments.push({
						original: rawSegments[index],
						text: rawSegments[index],
						truncatable: true,
						isSuffix: true
					});
			}
			final candidate = fitPathSegments(segments, hasLeadingSep, maxWidth, needEllipsis || segmentCount <= 2, segmentCount);
			if (candidate != null)
				return candidate;
		}
		return frontTruncate(path, maxWidth);
	}

	static function fitPathSegments(segments:Array<{
		original:String,
		text:String,
		truncatable:Bool,
		isSuffix:Bool
	}>, hasLeadingSep:Bool, maxWidth:Int, allowFrontTruncate:Bool,
			segmentCount:Int):Null<String> {
		while (true) {
			final candidate = assemblePathSegments(hasLeadingSep, segments);
			final width = displayWidth(candidate);
			if (width <= maxWidth)
				return candidate;
			if (!allowFrontTruncate)
				return null;
			final indices:Array<Int> = [];
			var index = segments.length - 1;
			while (index >= 0) {
				if (segments[index].truncatable && segments[index].isSuffix)
					indices.push(index);
				index--;
			}
			index = segments.length - 1;
			while (index >= 0) {
				if (segments[index].truncatable && !segments[index].isSuffix)
					indices.push(index);
				index--;
			}
			if (indices.length == 0)
				return null;
			var changed = false;
			for (idx in indices) {
				if (displayWidth(segments[idx].original) <= maxWidth && segmentCount > 2)
					continue;
				final otherWidth = width - displayWidth(segments[idx].text);
				final allowedWidth = intMax(1, maxWidth - otherWidth);
				final newText = frontTruncate(segments[idx].original, allowedWidth);
				if (newText != segments[idx].text) {
					segments[idx].text = newText;
					changed = true;
					break;
				}
			}
			if (!changed)
				return null;
		}
	}

	static function assemblePathSegments(hasLeadingSep:Bool, segments:Array<{
		original:String,
		text:String,
		truncatable:Bool,
		isSuffix:Bool
	}>):String {
		var result = hasLeadingSep ? "/" : "";
		for (segment in segments) {
			if (result != "" && !StringTools.endsWith(result, "/"))
				result += "/";
			result += segment.text;
		}
		return result;
	}

	static function frontTruncate(original:String, allowedWidth:Int):String {
		if (allowedWidth <= 0)
			return "";
		if (displayWidth(original) <= allowedWidth)
			return original;
		if (allowedWidth == 1)
			return ellipsis();
		final allowedTail = allowedWidth - 1;
		return ellipsis() + original.substr(intMax(0, original.length - allowedTail));
	}

	static function displayWidth(value:String):Int {
		return value.length;
	}

	static function uppercaseAscii(value:String):String {
		if (value.length == 0)
			return "";
		final code = value.charCodeAt(0);
		return code >= "a".code && code <= "z".code ? String.fromCharCode(code - 32) : value;
	}

	static function properJoin(items:Array<String>):String {
		return switch items.length {
			case 0:
				"";
			case 1:
				items[0];
			case 2:
				items[0] + " and " + items[1];
			case _:
				final prefix:Array<String> = [];
				for (index in 0...items.length - 1)
					prefix.push(items[index]);
				prefix.join(", ") + " and " + items[items.length - 1];
		}
	}

	static function ellipsis():String {
		return String.fromCharCode(0x2026);
	}

	static function traceLiveWrap(plan:TuiSmokeLiveWrapPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowTerminalMutation || plan.allowFilesystemMutation || plan.allowNetwork || plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.live_wrap.rejected=live_or_missing");
			return false;
		}
		final state = liveWrapState(1);
		trace.push("tui.live_wrap.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeLiveWrapActionKind.Reset:
					liveWrapReset(state, action.width);
					trace.push("tui.live_wrap.reset=" + action.name + ":width=" + state.targetWidth);
				case TuiSmokeLiveWrapActionKind.Push:
					liveWrapPushFragment(state, action.fragment);
					trace.push("tui.live_wrap.push=" + action.name + ":fragment=" + traceText(action.fragment) + ":display="
						+ liveWrapRowTrace(liveWrapDisplayRows(state)));
				case TuiSmokeLiveWrapActionKind.EndLine:
					liveWrapFlushCurrentLine(state, true);
					if (!liveWrapRowsExpected(action, liveWrapDisplayRows(state), trace, "end_line"))
						return false;
					trace.push("tui.live_wrap.end_line=" + action.name + ":display=" + liveWrapRowTrace(liveWrapDisplayRows(state)));
				case TuiSmokeLiveWrapActionKind.Rows:
					if (!liveWrapRowsExpected(action, state.rows, trace, "rows"))
						return false;
					trace.push("tui.live_wrap.rows=" + action.name + ":rows=" + liveWrapRowTrace(state.rows));
				case TuiSmokeLiveWrapActionKind.Display:
					final rows = liveWrapDisplayRows(state);
					if (!liveWrapRowsExpected(action, rows, trace, "display"))
						return false;
					trace.push("tui.live_wrap.display=" + action.name + ":rows=" + liveWrapRowTrace(rows));
				case TuiSmokeLiveWrapActionKind.SetWidth:
					liveWrapSetWidth(state, action.width);
					final rows = liveWrapDisplayRows(state);
					if (!liveWrapRowsExpected(action, rows, trace, "set_width"))
						return false;
					trace.push("tui.live_wrap.set_width=" + action.name + ":width=" + state.targetWidth + ":display=" + liveWrapRowTrace(rows));
				case TuiSmokeLiveWrapActionKind.Drain:
					final drained = liveWrapDrainCommitReady(state, action.maxKeep);
					final remaining = liveWrapDisplayRows(state);
					if (!liveWrapRowsExpected(action, drained, trace, "drain"))
						return false;
					if (!liveWrapRowsMatch(remaining, action.expectedRemainingRows)) {
						trace.push("tui.live_wrap.drain_remaining_mismatch=" + action.name + ":expected=" + liveWrapRowTrace(action.expectedRemainingRows)
							+ ":actual=" + liveWrapRowTrace(remaining));
						return false;
					}
					trace.push("tui.live_wrap.drain=" + action.name + ":max_keep=" + action.maxKeep + ":drained=" + liveWrapRowTrace(drained)
						+ ":remaining=" + liveWrapRowTrace(remaining));
				case TuiSmokeLiveWrapActionKind.Prefix:
					final result = liveWrapTakePrefixByWidth(action.text, action.maxCols);
					if (result.prefix != action.expectedPrefix
						|| result.suffix != action.expectedSuffix
						|| result.width != action.expectedWidth) {
						trace.push("tui.live_wrap.prefix_mismatch=" + action.name + ":expected=" + traceText(action.expectedPrefix) + "/"
							+ traceText(action.expectedSuffix) + "/" + action.expectedWidth + ":actual=" + traceText(result.prefix) + "/"
							+ traceText(result.suffix) + "/" + result.width);
						return false;
					}
					trace.push("tui.live_wrap.prefix=" + action.name + ":max=" + action.maxCols + ":prefix=" + traceText(result.prefix) + ":suffix="
						+ traceText(result.suffix) + ":width=" + result.width);
				case TuiSmokeLiveWrapActionKind.Failure:
					trace.push("tui.live_wrap.failure=" + action.failureCode + ":no_terminal=" + action.noTerminalMutation + ":no_fs="
						+ action.noFilesystemMutation + ":no_network=" + action.noNetwork + ":no_model=" + action.noModelCall + ":unsupported="
						+ action.unsupportedRejected);
				case _:
					trace.push("tui.live_wrap.unknown");
					return false;
			}
		}
		return true;
	}

	static function liveWrapState(width:Int):TuiSmokeLiveWrapState {
		return {
			targetWidth: intMax(1, width),
			currentLine: "",
			rows: []
		};
	}

	static function liveWrapReset(state:TuiSmokeLiveWrapState, width:Int):Void {
		state.targetWidth = intMax(1, width);
		state.currentLine = "";
		state.rows = [];
	}

	static function liveWrapSetWidth(state:TuiSmokeLiveWrapState, width:Int):Void {
		state.targetWidth = intMax(1, width);
		var all = "";
		for (row in state.rows) {
			all += row.text;
			if (row.explicitBreak)
				all += "\n";
		}
		all += state.currentLine;
		state.rows = [];
		state.currentLine = "";
		liveWrapPushFragment(state, all);
	}

	static function liveWrapPushFragment(state:TuiSmokeLiveWrapState, fragment:String):Void {
		if (fragment == "")
			return;
		var start = 0;
		var index = 0;
		while (index < fragment.length) {
			if (fragment.charAt(index) == "\n") {
				if (start < index)
					state.currentLine = state.currentLine + fragment.substr(start, index - start);
				liveWrapFlushCurrentLine(state, true);
				start = index + 1;
			}
			index++;
		}
		if (start < fragment.length) {
			state.currentLine = state.currentLine + fragment.substr(start);
			liveWrapWrapCurrentLine(state);
		}
	}

	static function liveWrapFlushCurrentLine(state:TuiSmokeLiveWrapState, explicitBreak:Bool):Void {
		liveWrapWrapCurrentLine(state);
		if (explicitBreak) {
			if (state.currentLine == "") {
				state.rows.push(liveWrapRow("", true));
			} else {
				state.rows.push(liveWrapRow(state.currentLine, true));
			}
		}
		state.currentLine = "";
	}

	static function liveWrapWrapCurrentLine(state:TuiSmokeLiveWrapState):Void {
		while (state.currentLine != "") {
			final result = liveWrapTakePrefixByWidth(state.currentLine, state.targetWidth);
			if (result.width == 0) {
				final first = state.currentLine.charAt(0);
				state.rows.push(liveWrapRow(first, false));
				state.currentLine = state.currentLine.substr(1);
			} else if (result.suffix == "") {
				break;
			} else {
				state.rows.push(liveWrapRow(result.prefix, false));
				state.currentLine = result.suffix;
			}
		}
	}

	static function liveWrapDisplayRows(state:TuiSmokeLiveWrapState):Array<TuiSmokeLiveWrapRow> {
		final out:Array<TuiSmokeLiveWrapRow> = [];
		for (row in state.rows)
			out.push(liveWrapRow(row.text, row.explicitBreak));
		if (state.currentLine != "")
			out.push(liveWrapRow(state.currentLine, false));
		return out;
	}

	static function liveWrapDrainCommitReady(state:TuiSmokeLiveWrapState, maxKeep:Int):Array<TuiSmokeLiveWrapRow> {
		final displayCount = state.rows.length + (state.currentLine == "" ? 0 : 1);
		if (displayCount <= maxKeep)
			return [];
		final toCommit = displayCount - maxKeep;
		final commitCount = intMin(toCommit, state.rows.length);
		final drained:Array<TuiSmokeLiveWrapRow> = [];
		for (_ in 0...commitCount) {
			drained.push(state.rows[0]);
			state.rows.splice(0, 1);
		}
		return drained;
	}

	static function liveWrapTakePrefixByWidth(text:String, maxCols:Int):TuiSmokeLiveWrapPrefix {
		if (maxCols <= 0 || text == "")
			return {
				prefix: "",
				suffix: text,
				width: 0
			};
		var cols = 0;
		var endIndex = 0;
		var index = 0;
		while (index < text.length) {
			final ch = text.charAt(index);
			final chWidth = liveWrapCharWidth(ch);
			if (cols + chWidth > maxCols)
				break;
			cols += chWidth;
			endIndex = index + 1;
			if (cols == maxCols)
				break;
			index++;
		}
		return {
			prefix: text.substr(0, endIndex),
			suffix: text.substr(endIndex),
			width: cols
		};
	}

	static function liveWrapCharWidth(ch:String):Int {
		if (ch == "")
			return 0;
		return ch.charCodeAt(0) == 0x754c ? 2 : 1;
	}

	static function liveWrapRowsExpected(action:TuiSmokeLiveWrapAction, actual:Array<TuiSmokeLiveWrapRow>, trace:Array<String>, label:String):Bool {
		if (liveWrapRowsMatch(actual, action.expectedRows))
			return true;
		trace.push("tui.live_wrap." + label + "_mismatch=" + action.name + ":expected=" + liveWrapRowTrace(action.expectedRows) + ":actual="
			+ liveWrapRowTrace(actual));
		return false;
	}

	static function liveWrapRowsMatch(left:Array<TuiSmokeLiveWrapRow>, right:Array<TuiSmokeLiveWrapRow>):Bool {
		if (left.length != right.length)
			return false;
		for (index in 0...left.length) {
			if (liveWrapRowKey(left[index]) != liveWrapRowKey(right[index]))
				return false;
		}
		return true;
	}

	static function liveWrapRowTrace(rows:Array<TuiSmokeLiveWrapRow>):String {
		if (rows.length == 0)
			return "<none>";
		final out:Array<String> = [];
		for (row in rows)
			out.push(traceText(row.text) + (row.explicitBreak ? "!" : "~") + ":" + row.width);
		return out.join("|");
	}

	static function liveWrapRowKey(row:TuiSmokeLiveWrapRow):String {
		return row.text + "\t" + row.explicitBreak + "\t" + row.width;
	}

	static function liveWrapRow(text:String, explicitBreak:Bool):TuiSmokeLiveWrapRow {
		return new TuiSmokeLiveWrapRow({
			text: text,
			explicitBreak: explicitBreak,
			width: liveWrapTextWidth(text)
		});
	}

	static function liveWrapTextWidth(text:String):Int {
		var width = 0;
		var index = 0;
		while (index < text.length) {
			width += liveWrapCharWidth(text.charAt(index));
			index++;
		}
		return width;
	}

	static function traceWrapping(plan:TuiSmokeWrappingPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowTerminalMutation || plan.allowFilesystemMutation || plan.allowNetwork || plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.wrapping.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.wrapping.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeWrappingActionKind.ContainsUrl:
					final actual = wrappingTextContainsUrl(action.text);
					if (actual != action.expectedBool) {
						trace.push("tui.wrapping.contains_url_mismatch=" + action.name + ":expected=" + action.expectedBool + ":actual=" + actual);
						return false;
					}
					trace.push("tui.wrapping.contains_url=" + action.name + ":value=" + actual + ":text=" + traceText(action.text));
				case TuiSmokeWrappingActionKind.LineContainsUrl:
					final actual = wrappingTextContainsUrl(wrappingSpanText(action.spans));
					if (actual != action.expectedBool) {
						trace.push("tui.wrapping.line_contains_url_mismatch=" + action.name + ":expected=" + action.expectedBool + ":actual=" + actual);
						return false;
					}
					trace.push("tui.wrapping.line_contains_url=" + action.name + ":value=" + actual + ":spans=" + wrappingSpanTrace(action.spans));
				case TuiSmokeWrappingActionKind.Mixed:
					final actual = wrappingLineHasMixedUrlAndNonUrlTokens(wrappingSpanText(action.spans));
					if (actual != action.expectedBool) {
						trace.push("tui.wrapping.mixed_mismatch=" + action.name + ":expected=" + action.expectedBool + ":actual=" + actual);
						return false;
					}
					trace.push("tui.wrapping.mixed=" + action.name + ":value=" + actual + ":spans=" + wrappingSpanTrace(action.spans));
				case TuiSmokeWrappingActionKind.AdaptiveWrap:
					final lines = wrappingAdaptiveLines(action.text, action.width, action.subsequentIndent);
					if (!wrappingLinesMatch(lines, action.expectedLines)) {
						trace.push("tui.wrapping.adaptive_mismatch=" + action.name + ":expected=" + wrappingLineTrace(action.expectedLines) + ":actual="
							+ wrappingLineTrace(lines));
						return false;
					}
					trace.push("tui.wrapping.adaptive=" + action.name + ":width=" + action.width + ":lines=" + wrappingLineTrace(lines));
				case TuiSmokeWrappingActionKind.RangeTrim:
					final ranges = wrappingTrimRanges(action.text, action.width);
					if (!wrappingRangesMatch(ranges, action.expectedRanges)) {
						trace.push("tui.wrapping.range_trim_mismatch=" + action.name + ":expected=" + wrappingRangeTrace(action.expectedRanges) + ":actual="
							+ wrappingRangeTrace(ranges));
						return false;
					}
					trace.push("tui.wrapping.range_trim=" + action.name + ":width=" + action.width + ":ranges=" + wrappingRangeTrace(ranges));
				case TuiSmokeWrappingActionKind.Failure:
					trace.push("tui.wrapping.failure=" + action.failureCode + ":no_terminal=" + action.noTerminalMutation + ":no_fs="
						+ action.noFilesystemMutation + ":no_network=" + action.noNetwork + ":no_model=" + action.noModelCall + ":unsupported="
						+ action.unsupportedRejected);
				case _:
					trace.push("tui.wrapping.unknown");
					return false;
			}
		}
		return true;
	}

	static function wrappingTextContainsUrl(text:String):Bool {
		final tokens = text.split(" ");
		for (token in tokens) {
			if (wrappingTokenIsUrlLike(token))
				return true;
		}
		return false;
	}

	static function wrappingLineHasMixedUrlAndNonUrlTokens(text:String):Bool {
		var sawUrl = false;
		var sawNonUrl = false;
		final tokens = text.split(" ");
		for (token in tokens) {
			if (wrappingTokenIsUrlLike(token)) {
				sawUrl = true;
			} else if (wrappingTokenIsSubstantiveNonUrl(token)) {
				sawNonUrl = true;
			}
			if (sawUrl && sawNonUrl)
				return true;
		}
		return false;
	}

	static function wrappingTokenIsUrlLike(raw:String):Bool {
		final token = wrappingTrimUrlToken(raw);
		if (token == "")
			return false;
		final schemeIndex = token.indexOf("://");
		if (schemeIndex > 0) {
			final scheme = token.substr(0, schemeIndex);
			final rest = token.substr(schemeIndex + 3);
			return wrappingValidScheme(scheme) && rest != "";
		}
		return wrappingBareTokenIsUrlLike(token);
	}

	static function wrappingBareTokenIsUrlLike(token:String):Bool {
		final split = wrappingFirstUrlPathSeparator(token);
		if (split < 0)
			return false;
		var host = token.substr(0, split);
		if (host == "")
			return false;
		final colon = host.lastIndexOf(":");
		if (colon >= 0) {
			final portText = host.substr(colon + 1);
			if (!wrappingValidPort(portText))
				return false;
			host = host.substr(0, colon);
		}
		if (host == "localhost")
			return colon >= 0;
		if (wrappingHostIsIpv4(host))
			return true;
		if (StringTools.startsWith(host, "www.") && host.indexOf(".", 4) > 4)
			return wrappingHostIsDomain(host);
		return wrappingHostIsDomain(host);
	}

	static function wrappingValidScheme(value:String):Bool {
		if (value == "" || !wrappingIsAsciiAlpha(value.charCodeAt(0)))
			return false;
		var index = 1;
		while (index < value.length) {
			final code = value.charCodeAt(index);
			if (!wrappingIsAsciiAlphaNumeric(code) && code != 43 && code != 45 && code != 46)
				return false;
			index++;
		}
		return true;
	}

	static function wrappingFirstUrlPathSeparator(value:String):Int {
		var best = -1;
		for (ch in ["/", "?", "#"]) {
			final found = value.indexOf(ch);
			if (found >= 0 && (best < 0 || found < best))
				best = found;
		}
		return best;
	}

	static function wrappingHostIsDomain(host:String):Bool {
		final dot = host.lastIndexOf(".");
		if (dot <= 0 || dot == host.length - 1)
			return false;
		final labels = host.split(".");
		for (label in labels) {
			if (label == "" || !wrappingDomainLabelOk(label))
				return false;
		}
		return true;
	}

	static function wrappingDomainLabelOk(label:String):Bool {
		var index = 0;
		while (index < label.length) {
			final code = label.charCodeAt(index);
			if (!wrappingIsAsciiAlphaNumeric(code) && code != 45)
				return false;
			index++;
		}
		return true;
	}

	static function wrappingHostIsIpv4(host:String):Bool {
		final parts = host.split(".");
		if (parts.length != 4)
			return false;
		for (part in parts) {
			if (part == "" || !wrappingAllDigits(part))
				return false;
			final parsed = Std.parseInt(part);
			if (parsed == null || parsed < 0 || parsed > 255)
				return false;
		}
		return true;
	}

	static function wrappingValidPort(value:String):Bool {
		if (value == "" || !wrappingAllDigits(value))
			return false;
		final parsed = Std.parseInt(value);
		return parsed != null && parsed >= 1 && parsed <= 65535;
	}

	static function wrappingAllDigits(value:String):Bool {
		var index = 0;
		while (index < value.length) {
			final code = value.charCodeAt(index);
			if (code < 48 || code > 57)
				return false;
			index++;
		}
		return true;
	}

	static function wrappingIsAsciiAlpha(code:Int):Bool {
		return (code >= 65 && code <= 90) || (code >= 97 && code <= 122);
	}

	static function wrappingIsAsciiAlphaNumeric(code:Int):Bool {
		return wrappingIsAsciiAlpha(code) || (code >= 48 && code <= 57);
	}

	static function wrappingTrimUrlToken(raw:String):String {
		var start = 0;
		var end = raw.length;
		while (start < end && wrappingIsTrimPunctuation(raw.charAt(start)))
			start++;
		while (end > start && wrappingIsTrimPunctuation(raw.charAt(end - 1)))
			end--;
		return raw.substr(start, end - start);
	}

	static function wrappingIsTrimPunctuation(ch:String):Bool {
		return ch == "(" || ch == ")" || ch == "[" || ch == "]" || ch == "{" || ch == "}" || ch == "<" || ch == ">" || ch == "," || ch == "." || ch == ";"
			|| ch == "!" || ch == "\"" || ch == "'";
	}

	static function wrappingTokenIsSubstantiveNonUrl(raw:String):Bool {
		final token = StringTools.trim(raw);
		if (token == "" || wrappingIsOrderedMarker(token) || wrappingIsDecorativeMarker(token))
			return false;
		final stripped = wrappingTrimUrlToken(token);
		var index = 0;
		while (index < stripped.length) {
			if (wrappingIsAsciiAlphaNumeric(stripped.charCodeAt(index)))
				return true;
			index++;
		}
		return false;
	}

	static function wrappingIsOrderedMarker(token:String):Bool {
		if (token.length < 2)
			return false;
		final last = token.charAt(token.length - 1);
		if (last != "." && last != ")")
			return false;
		return wrappingAllDigits(token.substr(0, token.length - 1));
	}

	static function wrappingIsDecorativeMarker(token:String):Bool {
		var index = 0;
		while (index < token.length) {
			final ch = token.charAt(index);
			if (ch != "-" && ch != "*" && ch != "+" && ch != "|" && ch != ">")
				return false;
			index++;
		}
		return token.length > 0;
	}

	static function wrappingAdaptiveLines(text:String, width:Int, subsequentIndent:String):Array<String> {
		final effectiveWidth = intMax(1, width);
		if (wrappingTextContainsUrl(text) && !wrappingLineHasMixedUrlAndNonUrlTokens(text))
			return [text];
		final trimmedStart = StringTools.ltrim(text);
		final tokens = wrappingSplitTokens(trimmedStart);
		final leading = text.substr(0, text.length - trimmedStart.length);
		final lines:Array<String> = [];
		var current = leading;
		for (token in tokens)
			current = wrappingAppendToken(lines, token, effectiveWidth, subsequentIndent, current);
		if (current != "")
			lines.push(current);
		return lines;
	}

	static function wrappingAppendToken(lines:Array<String>, token:String, width:Int, indent:String, current:String):String {
		final hasWord = StringTools.trim(current) != "";
		final separator = hasWord ? " " : "";
		final projected = current + separator + token;
		if (liveWrapTextWidth(projected) <= width) {
			current = projected;
		} else {
			if (hasWord) {
				lines.push(current);
				current = indent;
			}
			current = wrappingPlaceToken(lines, current, token, width, indent);
		}
		return current;
	}

	static function wrappingPlaceToken(lines:Array<String>, current:String, token:String, width:Int, indent:String):String {
		if (wrappingTokenIsUrlLike(token)) {
			if (StringTools.trim(current) != "")
				lines.push(current);
			return indent + token;
		}
		var remaining = token;
		var out = current;
		while (remaining != "") {
			final available = intMax(1, width - liveWrapTextWidth(out));
			if (liveWrapTextWidth(remaining) <= available) {
				out += remaining;
				remaining = "";
			} else {
				final prefix = liveWrapTakePrefixByWidth(remaining, available);
				out += prefix.prefix;
				lines.push(out);
				out = indent;
				remaining = prefix.suffix;
			}
		}
		return out;
	}

	static function wrappingSplitTokens(text:String):Array<String> {
		final out:Array<String> = [];
		var start = -1;
		var index = 0;
		while (index < text.length) {
			final ch = text.charAt(index);
			if (ch == " " || ch == "\t") {
				if (start >= 0) {
					out.push(text.substr(start, index - start));
					start = -1;
				}
			} else if (start < 0) {
				start = index;
			}
			index++;
		}
		if (start >= 0)
			out.push(text.substr(start));
		return out;
	}

	static function wrappingTrimRanges(text:String, width:Int):Array<TuiSmokeWrappingRange> {
		final ranges:Array<TuiSmokeWrappingRange> = [];
		final effectiveWidth = intMax(1, width);
		var index = 0;
		while (index < text.length) {
			while (index < text.length && text.charAt(index) == " ")
				index++;
			if (index >= text.length)
				break;
			final start = index;
			while (index < text.length && text.charAt(index) != " " && index - start < effectiveWidth)
				index++;
			ranges.push(new TuiSmokeWrappingRange({
				start: start,
				end: index
			}));
			while (index < text.length && text.charAt(index) != " " && index - start >= effectiveWidth) {
				final chunkStart = index;
				while (index < text.length && text.charAt(index) != " " && index - chunkStart < effectiveWidth)
					index++;
				ranges.push(new TuiSmokeWrappingRange({
					start: chunkStart,
					end: index
				}));
			}
		}
		return ranges;
	}

	static function wrappingSpanText(spans:Array<TuiSmokeWrappingSpan>):String {
		var out = "";
		for (span in spans)
			out += span.text;
		return out;
	}

	static function wrappingSpanTrace(spans:Array<TuiSmokeWrappingSpan>):String {
		final out:Array<String> = [];
		for (span in spans)
			out.push(traceText(span.text));
		return out.join("|");
	}

	static function wrappingLinesMatch(left:Array<String>, right:Array<String>):Bool {
		if (left.length != right.length)
			return false;
		for (index in 0...left.length) {
			if (left[index] != right[index])
				return false;
		}
		return true;
	}

	static function wrappingLineTrace(lines:Array<String>):String {
		if (lines.length == 0)
			return "<none>";
		final out:Array<String> = [];
		for (line in lines)
			out.push(traceText(line));
		return out.join("|");
	}

	static function wrappingRangesMatch(left:Array<TuiSmokeWrappingRange>, right:Array<TuiSmokeWrappingRange>):Bool {
		if (left.length != right.length)
			return false;
		for (index in 0...left.length) {
			if (left[index].start != right[index].start || left[index].end != right[index].end)
				return false;
		}
		return true;
	}

	static function wrappingRangeTrace(ranges:Array<TuiSmokeWrappingRange>):String {
		if (ranges.length == 0)
			return "<none>";
		final out:Array<String> = [];
		for (range in ranges)
			out.push(range.start + ".." + range.end);
		return out.join("|");
	}

	static function traceScrollState(plan:TuiSmokeScrollStatePlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowTerminalMutation || plan.allowFilesystemMutation || plan.allowNetwork || plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.scroll_state.rejected=live_or_missing");
			return false;
		}
		final state:TuiSmokeScrollState = scrollStateNew();
		trace.push("tui.scroll_state.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeScrollStateActionKind.Reset:
					scrollStateReset(state);
					if (!scrollStateMatches(action, state, trace, "reset"))
						return false;
					trace.push("tui.scroll_state.reset=" + action.name + ":state=" + scrollStateTrace(state));
				case TuiSmokeScrollStateActionKind.SetState:
					state.selectedIdx = action.selected;
					state.scrollTop = intMax(0, action.scrollTop);
					if (!scrollStateMatches(action, state, trace, "set_state"))
						return false;
					trace.push("tui.scroll_state.set=" + action.name + ":state=" + scrollStateTrace(state));
				case TuiSmokeScrollStateActionKind.ClampSelection:
					scrollStateClampSelection(state, action.len);
					if (!scrollStateMatches(action, state, trace, "clamp"))
						return false;
					trace.push("tui.scroll_state.clamp=" + action.name + ":len=" + action.len + ":state=" + scrollStateTrace(state));
				case TuiSmokeScrollStateActionKind.MoveUpWrap:
					scrollStateMoveUpWrap(state, action.len);
					if (!scrollStateMatches(action, state, trace, "move_up"))
						return false;
					trace.push("tui.scroll_state.move_up=" + action.name + ":len=" + action.len + ":state=" + scrollStateTrace(state));
				case TuiSmokeScrollStateActionKind.MoveDownWrap:
					scrollStateMoveDownWrap(state, action.len);
					if (!scrollStateMatches(action, state, trace, "move_down"))
						return false;
					trace.push("tui.scroll_state.move_down=" + action.name + ":len=" + action.len + ":state=" + scrollStateTrace(state));
				case TuiSmokeScrollStateActionKind.PageUpClamped:
					scrollStatePageUpClamped(state, action.len, action.visibleRows);
					if (!scrollStateMatches(action, state, trace, "page_up"))
						return false;
					trace.push("tui.scroll_state.page_up=" + action.name + ":len=" + action.len + ":visible=" + action.visibleRows + ":state="
						+ scrollStateTrace(state));
				case TuiSmokeScrollStateActionKind.PageDownClamped:
					scrollStatePageDownClamped(state, action.len, action.visibleRows);
					if (!scrollStateMatches(action, state, trace, "page_down"))
						return false;
					trace.push("tui.scroll_state.page_down=" + action.name + ":len=" + action.len + ":visible=" + action.visibleRows + ":state="
						+ scrollStateTrace(state));
				case TuiSmokeScrollStateActionKind.JumpTop:
					scrollStateJumpTop(state, action.len, action.visibleRows);
					if (!scrollStateMatches(action, state, trace, "jump_top"))
						return false;
					trace.push("tui.scroll_state.jump_top=" + action.name + ":len=" + action.len + ":visible=" + action.visibleRows + ":state="
						+ scrollStateTrace(state));
				case TuiSmokeScrollStateActionKind.JumpBottom:
					scrollStateJumpBottom(state, action.len, action.visibleRows);
					if (!scrollStateMatches(action, state, trace, "jump_bottom"))
						return false;
					trace.push("tui.scroll_state.jump_bottom=" + action.name + ":len=" + action.len + ":visible=" + action.visibleRows + ":state="
						+ scrollStateTrace(state));
				case TuiSmokeScrollStateActionKind.EnsureVisible:
					scrollStateEnsureVisible(state, action.len, action.visibleRows);
					if (!scrollStateMatches(action, state, trace, "ensure_visible"))
						return false;
					trace.push("tui.scroll_state.ensure_visible=" + action.name + ":len=" + action.len + ":visible=" + action.visibleRows + ":state="
						+ scrollStateTrace(state));
				case TuiSmokeScrollStateActionKind.Failure:
					trace.push("tui.scroll_state.failure=" + action.failureCode + ":no_terminal=" + action.noTerminalMutation + ":no_fs="
						+ action.noFilesystemMutation + ":no_network=" + action.noNetwork + ":no_model=" + action.noModelCall + ":unsupported="
						+ action.unsupportedRejected);
				case _:
					trace.push("tui.scroll_state.unknown");
					return false;
			}
		}
		return true;
	}

	static function scrollStateNew():TuiSmokeScrollState {
		return {
			selectedIdx: -1,
			scrollTop: 0
		};
	}

	static function scrollStateReset(state:TuiSmokeScrollState):Void {
		state.selectedIdx = -1;
		state.scrollTop = 0;
	}

	static function scrollStateClampSelection(state:TuiSmokeScrollState, len:Int):Void {
		if (scrollStateClearIfEmpty(state, len))
			return;
		final maxIdx = len - 1;
		state.selectedIdx = state.selectedIdx < 0 ? 0 : intMin(state.selectedIdx, maxIdx);
	}

	static function scrollStateMoveUpWrap(state:TuiSmokeScrollState, len:Int):Void {
		if (scrollStateClearIfEmpty(state, len))
			return;
		if (state.selectedIdx > 0) {
			state.selectedIdx = state.selectedIdx - 1;
		} else if (state.selectedIdx == 0) {
			state.selectedIdx = len - 1;
		} else {
			state.selectedIdx = 0;
		}
	}

	static function scrollStateMoveDownWrap(state:TuiSmokeScrollState, len:Int):Void {
		if (scrollStateClearIfEmpty(state, len))
			return;
		if (state.selectedIdx >= 0 && state.selectedIdx + 1 < len) {
			state.selectedIdx = state.selectedIdx + 1;
		} else {
			state.selectedIdx = 0;
		}
	}

	static function scrollStatePageUpClamped(state:TuiSmokeScrollState, len:Int, visibleRows:Int):Void {
		if (scrollStateClearIfEmpty(state, len))
			return;
		final step = intMax(1, visibleRows);
		final current = scrollStateCurrentClamped(state, len);
		state.selectedIdx = intMax(0, current - step);
		scrollStateEnsureVisible(state, len, visibleRows);
	}

	static function scrollStatePageDownClamped(state:TuiSmokeScrollState, len:Int, visibleRows:Int):Void {
		if (scrollStateClearIfEmpty(state, len))
			return;
		final step = intMax(1, visibleRows);
		final current = scrollStateCurrentClamped(state, len);
		state.selectedIdx = intMin(current + step, len - 1);
		scrollStateEnsureVisible(state, len, visibleRows);
	}

	static function scrollStateJumpTop(state:TuiSmokeScrollState, len:Int, visibleRows:Int):Void {
		if (scrollStateClearIfEmpty(state, len))
			return;
		state.selectedIdx = 0;
		scrollStateEnsureVisible(state, len, visibleRows);
	}

	static function scrollStateJumpBottom(state:TuiSmokeScrollState, len:Int, visibleRows:Int):Void {
		if (scrollStateClearIfEmpty(state, len))
			return;
		state.selectedIdx = len - 1;
		scrollStateEnsureVisible(state, len, visibleRows);
	}

	static function scrollStateEnsureVisible(state:TuiSmokeScrollState, len:Int, visibleRows:Int):Void {
		if (len == 0 || visibleRows == 0) {
			state.scrollTop = 0;
			return;
		}
		if (state.selectedIdx < 0) {
			state.scrollTop = 0;
			return;
		}
		if (state.selectedIdx < state.scrollTop) {
			state.scrollTop = state.selectedIdx;
		} else {
			final bottom = state.scrollTop + visibleRows - 1;
			if (state.selectedIdx > bottom)
				state.scrollTop = state.selectedIdx + 1 - visibleRows;
		}
	}

	static function scrollStateClearIfEmpty(state:TuiSmokeScrollState, len:Int):Bool {
		if (len != 0)
			return false;
		scrollStateReset(state);
		return true;
	}

	static function scrollStateCurrentClamped(state:TuiSmokeScrollState, len:Int):Int {
		if (state.selectedIdx < 0)
			return 0;
		return intMin(state.selectedIdx, len - 1);
	}

	static function scrollStateMatches(action:TuiSmokeScrollStateAction, state:TuiSmokeScrollState, trace:Array<String>, label:String):Bool {
		if (state.selectedIdx == action.expectedSelected && state.scrollTop == action.expectedScrollTop)
			return true;
		trace.push("tui.scroll_state."
			+ label
			+ "_mismatch="
			+ action.name
			+ ":expected="
			+ scrollStateTraceValues(action.expectedSelected, action.expectedScrollTop)
			+ ":actual="
			+ scrollStateTrace(state));
		return false;
	}

	static function scrollStateTrace(state:TuiSmokeScrollState):String {
		return scrollStateTraceValues(state.selectedIdx, state.scrollTop);
	}

	static function scrollStateTraceValues(selectedIdx:Int, scrollTop:Int):String {
		return "selected=" + (selectedIdx < 0 ? "none" : Std.string(selectedIdx)) + ":scroll=" + scrollTop;
	}

	static function traceSelectionTabs(plan:TuiSmokeSelectionTabsPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowTerminalMutation || plan.allowRatatuiBuffer || plan.allowFilesystemMutation || plan.allowNetwork
			|| plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.selection_tabs.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.selection_tabs.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeSelectionTabsActionKind.Lines:
					final lines = selectionTabLines(action.tabs, action.activeIdx, action.width);
					if (!selectionTabLinesMatch(lines, action.expectedLines)) {
						trace.push("tui.selection_tabs.lines_mismatch=" + action.name + ":expected=" + selectionTabLineTrace(action.expectedLines)
							+ ":actual=" + selectionTabLineTrace(lines));
						return false;
					}
					trace.push("tui.selection_tabs.lines=" + action.name + ":active=" + action.activeIdx + ":width=" + action.width + ":lines="
						+ selectionTabLineTrace(lines));
				case TuiSmokeSelectionTabsActionKind.Height:
					final height = selectionTabLines(action.tabs, action.activeIdx, action.width).length;
					if (height != action.expectedHeight) {
						trace.push("tui.selection_tabs.height_mismatch=" + action.name + ":expected=" + action.expectedHeight + ":actual=" + height);
						return false;
					}
					trace.push("tui.selection_tabs.height="
						+ action.name
						+ ":active="
						+ action.activeIdx
						+ ":width="
						+ action.width
						+ ":height="
						+ height);
				case TuiSmokeSelectionTabsActionKind.Render:
					final rendered = selectionTabRenderedLines(action.tabs, action.activeIdx, action.width, action.areaHeight);
					if (!selectionTabLinesMatch(rendered, action.expectedLines)) {
						trace.push("tui.selection_tabs.render_mismatch=" + action.name + ":expected=" + selectionTabLineTrace(action.expectedLines)
							+ ":actual=" + selectionTabLineTrace(rendered));
						return false;
					}
					trace.push("tui.selection_tabs.render=" + action.name + ":active=" + action.activeIdx + ":width=" + action.width + ":height="
						+ action.areaHeight + ":lines=" + selectionTabLineTrace(rendered));
				case TuiSmokeSelectionTabsActionKind.Failure:
					trace.push("tui.selection_tabs.failure=" + action.failureCode + ":no_terminal=" + action.noTerminalMutation + ":no_buffer="
						+ action.noRatatuiBuffer + ":no_fs=" + action.noFilesystemMutation + ":no_network=" + action.noNetwork + ":no_model="
						+ action.noModelCall + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.selection_tabs.unknown");
					return false;
			}
		}
		return true;
	}

	static function selectionTabLines(tabs:Array<TuiSmokeSelectionTab>, activeIdx:Int, width:Int):Array<String> {
		final lines:Array<String> = [];
		if (tabs.length == 0)
			return lines;
		final maxWidth = intMax(1, width);
		var currentUnits:Array<String> = [];
		var currentWidth = 0;
		for (idx in 0...tabs.length) {
			final tab = tabs[idx];
			final active = idx == activeIdx;
			final unit = selectionTabUnitTrace(tab.label, active);
			final unitWidth = selectionTabUnitWidth(tab.label, active);
			final gapWidth = currentUnits.length == 0 ? 0 : 2;
			if (currentUnits.length > 0 && currentWidth + gapWidth + unitWidth > maxWidth) {
				lines.push(currentUnits.join("  "));
				currentUnits = [];
				currentWidth = 0;
			}
			if (currentUnits.length > 0)
				currentWidth += 2;
			currentUnits.push(unit);
			currentWidth += unitWidth;
		}
		if (currentUnits.length > 0)
			lines.push(currentUnits.join("  "));
		return lines;
	}

	static function selectionTabRenderedLines(tabs:Array<TuiSmokeSelectionTab>, activeIdx:Int, width:Int, areaHeight:Int):Array<String> {
		final lines = selectionTabLines(tabs, activeIdx, width);
		final rendered:Array<String> = [];
		final limit = intMax(0, areaHeight);
		for (idx in 0...intMin(lines.length, limit))
			rendered.push(lines[idx]);
		return rendered;
	}

	static function selectionTabUnitTrace(label:String, active:Bool):String {
		return active ? "accent[" + label + "]" : "dim[" + label + "]";
	}

	static function selectionTabUnitWidth(label:String, active:Bool):Int {
		return label.length + (active ? 2 : 0);
	}

	static function selectionTabLinesMatch(left:Array<String>, right:Array<String>):Bool {
		if (left.length != right.length)
			return false;
		for (idx in 0...left.length) {
			if (left[idx] != right[idx])
				return false;
		}
		return true;
	}

	static function selectionTabLineTrace(lines:Array<String>):String {
		if (lines.length == 0)
			return "<none>";
		final out:Array<String> = [];
		for (line in lines)
			out.push(traceText(line));
		return out.join("|");
	}

	static function traceActionRequiredTitle(plan:TuiSmokeActionRequiredTitlePlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowTerminalTitleMutation || plan.allowRatatuiRender || plan.allowFilesystemMutation || plan.allowNetwork
			|| plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.action_required_title.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.action_required_title.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeActionRequiredTitleActionKind.Build:
					final actual = actionRequiredTitleBuild(action.prefix, action.items, action.excludedItems, action.values);
					if (actual != action.expected) {
						trace.push("tui.action_required_title.build_mismatch=" + action.name + ":expected=" + traceText(action.expected) + ":actual="
							+ traceText(actual));
						return false;
					}
					trace.push("tui.action_required_title.build=" + action.name + ":items=" + actionRequiredTitleListTrace(action.items) + ":excluded="
						+ actionRequiredTitleListTrace(action.excludedItems) + ":result=" + traceText(actual));
				case TuiSmokeActionRequiredTitleActionKind.Failure:
					trace.push("tui.action_required_title.failure=" + action.failureCode + ":no_title=" + action.noTerminalTitleMutation + ":no_render="
						+ action.noRatatuiRender + ":no_fs=" + action.noFilesystemMutation + ":no_network=" + action.noNetwork + ":no_model="
						+ action.noModelCall + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.action_required_title.unknown");
					return false;
			}
		}
		return true;
	}

	static function actionRequiredTitleBuild(prefix:String, items:Array<String>, excludedItems:Array<String>,
			values:Array<TuiSmokeActionRequiredTitleValue>):String {
		final parts:Array<String> = [prefix];
		for (item in items) {
			if (item == "spinner" || actionRequiredTitleContains(excludedItems, item))
				continue;
			final value = actionRequiredTitleValueFor(item, values);
			if (value != null)
				parts.push(value);
		}
		return parts.join(" | ");
	}

	static function actionRequiredTitleContains(items:Array<String>, item:String):Bool {
		for (candidate in items) {
			if (candidate == item)
				return true;
		}
		return false;
	}

	static function actionRequiredTitleValueFor(item:String, values:Array<TuiSmokeActionRequiredTitleValue>):Null<String> {
		for (entry in values) {
			if (entry.item == item)
				return entry.present ? entry.value : null;
		}
		return null;
	}

	static function actionRequiredTitleListTrace(items:Array<String>):String {
		if (items.length == 0)
			return "<none>";
		final out:Array<String> = [];
		for (item in items)
			out.push(traceText(item));
		return out.join(",");
	}

	static function tracePopupConsts(plan:TuiSmokePopupConstsPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowTerminalMutation || plan.allowRatatuiBuffer || plan.allowFilesystemMutation || plan.allowNetwork
			|| plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.popup_consts.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.popup_consts.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokePopupConstsActionKind.MaxRows:
					final actual = popupConstsMaxRows();
					if (actual != action.expectedMaxRows) {
						trace.push("tui.popup_consts.max_rows_mismatch=" + action.name + ":expected=" + action.expectedMaxRows + ":actual=" + actual);
						return false;
					}
					trace.push("tui.popup_consts.max_rows=" + action.name + ":expected=" + action.expectedMaxRows + ":actual=" + actual);
				case TuiSmokePopupConstsActionKind.StandardHint:
					final actual = popupConstsStandardHintLine();
					if (actual != action.expected) {
						trace.push("tui.popup_consts.standard_hint_mismatch=" + action.name + ":expected=" + traceText(action.expected) + ":actual="
							+ traceText(actual));
						return false;
					}
					trace.push("tui.popup_consts.standard_hint=" + action.name + ":hint=" + traceText(actual));
				case TuiSmokePopupConstsActionKind.KeymapHint:
					final actual = popupConstsAcceptCancelHint(action.acceptBindings, action.acceptLabel, action.cancelBindings, action.cancelLabel);
					if (actual != action.expected) {
						trace.push("tui.popup_consts.keymap_hint_mismatch=" + action.name + ":expected=" + traceText(action.expected) + ":actual="
							+ traceText(actual));
						return false;
					}
					trace.push("tui.popup_consts.keymap_hint=" + action.name + ":accept=" + popupConstsBindingListTrace(action.acceptBindings) + ":cancel="
						+ popupConstsBindingListTrace(action.cancelBindings) + ":hint=" + traceText(actual));
				case TuiSmokePopupConstsActionKind.AcceptCancel:
					final actual = popupConstsAcceptCancelHint(action.acceptBindings, action.acceptLabel, action.cancelBindings, action.cancelLabel);
					if (actual != action.expected) {
						trace.push("tui.popup_consts.accept_cancel_mismatch=" + action.name + ":expected=" + traceText(action.expected) + ":actual="
							+ traceText(actual));
						return false;
					}
					trace.push("tui.popup_consts.accept_cancel=" + action.name + ":accept=" + popupConstsBindingListTrace(action.acceptBindings)
						+ ":cancel=" + popupConstsBindingListTrace(action.cancelBindings) + ":hint=" + traceText(actual));
				case TuiSmokePopupConstsActionKind.Failure:
					trace.push("tui.popup_consts.failure=" + action.failureCode + ":no_terminal=" + action.noTerminalMutation + ":no_buffer="
						+ action.noRatatuiBuffer + ":no_fs=" + action.noFilesystemMutation + ":no_network=" + action.noNetwork + ":no_model="
						+ action.noModelCall + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.popup_consts.unknown");
					return false;
			}
		}
		return true;
	}

	static function popupConstsMaxRows():Int {
		return 8;
	}

	static function popupConstsStandardHintLine():String {
		return popupConstsAcceptCancelHint(["enter"], "to confirm", ["esc"], "to go back");
	}

	static function popupConstsAcceptCancelHint(acceptBindings:Array<String>, acceptLabel:String, cancelBindings:Array<String>, cancelLabel:String):String {
		final hasAccept = acceptBindings.length > 0;
		final hasCancel = cancelBindings.length > 0;
		final accept = hasAccept ? acceptBindings[0] : "";
		final cancel = hasCancel ? cancelBindings[0] : "";
		if (hasAccept && hasCancel)
			return "Press " + accept + " " + acceptLabel + " or " + cancel + " " + cancelLabel;
		if (hasAccept)
			return "Press " + accept + " " + acceptLabel;
		if (hasCancel)
			return "Press " + cancel + " " + cancelLabel;
		return "";
	}

	static function popupConstsBindingListTrace(bindings:Array<String>):String {
		if (bindings.length == 0)
			return "<none>";
		final out:Array<String> = [];
		for (binding in bindings)
			out.push(traceText(binding));
		return out.join("|");
	}

	static function traceStatusLineStyle(plan:TuiSmokeStatusLineStylePlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowTerminalMutation || plan.allowRatatuiBuffer || plan.allowFilesystemMutation || plan.allowNetwork
			|| plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.status_line_style.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.status_line_style.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeStatusLineStyleActionKind.Line:
					final actualPresent = action.segments.length > 0;
					final actualText = statusLineStyleText(action.segments);
					final actualSpans = statusLineStyleSpans(action);
					if (actualPresent != action.expectedPresent
						|| actualText != action.expectedText
						|| actualSpans.join("|") != action.expectedSpans.join("|")) {
						trace.push("tui.status_line_style.line_mismatch=" + action.name + ":present=" + actualPresent + ":text=" + traceText(actualText)
							+ ":spans=" + statusLineStyleListTrace(actualSpans));
						return false;
					}
					trace.push("tui.status_line_style.line=" + action.name + ":theme=" + action.useThemeColors + ":present=" + actualPresent + ":text="
						+ traceText(actualText) + ":spans=" + statusLineStyleListTrace(actualSpans));
				case TuiSmokeStatusLineStyleActionKind.Failure:
					trace.push("tui.status_line_style.failure=" + action.failureCode + ":no_terminal=" + action.noTerminalMutation + ":no_buffer="
						+ action.noRatatuiBuffer + ":no_fs=" + action.noFilesystemMutation + ":no_network=" + action.noNetwork + ":no_model="
						+ action.noModelCall + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.status_line_style.unknown");
					return false;
			}
		}
		return true;
	}

	static function statusLineStyleText(segments:Array<TuiSmokeStatusLineStyleSegment>):String {
		final parts:Array<String> = [];
		for (segment in segments)
			parts.push(segment.text);
		return parts.join(" · ");
	}

	static function statusLineStyleSpans(action:TuiSmokeStatusLineStyleAction):Array<String> {
		final out:Array<String> = [];
		var first = true;
		for (segment in action.segments) {
			if (!first)
				out.push(" · :dim");
			first = false;
			out.push(segment.text + ":" + statusLineStyleStyleFor(segment.item, action.useThemeColors, action.themeAccent, action.themeColor));
		}
		return out;
	}

	static function statusLineStyleStyleFor(item:String, useThemeColors:Bool, themeAccent:String, themeColor:String):String {
		var style = "dim";
		if (useThemeColors) {
			final accent = statusLineStyleAccentFor(item);
			style = accent == themeAccent
				&& themeColor != "" ? statusLineStyleSoftenColor(themeColor) : statusLineStyleFallbackColor(accent);
		}
		if (item == "pull-request")
			style += "+underline";
		return style;
	}

	static function statusLineStyleAccentFor(item:String):String {
		return switch item {
			case "model-name" | "model-with-reasoning" | "reasoning": "model";
			case "current-dir" | "project-root": "path";
			case "git-branch" | "pull-request" | "branch-changes": "branch";
			case "status": "state";
			case "context-remaining" | "context-used" | "context-window-size" | "used-tokens" | "total-input-tokens" | "total-output-tokens": "usage";
			case "five-hour-limit" | "weekly-limit": "limit";
			case "codex-version" | "session-id": "metadata";
			case "fast-mode" | "raw-output" | "permissions" | "approval-mode": "mode";
			case "thread-title": "thread";
			case "task-progress": "progress";
			case _: "metadata";
		}
	}

	static function statusLineStyleFallbackColor(accent:String):String {
		return switch accent {
			case "model" | "state" | "metadata" | "mode": "cyan";
			case "path" | "usage" | "progress": "green";
			case "branch" | "limit" | "thread": "magenta";
			case _: "cyan";
		}
	}

	static function statusLineStyleSoftenColor(color:String):String {
		if (color == "light-red")
			return "red";
		if (color == "light-green")
			return "green";
		if (color == "light-yellow")
			return "yellow";
		if (color == "light-blue")
			return "blue";
		if (color == "light-magenta")
			return "magenta";
		if (color == "light-cyan")
			return "cyan";
		if (color == "white")
			return "gray";
		if (StringTools.startsWith(color, "rgb(") && StringTools.endsWith(color, ")")) {
			final body = color.substr(4, color.length - 5);
			final parts = body.split(",");
			if (parts.length == 3) {
				final r = Std.parseInt(StringTools.trim(parts[0]));
				final g = Std.parseInt(StringTools.trim(parts[1]));
				final b = Std.parseInt(StringTools.trim(parts[2]));
				if (r != null && g != null && b != null)
					return "rgb("
						+ statusLineStyleSoftenRgbChannel(r, statusLineStyleWeightedLuma(r, g, b))
						+ ","
						+ statusLineStyleSoftenRgbChannel(g, statusLineStyleWeightedLuma(r, g, b))
						+ ","
						+ statusLineStyleSoftenRgbChannel(b, statusLineStyleWeightedLuma(r, g, b))
						+ ")";
			}
		}
		return color;
	}

	static function statusLineStyleWeightedLuma(r:Int, g:Int, b:Int):Int {
		return Std.int((77 * r + 150 * g + 29 * b) / 256);
	}

	static function statusLineStyleSoftenRgbChannel(channel:Int, luma:Int):Int {
		final softened = Std.int((channel * 85 + luma * 15 + 50) / 100);
		return Std.int((softened * 100 + 50) / 100);
	}

	static function statusLineStyleListTrace(items:Array<String>):String {
		if (items.length == 0)
			return "<none>";
		final out:Array<String> = [];
		for (item in items)
			out.push(traceText(item));
		return out.join("|");
	}

	static function traceStatusSurfacePreview(plan:TuiSmokeStatusSurfacePreviewPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowTerminalMutation || plan.allowRatatuiBuffer || plan.allowFilesystemMutation || plan.allowNetwork
			|| plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.status_surface_preview.rejected=live_or_missing");
			return false;
		}
		final state = statusSurfacePreviewDefaultState();
		trace.push("tui.status_surface_preview.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeStatusSurfacePreviewActionKind.Defaults:
					final actual = statusSurfacePreviewValuesTrace(state, action.items);
					if (actual != action.expected) {
						trace.push("tui.status_surface_preview.defaults_mismatch=" + action.name + ":expected=" + traceText(action.expected) + ":actual="
							+ traceText(actual));
						return false;
					}
					trace.push("tui.status_surface_preview.defaults=" + action.name + ":values=" + traceText(actual));
				case TuiSmokeStatusSurfacePreviewActionKind.SetLive:
					statusSurfacePreviewSetLive(state, action.item, action.value);
					final actual = statusSurfacePreviewValueTrace(state, action.item);
					if (actual != action.expected) {
						trace.push("tui.status_surface_preview.set_live_mismatch=" + action.name + ":expected=" + traceText(action.expected) + ":actual="
							+ traceText(actual));
						return false;
					}
					trace.push("tui.status_surface_preview.set_live=" + action.name + ":item=" + action.item + ":value=" + traceText(actual));
				case TuiSmokeStatusSurfacePreviewActionKind.SetPlaceholder:
					statusSurfacePreviewSetPlaceholder(state, action.item, action.value);
					final actual = statusSurfacePreviewValueTrace(state, action.item);
					if (actual != action.expected) {
						trace.push("tui.status_surface_preview.set_placeholder_mismatch=" + action.name + ":expected=" + traceText(action.expected)
							+ ":actual=" + traceText(actual));
						return false;
					}
					trace.push("tui.status_surface_preview.set_placeholder=" + action.name + ":item=" + action.item + ":value=" + traceText(actual));
				case TuiSmokeStatusSurfacePreviewActionKind.SuppressPlaceholder:
					statusSurfacePreviewSuppressPlaceholder(state, action.item);
					final actualPresent = statusSurfacePreviewValueFor(state, action.item) != null;
					if (actualPresent != action.expectedPresent) {
						trace.push("tui.status_surface_preview.suppress_mismatch=" + action.name + ":expected_present=" + action.expectedPresent
							+ ":actual_present=" + actualPresent);
						return false;
					}
					trace.push("tui.status_surface_preview.suppress=" + action.name + ":item=" + action.item + ":present=" + actualPresent);
				case TuiSmokeStatusSurfacePreviewActionKind.ValueFor:
					final actualValue = statusSurfacePreviewValueFor(state, action.item);
					final actualPresent = actualValue != null;
					final actual = actualPresent ? actualValue : "";
					if (actualPresent != action.expectedPresent || actual != action.expected) {
						trace.push("tui.status_surface_preview.value_mismatch=" + action.name + ":expected_present=" + action.expectedPresent
							+ ":actual_present=" + actualPresent + ":actual=" + traceText(actual));
						return false;
					}
					trace.push("tui.status_surface_preview.value=" + action.name + ":item=" + action.item + ":present=" + actualPresent + ":value="
						+ traceText(actual));
				case TuiSmokeStatusSurfacePreviewActionKind.StatusLine:
					final actualLine = statusSurfacePreviewStatusLine(state, action.items);
					final actualCount = statusSurfacePreviewStatusLineCount(state, action.items);
					if (actualLine != action.expected || actualCount != action.expectedCount) {
						trace.push("tui.status_surface_preview.status_line_mismatch=" + action.name + ":expected=" + traceText(action.expected) + ":actual="
							+ traceText(actualLine) + ":count=" + actualCount);
						return false;
					}
					trace.push("tui.status_surface_preview.status_line=" + action.name + ":items=" + statusSurfacePreviewListTrace(action.items) + ":line="
						+ traceText(actualLine) + ":count=" + actualCount);
				case TuiSmokeStatusSurfacePreviewActionKind.RateLimitCopy:
					final copy = statusSurfacePreviewRateLimitCopy(action.value, action.fallbackName, action.fallbackDescription);
					if (copy.name != action.expectedName || copy.description != action.expectedDescription) {
						trace.push("tui.status_surface_preview.rate_limit_mismatch=" + action.name + ":name=" + copy.name + ":description="
							+ traceText(copy.description));
						return false;
					}
					trace.push("tui.status_surface_preview.rate_limit=" + action.name + ":value=" + traceText(action.value) + ":name=" + copy.name
						+ ":description=" + traceText(copy.description));
				case TuiSmokeStatusSurfacePreviewActionKind.Failure:
					trace.push("tui.status_surface_preview.failure=" + action.failureCode + ":no_terminal=" + action.noTerminalMutation + ":no_buffer="
						+ action.noRatatuiBuffer + ":no_fs=" + action.noFilesystemMutation + ":no_network=" + action.noNetwork + ":no_model="
						+ action.noModelCall + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.status_surface_preview.unknown");
					return false;
			}
		}
		return true;
	}

	static function statusSurfacePreviewDefaultState():Array<TuiSmokeStatusSurfacePreviewEntry> {
		final out:Array<TuiSmokeStatusSurfacePreviewEntry> = [];
		for (item in statusSurfacePreviewItems())
			out.push({item: item, text: statusSurfacePreviewPlaceholder(item), isPlaceholder: true});
		return out;
	}

	static function statusSurfacePreviewItems():Array<String> {
		return [
			"app-name",
			"project-name",
			"project-root",
			"current-dir",
			"status",
			"thread-title",
			"git-branch",
			"pull-request-number",
			"branch-changes",
			"permissions",
			"approval-mode",
			"context-remaining",
			"context-used",
			"five-hour-limit",
			"weekly-limit",
			"codex-version",
			"context-window-size",
			"used-tokens",
			"total-input-tokens",
			"total-output-tokens",
			"session-id",
			"fast-mode",
			"raw-output",
			"model",
			"model-with-reasoning",
			"reasoning",
			"task-progress"
		];
	}

	static function statusSurfacePreviewPlaceholder(item:String):String {
		return switch item {
			case "app-name": "codex";
			case "project-name": "my-project";
			case "project-root": "my-project";
			case "current-dir": "~/my-project/subdir";
			case "status": "Working";
			case "thread-title": "thread title";
			case "git-branch": "feat/awesome-feature";
			case "pull-request-number": "PR #123";
			case "branch-changes": "+12 -3";
			case "permissions": "Workspace";
			case "approval-mode": "on-request";
			case "context-remaining": "Context 0% left";
			case "context-used": "Context 0% used";
			case "five-hour-limit": "primary 0%";
			case "weekly-limit": "secondary 0%";
			case "codex-version": "0.0.0";
			case "context-window-size": "0 window";
			case "used-tokens": "0 used";
			case "total-input-tokens": "0 in";
			case "total-output-tokens": "0 out";
			case "session-id": "550e8400-e29b-41d4";
			case "fast-mode": "Fast on";
			case "raw-output": "raw output";
			case "model": "gpt-5.2-codex";
			case "model-with-reasoning": "gpt-5.2-codex medium";
			case "reasoning": "medium";
			case "task-progress": "Tasks 0/0";
			case _: "";
		}
	}

	static function statusSurfacePreviewFind(state:Array<TuiSmokeStatusSurfacePreviewEntry>, item:String):Int {
		for (idx in 0...state.length) {
			if (state[idx].item == item)
				return idx;
		}
		return -1;
	}

	static function statusSurfacePreviewSetLive(state:Array<TuiSmokeStatusSurfacePreviewEntry>, item:String, value:String):Void {
		final idx = statusSurfacePreviewFind(state, item);
		if (idx >= 0) {
			state[idx].text = value;
			state[idx].isPlaceholder = false;
		} else {
			state.push({item: item, text: value, isPlaceholder: false});
		}
	}

	static function statusSurfacePreviewSetPlaceholder(state:Array<TuiSmokeStatusSurfacePreviewEntry>, item:String, value:String):Void {
		final idx = statusSurfacePreviewFind(state, item);
		if (idx >= 0) {
			if (!state[idx].isPlaceholder)
				return;
			state[idx].text = value;
			state[idx].isPlaceholder = true;
		} else {
			state.push({item: item, text: value, isPlaceholder: true});
		}
	}

	static function statusSurfacePreviewSuppressPlaceholder(state:Array<TuiSmokeStatusSurfacePreviewEntry>, item:String):Void {
		final idx = statusSurfacePreviewFind(state, item);
		if (idx >= 0 && state[idx].isPlaceholder)
			state.splice(idx, 1);
	}

	static function statusSurfacePreviewValueFor(state:Array<TuiSmokeStatusSurfacePreviewEntry>, item:String):Null<String> {
		final idx = statusSurfacePreviewFind(state, item);
		if (idx < 0)
			return null;
		return state[idx].text;
	}

	static function statusSurfacePreviewValueTrace(state:Array<TuiSmokeStatusSurfacePreviewEntry>, item:String):String {
		final idx = statusSurfacePreviewFind(state, item);
		if (idx < 0)
			return "<missing>";
		return state[idx].text + (state[idx].isPlaceholder ? ":placeholder" : ":live");
	}

	static function statusSurfacePreviewValuesTrace(state:Array<TuiSmokeStatusSurfacePreviewEntry>, items:Array<String>):String {
		final out:Array<String> = [];
		for (item in items)
			out.push(item + "=" + statusSurfacePreviewValueTrace(state, item));
		return out.join("|");
	}

	static function statusSurfacePreviewStatusLine(state:Array<TuiSmokeStatusSurfacePreviewEntry>, items:Array<String>):String {
		final out:Array<String> = [];
		for (item in items) {
			final value = statusSurfacePreviewValueFor(state, statusSurfacePreviewPreviewItemForStatusLine(item));
			if (value != null)
				out.push(value);
		}
		return out.join(" · ");
	}

	static function statusSurfacePreviewStatusLineCount(state:Array<TuiSmokeStatusSurfacePreviewEntry>, items:Array<String>):Int {
		var count = 0;
		for (item in items) {
			final value = statusSurfacePreviewValueFor(state, statusSurfacePreviewPreviewItemForStatusLine(item));
			if (value != null)
				count++;
		}
		return count;
	}

	static function statusSurfacePreviewPreviewItemForStatusLine(item:String):String {
		return switch item {
			case "model-name": "model";
			case "model-with-reasoning": "model-with-reasoning";
			case "reasoning": "reasoning";
			case "current-dir": "current-dir";
			case "project-root": "project-root";
			case "git-branch": "git-branch";
			case "pull-request": "pull-request-number";
			case "branch-changes": "branch-changes";
			case "status": "status";
			case "context-remaining": "context-remaining";
			case "context-used": "context-used";
			case "context-window-size": "context-window-size";
			case "used-tokens": "used-tokens";
			case "total-input-tokens": "total-input-tokens";
			case "total-output-tokens": "total-output-tokens";
			case "five-hour-limit": "five-hour-limit";
			case "weekly-limit": "weekly-limit";
			case "codex-version": "codex-version";
			case "session-id": "session-id";
			case "fast-mode": "fast-mode";
			case "raw-output": "raw-output";
			case "permissions": "permissions";
			case "approval-mode": "approval-mode";
			case "thread-title": "thread-title";
			case "task-progress": "task-progress";
			case _: item;
		}
	}

	static function statusSurfacePreviewRateLimitCopy(value:String, fallbackName:String, fallbackDescription:String):{name:String, description:String} {
		final trimmed = StringTools.ltrim(value);
		if (StringTools.startsWith(trimmed, "secondary usage "))
			return {
				name: "secondary-usage-limit",
				description: "Remaining usage on the secondary usage limit (omitted when unavailable)"
			};
		if (StringTools.startsWith(trimmed, "usage "))
			return {name: "usage-limit", description: "Remaining usage on the primary usage limit (omitted when unavailable)"};
		if (StringTools.startsWith(trimmed, "5h "))
			return {name: "five-hour-limit", description: "Remaining usage on the 5-hour usage limit (omitted when unavailable)"};
		if (StringTools.startsWith(trimmed, "daily "))
			return {name: "daily-limit", description: "Remaining usage on the daily usage limit (omitted when unavailable)"};
		if (StringTools.startsWith(trimmed, "weekly "))
			return {name: "weekly-limit", description: "Remaining usage on the weekly usage limit (omitted when unavailable)"};
		if (StringTools.startsWith(trimmed, "monthly "))
			return {name: "monthly-limit", description: "Remaining usage on the monthly usage limit (omitted when unavailable)"};
		if (StringTools.startsWith(trimmed, "annual "))
			return {name: "annual-limit", description: "Remaining usage on the annual usage limit (omitted when unavailable)"};
		return {name: fallbackName, description: fallbackDescription};
	}

	static function statusSurfacePreviewListTrace(items:Array<String>):String {
		if (items.length == 0)
			return "<none>";
		final out:Array<String> = [];
		for (item in items)
			out.push(traceText(item));
		return out.join(",");
	}

	static function tracePendingInputPreview(plan:TuiSmokePendingInputPreviewPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowTerminalMutation || plan.allowRatatuiBuffer || plan.allowFilesystemMutation || plan.allowNetwork
			|| plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.pending_input_preview.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.pending_input_preview.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokePendingInputPreviewActionKind.Render:
					final rows = pendingInputPreviewRows(action);
					final height = rows.length;
					final noEllipsis = !pendingInputPreviewContainsEllipsis(rows);
					if (height != action.expectedHeight
						|| rows.join("|") != action.expectedRows.join("|")
						|| (action.expectedNoEllipsis && !noEllipsis)) {
						trace.push("tui.pending_input_preview.render_mismatch=" + action.name + ":height=" + height + ":rows="
							+ pendingInputPreviewRowsTrace(rows) + ":no_ellipsis=" + noEllipsis);
						return false;
					}
					trace.push("tui.pending_input_preview.render=" + action.name + ":width=" + action.width + ":height=" + height + ":rows="
						+ pendingInputPreviewRowsTrace(rows) + ":no_ellipsis=" + noEllipsis);
				case TuiSmokePendingInputPreviewActionKind.Failure:
					trace.push("tui.pending_input_preview.failure=" + action.failureCode + ":no_terminal=" + action.noTerminalMutation + ":no_buffer="
						+ action.noRatatuiBuffer + ":no_fs=" + action.noFilesystemMutation + ":no_network=" + action.noNetwork + ":no_model="
						+ action.noModelCall + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.pending_input_preview.unknown");
					return false;
			}
		}
		return true;
	}

	static function pendingInputPreviewRows(action:TuiSmokePendingInputPreviewAction):Array<String> {
		final rows:Array<String> = [];
		if (action.width < 4
			|| (action.pendingSteers.length == 0 && action.rejectedSteers.length == 0 && action.queuedMessages.length == 0))
			return rows;
		if (action.pendingSteers.length > 0) {
			var header = "• Messages to be submitted after next tool call";
			if (action.interruptBinding != "")
				header += " (press " + action.interruptBinding + " to interrupt and send immediately)";
			rows.push(header);
			pendingInputPreviewPushPreviews(rows, action.pendingSteers, action.width);
		}
		if (action.rejectedSteers.length > 0) {
			if (rows.length > 0)
				rows.push("");
			rows.push("• Messages to be submitted at end of turn");
			pendingInputPreviewPushPreviews(rows, action.rejectedSteers, action.width);
		}
		if (action.queuedMessages.length > 0) {
			if (rows.length > 0)
				rows.push("");
			rows.push("• Queued follow-up inputs");
			pendingInputPreviewPushPreviews(rows, action.queuedMessages, action.width);
			if (action.editBinding != "")
				rows.push("    " + action.editBinding + " edit last queued message");
		}
		return rows;
	}

	static function pendingInputPreviewPushPreviews(rows:Array<String>, messages:Array<String>, width:Int):Void {
		for (message in messages) {
			final wrapped = pendingInputPreviewPreviewRows(message, width);
			final limit = wrapped.length > 3 ? 3 : wrapped.length;
			for (idx in 0...limit)
				rows.push(wrapped[idx]);
			if (wrapped.length > 3)
				rows.push("    …");
		}
	}

	static function pendingInputPreviewPreviewRows(message:String, width:Int):Array<String> {
		final out:Array<String> = [];
		final lines = message.split("\n");
		var first = true;
		for (line in lines) {
			final prefix = first ? "  ↳ " : "    ";
			first = false;
			if (pendingInputPreviewLooksUrlLike(line)) {
				out.push(prefix + line);
			} else {
				pendingInputPreviewPushWrappedLine(out, prefix, line, width);
			}
		}
		return out;
	}

	static function pendingInputPreviewPushWrappedLine(out:Array<String>, prefix:String, line:String, width:Int):Void {
		final maxText = width - prefix.length;
		if (maxText <= 0 || line.length <= maxText) {
			out.push(prefix + line);
			return;
		}
		var current = "";
		var currentPrefix = prefix;
		for (word in line.split(" ")) {
			if (current == "") {
				current = word;
			} else if (current.length + 1 + word.length <= maxText) {
				current += " " + word;
			} else {
				out.push(currentPrefix + current);
				currentPrefix = "    ";
				current = word;
			}
		}
		if (current != "")
			out.push(currentPrefix + current);
	}

	static function pendingInputPreviewLooksUrlLike(value:String):Bool {
		return value.indexOf("/") >= 0 && value.indexOf(" ") < 0;
	}

	static function pendingInputPreviewContainsEllipsis(rows:Array<String>):Bool {
		for (row in rows) {
			if (row.indexOf("…") >= 0)
				return true;
		}
		return false;
	}

	static function pendingInputPreviewRowsTrace(rows:Array<String>):String {
		if (rows.length == 0)
			return "<none>";
		final out:Array<String> = [];
		for (row in rows)
			out.push(traceText(row));
		return out.join("|");
	}

	static function tracePendingThreadApprovals(plan:TuiSmokePendingThreadApprovalsPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowTerminalMutation || plan.allowRatatuiBuffer || plan.allowFilesystemMutation || plan.allowNetwork
			|| plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.pending_thread_approvals.rejected=live_or_missing");
			return false;
		}
		final threads:Array<String> = [];
		trace.push("tui.pending_thread_approvals.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokePendingThreadApprovalsActionKind.SetThreads:
					final changed = !stringArraysEqual(threads, action.threads);
					threads.resize(0);
					for (thread in action.threads)
						threads.push(thread);
					final empty = threads.length == 0;
					if (changed != action.expectedChanged || empty != action.expectedEmpty) {
						trace.push("tui.pending_thread_approvals.set_mismatch=" + action.name + ":changed=" + changed + ":empty=" + empty + ":threads="
							+ pendingThreadApprovalsThreadsTrace(threads));
						return false;
					}
					trace.push("tui.pending_thread_approvals.set=" + action.name + ":changed=" + changed + ":empty=" + empty + ":threads="
						+ pendingThreadApprovalsThreadsTrace(threads));
				case TuiSmokePendingThreadApprovalsActionKind.Render:
					final rows = pendingThreadApprovalsRows(threads, action.width);
					final height = rows.length;
					if (height != action.expectedHeight || rows.join("|") != action.expectedRows.join("|")) {
						trace.push("tui.pending_thread_approvals.render_mismatch=" + action.name + ":width=" + action.width + ":height=" + height + ":rows="
							+ pendingThreadApprovalsRowsTrace(rows));
						return false;
					}
					trace.push("tui.pending_thread_approvals.render=" + action.name + ":width=" + action.width + ":height=" + height + ":rows="
						+ pendingThreadApprovalsRowsTrace(rows));
				case TuiSmokePendingThreadApprovalsActionKind.Failure:
					trace.push("tui.pending_thread_approvals.failure=" + action.failureCode + ":no_terminal=" + action.noTerminalMutation + ":no_buffer="
						+ action.noRatatuiBuffer + ":no_fs=" + action.noFilesystemMutation + ":no_network=" + action.noNetwork + ":no_model="
						+ action.noModelCall + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.pending_thread_approvals.unknown");
					return false;
			}
		}
		return true;
	}

	static function pendingThreadApprovalsRows(threads:Array<String>, width:Int):Array<String> {
		final rows:Array<String> = [];
		if (threads.length == 0 || width < 4)
			return rows;
		final limit = threads.length > 3 ? 3 : threads.length;
		for (idx in 0...limit)
			pendingThreadApprovalsPushWrappedLine(rows, "  ! ", "Approval needed in " + threads[idx], width);
		if (threads.length > 3)
			rows.push("    ...");
		rows.push("    /agent to switch threads");
		return rows;
	}

	static function pendingThreadApprovalsPushWrappedLine(out:Array<String>, prefix:String, line:String, width:Int):Void {
		final maxText = width - prefix.length;
		if (maxText <= 0 || line.length <= maxText) {
			out.push(prefix + line);
			return;
		}
		var current = "";
		var currentPrefix = prefix;
		for (word in line.split(" ")) {
			if (current == "") {
				current = word;
			} else if (current.length + 1 + word.length <= maxText) {
				current += " " + word;
			} else {
				out.push(currentPrefix + current);
				currentPrefix = "    ";
				current = word;
			}
		}
		if (current != "")
			out.push(currentPrefix + current);
	}

	static function pendingThreadApprovalsThreadsTrace(threads:Array<String>):String {
		if (threads.length == 0)
			return "<none>";
		final out:Array<String> = [];
		for (thread in threads)
			out.push(traceText(thread));
		return out.join(",");
	}

	static function pendingThreadApprovalsRowsTrace(rows:Array<String>):String {
		if (rows.length == 0)
			return "<none>";
		final out:Array<String> = [];
		for (row in rows)
			out.push(traceText(row));
		return out.join("|");
	}

	static function tracePromptArgs(plan:TuiSmokePromptArgsPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowTerminalMutation || plan.allowRatatuiBuffer || plan.allowFilesystemMutation || plan.allowNetwork
			|| plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.prompt_args.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.prompt_args.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokePromptArgsActionKind.Parse:
					final parsed = parsePromptSlashName(action.line);
					if (parsed.present != action.expectedPresent
						|| parsed.name != action.expectedName
						|| parsed.rest != action.expectedRest
						|| parsed.restOffset != action.expectedRestOffset) {
						trace.push("tui.prompt_args.parse_mismatch=" + action.name + ":present=" + parsed.present + ":name=" + traceText(parsed.name)
							+ ":rest=" + traceText(parsed.rest) + ":offset=" + parsed.restOffset);
						return false;
					}
					trace.push("tui.prompt_args.parse=" + action.name + ":line=" + traceText(action.line) + ":present=" + parsed.present + ":name="
						+ traceText(parsed.name) + ":rest=" + traceText(parsed.rest) + ":offset=" + parsed.restOffset);
				case TuiSmokePromptArgsActionKind.Failure:
					trace.push("tui.prompt_args.failure=" + action.failureCode + ":no_terminal=" + action.noTerminalMutation + ":no_buffer="
						+ action.noRatatuiBuffer + ":no_fs=" + action.noFilesystemMutation + ":no_network=" + action.noNetwork + ":no_model="
						+ action.noModelCall + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.prompt_args.unknown");
					return false;
			}
		}
		return true;
	}

	static function parsePromptSlashName(line:String):TuiSmokePromptArgsResult {
		if (line.length == 0 || line.charAt(0) != "/")
			return promptArgsNone();
		final stripped = line.substr(1);
		var nameEnd = stripped.length;
		var idx = 0;
		while (idx < stripped.length) {
			if (StringTools.isSpace(stripped, idx)) {
				nameEnd = idx;
				break;
			}
			idx++;
		}
		final name = stripped.substr(0, nameEnd);
		if (name == "")
			return promptArgsNone();
		final restUntrimmed = stripped.substr(nameEnd);
		var restStart = 0;
		while (restStart < restUntrimmed.length && StringTools.isSpace(restUntrimmed, restStart))
			restStart++;
		final rest = restUntrimmed.substr(restStart);
		final restOffset = 1 + utf8ByteLength(stripped.substr(0, nameEnd)) + utf8ByteLength(restUntrimmed.substr(0, restStart));
		return {
			present: true,
			name: name,
			rest: rest,
			restOffset: restOffset
		};
	}

	static function promptArgsNone():TuiSmokePromptArgsResult {
		return {
			present: false,
			name: "",
			rest: "",
			restOffset: 0
		};
	}

	static function utf8ByteLength(value:String):Int {
		return haxe.io.Bytes.ofString(value).length;
	}

	static function traceUnifiedExecFooter(plan:TuiSmokeUnifiedExecFooterPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowTerminalMutation || plan.allowRatatuiBuffer || plan.allowFilesystemMutation || plan.allowNetwork
			|| plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.unified_exec_footer.rejected=live_or_missing");
			return false;
		}
		final processes:Array<String> = [];
		trace.push("tui.unified_exec_footer.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeUnifiedExecFooterActionKind.SetProcesses:
					final changed = !stringArraysEqual(processes, action.processes);
					processes.resize(0);
					for (process in action.processes)
						processes.push(process);
					final empty = processes.length == 0;
					if (changed != action.expectedChanged || empty != action.expectedEmpty) {
						trace.push("tui.unified_exec_footer.set_mismatch=" + action.name + ":changed=" + changed + ":empty=" + empty + ":processes="
							+ unifiedExecFooterProcessesTrace(processes));
						return false;
					}
					trace.push("tui.unified_exec_footer.set=" + action.name + ":changed=" + changed + ":empty=" + empty + ":processes="
						+ unifiedExecFooterProcessesTrace(processes));
				case TuiSmokeUnifiedExecFooterActionKind.Summary:
					final summary = unifiedExecFooterSummary(processes);
					final present = summary != null;
					final text = present ? summary : "";
					if (present != action.expectedPresent || text != action.expectedSummary) {
						trace.push("tui.unified_exec_footer.summary_mismatch=" + action.name + ":present=" + present + ":text=" + traceText(text));
						return false;
					}
					trace.push("tui.unified_exec_footer.summary=" + action.name + ":present=" + present + ":text=" + traceText(text));
				case TuiSmokeUnifiedExecFooterActionKind.Render:
					final rows = unifiedExecFooterRows(processes, action.width);
					final height = rows.length;
					if (height != action.expectedHeight || rows.join("|") != action.expectedRows.join("|")) {
						trace.push("tui.unified_exec_footer.render_mismatch=" + action.name + ":width=" + action.width + ":height=" + height + ":rows="
							+ unifiedExecFooterRowsTrace(rows));
						return false;
					}
					trace.push("tui.unified_exec_footer.render=" + action.name + ":width=" + action.width + ":height=" + height + ":rows="
						+ unifiedExecFooterRowsTrace(rows));
				case TuiSmokeUnifiedExecFooterActionKind.Failure:
					trace.push("tui.unified_exec_footer.failure=" + action.failureCode + ":no_terminal=" + action.noTerminalMutation + ":no_buffer="
						+ action.noRatatuiBuffer + ":no_fs=" + action.noFilesystemMutation + ":no_network=" + action.noNetwork + ":no_model="
						+ action.noModelCall + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.unified_exec_footer.unknown");
					return false;
			}
		}
		return true;
	}

	static function unifiedExecFooterSummary(processes:Array<String>):Null<String> {
		if (processes.length == 0)
			return null;
		return unifiedExecFooterSummaryText(processes.length);
	}

	static function unifiedExecFooterSummaryText(count:Int):String {
		final plural = count == 1 ? "" : "s";
		return count + " background terminal" + plural + " running · /ps to view · /stop to close";
	}

	static function unifiedExecFooterRows(processes:Array<String>, width:Int):Array<String> {
		final rows:Array<String> = [];
		if (width < 4 || processes.length == 0)
			return rows;
		final summary = unifiedExecFooterSummaryText(processes.length);
		rows.push(takePrefixByCodepointWidth("  " + summary, width));
		return rows;
	}

	static function takePrefixByCodepointWidth(value:String, width:Int):String {
		if (width <= 0)
			return "";
		var out = "";
		var index = 0;
		while (index < value.length && index < width) {
			out += value.charAt(index);
			index++;
		}
		return out;
	}

	static function unifiedExecFooterProcessesTrace(processes:Array<String>):String {
		if (processes.length == 0)
			return "<none>";
		final out:Array<String> = [];
		for (process in processes)
			out.push(traceText(process));
		return out.join(",");
	}

	static function unifiedExecFooterRowsTrace(rows:Array<String>):String {
		if (rows.length == 0)
			return "<none>";
		final out:Array<String> = [];
		for (row in rows)
			out.push(traceText(row));
		return out.join("|");
	}

	static function traceFileSearchPopup(plan:TuiSmokeFileSearchPopupPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowTerminalMutation || plan.allowRatatuiBuffer || plan.allowFilesystemMutation || plan.allowNetwork
			|| plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.file_search_popup.rejected=live_or_missing");
			return false;
		}
		final state = fileSearchPopupInitialState();
		trace.push("tui.file_search_popup.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeFileSearchPopupActionKind.Snapshot:
				case TuiSmokeFileSearchPopupActionKind.SetQuery:
					fileSearchPopupSetQuery(state, action.query);
				case TuiSmokeFileSearchPopupActionKind.EmptyPrompt:
					fileSearchPopupSetEmptyPrompt(state);
				case TuiSmokeFileSearchPopupActionKind.SetMatches:
					fileSearchPopupSetMatches(state, action.query, action.paths);
				case TuiSmokeFileSearchPopupActionKind.MoveUp:
					fileSearchPopupMoveUp(state);
				case TuiSmokeFileSearchPopupActionKind.MoveDown:
					fileSearchPopupMoveDown(state);
				case TuiSmokeFileSearchPopupActionKind.Failure:
					trace.push("tui.file_search_popup.failure=" + action.failureCode + ":no_terminal=" + action.noTerminalMutation + ":no_buffer="
						+ action.noRatatuiBuffer + ":no_fs=" + action.noFilesystemMutation + ":no_network=" + action.noNetwork + ":no_model="
						+ action.noModelCall + ":unsupported=" + action.unsupportedRejected);
					continue;
				case _:
					trace.push("tui.file_search_popup.unknown");
					return false;
			}
			if (!fileSearchPopupMatchesExpectation(state, action)) {
				trace.push("tui.file_search_popup.state_mismatch=" + action.name + ":" + fileSearchPopupStateTrace(state));
				return false;
			}
			trace.push("tui.file_search_popup." + action.kind + "=" + action.name + ":" + fileSearchPopupStateTrace(state));
		}
		return true;
	}

	static function fileSearchPopupInitialState():TuiSmokeFileSearchPopupState {
		return {
			displayQuery: "",
			pendingQuery: "",
			waiting: true,
			matches: [],
			selectedIndex: -1,
			scrollTop: 0
		};
	}

	static function fileSearchPopupSetQuery(state:TuiSmokeFileSearchPopupState, query:String):Void {
		if (query == state.pendingQuery)
			return;
		state.pendingQuery = query;
		state.waiting = true;
	}

	static function fileSearchPopupSetEmptyPrompt(state:TuiSmokeFileSearchPopupState):Void {
		state.displayQuery = "";
		state.pendingQuery = "";
		state.waiting = false;
		state.matches.resize(0);
		state.selectedIndex = -1;
		state.scrollTop = 0;
	}

	static function fileSearchPopupSetMatches(state:TuiSmokeFileSearchPopupState, query:String, paths:Array<String>):Void {
		if (query != state.pendingQuery)
			return;
		state.displayQuery = query;
		state.matches.resize(0);
		final limit = paths.length > 8 ? 8 : paths.length;
		for (idx in 0...limit)
			state.matches.push(paths[idx]);
		state.waiting = false;
		fileSearchPopupClampSelection(state);
		fileSearchPopupEnsureVisible(state);
	}

	static function fileSearchPopupMoveUp(state:TuiSmokeFileSearchPopupState):Void {
		final len = state.matches.length;
		if (len == 0) {
			state.selectedIndex = -1;
			state.scrollTop = 0;
			return;
		}
		if (state.selectedIndex > 0) {
			state.selectedIndex--;
		} else if (state.selectedIndex == 0) {
			state.selectedIndex = len - 1;
		} else {
			state.selectedIndex = 0;
		}
		fileSearchPopupEnsureVisible(state);
	}

	static function fileSearchPopupMoveDown(state:TuiSmokeFileSearchPopupState):Void {
		final len = state.matches.length;
		if (len == 0) {
			state.selectedIndex = -1;
			state.scrollTop = 0;
			return;
		}
		if (state.selectedIndex >= 0 && state.selectedIndex + 1 < len) {
			state.selectedIndex++;
		} else {
			state.selectedIndex = 0;
		}
		fileSearchPopupEnsureVisible(state);
	}

	static function fileSearchPopupClampSelection(state:TuiSmokeFileSearchPopupState):Void {
		final len = state.matches.length;
		if (len == 0) {
			state.selectedIndex = -1;
			state.scrollTop = 0;
			return;
		}
		if (state.selectedIndex < 0) {
			state.selectedIndex = 0;
		} else if (state.selectedIndex >= len) {
			state.selectedIndex = len - 1;
		}
	}

	static function fileSearchPopupEnsureVisible(state:TuiSmokeFileSearchPopupState):Void {
		final len = state.matches.length;
		final visible = len < 8 ? len : 8;
		if (len == 0 || visible == 0) {
			state.scrollTop = 0;
			return;
		}
		if (state.selectedIndex < state.scrollTop) {
			state.scrollTop = state.selectedIndex;
		} else {
			final bottom = state.scrollTop + visible - 1;
			if (state.selectedIndex > bottom)
				state.scrollTop = state.selectedIndex + 1 - visible;
		}
	}

	static function fileSearchPopupMatchesExpectation(state:TuiSmokeFileSearchPopupState, action:TuiSmokeFileSearchPopupAction):Bool {
		return state.displayQuery == action.expectedDisplayQuery
			&& state.pendingQuery == action.expectedPendingQuery
			&& state.waiting == action.expectedWaiting
			&& stringArraysEqual(state.matches, action.expectedMatches)
			&& fileSearchPopupRequiredHeight(state) == action.expectedHeight
			&& fileSearchPopupSelectedPath(state) == action.expectedSelectedPath
			&& fileSearchPopupEmptyMessage(state) == action.expectedEmptyMessage
			&& state.selectedIndex == action.expectedSelectedIndex
			&& state.scrollTop == action.expectedScrollTop;
	}

	static function fileSearchPopupRequiredHeight(state:TuiSmokeFileSearchPopupState):Int {
		if (state.matches.length < 1)
			return 1;
		return state.matches.length > 8 ? 8 : state.matches.length;
	}

	static function fileSearchPopupSelectedPath(state:TuiSmokeFileSearchPopupState):String {
		if (state.selectedIndex < 0 || state.selectedIndex >= state.matches.length)
			return "";
		return state.matches[state.selectedIndex];
	}

	static function fileSearchPopupEmptyMessage(state:TuiSmokeFileSearchPopupState):String {
		return state.waiting ? "loading..." : "no matches";
	}

	static function fileSearchPopupStateTrace(state:TuiSmokeFileSearchPopupState):String {
		return "display=" + traceText(state.displayQuery) + ":pending=" + traceText(state.pendingQuery) + ":waiting=" + state.waiting + ":matches="
			+ fileSearchPopupMatchesTrace(state.matches) + ":height=" + fileSearchPopupRequiredHeight(state) + ":selected="
			+ traceText(fileSearchPopupSelectedPath(state)) + ":empty_message=" + traceText(fileSearchPopupEmptyMessage(state)) + ":selected_idx="
			+ state.selectedIndex + ":scroll_top=" + state.scrollTop;
	}

	static function fileSearchPopupMatchesTrace(matches:Array<String>):String {
		if (matches.length == 0)
			return "<none>";
		final out:Array<String> = [];
		for (path in matches)
			out.push(traceText(path));
		return out.join(",");
	}

	static function traceSkillPopup(plan:TuiSmokeSkillPopupPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowTerminalMutation || plan.allowRatatuiBuffer || plan.allowFilesystemMutation || plan.allowNetwork
			|| plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.skill_popup.rejected=live_or_missing");
			return false;
		}
		final state = skillPopupInitialState();
		trace.push("tui.skill_popup.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeSkillPopupActionKind.Snapshot:
				case TuiSmokeSkillPopupActionKind.SetMentions:
					skillPopupSetMentions(state, action.mentions);
				case TuiSmokeSkillPopupActionKind.SetQuery:
					skillPopupSetQuery(state, action.query);
				case TuiSmokeSkillPopupActionKind.MoveUp:
					skillPopupMoveUp(state);
				case TuiSmokeSkillPopupActionKind.MoveDown:
					skillPopupMoveDown(state);
				case TuiSmokeSkillPopupActionKind.Failure:
					trace.push("tui.skill_popup.failure=" + action.failureCode + ":no_terminal=" + action.noTerminalMutation + ":no_buffer="
						+ action.noRatatuiBuffer + ":no_fs=" + action.noFilesystemMutation + ":no_network=" + action.noNetwork + ":no_model="
						+ action.noModelCall + ":unsupported=" + action.unsupportedRejected);
					continue;
				case _:
					trace.push("tui.skill_popup.unknown");
					return false;
			}
			if (!skillPopupMatchesExpectation(state, action)) {
				trace.push("tui.skill_popup.state_mismatch=" + action.name + ":" + skillPopupStateTrace(state));
				return false;
			}
			trace.push("tui.skill_popup." + action.kind + "=" + action.name + ":" + skillPopupStateTrace(state));
		}
		return true;
	}

	static function skillPopupInitialState():TuiSmokeSkillPopupState {
		return {
			query: "",
			mentions: [],
			selectedIndex: -1,
			scrollTop: 0
		};
	}

	static function skillPopupSetMentions(state:TuiSmokeSkillPopupState, mentions:Array<TuiSmokeSkillPopupMention>):Void {
		state.mentions = mentions.copy();
		skillPopupClampSelection(state);
		skillPopupEnsureVisible(state);
	}

	static function skillPopupSetQuery(state:TuiSmokeSkillPopupState, query:String):Void {
		state.query = query;
		skillPopupClampSelection(state);
		skillPopupEnsureVisible(state);
	}

	static function skillPopupMoveUp(state:TuiSmokeSkillPopupState):Void {
		final count = skillPopupFilteredIndices(state).length;
		if (count == 0) {
			state.selectedIndex = -1;
			state.scrollTop = 0;
			return;
		}
		if (state.selectedIndex > 0) {
			state.selectedIndex--;
		} else if (state.selectedIndex == 0) {
			state.selectedIndex = count - 1;
		} else {
			state.selectedIndex = 0;
		}
		skillPopupEnsureVisible(state);
	}

	static function skillPopupMoveDown(state:TuiSmokeSkillPopupState):Void {
		final count = skillPopupFilteredIndices(state).length;
		if (count == 0) {
			state.selectedIndex = -1;
			state.scrollTop = 0;
			return;
		}
		if (state.selectedIndex >= 0 && state.selectedIndex + 1 < count) {
			state.selectedIndex++;
		} else {
			state.selectedIndex = 0;
		}
		skillPopupEnsureVisible(state);
	}

	static function skillPopupFilteredIndices(state:TuiSmokeSkillPopupState):Array<Int> {
		if (state.query == "") {
			final indices:Array<Int> = [];
			for (idx in 0...state.mentions.length)
				indices.push(idx);
			indices.sort(function(left, right) {
				return skillPopupCompareMentions(state.mentions[left], state.mentions[right]);
			});
			return indices;
		}
		final matches:Array<TuiSmokeSkillPopupMatch> = [];
		for (idx in 0...state.mentions.length) {
			final match = skillPopupMatch(state.mentions[idx], state.query);
			if (match.score >= 0)
				matches.push({index: idx, display: match.display, score: match.score});
		}
		matches.sort(function(left, right) {
			if (left.display != right.display)
				return left.display ? -1 : 1;
			if (left.score != right.score)
				return left.score - right.score;
			return skillPopupCompareMentions(state.mentions[left.index], state.mentions[right.index]);
		});
		final out:Array<Int> = [];
		for (match in matches)
			out.push(match.index);
		return out;
	}

	static function skillPopupMatch(mention:TuiSmokeSkillPopupMention, query:String):TuiSmokeSkillPopupMatch {
		final normalizedQuery = query.toLowerCase();
		final displayName = mention.displayName.toLowerCase();
		final displayIndex = displayName.indexOf(normalizedQuery);
		if (displayIndex >= 0)
			return {index: -1, display: true, score: displayIndex * 100 + displayName.length};
		var best = -1;
		for (term in mention.searchTerms) {
			final normalizedTerm = term.toLowerCase();
			if (normalizedTerm == displayName)
				continue;
			final termIndex = normalizedTerm.indexOf(normalizedQuery);
			if (termIndex >= 0) {
				final score = termIndex * 100 + normalizedTerm.length;
				if (best < 0 || score < best)
					best = score;
			}
		}
		if (best >= 0)
			return {index: -1, display: false, score: best};
		return {index: -1, display: false, score: -1};
	}

	static function skillPopupCompareMentions(left:TuiSmokeSkillPopupMention, right:TuiSmokeSkillPopupMention):Int {
		if (left.sortRank != right.sortRank)
			return left.sortRank - right.sortRank;
		return compareStrings(left.displayName, right.displayName);
	}

	static function skillPopupClampSelection(state:TuiSmokeSkillPopupState):Void {
		final count = skillPopupFilteredIndices(state).length;
		if (count == 0) {
			state.selectedIndex = -1;
			state.scrollTop = 0;
			return;
		}
		if (state.selectedIndex < 0) {
			state.selectedIndex = 0;
		} else if (state.selectedIndex >= count) {
			state.selectedIndex = count - 1;
		}
	}

	static function skillPopupEnsureVisible(state:TuiSmokeSkillPopupState):Void {
		final count = skillPopupFilteredIndices(state).length;
		final visible = count < 8 ? count : 8;
		if (count == 0 || visible == 0) {
			state.scrollTop = 0;
			return;
		}
		if (state.selectedIndex < state.scrollTop) {
			state.scrollTop = state.selectedIndex;
		} else {
			final bottom = state.scrollTop + visible - 1;
			if (state.selectedIndex > bottom)
				state.scrollTop = state.selectedIndex + 1 - visible;
		}
	}

	static function skillPopupMatchesExpectation(state:TuiSmokeSkillPopupState, action:TuiSmokeSkillPopupAction):Bool {
		final indices = skillPopupFilteredIndices(state);
		return stringArraysEqual(skillPopupOrder(state, indices), action.expectedOrder)
			&& stringArraysEqual(skillPopupRows(state, indices), action.expectedRows)
			&& skillPopupRequiredHeight(indices) == action.expectedHeight
			&& skillPopupSelectedName(state, indices) == action.expectedSelectedName
			&& skillPopupSelectedInsertText(state, indices) == action.expectedSelectedInsertText
			&& skillPopupSelectedPath(state, indices) == action.expectedSelectedPath
			&& state.selectedIndex == action.expectedSelectedIndex
			&& state.scrollTop == action.expectedScrollTop;
	}

	static function skillPopupRequiredHeight(indices:Array<Int>):Int {
		var visible = indices.length;
		if (visible < 1)
			visible = 1;
		if (visible > 8)
			visible = 8;
		return visible + 2;
	}

	static function skillPopupSelectedMention(state:TuiSmokeSkillPopupState, indices:Array<Int>):Null<TuiSmokeSkillPopupMention> {
		if (state.selectedIndex < 0 || state.selectedIndex >= indices.length)
			return null;
		return state.mentions[indices[state.selectedIndex]];
	}

	static function skillPopupSelectedName(state:TuiSmokeSkillPopupState, indices:Array<Int>):String {
		final mention = skillPopupSelectedMention(state, indices);
		return mention == null ? "" : mention.displayName;
	}

	static function skillPopupSelectedInsertText(state:TuiSmokeSkillPopupState, indices:Array<Int>):String {
		final mention = skillPopupSelectedMention(state, indices);
		return mention == null ? "" : mention.insertText;
	}

	static function skillPopupSelectedPath(state:TuiSmokeSkillPopupState, indices:Array<Int>):String {
		final mention = skillPopupSelectedMention(state, indices);
		return mention == null ? "" : mention.path;
	}

	static function skillPopupOrder(state:TuiSmokeSkillPopupState, indices:Array<Int>):Array<String> {
		final out:Array<String> = [];
		for (index in indices)
			out.push(state.mentions[index].displayName);
		return out;
	}

	static function skillPopupRows(state:TuiSmokeSkillPopupState, indices:Array<Int>):Array<String> {
		final out:Array<String> = [];
		final limit = indices.length > 8 ? 8 : indices.length;
		for (idx in 0...limit) {
			final mention = state.mentions[indices[idx]];
			out.push(skillPopupTruncateName(mention.displayName) + ">" + skillPopupDescription(mention));
		}
		return out;
	}

	static function skillPopupTruncateName(value:String):String {
		if (value.length <= 28)
			return value;
		return value.substr(0, 25) + "...";
	}

	static function skillPopupDescription(mention:TuiSmokeSkillPopupMention):String {
		final hasTag = mention.categoryTag != "";
		final hasDescription = mention.description != "";
		if (hasTag && hasDescription)
			return mention.categoryTag + " " + mention.description;
		if (hasTag)
			return mention.categoryTag;
		if (hasDescription)
			return mention.description;
		return "";
	}

	static function skillPopupStateTrace(state:TuiSmokeSkillPopupState):String {
		final indices = skillPopupFilteredIndices(state);
		return "query=" + traceText(state.query) + ":order=" + skillPopupListTrace(skillPopupOrder(state, indices)) + ":rows="
			+ skillPopupRowsTrace(skillPopupRows(state, indices)) + ":height=" + skillPopupRequiredHeight(indices) + ":selected="
			+ traceText(skillPopupSelectedName(state, indices)) + ":insert=" + traceText(skillPopupSelectedInsertText(state, indices)) + ":path="
			+ traceText(skillPopupSelectedPath(state, indices)) + ":selected_idx=" + state.selectedIndex + ":scroll_top=" + state.scrollTop;
	}

	static function skillPopupListTrace(values:Array<String>):String {
		if (values.length == 0)
			return "<none>";
		final out:Array<String> = [];
		for (value in values)
			out.push(traceText(value));
		return out.join(",");
	}

	static function skillPopupRowsTrace(values:Array<String>):String {
		if (values.length == 0)
			return "<none>";
		final out:Array<String> = [];
		for (value in values)
			out.push(traceText(value));
		return out.join("|");
	}

	static function compareStrings(left:String, right:String):Int {
		if (left < right)
			return -1;
		if (left > right)
			return 1;
		return 0;
	}

	static function parseAssistantMarkdownDirectives(markdown:String, cwd:String):TuiSmokeParsedGitActionMarkdown {
		final directives:Array<TuiSmokeGitActionDirectiveExpectation> = [];
		final seen:Map<String, Bool> = new Map();
		final visibleLines:Array<String> = [];
		final lines = markdown.split("\n");
		for (line in lines) {
			final rewritten = rewriteCodeCommentLine(line, cwd);
			if (rewritten != null) {
				visibleLines.push(StringTools.rtrim(rewritten));
				continue;
			}
			final stripped = stripLineDirectives(line);
			for (directive in stripped.directives) {
				final key = gitActionDirectiveKey(directive);
				if (!seen.exists(key)) {
					seen.set(key, true);
					directives.push(directive);
				}
			}
			visibleLines.push(StringTools.rtrim(stripped.visible));
		}
		while (visibleLines.length > 0 && visibleLines[visibleLines.length - 1] == "")
			visibleLines.pop();
		return {
			visibleMarkdown: visibleLines.join("\n"),
			directives: directives,
			lastCreatedBranchCwd: lastCreatedBranchCwd(directives)
		};
	}

	static function rewriteCodeCommentLine(line:String, cwd:String):Null<String> {
		final content = trimStartTabsAndSpaces(line);
		final indent = line.substr(0, line.length - content.length);
		var markerLength = 0;
		while (markerLength < content.length && content.charAt(markerLength) == ":")
			markerLength++;
		if (markerLength < 1 || markerLength > 3)
			return null;
		final afterMarker = content.substr(markerLength);
		if (!StringTools.startsWith(afterMarker, "code-comment{"))
			return null;
		final directive = afterMarker.substr("code-comment{".length);
		final closeBrace = directive.lastIndexOf("}");
		if (closeBrace < 0)
			return null;
		final attrs = parseCodeCommentAttributes(directive.substr(0, closeBrace));
		if (attrs == null)
			return null;
		final titleRaw = mapGet(attrs, "title");
		final bodyRaw = mapGet(attrs, "body");
		final fileRaw = mapGet(attrs, "file");
		if (titleRaw == null || bodyRaw == null || fileRaw == null)
			return null;
		final title = StringTools.trim(titleRaw);
		final body = StringTools.trim(bodyRaw);
		final file = StringTools.trim(fileRaw);
		if (title == "" || body == "" || file == "")
			return null;
		final start = intMax(optionalDirectiveInteger(attrs, "start", 1), 1);
		final end = intMax(optionalDirectiveInteger(attrs, "end", start), start);
		final priority = directiveInteger(attrs, "priority");
		final renderedTitle = if (titleHasPriority(title) || priority == null || priority < 0 || priority > 3) {
			title;
		} else {
			"[P" + priority + "] " + title;
		}
		final relativeFile = cwdRelativeFile(file, cwd);
		final location = start == end ? relativeFile + ":" + start : relativeFile + ":" + start + "-" + end;
		final suffix = directive.substr(closeBrace + 1);
		return indent
			+ "- "
			+ renderedTitle
			+ " "
			+ String.fromCharCode(0x2014)
			+ " "
			+ location
			+ "\n"
			+ indent
			+ "  "
			+ body
			+ suffix;
	}

	static function stripLineDirectives(line:String):TuiSmokeStrippedGitActionLine {
		var visible = "";
		final directives:Array<TuiSmokeGitActionDirectiveExpectation> = [];
		var remaining = line;
		while (true) {
			final start = remaining.indexOf("::git-");
			if (start < 0)
				break;
			visible += remaining.substr(0, start);
			final directive = remaining.substr(start + 2);
			final openBrace = directive.indexOf("{");
			if (openBrace < 0) {
				visible += remaining.substr(start);
				return {visible: visible, directives: directives};
			}
			final closeFromOpen = directive.indexOf("}", openBrace + 1);
			if (closeFromOpen < 0) {
				visible += remaining.substr(start);
				return {visible: visible, directives: directives};
			}
			final name = directive.substr(0, openBrace);
			final attributes = directive.substr(openBrace + 1, closeFromOpen - openBrace - 1);
			final parsed = parseGitAction(name, attributes);
			if (parsed != null)
				directives.push(parsed);
			remaining = directive.substr(closeFromOpen + 1);
		}
		visible += remaining;
		return {visible: visible, directives: directives};
	}

	static function parseGitAction(name:String, attributes:String):Null<TuiSmokeGitActionDirectiveExpectation> {
		final attrs = parseGitAttributes(attributes);
		if (attrs == null)
			return null;
		final cwd = mapGet(attrs, "cwd");
		if (cwd == null)
			return null;
		return switch name {
			case "git-stage":
				new TuiSmokeGitActionDirectiveExpectation({
					kind: "Stage",
					cwd: cwd,
					branch: "",
					url: "",
					isDraft: false
				});
			case "git-commit":
				new TuiSmokeGitActionDirectiveExpectation({
					kind: "Commit",
					cwd: cwd,
					branch: "",
					url: "",
					isDraft: false
				});
			case "git-create-branch":
				final branch = mapGet(attrs, "branch");
				branch == null ? null : new TuiSmokeGitActionDirectiveExpectation({
					kind: "CreateBranch",
					cwd: cwd,
					branch: branch,
					url: "",
					isDraft: false
				});
			case "git-push":
				final branch = mapGet(attrs, "branch");
				branch == null ? null : new TuiSmokeGitActionDirectiveExpectation({
					kind: "Push",
					cwd: cwd,
					branch: branch,
					url: "",
					isDraft: false
				});
			case "git-create-pr":
				final branch = mapGet(attrs, "branch");
				branch == null ? null : new TuiSmokeGitActionDirectiveExpectation({
					kind: "CreatePr",
					cwd: cwd,
					branch: branch,
					url: mapGetDefault(attrs, "url", ""),
					isDraft: mapGetDefault(attrs, "isDraft", "") == "true"
				});
			case _:
				null;
		}
	}

	static function parseGitAttributes(input:String):Null<Map<String, String>> {
		final attrs:Map<String, String> = new Map();
		var rest = StringTools.trim(input);
		while (rest != "") {
			final eq = rest.indexOf("=");
			if (eq < 0)
				return null;
			final key = StringTools.trim(rest.substr(0, eq));
			if (key == "")
				return null;
			rest = trimStartTabsAndSpaces(rest.substr(eq + 1));
			if (StringTools.startsWith(rest, "\"")) {
				final quoted = rest.substr(1);
				final end = quoted.indexOf("\"");
				if (end < 0)
					return null;
				attrs.set(key, quoted.substr(0, end));
				rest = trimStartTabsAndSpaces(quoted.substr(end + 1));
			} else {
				final end = firstWhitespaceIndex(rest);
				attrs.set(key, rest.substr(0, end));
				rest = trimStartTabsAndSpaces(rest.substr(end));
			}
		}
		return attrs;
	}

	static function parseCodeCommentAttributes(input:String):Null<Map<String, String>> {
		final attrs:Map<String, String> = new Map();
		var rest = StringTools.trim(input);
		while (rest != "") {
			final eq = rest.indexOf("=");
			if (eq < 0)
				return null;
			final name = StringTools.trim(rest.substr(0, eq));
			if (name == "")
				return null;
			rest = trimStartTabsAndSpaces(rest.substr(eq + 1));
			if (StringTools.startsWith(rest, "\"")) {
				final parsed = parseEscapedQuotedValue(rest.substr(1));
				if (parsed == null)
					return null;
				attrs.set(name, parsed.value);
				rest = trimStartTabsAndSpaces(parsed.rest);
			} else {
				final end = firstWhitespaceIndex(rest);
				attrs.set(name, rest.substr(0, end));
				rest = trimStartTabsAndSpaces(rest.substr(end));
			}
		}
		return attrs;
	}

	static function parseEscapedQuotedValue(input:String):Null<TuiSmokeParsedQuotedValue> {
		var value = "";
		var index = 0;
		while (index < input.length) {
			final character = input.charAt(index);
			if (character == "\"")
				return {value: value, rest: input.substr(index + 1)};
			if (character == "\\" && index + 1 < input.length && input.charAt(index + 1) == "\"") {
				value += "\"";
				index += 2;
				continue;
			}
			value += character;
			index++;
		}
		return null;
	}

	static function directiveInteger(attributes:Map<String, String>, name:String):Null<Int> {
		final value = mapGet(attributes, name);
		if (value == null)
			return null;
		var trimmed = StringTools.trim(value);
		if (StringTools.startsWith(trimmed, "P") || StringTools.startsWith(trimmed, "p"))
			trimmed = trimmed.substr(1);
		return Std.parseInt(trimmed);
	}

	static function optionalDirectiveInteger(attributes:Map<String, String>, name:String, fallback:Int):Int {
		final value = directiveInteger(attributes, name);
		return value == null ? fallback : value;
	}

	static function titleHasPriority(title:String):Bool {
		final trimmed = StringTools.ltrim(title);
		if (trimmed.length < 4)
			return false;
		final digit = trimmed.charCodeAt(2);
		return trimmed.charAt(0) == "["
			&& (trimmed.charAt(1) == "P" || trimmed.charAt(1) == "p")
			&& digit >= 48
			&& digit <= 57
			&& trimmed.charAt(3) == "]";
	}

	static function cwdRelativeFile(file:String, cwd:String):String {
		var out = file;
		if (cwd != "") {
			if (out == cwd) {
				out = "";
			} else if (StringTools.startsWith(out, cwd + "/")) {
				out = out.substr(cwd.length + 1);
			}
		}
		return StringTools.replace(out, "\\", "/");
	}

	static function lastCreatedBranchCwd(directives:Array<TuiSmokeGitActionDirectiveExpectation>):String {
		var index = directives.length - 1;
		while (index >= 0) {
			final directive = directives[index];
			if (directive.kind == "CreateBranch")
				return directive.cwd;
			index--;
		}
		return "";
	}

	static function gitActionDirectivesMatch(left:Array<TuiSmokeGitActionDirectiveExpectation>, right:Array<TuiSmokeGitActionDirectiveExpectation>):Bool {
		if (left.length != right.length)
			return false;
		for (index in 0...left.length) {
			if (gitActionDirectiveKey(left[index]) != gitActionDirectiveKey(right[index]))
				return false;
		}
		return true;
	}

	static function gitActionDirectiveTrace(directives:Array<TuiSmokeGitActionDirectiveExpectation>):String {
		if (directives.length == 0)
			return "<none>";
		final out:Array<String> = [];
		for (directive in directives) {
			switch directive.kind {
				case "Stage":
					out.push("Stage(cwd=" + directive.cwd + ")");
				case "Commit":
					out.push("Commit(cwd=" + directive.cwd + ")");
				case "CreateBranch":
					out.push("CreateBranch(cwd=" + directive.cwd + ",branch=" + directive.branch + ")");
				case "Push":
					out.push("Push(cwd=" + directive.cwd + ",branch=" + directive.branch + ")");
				case "CreatePr":
					out.push("CreatePr(cwd="
						+ directive.cwd
						+ ",branch="
						+ directive.branch
						+ ",url="
						+ directive.url
						+ ",draft="
						+ directive.isDraft
						+ ")");
				case _:
					out.push(directive.kind + "(cwd=" + directive.cwd + ")");
			}
		}
		return out.join("|");
	}

	static function gitActionDirectiveKey(directive:TuiSmokeGitActionDirectiveExpectation):String {
		return directive.kind + "\t" + directive.cwd + "\t" + directive.branch + "\t" + directive.url + "\t" + directive.isDraft;
	}

	static function traceText(value:String):String {
		var out = StringTools.replace(value, "\\", "\\\\");
		out = StringTools.replace(out, "\n", "\\n");
		out = StringTools.replace(out, "\t", "\\t");
		return out == "" ? "<empty>" : out;
	}

	static function trimStartTabsAndSpaces(value:String):String {
		var index = 0;
		while (index < value.length && (value.charAt(index) == " " || value.charAt(index) == "\t"))
			index++;
		return value.substr(index);
	}

	static function firstWhitespaceIndex(value:String):Int {
		var index = 0;
		while (index < value.length) {
			final character = value.charAt(index);
			if (character == " " || character == "\t" || character == "\n" || character == "\r")
				return index;
			index++;
		}
		return value.length;
	}

	static function mapGet(map:Map<String, String>, key:String):Null<String> {
		return map.exists(key) ? map.get(key) : null;
	}

	static function mapGetDefault(map:Map<String, String>, key:String, fallback:String):String {
		return map.exists(key) ? map.get(key) : fallback;
	}

	static function intMax(left:Int, right:Int):Int {
		return left > right ? left : right;
	}

	static function intMin(left:Int, right:Int):Int {
		return left < right ? left : right;
	}

	static function formatGoalElapsedSeconds(seconds:Int):String {
		final clamped = seconds < 0 ? 0 : seconds;
		if (clamped < 60)
			return Std.string(clamped) + "s";
		final minutes = Std.int(clamped / 60);
		if (minutes < 60)
			return Std.string(minutes) + "m";
		final hours = Std.int(minutes / 60);
		final remainingMinutes = minutes % 60;
		if (hours >= 24) {
			final days = Std.int(hours / 24);
			final remainingHours = hours % 24;
			return Std.string(days) + "d " + Std.string(remainingHours) + "h " + Std.string(remainingMinutes) + "m";
		}
		if (remainingMinutes == 0)
			return Std.string(hours) + "h";
		return Std.string(hours) + "h " + Std.string(remainingMinutes) + "m";
	}

	static function goalStatusLabel(status:String):String {
		return switch status {
			case "Active": "active";
			case "Paused": "paused";
			case "Blocked": "blocked";
			case "UsageLimited": "usage limited";
			case "BudgetLimited": "limited by budget";
			case "Complete": "complete";
			case _: "";
		}
	}

	static function goalUsageSummary(objective:String, timeUsedSeconds:Int, hasTokenBudget:Bool, tokensUsed:Int, tokenBudget:Int):String {
		final parts:Array<String> = ["Objective: " + objective];
		if (timeUsedSeconds > 0)
			parts.push("Time: " + formatGoalElapsedSeconds(timeUsedSeconds) + ".");
		if (hasTokenBudget)
			parts.push("Tokens: " + formatTokensCompact(tokensUsed) + "/" + formatTokensCompact(tokenBudget) + ".");
		return parts.join(" ");
	}

	static function formatTokensCompact(value:Int):String {
		final sign = value < 0 ? "-" : "";
		final abs = value < 0 ? -value : value;
		if (abs < 1000)
			return sign + Std.string(abs);
		if (abs < 1000000)
			return sign + formatCompactUnit(abs, 1000, "K");
		return sign + formatCompactUnit(abs, 1000000, "M");
	}

	static function formatCompactUnit(value:Int, unit:Int, suffix:String):String {
		final scaled = Std.int((value * 10 + Std.int(unit / 2)) / unit);
		final whole = Std.int(scaled / 10);
		final decimal = scaled % 10;
		if (decimal == 0)
			return Std.string(whole) + suffix;
		return Std.string(whole) + "." + Std.string(decimal) + suffix;
	}

	static function traceGoalMenu(plan:TuiSmokeGoalMenuPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowRatatuiRender || plan.allowModelCall || plan.allowAppServerMutation || !plan.enabled()) {
			trace.push("tui.chat_widget_goal_menu.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.chat_widget_goal_menu.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeGoalMenuActionKind.Summary:
					trace.push("tui.chat_widget_goal_menu.summary=" + action.status + ":objective=" + action.objective + ":budget=" + action.tokenBudget
						+ ":tokens=" + action.tokensUsed + ":time=" + action.timeUsedSeconds + ":hint=" + action.commandHint + ":inserted="
						+ action.summaryInserted);
				case TuiSmokeGoalMenuActionKind.Indicator:
					trace.push("tui.chat_widget_goal_menu.indicator=" + action.status + ":kind=" + action.indicator + ":usage=" + action.usage + ":budget="
						+ action.budgetPresent + ":active_elapsed=" + action.activeTurnElapsedSeconds);
				case TuiSmokeGoalMenuActionKind.EditPrompt:
					trace.push("tui.chat_widget_goal_menu.edit=" + action.status + ":edited=" + action.editedStatus + ":opened=" + action.editPromptOpened
						+ ":set_objective=" + action.setObjectiveEvent);
				case TuiSmokeGoalMenuActionKind.ResumePrompt:
					trace.push("tui.chat_widget_goal_menu.resume=" + action.status + ":opened=" + action.resumePromptOpened + ":default="
						+ action.resumeDefaultSelected + ":set_status=" + action.setStatusEvent + ":leave_paused=" + action.leavePausedSelected);
				case TuiSmokeGoalMenuActionKind.Validation:
					trace.push("tui.chat_widget_goal_menu.validation=" + action.validationSource + ":chars=" + action.actualChars + "/" + action.maxChars
						+ ":allowed=" + action.allowed + ":error=" + action.errorInserted + ":composer_cleared=" + action.composerCleared
						+ ":pending_drained=" + action.pendingSubmissionDrained);
				case TuiSmokeGoalMenuActionKind.InterruptPause:
					trace.push("tui.chat_widget_goal_menu.interrupt_pause=" + action.status + ":active_paused=" + action.activeGoalPaused + ":set_status="
						+ action.setStatusEvent);
				case TuiSmokeGoalMenuActionKind.Clear:
					trace.push("tui.chat_widget_goal_menu.clear=" + action.status + ":current=" + action.currentGoalCleared + ":indicator="
						+ action.collaborationIndicatorUpdated);
				case TuiSmokeGoalMenuActionKind.Failure:
					trace.push("tui.chat_widget_goal_menu.failure=" + action.failureCode + ":no_render=" + action.noRatatuiRender + ":no_model="
						+ action.noModelCall + ":no_app_server=" + action.noAppServerMutation + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.chat_widget_goal_menu.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceReviewMode(plan:TuiSmokeReviewModePlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowRatatuiRender || plan.allowModelCall || plan.allowAppServerMutation || !plan.enabled()) {
			trace.push("tui.chat_widget_review_mode.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.chat_widget_review_mode.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeReviewModeActionKind.Popup:
					trace.push("tui.chat_widget_review_mode.popup=" + "items=" + action.itemCount + ":opened=" + action.popupOpened + ":branch="
						+ action.branchPickerEvent + ":uncommitted=" + action.uncommittedReviewEvent + ":commit=" + action.commitPickerEvent + ":custom="
						+ action.customPromptEvent + ":child_accept=" + action.dismissParentOnChildAccept);
				case TuiSmokeReviewModeActionKind.Picker:
					trace.push("tui.chat_widget_review_mode.picker=" + action.pickerKind + ":items=" + action.itemCount + ":branches=" + action.branchCount
						+ ":commits=" + action.commitCount + ":search=" + action.searchable + ":target=" + action.target + ":review="
						+ (action.branchPickerEvent || action.commitPickerEvent));
				case TuiSmokeReviewModeActionKind.CustomPrompt:
					trace.push("tui.chat_widget_review_mode.custom=" + "prompt=" + action.prompt + ":empty_ignored=" + action.emptyIgnored + ":review="
						+ action.customPromptEvent);
				case TuiSmokeReviewModeActionKind.EnterExit:
					trace.push("tui.chat_widget_review_mode.enter_exit=" + "hint=" + action.hint + ":entered=" + action.reviewModeEntered + ":exited="
						+ action.reviewModeExited + ":banner=" + action.bannerInserted + ":prompt_suppressed=" + action.reviewPromptSuppressed
						+ ":assistant_rendered=" + action.assistantRendered);
				case TuiSmokeReviewModeActionKind.SteerQueue:
					trace.push("tui.chat_widget_review_mode.steer_queue=" + "pending=" + action.pendingSteerCount + ":queued=" + action.queuedMessageCount
						+ ":rejected=" + action.rejectedSteerCount + ":submitted=" + action.submittedCount + ":pending_submitted="
						+ action.pendingSteerSubmitted + ":non_steerable=" + action.nonSteerableRejected + ":prepended=" + action.rejectedSteersPrepended
						+ ":merged=" + action.mergedAfterReviewExit + ":preserved=" + action.existingQueuePreserved);
				case TuiSmokeReviewModeActionKind.Warning:
					trace.push("tui.chat_widget_review_mode.warning=" + action.failureCode + ":inserted=" + action.escWarningInserted + ":interrupt="
						+ !action.interruptSuppressed + ":pending=" + action.pendingSteerCount);
				case TuiSmokeReviewModeActionKind.TokenRestore:
					trace.push("tui.chat_widget_review_mode.tokens=" + "pre=" + action.preReviewPercent + ":review=" + action.reviewPercent + ":restored="
						+ action.restoredPercent + ":saved=" + action.tokenSnapshotSaved + ":restored_flag=" + action.tokenRestored);
				case TuiSmokeReviewModeActionKind.Guardian:
					trace.push("tui.chat_widget_review_mode.guardian=" + action.guardianStatus + ":risk=" + action.risk + ":summary=" + action.actionSummary
						+ ":header=" + action.statusHeader + ":details=" + action.statusDetails + ":parallel=" + action.parallelCount + ":remaining="
						+ action.remainingCount + ":status=" + action.statusSet + ":history=" + action.historyInserted + ":warning=" + action.warningInserted
						+ ":denial_stored=" + action.denialStored + ":approval_submit=" + action.approvalSubmitted + ":remaining_visible="
						+ action.remainingStatusVisible);
				case TuiSmokeReviewModeActionKind.Failure:
					trace.push("tui.chat_widget_review_mode.failure=" + action.failureCode + ":no_render=" + action.noRatatuiRender + ":no_model="
						+ action.noModelCall + ":no_app_server=" + action.noAppServerMutation + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.chat_widget_review_mode.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceTranscriptHistory(plan:TuiSmokeTranscriptHistoryPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowRatatuiRender || plan.allowModelCall || plan.allowAppServerMutation || !plan.enabled()) {
			trace.push("tui.chat_widget_transcript_history.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.chat_widget_transcript_history.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeTranscriptHistoryActionKind.Cell:
					trace.push("tui.chat_widget_transcript_history.cell=" + action.cellKind + ":mode=" + action.renderMode + ":width=" + action.width
						+ ":display=" + action.displayLines + ":raw=" + action.rawLines + ":transcript=" + action.transcriptLines + ":height="
						+ action.height + ":visible=" + action.visible + ":hyperlinks=" + action.hyperlinkAnnotated);
				case TuiSmokeTranscriptHistoryActionKind.User:
					trace.push("tui.chat_widget_transcript_history.user=" + action.source + ":turns=" + action.visibleUserTurns + ":display="
						+ action.displayLines + ":raw=" + action.rawLines + ":trim=" + action.trailingBlankTrimmed + ":images="
						+ action.remoteImagesSummarized + ":elements=" + action.textElementsStyled + ":inserted=" + action.inserted);
				case TuiSmokeTranscriptHistoryActionKind.Assistant:
					trace.push("tui.chat_widget_transcript_history.assistant=" + action.source + ":stream=" + action.streamStarted + ":consolidated="
						+ action.streamConsolidated + ":separator=" + action.separatorInserted + ":copy=" + action.copyRecorded + ":entries="
						+ action.copyEntries + ":active=" + action.activeCell);
				case TuiSmokeTranscriptHistoryActionKind.Reasoning:
					trace.push("tui.chat_widget_transcript_history.reasoning=" + action.source + ":transcript_only=" + action.transcriptOnly + ":display="
						+ action.displayLines + ":transcript=" + action.transcriptLines + ":status=" + action.status + ":revision=" + action.revision);
				case TuiSmokeTranscriptHistoryActionKind.Notice:
					trace.push("tui.chat_widget_transcript_history.notice=" + action.cellKind + ":message=" + action.message + ":hint="
						+ action.noticeHintShown + ":deduped=" + action.warningDeduped + ":error=" + action.errorInserted + ":inserted=" + action.inserted);
				case TuiSmokeTranscriptHistoryActionKind.Tool:
					trace.push("tui.chat_widget_transcript_history.tool=" + action.toolName + ":status=" + action.status + ":display=" + action.displayLines
						+ ":raw=" + action.rawLines + ":image_extra=" + action.toolExtraImageCell + ":inserted=" + action.inserted);
				case TuiSmokeTranscriptHistoryActionKind.Command:
					trace.push("tui.chat_widget_transcript_history.command=" + action.command + ":status=" + action.status + ":exit=" + action.exitCode
						+ ":grouped=" + action.commandGrouped + ":orphan=" + action.orphanHistoryInserted + ":display=" + action.displayLines
						+ ":transcript=" + action.transcriptLines);
				case TuiSmokeTranscriptHistoryActionKind.TranscriptMode:
					trace.push("tui.chat_widget_transcript_history.mode=" + action.renderMode + ":rich=" + action.richMode + ":raw=" + action.rawMode
						+ ":active_revision=" + action.activeRevisionBumped + ":hyperlinks=" + action.hyperlinkAnnotated + ":transcript="
						+ action.transcriptLines);
				case TuiSmokeTranscriptHistoryActionKind.CopyHistory:
					trace.push("tui.chat_widget_transcript_history.copy=" + "turns=" + action.visibleUserTurns + ":entries=" + action.copyEntries
						+ ":recorded=" + action.copyRecorded + ":revision=" + action.revision + ":source=" + action.source);
				case TuiSmokeTranscriptHistoryActionKind.Failure:
					trace.push("tui.chat_widget_transcript_history.failure=" + action.failureCode + ":no_render=" + action.noRatatuiRender + ":no_model="
						+ action.noModelCall + ":no_app_server=" + action.noAppServerMutation + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.chat_widget_transcript_history.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceTranscriptOverlay(plan:TuiSmokeTranscriptOverlayPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowRatatuiRender || plan.allowModelCall || plan.allowAppServerMutation || !plan.enabled()) {
			trace.push("tui.chat_widget_transcript_overlay.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.chat_widget_transcript_overlay.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeTranscriptOverlayActionKind.Open:
					trace.push("tui.chat_widget_transcript_overlay.open=" + "title=" + action.title + ":cells=" + action.committedCellCount + ":alt="
						+ action.altScreenEntered + ":opened=" + action.opened + ":frame=" + action.frameScheduled);
				case TuiSmokeTranscriptOverlayActionKind.LiveTailKey:
					trace.push("tui.chat_widget_transcript_overlay.key=" + "present=" + action.keyPresent + ":revision=" + action.revision
						+ ":continuation=" + action.streamContinuation + ":animation=" + action.animationTick + ":bumped=" + action.activeRevisionBumped);
				case TuiSmokeTranscriptOverlayActionKind.LiveTailSync:
					trace.push("tui.chat_widget_transcript_overlay.live_tail=" + "width=" + action.width + ":lines=" + action.liveTailLines + ":recomputed="
						+ action.recomputed + ":cache_hit=" + action.cacheHit + ":follow_bottom=" + action.followBottom + ":continuation="
						+ action.streamContinuation + ":top_inset=" + action.topInset + ":links=" + action.hyperlinkAnnotated + ":animation_frame="
						+ action.animationScheduled);
				case TuiSmokeTranscriptOverlayActionKind.LiveTailDrop:
					trace.push("tui.chat_widget_transcript_overlay.drop_tail=" + "key=" + action.keyPresent + ":dropped=" + action.dropped + ":renderables="
						+ action.renderableCount);
				case TuiSmokeTranscriptOverlayActionKind.InsertCell:
					trace.push("tui.chat_widget_transcript_overlay.insert=" + action.source + ":cells=" + action.committedCellCount + ":renderables="
						+ action.renderableCount + ":tail_lines=" + action.liveTailLines + ":follow_bottom=" + action.followBottom + ":inserted="
						+ action.inserted);
				case TuiSmokeTranscriptOverlayActionKind.ReplaceCells:
					trace.push("tui.chat_widget_transcript_overlay.replace=" + "cells=" + action.committedCellCount + ":replaced=" + action.replacedCount
						+ ":highlight_cleared=" + action.highlightCleared + ":follow_bottom=" + action.followBottom);
				case TuiSmokeTranscriptOverlayActionKind.Consolidate:
					trace.push("tui.chat_widget_transcript_overlay.consolidate=" + "range=" + action.consolidatedStart + ".." + action.consolidatedEnd
						+ ":cells=" + action.committedCellCount + ":renderables=" + action.renderableCount + ":follow_bottom=" + action.followBottom
						+ ":frame=" + action.frameScheduled);
				case TuiSmokeTranscriptOverlayActionKind.Highlight:
					trace.push("tui.chat_widget_transcript_overlay.highlight=" + "cell=" + action.selectedCell + ":applied=" + action.highlightApplied
						+ ":cleared=" + action.highlightCleared + ":scroll=" + action.scrollOffset);
				case TuiSmokeTranscriptOverlayActionKind.Paging:
					trace.push("tui.chat_widget_transcript_overlay.paging=" + "height=" + action.height + ":page=" + action.pageHeight + ":offset="
						+ action.scrollOffset + ":continuous=" + action.continuousPaging + ":roundtrip=" + action.roundTripped);
				case TuiSmokeTranscriptOverlayActionKind.RawMode:
					trace.push("tui.chat_widget_transcript_overlay.raw_mode=" + action.renderMode + ":raw=" + action.rawMode + ":rich=" + action.richMode
						+ ":frame=" + action.frameScheduled + ":links=" + action.hyperlinkAnnotated);
				case TuiSmokeTranscriptOverlayActionKind.Close:
					trace.push("tui.chat_widget_transcript_overlay.close=" + "closed=" + action.closed + ":frame=" + action.frameScheduled);
				case TuiSmokeTranscriptOverlayActionKind.Failure:
					trace.push("tui.chat_widget_transcript_overlay.failure=" + action.failureCode + ":no_render=" + action.noRatatuiRender + ":no_model="
						+ action.noModelCall + ":no_app_server=" + action.noAppServerMutation + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.chat_widget_transcript_overlay.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceBacktrackOverlay(plan:TuiSmokeBacktrackOverlayPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowRatatuiRender || plan.allowModelCall || plan.allowAppServerMutation || !plan.enabled()) {
			trace.push("tui.chat_widget_backtrack_overlay.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.chat_widget_backtrack_overlay.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeBacktrackOverlayActionKind.Prime:
					trace.push("tui.chat_widget_backtrack_overlay.prime=" + "thread=" + action.threadId + ":users=" + action.userCount + ":composer_empty="
						+ action.composerEmpty + ":target=" + action.targetAvailable + ":primed=" + action.primed + ":base=" + action.baseThreadCaptured
						+ ":hint=" + action.hintShown);
				case TuiSmokeBacktrackOverlayActionKind.OpenPreview:
					trace.push("tui.chat_widget_backtrack_overlay.open_preview=" + "users=" + action.userCount + ":alt=" + action.altScreenEntered
						+ ":opened=" + action.overlayOpened + ":preview=" + action.overlayPreviewActive + ":hint_cleared=" + action.hintCleared + ":frame="
						+ action.frameScheduled);
				case TuiSmokeBacktrackOverlayActionKind.OverlayPreview:
					trace.push("tui.chat_widget_backtrack_overlay.overlay_preview=" + "source=" + action.source + ":users=" + action.userCount + ":preview="
						+ action.overlayPreviewActive + ":target=" + action.targetAvailable + ":frame=" + action.frameScheduled);
				case TuiSmokeBacktrackOverlayActionKind.Selection:
					trace.push("tui.chat_widget_backtrack_overlay.selection=" + action.source + ":nth=" + action.nthUserMessage + ":cell="
						+ action.cellIndex + ":thread_match=" + action.selectionMatchedThread + ":highlight=" + action.highlightApplied + ":prefill="
						+ action.prefill + ":text=" + action.textElementCount + ":local=" + action.localImageCount + ":remote=" + action.remoteImageCount);
				case TuiSmokeBacktrackOverlayActionKind.Step:
					trace.push("tui.chat_widget_backtrack_overlay.step=" + action.direction + ":from=" + action.previousNthUserMessage + ":to="
						+ action.nextNthUserMessage + ":cell=" + action.cellIndex + ":clamped=" + action.clamped + ":highlight=" + action.highlightApplied
						+ ":frame=" + action.frameScheduled);
				case TuiSmokeBacktrackOverlayActionKind.Confirm:
					trace.push("tui.chat_widget_backtrack_overlay.confirm=" + "nth=" + action.nthUserMessage + ":closed=" + action.closed + ":confirmed="
						+ action.confirmed + ":thread_match=" + action.selectionMatchedThread + ":frame=" + action.frameScheduled);
				case TuiSmokeBacktrackOverlayActionKind.RollbackRequest:
					trace.push("tui.chat_widget_backtrack_overlay.rollback_request=" + "nth=" + action.nthUserMessage + ":users=" + action.userCount
						+ ":num_turns=" + action.numTurns + ":pending=" + action.pendingRollbackSet + ":submitted=" + action.rollbackSubmitted + ":prefill="
						+ action.composerPrefilled + ":remote=" + action.remoteImagesRestored);
				case TuiSmokeBacktrackOverlayActionKind.RollbackSuccess:
					trace.push("tui.chat_widget_backtrack_overlay.rollback_success=" + "nth=" + action.nthUserMessage + ":from=" + action.originalCellCount
						+ ":to=" + action.trimmedCellCount + ":copy_users=" + action.copyHistoryUserCount + ":overlay_replaced=" + action.overlayReplaced
						+ ":deferred_cleared=" + action.deferredHistoryCleared + ":render_pending=" + action.renderPending);
				case TuiSmokeBacktrackOverlayActionKind.RollbackFailure:
					trace.push("tui.chat_widget_backtrack_overlay.rollback_failure=" + "pending_cleared=" + action.pendingRollbackCleared);
				case TuiSmokeBacktrackOverlayActionKind.NonPendingRollback:
					trace.push("tui.chat_widget_backtrack_overlay.non_pending=" + "num_turns=" + action.numTurns + ":from=" + action.originalCellCount
						+ ":to=" + action.trimmedCellCount + ":copy_users=" + action.copyHistoryUserCount + ":overlay_replaced=" + action.overlayReplaced
						+ ":render_pending=" + action.renderPending);
				case TuiSmokeBacktrackOverlayActionKind.Trim:
					trace.push("tui.chat_widget_backtrack_overlay.trim=" + "nth=" + action.nthUserMessage + ":from=" + action.originalCellCount + ":to="
						+ action.trimmedCellCount + ":copy_truncated=" + action.copyHistoryTruncated + ":highlight_cleared=" + action.highlightCleared);
				case TuiSmokeBacktrackOverlayActionKind.Unavailable:
					trace.push("tui.chat_widget_backtrack_overlay.unavailable=" + action.source + ":users=" + action.userCount + ":target="
						+ action.targetAvailable + ":reset=" + action.stateReset + ":info=" + action.infoInserted + ":side_rejected="
						+ action.sideConversationRejected + ":vim_insert_allowed=" + action.vimInsertAllowed + ":frame=" + action.frameScheduled);
				case TuiSmokeBacktrackOverlayActionKind.Reset:
					trace.push("tui.chat_widget_backtrack_overlay.reset=" + action.source + ":primed=" + action.primed + ":preview="
						+ action.overlayPreviewActive + ":pending=" + action.pendingRollbackSet + ":render_pending=" + action.renderPending);
				case TuiSmokeBacktrackOverlayActionKind.Failure:
					trace.push("tui.chat_widget_backtrack_overlay.failure=" + action.failureCode + ":no_render=" + action.noRatatuiRender + ":no_model="
						+ action.noModelCall + ":no_app_server=" + action.noAppServerMutation + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.chat_widget_backtrack_overlay.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceKeymapRawOutput(plan:TuiSmokeKeymapRawOutputPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveTerminal || plan.allowRatatuiRender || plan.allowModelCall || plan.allowAppServerMutation || !plan.enabled()) {
			trace.push("tui.chat_widget_keymap_raw_output.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.chat_widget_keymap_raw_output.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeKeymapRawOutputActionKind.RawOutputDefault:
					trace.push("tui.chat_widget_keymap_raw_output.raw_default=" + "action=" + action.actionName + ":binding=" + action.binding + ":matched="
						+ action.matched + ":surface=" + action.surface);
				case TuiSmokeKeymapRawOutputActionKind.RawOutputRemap:
					trace.push("tui.chat_widget_keymap_raw_output.raw_remap=" + "action=" + action.actionName + ":binding=" + action.binding + ":previous="
						+ action.previousBinding + ":remapped=" + action.remapped + ":default_pruned=" + action.defaultPruned);
				case TuiSmokeKeymapRawOutputActionKind.ToggleRawOutput:
					trace.push("tui.chat_widget_keymap_raw_output.toggle=" + "binding=" + action.binding + ":raw=" + action.rawOutputBefore + "->"
						+ action.rawOutputAfter + ":toggled=" + action.rawOutputToggled + ":frame=" + action.frameScheduled + ":live_terminal="
						+ !action.noLiveTerminal);
				case TuiSmokeKeymapRawOutputActionKind.ExplicitUnbind:
					trace.push("tui.chat_widget_keymap_raw_output.unbind=" + "action=" + action.actionName + ":bindings=" + action.afterCount + ":unbound="
						+ action.unbound + ":fallback_suppressed=" + action.fallbackSuppressed);
				case TuiSmokeKeymapRawOutputActionKind.EditorAliases:
					trace.push("tui.chat_widget_keymap_raw_output.editor_aliases=" + "newline=" + action.aliasCount + ":delete_word=" + action.binding
						+ ":modified_delete=" + action.modifiedDeleteCount + ":preserved=" + action.preserved);
				case TuiSmokeKeymapRawOutputActionKind.MainSurfaceAssignment:
					trace.push("tui.chat_widget_keymap_raw_output.main_assign=" + "action=" + action.actionName + ":binding=" + action.binding + ":surface="
						+ action.surface + ":assigned=" + action.assigned + ":conflict=" + action.conflict);
				case TuiSmokeKeymapRawOutputActionKind.MainSurfaceConflict:
					trace.push("tui.chat_widget_keymap_raw_output.main_conflict=" + "action=" + action.actionName + ":binding=" + action.binding
						+ ":conflict=" + action.conflictWith + ":rejected=" + action.rejected);
				case TuiSmokeKeymapRawOutputActionKind.FixedShortcutConflict:
					trace.push("tui.chat_widget_keymap_raw_output.fixed_conflict=" + "action=" + action.actionName + ":binding=" + action.binding
						+ ":conflict=" + action.conflictWith + ":rejected=" + action.rejected);
				case TuiSmokeKeymapRawOutputActionKind.FixedShortcutUnbindRemap:
					trace.push("tui.chat_widget_keymap_raw_output.fixed_unbind_remap=" + "action=" + action.actionName + ":binding=" + action.binding
						+ ":conflict=" + action.conflictWith + ":unbound=" + action.unbound + ":assigned=" + action.assigned);
				case TuiSmokeKeymapRawOutputActionKind.DefaultPruning:
					trace.push("tui.chat_widget_keymap_raw_output.default_pruning=" + "surface=" + action.surface + ":defaults=" + action.beforeCount + "->"
						+ action.afterCount + ":legacy_pruned=" + action.legacyPruned + ":conflict=" + action.conflict);
				case TuiSmokeKeymapRawOutputActionKind.BindingInput:
					trace.push("tui.chat_widget_keymap_raw_output.binding_input=" + "path=" + action.errorPath + ":string_or_array="
						+ action.stringOrArrayAccepted + ":deduped=" + action.beforeCount + "->" + action.afterCount + ":fallback=" + action.fallback
						+ ":invalid_path=" + action.conflictAction);
				case TuiSmokeKeymapRawOutputActionKind.Failure:
					trace.push("tui.chat_widget_keymap_raw_output.failure=" + action.failureCode + ":no_terminal=" + action.noLiveTerminal + ":no_render="
						+ action.noRatatuiRender + ":no_model=" + action.noModelCall + ":no_app_server=" + action.noAppServerMutation + ":unsupported="
						+ action.unsupportedRejected);
				case _:
					trace.push("tui.chat_widget_keymap_raw_output.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceRawOutputRender(plan:TuiSmokeRawOutputRenderPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowRatatuiRender || plan.allowModelCall || plan.allowAppServerMutation || !plan.enabled()) {
			trace.push("tui.chat_widget_raw_output_render.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.chat_widget_raw_output_render.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeRawOutputRenderActionKind.ModeSet:
					trace.push("tui.chat_widget_raw_output_render.mode=" + action.renderMode + ":raw=" + action.rawOutputBefore + "->"
						+ action.rawOutputAfter + ":config=" + action.configUpdated + ":propagated=" + action.renderModePropagated + ":redraw="
						+ action.redrawRequested + ":event=" + action.rawEventEmitted);
				case TuiSmokeRawOutputRenderActionKind.Notice:
					trace.push("tui.chat_widget_raw_output_render.notice=" + action.notice + ":inserted=" + action.noticeInserted + ":raw="
						+ action.rawOutputAfter);
				case TuiSmokeRawOutputRenderActionKind.StatusLine:
					trace.push("tui.chat_widget_raw_output_render.status=" + action.status + ":visible=" + action.statusVisible + ":raw="
						+ action.rawOutputAfter);
				case TuiSmokeRawOutputRenderActionKind.RenderCell:
					trace.push("tui.chat_widget_raw_output_render.cell=" + action.cellKind + ":mode=" + action.renderMode + ":width=" + action.width
						+ ":display=" + action.displayLines + ":raw=" + action.rawLines + ":visible=" + action.visibleLines + ":plain="
						+ action.plainSelection + ":links=" + action.hyperlinkAnnotated);
				case TuiSmokeRawOutputRenderActionKind.ActiveStream:
					trace.push("tui.chat_widget_raw_output_render.active_stream=" + action.source + ":mode=" + action.renderMode + ":width=" + action.width
						+ ":revision=" + action.revisionBefore + "->" + action.revisionAfter + ":tail_synced=" + action.activeTailSynced + ":redraw="
						+ action.redrawRequested);
				case TuiSmokeRawOutputRenderActionKind.CommandOutput:
					trace.push("tui.chat_widget_raw_output_render.command=" + action.command + ":grouped=" + action.commandGrouped + ":stdout="
						+ action.stdoutVisible + ":stderr=" + action.stderrVisible + ":display=" + action.displayLines + ":raw=" + action.rawLines);
				case TuiSmokeRawOutputRenderActionKind.ToolOutput:
					trace.push("tui.chat_widget_raw_output_render.tool=" + action.toolName + ":status=" + action.status + ":display=" + action.displayLines
						+ ":raw=" + action.rawLines + ":hidden=" + action.hiddenLines + ":image_extra=" + action.toolExtraImageCell);
				case TuiSmokeRawOutputRenderActionKind.CopyTranscript:
					trace.push("tui.chat_widget_raw_output_render.copy_transcript=" + action.source + ":copy=" + action.copyLines + ":transcript="
						+ action.transcriptLines + ":copy_preserved=" + action.copyPreserved + ":transcript_preserved=" + action.transcriptPreserved);
				case TuiSmokeRawOutputRenderActionKind.ResizeSync:
					trace.push("tui.chat_widget_raw_output_render.resize=" + action.previousWidth + "->" + action.width + ":mode=" + action.renderMode
						+ ":tail_synced=" + action.activeTailSynced + ":revision_bumped=" + action.activeRevisionBumped + ":redraw=" + action.redrawRequested);
				case TuiSmokeRawOutputRenderActionKind.SlashCommand:
					trace.push("tui.chat_widget_raw_output_render.slash=" + action.slashCommand + ":raw=" + action.rawOutputBefore + "->"
						+ action.rawOutputAfter + ":event=" + action.rawEventEmitted + ":notice=" + action.noticeInserted);
				case TuiSmokeRawOutputRenderActionKind.Failure:
					trace.push("tui.chat_widget_raw_output_render.failure=" + action.failureCode + ":no_render=" + action.noRatatuiRender + ":no_model="
						+ action.noModelCall + ":no_app_server=" + action.noAppServerMutation + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.chat_widget_raw_output_render.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceSlashCommand(plan:TuiSmokeSlashCommandPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowRatatuiRender || plan.allowModelCall || plan.allowAppServerMutation || !plan.enabled()) {
			trace.push("tui.chat_widget_slash_command.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.chat_widget_slash_command.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeSlashCommandActionKind.Dispatch:
					trace.push("tui.chat_widget_slash_command.dispatch=" + action.command + ":source=" + action.source + ":history=" + action.historyStaged
						+ "->" + action.historyRecorded + ":task=" + action.taskRunning + ":side=" + action.sideConversation + ":allowed="
						+ action.commandAllowed + ":redraw=" + action.redrawRequested);
				case TuiSmokeSlashCommandActionKind.RawMode:
					trace.push("tui.chat_widget_slash_command.raw=" + action.command + ":args=" + action.args + ":raw=" + action.rawOutputBefore + "->"
						+ action.rawOutputAfter + ":config=" + action.configUpdated + ":notice=" + action.noticeInserted + ":surfaces="
						+ action.statusSurfacesRefreshed + ":event=" + action.appEventSent);
				case TuiSmokeSlashCommandActionKind.StatusOutput:
					trace.push("tui.chat_widget_slash_command.status=" + action.command + ":card=" + action.statusCard + ":inserted="
						+ action.statusOutputInserted + ":prefetch=" + action.rateLimitPrefetch + ":request=" + action.requestId + ":refreshing="
						+ action.statusRefreshing + ":event=" + action.appEventSent);
				case TuiSmokeSlashCommandActionKind.InlineArgs:
					trace.push("tui.chat_widget_slash_command.inline_args=" + action.command + ":args=" + action.args + ":supports="
						+ action.supportsInlineArgs + ":trimmed=" + action.argsTrimmed + ":fallback=" + action.fallbackToBare);
				case TuiSmokeSlashCommandActionKind.Availability:
					trace.push("tui.chat_widget_slash_command.availability=" + action.command + ":task=" + action.taskRunning + ":side="
						+ action.sideConversation + ":side_allowed=" + action.sideAllowed + ":allowed=" + action.commandAllowed + ":drained="
						+ action.submissionDrained + ":redraw=" + action.redrawRequested);
				case TuiSmokeSlashCommandActionKind.AppEvent:
					trace.push("tui.chat_widget_slash_command.app_event="
						+ action.appEvent
						+ ":command="
						+ action.command
						+ ":sent="
						+ action.appEventSent);
				case TuiSmokeSlashCommandActionKind.Failure:
					trace.push("tui.chat_widget_slash_command.failure=" + action.failureCode + ":no_render=" + action.noRatatuiRender + ":no_model="
						+ action.noModelCall + ":no_app_server=" + action.noAppServerMutation + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.chat_widget_slash_command.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceStatusCard(plan:TuiSmokeStatusCardPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowRatatuiRender || plan.allowModelCall || plan.allowAppServerMutation || !plan.enabled()) {
			trace.push("tui.chat_widget_status_card.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.chat_widget_status_card.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeStatusCardActionKind.Summary:
					trace.push("tui.chat_widget_status_card.summary=" + "command=" + action.commandRow + ":rows=" + action.rowCount + ":inserted="
						+ action.statusOutputInserted + ":usage_link=" + action.showChatGptUsageLink + ":remote=" + action.remoteConnectionVisible);
				case TuiSmokeStatusCardActionKind.ModelProvider:
					trace.push("tui.chat_widget_status_card.model=" + action.model + ":details=" + action.modelDetails + ":provider=" + action.provider
						+ ":runtime=" + action.runtimeProvider + ":account=" + action.account);
				case TuiSmokeStatusCardActionKind.Permissions:
					trace.push("tui.chat_widget_status_card.permissions=" + action.permissions + ":dir=" + action.directory + ":agents=" +
						action.agentsSummary);
				case TuiSmokeStatusCardActionKind.ThreadSession:
					trace.push("tui.chat_widget_status_card.thread=" + action.threadName + ":session=" + action.sessionId + ":forked_from="
						+ action.forkedFrom + ":collab=" + action.collaborationMode);
				case TuiSmokeStatusCardActionKind.TokenUsage:
					trace.push("tui.chat_widget_status_card.tokens=" + "total=" + action.totalTokens + ":input=" + action.inputTokens + ":output="
						+ action.outputTokens + ":visible=" + action.tokenUsageVisible + ":context=" + action.contextUsed + "/" + action.contextWindow
						+ ":context_left=" + action.contextPercentRemaining + ":context_visible=" + action.contextWindowVisible);
				case TuiSmokeStatusCardActionKind.RateLimit:
					trace.push("tui.chat_widget_status_card.rate_limit=" + action.rateLimitState + ":label=" + action.rateLimitLabel + ":summary="
						+ action.rateLimitSummary + ":reset=" + action.rateLimitReset + ":details=" + action.rateLimitDetails + ":warning="
						+ action.rateLimitWarning + ":rows=" + action.rateLimitRowCount + ":refreshing=" + action.refreshingRateLimits);
				case TuiSmokeStatusCardActionKind.Refresh:
					trace.push("tui.chat_widget_status_card.refresh=" + action.rateLimitState + ":rows=" + action.rateLimitRowCount + ":completed="
						+ action.refreshCompleted + ":refreshing=" + action.refreshingRateLimits);
				case TuiSmokeStatusCardActionKind.RenderWidth:
					trace.push("tui.chat_widget_status_card.render_width=" + "width=" + action.width + ":inner=" + action.innerWidth + ":value="
						+ action.valueWidth + ":rows=" + action.rowCount + ":wrapped=" + action.wrappedLineCount + ":continued="
						+ action.continuationLineCount + ":truncated=" + action.truncatedLineCount);
				case TuiSmokeStatusCardActionKind.RemoteWrap:
					trace.push("tui.chat_widget_status_card.remote_wrap=" + action.remoteAddress + ":width=" + action.width + ":value=" + action.valueWidth
						+ ":visible=" + action.remoteConnectionVisible + ":wrapped=" + action.wrappedLineCount);
				case TuiSmokeStatusCardActionKind.Continuation:
					trace.push("tui.chat_widget_status_card.continuation=" + action.rowName + ":summary=" + action.rateLimitSummary + ":reset="
						+ action.rateLimitReset + ":details=" + action.rateLimitDetails + ":continued=" + action.continuationLineCount + ":truncated="
						+ action.truncatedLineCount);
				case TuiSmokeStatusCardActionKind.SubscriberVisibility:
					trace.push("tui.chat_widget_status_card.subscriber=" + action.account + ":token_visible=" + action.tokenUsageVisible
						+ ":context_visible=" + action.contextWindowVisible + ":hidden=" + action.hiddenRowCount);
				case TuiSmokeStatusCardActionKind.UsageLink:
					trace.push("tui.chat_widget_status_card.usage_link=" + action.provider + ":visible=" + action.showChatGptUsageLink + ":row_visible="
						+ action.rowVisible);
				case TuiSmokeStatusCardActionKind.RefreshRequest:
					trace.push("tui.chat_widget_status_card.refresh_request=" + "request=" + action.requestId + ":next=" + action.nextRequestId
						+ ":pending=" + action.pendingRefreshCount + ":inserted=" + action.statusOutputInserted + ":refreshing="
						+ action.refreshingRateLimits + ":event=" + action.appEventEmitted);
				case TuiSmokeStatusCardActionKind.RefreshDelivery:
					trace.push("tui.chat_widget_status_card.refresh_delivery=" + "request=" + action.requestId + ":snapshot_left="
						+ action.snapshotPercentRemaining + ":pending=" + action.pendingRefreshCount + "->" + action.remainingRefreshCount + ":updated="
						+ action.statusHistoryUpdated + ":completed=" + action.refreshCompleted + ":refreshing=" + action.refreshingRateLimits + ":redraw="
						+ action.redrawRequested);
				case TuiSmokeStatusCardActionKind.CachedSnapshot:
					trace.push("tui.chat_widget_status_card.cached_snapshot=" + "left=" + action.snapshotPercentRemaining + ":future_status="
						+ action.cachedForFutureStatus + ":rows=" + action.rateLimitRowCount);
				case TuiSmokeStatusCardActionKind.StaleCompletion:
					trace.push("tui.chat_widget_status_card.stale_completion=" + "request=" + action.requestId + ":pending=" + action.pendingRefreshCount
						+ "->" + action.remainingRefreshCount + ":ignored=" + action.staleCompletionIgnored + ":updated=" + action.statusHistoryUpdated
						+ ":redraw=" + action.redrawRequested);
				case TuiSmokeStatusCardActionKind.StartupPrefetch:
					trace.push("tui.chat_widget_status_card.startup_prefetch=" + "snapshot_left=" + action.snapshotPercentRemaining + ":cached="
						+ action.cachedForFutureStatus + ":frame=" + action.frameScheduled + ":status_handle=" + action.statusHistoryUpdated);
				case TuiSmokeStatusCardActionKind.NoRefreshGate:
					trace.push("tui.chat_widget_status_card.no_refresh_gate=" + action.provider + ":inserted=" + action.statusOutputInserted + ":event="
						+ action.appEventEmitted + ":pending=" + action.pendingRefreshCount);
				case TuiSmokeStatusCardActionKind.Failure:
					trace.push("tui.chat_widget_status_card.failure=" + action.failureCode + ":no_render=" + action.noRatatuiRender + ":no_model="
						+ action.noModelCall + ":no_app_server=" + action.noAppServerMutation + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.chat_widget_status_card.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceModelSettings(plan:TuiSmokeModelSettingsPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowRatatuiRender || plan.allowModelCall || plan.allowConfigMutation || !plan.enabled()) {
			trace.push("tui.chat_widget_model_settings.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.chat_widget_model_settings.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeModelSettingsActionKind.ModelPopup:
					trace.push("tui.chat_widget_model_settings.model_popup=" + "session=" + action.sessionConfigured + ":catalog=" + action.catalogReady
						+ ":auto=" + action.autoPresetCount + ":other=" + action.otherPresetCount + ":items=" + action.itemCount + ":current="
						+ action.currentSelected + ":all_row=" + action.allModelsRow + ":warning=" + action.customBaseUrlWarning + ":open_all="
						+ action.openAllModelsEvent);
				case TuiSmokeModelSettingsActionKind.AllModelsPopup:
					trace.push("tui.chat_widget_model_settings.all_models=" + "items=" + action.itemCount + ":model=" + action.model + ":current="
						+ action.currentSelected + ":default=" + action.defaultSelected + ":reasoning_event=" + action.openReasoningEvent + ":single_auto="
						+ action.singleEffortAutoApplied);
				case TuiSmokeModelSettingsActionKind.ReasoningPopup:
					trace.push("tui.chat_widget_model_settings.reasoning=" + action.model + ":choices=" + action.reasoningChoiceCount + ":selected="
						+ action.effort + ":warning=" + action.warningShown + ":plan=" + action.planMode + ":update_model=" + action.updateModel
						+ ":update_reasoning=" + action.updateReasoning + ":persist=" + action.persistModel);
				case TuiSmokeModelSettingsActionKind.PlanScopePrompt:
					trace.push("tui.chat_widget_model_settings.plan_scope=" + action.model + ":effort=" + action.effort + ":plan_only="
						+ action.planOnlySelected + ":all_modes=" + action.allModesSelected + ":update_model=" + action.updateModel + ":update_reasoning="
						+ action.updateReasoning + ":update_plan=" + action.updatePlanReasoning + ":persist_model=" + action.persistModel + ":persist_plan="
						+ action.persistPlanReasoning + ":notify=" + action.notifyPlanPrompt);
				case TuiSmokeModelSettingsActionKind.ServiceTier:
					trace.push("tui.chat_widget_model_settings.service_tier=" + action.serviceTier + ":configured=" + action.configuredTier + ":effective="
						+ action.effectiveTier + ":fast_feature=" + action.fastFeatureEnabled + ":toggle_allowed=" + action.fastToggleAllowed + ":override="
						+ action.overrideTurnContext + ":persist=" + action.persistServiceTier + ":refresh=" + action.refreshSurfaces);
				case TuiSmokeModelSettingsActionKind.Personality:
					trace.push("tui.chat_widget_model_settings.personality=" + action.personality + ":session=" + action.sessionConfigured + ":supports="
						+ action.supportsPersonality + ":popup=" + action.popupOpened + ":error=" + action.errorInserted + ":override="
						+ action.overrideTurnContext + ":persist=" + action.persistPersonality);
				case TuiSmokeModelSettingsActionKind.RealtimeAudio:
					trace.push("tui.chat_widget_model_settings.audio=" + action.audioKind + ":devices=" + action.deviceCount + ":selected="
						+ action.selectedDevice + ":default_row=" + action.defaultDeviceRow + ":unavailable=" + action.unavailableDeviceRow + ":persist="
						+ action.persistAudioDevice + ":restart_prompt=" + action.restartPrompt + ":restart=" + action.restartEvent);
				case TuiSmokeModelSettingsActionKind.ExperimentalFeatures:
					trace.push("tui.chat_widget_model_settings.experimental=" + "features=" + action.featureCount + ":stable_omitted="
						+ action.stableFeatureOmitted + ":save_on_exit=" + action.configSaveOnExit + ":popup=" + action.popupOpened);
				case TuiSmokeModelSettingsActionKind.Failure:
					trace.push("tui.chat_widget_model_settings.failure=" + action.failureCode + ":no_render=" + action.noRatatuiRender + ":no_model="
						+ action.noModelCall + ":no_config=" + action.noConfigMutation + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.chat_widget_model_settings.unknown");
					return false;
			}
		}
		return true;
	}

	static function tracePermissionSelection(plan:TuiSmokePermissionSelectionPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowRatatuiRender || plan.allowModelCall || plan.allowFilesystemMutation || !plan.enabled()) {
			trace.push("tui.chat_widget_permission_selection.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.chat_widget_permission_selection.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokePermissionSelectionActionKind.ModeList:
					trace.push("tui.chat_widget_permission_selection.mode_list=" + "items=" + action.itemCount + ":disabled=" + action.disabledCount
						+ ":read_only=" + action.includeReadOnly + ":guardian=" + action.guardianEnabled + ":auto_review=" + action.autoReviewIncluded
						+ ":degraded=" + action.windowsDegradedSandbox + ":elevate_hint=" + action.elevateSandboxHint);
				case TuiSmokePermissionSelectionActionKind.ProfileList:
					trace.push("tui.chat_widget_permission_selection.profile_list=" + "items=" + action.itemCount + ":builtin=" + action.builtinCount
						+ ":custom=" + action.customProfileCount + ":current=" + action.profileId + ":auto_review=" + action.autoReviewIncluded);
				case TuiSmokePermissionSelectionActionKind.SelectProfile:
					trace.push("tui.chat_widget_permission_selection.select_profile=" + action.profileId + ":label=" + action.displayLabel + ":approval="
						+ action.approvalPolicy + ":reviewer=" + action.reviewer + ":current=" + action.isCurrent + ":override=" + action.overrideTurnContext
						+ ":approval_event=" + action.updateApprovalPolicy + ":reviewer_event=" + action.updateReviewer + ":profile_event="
						+ action.selectProfileEvent + ":history=" + action.historyCellEmitted);
				case TuiSmokePermissionSelectionActionKind.FullAccessConfirm:
					trace.push("tui.chat_widget_permission_selection.full_access=" + action.presetId + ":warning_hidden=" + action.warningHidden
						+ ":requires=" + action.requiresConfirmation + ":opened=" + action.confirmationOpened + ":return=" + action.returnToPermissions
						+ ":remember=" + action.rememberDismissal + ":history=" + action.historyCellEmitted);
				case TuiSmokePermissionSelectionActionKind.AutoReviewDenials:
					trace.push("tui.chat_widget_permission_selection.denials=" + "entries=" + action.denialCount + ":popup=" + action.popupOpened
						+ ":empty_info=" + action.emptyInfoInserted + ":missing_thread=" + action.missingThreadError + ":selected=" + action.selectedId
						+ ":submit=" + action.submitThreadOp + ":info=" + action.infoInserted);
				case TuiSmokePermissionSelectionActionKind.DisabledPreset:
					trace.push("tui.chat_widget_permission_selection.disabled=" + action.presetId + ":approval=" + action.approvalDisabled + ":guardian="
						+ action.guardianDisabled + ":skipped=" + action.skippedByNavigation);
				case TuiSmokePermissionSelectionActionKind.Failure:
					trace.push("tui.chat_widget_permission_selection.failure=" + action.failureCode + ":no_render=" + action.noRatatuiRender + ":no_model="
						+ action.noModelCall + ":no_fs=" + action.noFilesystemMutation + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.chat_widget_permission_selection.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceWindowsSandbox(plan:TuiSmokeWindowsSandboxPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowOsSandboxMutation || plan.allowRatatuiRender || plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.chat_widget_windows_sandbox.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.chat_widget_windows_sandbox.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeWindowsSandboxActionKind.ModeAllowed:
					trace.push("tui.chat_widget_windows_sandbox.mode_allowed=" + action.mode + ":allowed=" + action.allowed);
				case TuiSmokeWindowsSandboxActionKind.SetupRequired:
					trace.push("tui.chat_widget_windows_sandbox.setup_required=" + "elevated=" + action.elevatedLevel + ":source="
						+ action.configSourcePresent + ":complete=" + action.setupComplete + ":required=" + action.setupRequired);
				case TuiSmokeWindowsSandboxActionKind.EnablePrompt:
					trace.push("tui.chat_widget_windows_sandbox.enable_prompt=" + action.promptKind + ":preset=" + action.presetId + ":legacy_nux="
						+ action.legacyNuxEnabled + ":allow_unelevated=" + action.allowUnelevated + ":admin=" + action.adminActionShown + ":fallback="
						+ action.unelevatedFallbackShown + ":quit=" + action.quitActionShown + ":cancel_reopens=" + action.cancelReopens + ":telemetry="
						+ action.telemetryRecorded + ":elevated_event=" + action.elevatedSetupEvent + ":legacy_event=" + action.legacySetupEvent);
				case TuiSmokeWindowsSandboxActionKind.FallbackPrompt:
					trace.push("tui.chat_widget_windows_sandbox.fallback_prompt=" + action.promptKind + ":preset=" + action.presetId + ":allow_unelevated="
						+ action.allowUnelevated + ":retry=" + action.retryActionShown + ":legacy=" + action.unelevatedFallbackShown + ":quit="
						+ action.quitActionShown + ":cancel_reopens=" + action.cancelReopens + ":fallback_event=" + action.fallbackPromptEvent
						+ ":elevated_event=" + action.elevatedSetupEvent + ":legacy_event=" + action.legacySetupEvent);
				case TuiSmokeWindowsSandboxActionKind.StartupPrompt:
					trace.push("tui.chat_widget_windows_sandbox.startup_prompt=" + "show_now=" + action.showNow + ":required=" + action.setupRequired
						+ ":popup=" + action.popupOpened + ":enable_event=" + action.enablePromptEvent + ":quit=" + action.quitActionShown);
				case TuiSmokeWindowsSandboxActionKind.InitialPromptGate:
					trace.push("tui.chat_widget_windows_sandbox.initial_prompt=" + action.initialMessage + ":required=" + action.setupRequired + ":held="
						+ action.initialMessageHeld + ":submitted=" + action.initialMessageSubmitted + ":mode=" + action.mode);
				case TuiSmokeWindowsSandboxActionKind.WorldWritableWarning:
					trace.push("tui.chat_widget_windows_sandbox.world_writable=" + "shown=" + action.warningShown + ":remembered="
						+ action.rememberedWarning + ":failed_scan=" + action.failedScan + ":paths=" + action.samplePaths + ":extra=" + action.extraCount
						+ ":items=" + action.itemCount);
				case TuiSmokeWindowsSandboxActionKind.Failure:
					trace.push("tui.chat_widget_windows_sandbox.failure=" + action.failureCode + ":no_os=" + action.noOsSandboxMutation + ":no_render="
						+ action.noRatatuiRender + ":no_model=" + action.noModelCall + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.chat_widget_windows_sandbox.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceRateLimit(plan:TuiSmokeRateLimitPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveAccountRefresh || plan.allowRatatuiRender || plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.chat_widget_rate_limit.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.chat_widget_rate_limit.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeRateLimitActionKind.DurationLabel:
					trace.push("tui.chat_widget_rate_limit.duration=" + "window=" + action.windowMinutes + ":label=" + action.label + ":fallback="
						+ action.fallbackLabel + ":secondary=" + (action.source == "secondary"));
				case TuiSmokeRateLimitActionKind.WarningThreshold:
					trace.push("tui.chat_widget_rate_limit.warning=" + action.source + ":used=" + action.usedPercent + ":threshold="
						+ action.thresholdPercent + ":remaining=" + action.remainingPercent + ":warnings=" + action.warningCount + ":primary="
						+ action.primaryIndexBefore + "->" + action.primaryIndexAfter + ":secondary=" + action.secondaryIndexBefore + "->"
						+ action.secondaryIndexAfter + ":cap=" + action.capReached + ":emitted=" + action.warningEmitted);
				case TuiSmokeRateLimitActionKind.SnapshotPreservation:
					trace.push("tui.chat_widget_rate_limit.snapshot=" + action.source + ":limit=" + action.limitId + ":entries=" + action.entriesBefore
						+ "->" + action.entriesAfter + ":credits=" + action.creditsPreserved + ":individual=" + action.individualLimitPreserved + ":plan="
						+ action.planTypeBefore + "->" + action.planTypeAfter + ":plan_preserved=" + action.planTypePreserved + ":reached="
						+ action.reachedType + ":codex_reached=" + action.codexReachedTypeStored);
				case TuiSmokeRateLimitActionKind.SeparateLimitEntries:
					trace.push("tui.chat_widget_rate_limit.entries=" + action.limitId + ":entries=" + action.entriesBefore + "->" + action.entriesAfter
						+ ":label=" + action.label + ":non_codex=" + action.nonCodexLimit);
				case TuiSmokeRateLimitActionKind.SwitchPrompt:
					trace.push("tui.chat_widget_rate_limit.switch_prompt=" + action.promptStateBefore + "->" + action.promptStateAfter + ":model="
						+ action.model + ":nudge=" + action.nudgeModel + ":used=" + action.usedPercent + ":pending=" + action.promptPending + ":shown="
						+ action.promptShown + ":hidden=" + action.hiddenNotice + ":lower_cost=" + action.lowerCostModel + ":non_codex="
						+ action.nonCodexLimit + ":task=" + action.taskRunning + ":deferred=" + action.deferred + ":once=" + action.shownOnce);
				case TuiSmokeRateLimitActionKind.MemberPrompt:
					trace.push("tui.chat_widget_rate_limit.member_prompt=" + action.reachedType + ":error=" + action.errorKind + ":popup="
						+ action.popupOpened + ":refresh=" + action.rateLimitRefreshRequested + ":stale_remap=" + action.staleCreditsRemapped
						+ ":owner_suppressed=" + action.ownerNudgeSuppressed + ":missing_suppressed=" + action.missingStateSuppressed);
				case TuiSmokeRateLimitActionKind.ErrorKind:
					trace.push("tui.chat_widget_rate_limit.error_kind=" + action.errorKind + ":message=" + action.errorMessage + ":classified="
						+ action.classified + ":cyber=" + action.cyberPolicy);
				case TuiSmokeRateLimitActionKind.Failure:
					trace.push("tui.chat_widget_rate_limit.failure=" + action.failureCode + ":no_account=" + action.noLiveAccountRefresh + ":no_render="
						+ action.noRatatuiRender + ":no_model=" + action.noModelCall + ":unsupported=" + action.unsupportedRejected);
				case _:
					trace.push("tui.chat_widget_rate_limit.unknown");
					return false;
			}
		}
		return true;
	}

	static function traceReplayProtocol(plan:TuiSmokeReplayProtocolPlan, trace:Array<String>):Bool {
		if (plan == null || plan.allowLiveTerminal || plan.allowAppServerMutation || plan.allowRatatuiRender || plan.allowModelCall || !plan.enabled()) {
			trace.push("tui.chat_widget_replay_protocol.rejected=live_or_missing");
			return false;
		}
		trace.push("tui.chat_widget_replay_protocol.plan=headless");
		for (action in plan.actions) {
			switch action.kind {
				case TuiSmokeReplayProtocolActionKind.ReplayTurn:
					trace.push("tui.chat_widget_replay_protocol.replay_turn=" + action.replayKind + ":status=" + action.turnStatus + ":turn="
						+ action.turnId + ":items=" + action.itemCount + ":task_started=" + action.taskStarted + ":completion="
						+ action.completionSynthesized + ":task_complete=" + action.taskCompleted + ":interrupted=" + action.interrupted + ":failed="
						+ action.failed + ":last_error_cleared=" + action.lastNonRetryErrorCleared + ":from_replay=" + action.fromReplay);
				case TuiSmokeReplayProtocolActionKind.ReplayItem:
					trace.push("tui.chat_widget_replay_protocol.replay_item=" + action.itemType + ":kind=" + action.replayKind + ":turn=" + action.turnId
						+ ":from_replay=" + action.fromReplay + ":user=" + action.userCommitted + ":history=" + action.composerHistorySeeded + ":agent="
						+ action.agentCommitted + ":plan=" + action.planCompleted + ":reasoning=" + action.reasoningDeltaCount + ":raw="
						+ action.rawReasoningShown + ":final=" + action.reasoningFinalized + ":cmd=" + action.commandStarted + "/" + action.commandCompleted
						+ ":file=" + action.fileChangeIgnored + "/" + action.fileChangeCompleted + ":mcp=" + action.mcpStarted + "/" + action.mcpCompleted
						+ ":web=" + action.webSearchCompleted + ":image=" + action.imageViewOpened + "/" + action.imageGenerationCompleted + ":review="
						+ action.reviewEntered + "/" + action.reviewExited + ":context=" + action.contextCompacted + ":collab=" + action.collabToolRouted
						+ ":subagent=" + action.subAgentActivityRouted + ":redraw=" + action.requestRedraw);
				case TuiSmokeReplayProtocolActionKind.ServerNotification:
					trace.push("tui.chat_widget_replay_protocol.notification=" + action.notificationType + ":kind=" + action.replayKind + ":from_replay="
						+ action.fromReplay + ":resume_initial=" + action.resumeInitialReplay + ":snapshot=" + action.threadSnapshotReplay + ":misrouted="
						+ action.misroutedRejected + ":last_turn=" + action.lastTurnIdSet + ":task_started=" + action.taskStarted + ":retry_header="
						+ action.retryHeaderRestored + ":live_suppressed=" + action.liveEffectsSuppressed);
				case TuiSmokeReplayProtocolActionKind.TurnCompleted:
					trace.push("tui.chat_widget_replay_protocol.turn_completed=" + action.turnStatus + ":kind=" + action.replayKind + ":turn="
						+ action.turnId + ":dedupe_clear=" + action.lastRenderedUserCleared + ":task_complete=" + action.taskCompleted + ":interrupted="
						+ action.interrupted + ":budget=" + action.budgetLimited + ":failed=" + action.failed + ":finalized=" + action.finalizedTurn
						+ ":last_error_set=" + action.lastNonRetryErrorSet + ":last_error_cleared=" + action.lastNonRetryErrorCleared + ":duration="
						+ action.durationMs);
				case TuiSmokeReplayProtocolActionKind.ErrorNotification:
					trace.push("tui.chat_widget_replay_protocol.error=" + action.errorMessage + ":retryable=" + action.retryable + ":from_replay="
						+ action.fromReplay + ":stream=" + action.streamErrorShown + ":non_retry=" + action.nonRetryHandled + ":last_error_set="
						+ action.lastNonRetryErrorSet + ":retry_header=" + action.retryHeaderRestored);
				case TuiSmokeReplayProtocolActionKind.Failure:
					trace.push("tui.chat_widget_replay_protocol.failure=" + action.failureCode + ":no_live=" + action.noLiveTerminal + ":no_app_server="
						+ action.noAppServerMutation + ":no_render=" + action.noRatatuiRender + ":no_model=" + action.noModelCall + ":unsupported="
						+ action.unsupportedRejected);
				case _:
					trace.push("tui.chat_widget_replay_protocol.unknown");
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
					trace.push("tui.chat_widget_active_stream.agent_delta=" + "text=" + action.text + ":stream=" + action.streamControllerPresent
						+ ":width=" + action.streamWidth + ":queued=" + action.streamQueueText() + ":pushed=" + action.pushed + ":commit_animation="
						+ action.startedCommitAnimation + ":catch_up=" + action.ranCatchUpTick + ":redraw=" + action.requestRedraw + ":model="
						+ !action.noModelCall);
				case TuiSmokeChatWidgetActiveStreamActionKind.PlanDelta:
					trace.push("tui.chat_widget_active_stream.plan_delta=" + "text=" + action.text + ":plan_stream=" + action.planStreamControllerPresent
						+ ":width=" + action.planStreamWidth + ":buffer=" + action.planBufferLength + ":queued=" + action.streamQueueText() + ":pushed="
						+ action.pushed + ":commit_animation=" + action.startedCommitAnimation + ":catch_up=" + action.ranCatchUpTick + ":redraw="
						+ action.requestRedraw + ":model=" + !action.noModelCall);
				case TuiSmokeChatWidgetActiveStreamActionKind.CommitTick:
					trace.push("tui.chat_widget_active_stream.commit_tick=" + "queued=" + action.streamQueueText() + ":cells=" + action.committedCells
						+ ":status_hidden=" + action.statusHidden + ":active_tail=" + action.activeTailPresent + ":revision=" + action.revisionText());
				case TuiSmokeChatWidgetActiveStreamActionKind.Resize:
					trace.push("tui.chat_widget_active_stream.resize=" + action.previousWidth + "->" + action.width + ":stream_reserved="
						+ action.streamReservedCols + ":stream_width=" + action.streamWidth + ":plan_reserved=" + action.planReservedCols + ":plan_width="
						+ action.planStreamWidth + ":tail_synced=" + action.activeTailPresent + ":redraw=" + action.requestRedraw);
				case TuiSmokeChatWidgetActiveStreamActionKind.ActiveTail:
					trace.push("tui.chat_widget_active_stream.active_tail=" + "present=" + action.activeTailPresent + ":cell=" + action.activeCellPresent
						+ ":hook=" + action.activeHookPresent + ":revision=" + action.revisionAfter + ":continuation=" + action.liveTailPresent
						+ ":animation=" + action.animationTick + ":lines=" + action.transcriptLineCount + ":hyperlinks=" + action.hyperlinkLineCount);
				case TuiSmokeChatWidgetActiveStreamActionKind.FlushAnswer:
					trace.push("tui.chat_widget_active_stream.flush_answer=" + "live_tail=" + action.liveTailPresent + ":tail_cleared="
						+ action.activeTailCleared + ":reflow=" + action.scrollbackReflow + ":history=" + action.historyInserted + ":deferred="
						+ action.deferredHistoryCell + ":consolidate=" + action.sourceConsolidated);
				case TuiSmokeChatWidgetActiveStreamActionKind.PlanComplete:
					trace.push("tui.chat_widget_active_stream.plan_complete=" + "live_tail=" + action.liveTailPresent + ":buffer=" + action.planBufferLength
						+ ":tail_cleared=" + action.activeTailCleared + ":history=" + action.historyInserted + ":stream_history="
						+ action.deferredHistoryCell + ":consolidate=" + action.sourceConsolidated + ":restore_pending=" + action.statusRestorePending
						+ ":restored=" + action.statusRestored);
				case TuiSmokeChatWidgetActiveStreamActionKind.RenderMode:
					trace.push("tui.chat_widget_active_stream.render_mode=" + action.renderMode + ":stream=" + action.streamControllerPresent
						+ ":plan_stream=" + action.planStreamControllerPresent);
				case TuiSmokeChatWidgetActiveStreamActionKind.Failure:
					trace.push("tui.chat_widget_active_stream.failure=" + action.failureCode + ":unsupported=" + action.unsupportedRejected);
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
					trace.push("tui.chat_widget_composer_render.composition=" + "area=" + action.areaText() + ":reserve=" + action.rightReserve + ":active="
						+ action.activeCellPresent + ":hook=" + action.activeHookPresent + ":hook_render=" + action.activeHookShouldRender + ":bottom_inset="
						+ action.bottomPaneInsetTop + ":terminal=" + !action.noLiveTerminal + ":ratatui=" + !action.noRatatuiRender);
				case TuiSmokeChatWidgetComposerRenderActionKind.BottomPaneDelegate:
					trace.push("tui.chat_widget_composer_render.bottom_pane=" + "reserve=" + action.rightReserve + ":desired="
						+ action.bottomPaneDesiredHeight + ":cursor=" + action.cursorVisible + ":style=" + action.cursorStyle + ":task=" + action.taskRunning
						+ ":input=" + action.inputEnabled);
				case TuiSmokeChatWidgetComposerRenderActionKind.TranscriptArea:
					trace.push("tui.chat_widget_composer_render.transcript=" + (action.activeHookShouldRender ? "hook" : "active") + ":width="
						+ action.transcriptAreaWidth + ":height=" + action.transcriptAreaHeight + ":desired=" + action.activeCellDesiredHeight
						+ ":hook_desired=" + action.activeHookDesiredHeight + ":scroll=" + action.transcriptScrollOffset);
				case TuiSmokeChatWidgetComposerRenderActionKind.Cursor:
					trace.push("tui.chat_widget_composer_render.cursor=" + action.cursorText() + ":style=" + action.cursorStyle + ":reserve="
						+ action.rightReserve + ":visible=" + action.cursorVisible);
				case TuiSmokeChatWidgetComposerRenderActionKind.InputResult:
					trace.push("tui.chat_widget_composer_render.input=" + action.inputResult + ":text=" + action.text + ":action=" + action.queuedAction
						+ ":session=" + action.sessionConfigured + ":plan=" + action.planStreaming + ":shell_only=" + action.onlyUserShellCommandsRunning
						+ ":pending=" + action.userTurnPending + ":submit_now=" + action.shouldSubmitNow + ":queue=" + action.queueTransitionText()
						+ ":status=" + action.statusWorking + ":reasoning_cleared=" + action.reasoningCleared + ":live_dispatch=" + !action.noLiveDispatch);
				case TuiSmokeChatWidgetComposerRenderActionKind.QueuePreview:
					trace.push("tui.chat_widget_composer_render.queue_preview=" + "queued=" + action.queuedAfter + ":pending_steers=" + action.pendingSteers
						+ ":rejected=" + action.rejectedSteers + ":updated=" + action.previewUpdated + ":autosend=" + !action.autosendSuppressed
						+ ":followup=" + action.followupSubmitted + ":modal=" + action.hadModalOrPopup + "->" + action.modalCleared);
				case TuiSmokeChatWidgetComposerRenderActionKind.InputQueueState:
					trace.push("tui.chat_widget_composer_render.input_queue=" + "queued=" + action.queuedAfter + ":queued_history="
						+ action.queuedHistoryRecords + ":pending=" + action.pendingSteers + ":pending_history=" + action.pendingSteerHistoryRecords
						+ ":compare_keys=" + action.pendingSteerCompareKeys + ":rejected=" + action.rejectedSteers + ":rejected_history="
						+ action.rejectedHistoryRecords + ":followups=" + action.queuedFollowUps + ":fallback=" + action.missingHistoryFallback + ":texts="
						+ action.previewQueuedText + "|" + action.previewPendingText + "|" + action.previewRejectedText);
				case TuiSmokeChatWidgetComposerRenderActionKind.InputQueueClear:
					trace.push("tui.chat_widget_composer_render.input_queue_clear=" + "queued=" + action.queueTransitionText() + ":pending="
						+ action.pendingSteers + "->0" + ":rejected=" + action.rejectedSteers + "->0" + ":user_turn=" + action.userTurnPendingBefore + "->"
						+ action.userTurnPendingAfter + ":submit_after_interrupt=" + action.submitPendingSteersAfterInterruptBefore + "->"
						+ action.submitPendingSteersAfterInterruptAfter + ":autosend=" + action.suppressAutosendBefore + "->" + action.suppressAutosendAfter);
				case TuiSmokeChatWidgetComposerRenderActionKind.QueueDrainGate:
					trace.push("tui.chat_widget_composer_render.queue_drain_gate=" + "autosend=" + !action.autosendSuppressed + ":pending="
						+ action.userTurnPending + ":task=" + action.taskRunning + ":queued=" + action.queueTransitionText() + ":action="
						+ action.queuedAction + ":followup=" + action.followupSubmitted + ":modal=" + action.hadModalOrPopup + "->" + action.modalCleared
						+ ":preview=" + action.previewUpdated + ":live_dispatch=" + !action.noLiveDispatch);
				case TuiSmokeChatWidgetComposerRenderActionKind.Frame:
					trace.push("tui.chat_widget_composer_render.frame=" + "redraw:scheduled=" + action.frameScheduled + ":pre_draw=" + action.preDrawTick
						+ ":bottom_tick=" + action.bottomPaneTick + ":ambient_reserve=" + action.rightReserve);
				case TuiSmokeChatWidgetComposerRenderActionKind.Failure:
					trace.push("tui.chat_widget_composer_render.failure=" + action.failureCode + ":unsupported=" + action.unsupportedRejected);
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
					trace.push("tui.composer_textarea_render.layout=" + "area=" + action.width + "x" + action.height + ":reserve="
						+ action.textareaRightReserve + ":textarea=" + action.textareaSizeText() + ":remote_height=" + action.remoteImageHeight
						+ ":remote_separator=" + action.remoteImageSeparator + ":popup=" + action.popupHeight + ":footer=" + action.footerTotalHeight);
				case TuiSmokeComposerTextareaRenderActionKind.DesiredHeight:
					trace.push("tui.composer_textarea_render.desired=" + "width=" + action.width + ":inner=" + action.innerWidth + ":wrapped="
						+ action.wrappedLineCount + ":remote=" + action.remoteImageHeight + ":separator=" + action.remoteImageSeparator + ":footer="
						+ action.footerTotalHeight + ":total=" + action.desiredHeight);
				case TuiSmokeComposerTextareaRenderActionKind.RemoteImages:
					trace.push("tui.composer_textarea_render.remote_images=" + "count=" + action.remoteImageCount + ":height=" + action.remoteImageHeight
						+ ":selected=" + action.selectedRemoteIndex + ":textarea_mutated=" + !action.remoteImagesDoNotMutateTextarea + ":terminal="
						+ !action.noLiveTerminal + ":ratatui=" + !action.noRatatuiRender);
				case TuiSmokeComposerTextareaRenderActionKind.Prompt:
					trace.push("tui.composer_textarea_render.prompt=" + action.promptKind + ":text=" + action.promptText + ":input=" + action.inputEnabled
						+ ":bash=" + action.bashMode);
				case TuiSmokeComposerTextareaRenderActionKind.Plain:
					trace.push("tui.composer_textarea_render.plain=" + "lines=" + action.wrappedLineCount + ":scroll=" + action.scrollBefore + "->"
						+ action.scrollAfter + ":window=" + action.lineWindowText() + ":elements=" + action.elementCount + ":highlights="
						+ action.highlightCount);
				case TuiSmokeComposerTextareaRenderActionKind.Masked:
					trace.push("tui.composer_textarea_render.masked=" + "char=" + action.maskChar + ":text_len=" + action.textLength + ":lines="
						+ action.wrappedLineCount + ":scroll=" + action.scrollBefore + "->" + action.scrollAfter + ":window=" + action.lineWindowText());
				case TuiSmokeComposerTextareaRenderActionKind.Highlighted:
					trace.push("tui.composer_textarea_render.highlighted=" + "lines=" + action.wrappedLineCount + ":scroll=" + action.scrollBefore + "->"
						+ action.scrollAfter + ":window=" + action.lineWindowText() + ":elements=" + action.elementCount + ":plugin="
						+ action.pluginHighlightCount + ":history=" + action.historyHighlightCount + ":render_only=" + action.renderOnlyHighlights);
				case TuiSmokeComposerTextareaRenderActionKind.Placeholder:
					trace.push("tui.composer_textarea_render.placeholder=" + action.mode + ":text=" + action.placeholderText + ":visible="
						+ action.placeholderVisible + ":input=" + action.inputEnabled + ":empty=" + action.textareaEmpty);
				case TuiSmokeComposerTextareaRenderActionKind.Cursor:
					trace.push("tui.composer_textarea_render.cursor=" + action.mode + ":visible=" + action.cursorVisible + ":x=" + action.cursorX + ":y="
						+ action.cursorY + ":reserve=" + action.textareaRightReserve + ":input=" + action.inputEnabled + ":selected_remote="
						+ action.selectedRemoteIndex);
				case TuiSmokeComposerTextareaRenderActionKind.Failure:
					trace.push("tui.composer_textarea_render.failure=" + action.failureCode + ":unsupported=" + action.unsupportedRejected);
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
					trace.push("tui.composer_footer_render.props=" + action.modeAfter + ":base=" + action.baseMode + ":focus=" + action.hasInputFocus
						+ ":task=" + action.taskRunning + ":empty=" + action.inputEmpty + ":history=" + action.historySearchActive + ":quit_visible="
						+ action.quitHintVisible + ":status_enabled=" + action.statusLineEnabled + ":collab=" + action.collaborationModesEnabled
						+ ":indicator=" + action.collaborationIndicatorVisible);
				case TuiSmokeComposerFooterRenderActionKind.Height:
					trace.push("tui.composer_footer_render.height=" + action.modeAfter + ":" + action.heightText() + ":passive_status="
						+ action.passiveStatusActive + ":queue=" + action.showQueueHint);
				case TuiSmokeComposerFooterRenderActionKind.PassiveStatus, TuiSmokeComposerFooterRenderActionKind.StatusLine:
					trace.push("tui.composer_footer_render.status=" + action.statusText + ":enabled=" + action.statusLineEnabled + ":passive="
						+ action.passiveStatusActive + ":hyperlink=" + action.statusHyperlinkActive + ":mode=" + action.modeAfter);
				case TuiSmokeComposerFooterRenderActionKind.ShortcutOverlay:
					trace.push("tui.composer_footer_render.shortcut_overlay=" + action.modeTransitionText() + ":key=" + action.keyName + ":active="
						+ action.shortcutOverlayActive + ":paste_burst=" + action.pasteBurstActive + ":shortcuts=" + action.showShortcutsHint + ":cycle="
						+ action.showCycleHint);
				case TuiSmokeComposerFooterRenderActionKind.QuitShortcut:
					trace.push("tui.composer_footer_render.quit=" + action.modeTransitionText() + ":key=" + action.keyName + ":visible="
						+ action.quitHintVisible + ":expired=" + action.quitHintExpired + ":ctrl_c=" + action.ctrlCQuitHint);
				case TuiSmokeComposerFooterRenderActionKind.EscHint:
					trace.push("tui.composer_footer_render.esc=" + action.modeTransitionText() + ":key=" + action.keyName + ":backtrack="
						+ action.escBacktrackHint);
				case TuiSmokeComposerFooterRenderActionKind.FooterFallback:
					trace.push("tui.composer_footer_render.fallback=" + action.modeAfter + ":lines=" + action.lineCount + ":hints=" + action.hintCount
						+ ":shortcuts=" + action.showShortcutsHint + ":queue=" + action.showQueueHint + ":cycle=" + action.showCycleHint + ":terminal="
						+ !action.noLiveTerminal + ":ratatui=" + !action.noRatatuiRender);
				case TuiSmokeComposerFooterRenderActionKind.Failure:
					trace.push("tui.composer_footer_render.failure=" + action.failureCode + ":unsupported=" + action.unsupportedRejected);
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
					trace.push("tui.composer_popup_key.dispatch=" + action.popupBefore + ":key=" + action.keyName + ":popup=" + action.popupTransitionText()
						+ ":consumed=" + action.keyConsumed + ":sync=" + action.syncAfterKey);
				case TuiSmokeComposerPopupKeyActionKind.ShortcutOverlay:
					trace.push("tui.composer_popup_key.shortcut_overlay=" + action.popupBefore + ":key=" + action.keyName + ":handled="
						+ action.shortcutOverlayHandled + ":redraw=" + action.redrawRequested);
				case TuiSmokeComposerPopupKeyActionKind.FooterEscHint:
					trace.push("tui.composer_popup_key.footer_esc=" + action.popupBefore + ":key=" + action.keyName + ":mode_changed="
						+ action.footerModeChanged + ":popup=" + action.popupTransitionText());
				case TuiSmokeComposerPopupKeyActionKind.MoveSelection:
					trace.push("tui.composer_popup_key.selection=" + action.popupBefore + ":key=" + action.keyName + ":selected="
						+ action.selectionTransitionText() + ":scroll=" + action.scrollTransitionText() + ":matches=" + action.matchCount);
				case TuiSmokeComposerPopupKeyActionKind.Dismiss:
					trace.push("tui.composer_popup_key.dismiss=" + action.popupBefore + ":key=" + action.keyName + ":token=" + action.token + ":stored="
						+ action.dismissedTokenStored + ":popup=" + action.popupTransitionText() + ":sync=" + action.syncAfterKey);
				case TuiSmokeComposerPopupKeyActionKind.CompleteCommand:
					trace.push("tui.composer_popup_key.command.complete=" + action.commandName + ":key=" + action.keyName + ":completed="
						+ action.commandCompleted + ":inline_args=" + action.inlineArgsPreserved + ":popup=" + action.popupTransitionText());
				case TuiSmokeComposerPopupKeyActionKind.DispatchCommand:
					trace.push("tui.composer_popup_key.command.dispatch=" + action.commandName + ":key=" + action.keyName + ":command="
						+ action.commandDispatched + ":service_tier=" + action.serviceTierDispatched + ":history=" + action.historyStaged + ":text_cleared="
						+ action.textCleared);
				case TuiSmokeComposerPopupKeyActionKind.AcceptFile:
					trace.push("tui.composer_popup_key.file.accept=" + action.selectedPath + ":key=" + action.keyName + ":selected="
						+ action.selectedAvailable + ":draft=" + action.draftUpdated + ":path_inserted=" + action.pathInserted + ":popup="
						+ action.popupTransitionText());
				case TuiSmokeComposerPopupKeyActionKind.AcceptImage:
					trace.push("tui.composer_popup_key.image.accept=" + action.selectedPath + ":key=" + action.keyName + ":dimensions="
						+ action.imageDimensionsAvailable + ":attached=" + action.imageAttached + ":path_fallback=" + action.pathInserted + ":live_probe="
						+ !action.liveProbeRejected);
				case TuiSmokeComposerPopupKeyActionKind.AcceptMention:
					trace.push("tui.composer_popup_key.mention.accept=" + action.insertText + ":key=" + action.keyName + ":path=" + action.selectedPath
						+ ":binding=" + action.mentionBindingStored + ":popup=" + action.popupTransitionText());
				case TuiSmokeComposerPopupKeyActionKind.SwitchMentionMode:
					trace.push("tui.composer_popup_key.mentions_v2.mode=" + action.searchModeTransitionText() + ":key=" + action.keyName + ":allowed="
						+ action.modeSwitchAllowed + ":selected=" + action.selectionTransitionText());
				case TuiSmokeComposerPopupKeyActionKind.AcceptMentionsV2File:
					trace.push("tui.composer_popup_key.mentions_v2.file=" + action.selectedPath + ":key=" + action.keyName + ":draft=" + action.draftUpdated
						+ ":popup=" + action.popupTransitionText());
				case TuiSmokeComposerPopupKeyActionKind.AcceptMentionsV2Tool:
					trace.push("tui.composer_popup_key.mentions_v2.tool=" + action.insertText + ":key=" + action.keyName + ":path=" + action.selectedPath
						+ ":binding=" + action.mentionBindingStored + ":popup=" + action.popupTransitionText());
				case TuiSmokeComposerPopupKeyActionKind.FallbackEnter:
					trace.push("tui.composer_popup_key.fallback_enter=" + action.popupBefore + ":selected=" + action.selectedAvailable
						+ ":submit_without_popup=" + action.submitWithoutPopup + ":without_popup=" + action.fallbackWithoutPopup + ":popup="
						+ action.popupTransitionText());
				case TuiSmokeComposerPopupKeyActionKind.BasicInput:
					trace.push("tui.composer_popup_key.basic_input=" + action.popupBefore + ":key=" + action.keyName + ":forwarded=" + action.inputForwarded
						+ ":sync=" + action.syncAfterKey);
				case TuiSmokeComposerPopupKeyActionKind.Failure:
					trace.push("tui.composer_popup_key.failure=" + action.failureCode + ":unsupported=" + action.unsupportedRejected + ":live_probe="
						+ action.liveProbeRejected);
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
					trace.push("tui.composer_editing.route=" + action.keyName + ":result=" + action.result + ":mode=" + action.modeBefore + "->"
						+ action.modeAfter + ":consumed=" + action.keyConsumed + ":redraw=" + action.needsRedraw);
				case TuiSmokeComposerEditingActionKind.RemoteSelection:
					trace.push("tui.composer_editing.remote_selection=" + action.keyName + ":remote=" + action.remoteImageAfter + ":selected="
						+ action.selectedRemoteTransitionText() + ":handled=" + action.remoteSelectionHandled + ":redraw=" + action.needsRedraw);
				case TuiSmokeComposerEditingActionKind.ClearRemoteSelection:
					trace.push("tui.composer_editing.remote_clear=" + action.keyName + ":selected=" + action.selectedRemoteTransitionText() + ":cleared="
						+ action.remoteSelectionCleared);
				case TuiSmokeComposerEditingActionKind.BashEscape:
					trace.push("tui.composer_editing.bash_escape=" + action.keyName + ":mode=" + action.modeBefore + "->" + action.modeAfter + ":disabled="
						+ action.bashModeDisabled + ":burst_flushed=" + action.pasteBurstFlushed + ":redraw=" + action.needsRedraw);
				case TuiSmokeComposerEditingActionKind.VimTransition:
					trace.push("tui.composer_editing.vim=" + action.keyName + ":mode=" + action.modeBefore + "->" + action.modeAfter + ":insert_escape="
						+ action.vimInsertEscapeHandled + ":redraw=" + action.needsRedraw);
				case TuiSmokeComposerEditingActionKind.VimNormalShortcut:
					trace.push("tui.composer_editing.vim_shortcut=" + action.keyName + ":text=" + action.outputText + ":mode=" + action.modeBefore + "->"
						+ action.modeAfter + ":bash=" + action.bashModeEnabled);
				case TuiSmokeComposerEditingActionKind.QueueKey:
					trace.push("tui.composer_editing.queue_key=" + action.keyName + ":task=" + action.taskRunning + ":queue_submissions="
						+ action.queueSubmissions + ":shell=" + action.shellCommand + ":queued=" + action.submissionQueued);
				case TuiSmokeComposerEditingActionKind.SubmitKey:
					trace.push("tui.composer_editing.submit_key=" + action.keyName + ":queue_submissions=" + action.queueSubmissions + ":submitted="
						+ action.submissionSubmitted + ":queued=" + action.submissionQueued);
				case TuiSmokeComposerEditingActionKind.HistoryNavigate:
					trace.push("tui.composer_editing.history=" + action.keyName + ":handled=" + action.historyHandled + ":applied=" + action.historyApplied
						+ ":cursor=" + action.cursorTransitionText());
				case TuiSmokeComposerEditingActionKind.BasicInput:
					trace.push("tui.composer_editing.basic_input=" + action.keyName + ":text=" + action.inputText + "->" + action.outputText + ":cursor="
						+ action.cursorTransitionText() + ":pending=" + action.pendingPasteTransitionText() + ":redraw=" + action.needsRedraw);
				case TuiSmokeComposerEditingActionKind.PasteBurstFlush:
					trace.push("tui.composer_editing.burst_flush=" + action.keyName + ":active=" + action.pasteBurstActiveBefore + "->"
						+ action.pasteBurstActiveAfter + ":flushed=" + action.pasteBurstFlushed + ":newline=" + action.newlineCaptured + ":window_cleared="
						+ action.burstWindowCleared);
				case TuiSmokeComposerEditingActionKind.ReconcileElements:
					trace.push("tui.composer_editing.reconcile=" + action.keyName + ":elements=" + action.elementTransitionText() + ":pending="
						+ action.pendingPasteTransitionText() + ":local=" + action.localImageTransitionText() + ":pending_pruned="
						+ action.pendingPastePruned + ":locals_pruned=" + action.localImagesPruned);
				case TuiSmokeComposerEditingActionKind.ShortcutOverlay:
					trace.push("tui.composer_editing.shortcut_overlay=" + action.keyName + ":handled=" + action.shortcutOverlayHandled + ":redraw="
						+ action.needsRedraw);
				case TuiSmokeComposerEditingActionKind.CtrlD:
					trace.push("tui.composer_editing.ctrl_d="
						+ "empty="
						+ action.inputText
						+ ":result="
						+ action.result
						+ ":redraw="
						+ action.needsRedraw);
				case TuiSmokeComposerEditingActionKind.Failure:
					trace.push("tui.composer_editing.failure=" + action.failureCode + ":unsupported=" + action.unsupportedRejected);
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
					trace.push("tui.composer_submission.prepare=" + action.result + ":text=" + action.preparedText + ":chars=" + action.charCount + "/"
						+ action.maxChars + ":pending=" + action.pendingTransitionText() + ":elements=" + action.elementTransitionText() + ":trimmed="
						+ action.textTrimmed + ":expanded=" + action.pendingExpanded + ":cleared=" + action.pendingCleared);
				case TuiSmokeComposerSubmissionActionKind.HandleSubmission:
					trace.push("tui.composer_submission.handle=" + action.result + ":queue=" + action.shouldQueue + ":validation=" + action.slashValidation
						+ ":burst_flushed=" + action.pasteBurstFlushed + ":vim_normal=" + action.vimNormalEntered);
				case TuiSmokeComposerSubmissionActionKind.QueueSubmission:
					trace.push("tui.composer_submission.queue=" + action.queuedAction + ":text=" + action.preparedText + ":messages="
						+ action.queueTransitionText() + ":defer_slash=" + action.slashValidationDeferred + ":queued=" + action.queued);
				case TuiSmokeComposerSubmissionActionKind.DispatchBareSlash:
					trace.push("tui.composer_submission.dispatch_bare=" + action.commandName + ":result=" + action.result + ":history_staged="
						+ action.historyStaged + ":history_recorded=" + action.historyRecorded + ":event=" + action.appEventSent);
				case TuiSmokeComposerSubmissionActionKind.DispatchSlashArgs:
					trace.push("tui.composer_submission.dispatch_args=" + action.commandName + ":args=" + action.argsText + ":result=" + action.result
						+ ":elements=" + action.textElementAfter + ":history_staged=" + action.historyStaged + ":live=" + !action.noLiveDispatch);
				case TuiSmokeComposerSubmissionActionKind.PrepareInlineArgs:
					trace.push("tui.composer_submission.inline_args=" + action.commandName + ":args=" + action.argsText + ":pending="
						+ action.pendingTransitionText() + ":elements=" + action.elementTransitionText() + ":trimmed=" + action.textTrimmed);
				case TuiSmokeComposerSubmissionActionKind.BuildUserMessage:
					trace.push("tui.composer_submission.user_message=" + action.result + ":text=" + action.preparedText + ":local="
						+ action.localImageTransitionText() + ":remote=" + action.remoteImageTransitionText() + ":local_drained=" + action.localImagesDrained
						+ ":remote_drained=" + action.remoteImagesDrained);
				case TuiSmokeComposerSubmissionActionKind.AssembleUserInput:
					trace.push("tui.composer_submission.items=" + "order=" + action.itemOrder + ":count=" + action.itemCount + ":remote="
						+ action.remoteImageItemCount + ":local=" + action.localImageItemCount + ":text=" + action.textItemCount + ":skills="
						+ action.skillItemCount + ":mentions=" + action.mentionItemCount + ":bindings=" + action.mentionBindingCount);
				case TuiSmokeComposerSubmissionActionKind.SubmitUserTurn:
					trace.push("tui.composer_submission.user_turn=" + "submitted=" + action.userTurnSubmitted + ":model=" + action.modelName + ":session="
						+ action.sessionConfigured + ":history=" + action.renderInHistory + ":pending_steer=" + action.pendingSteerQueued + ":display="
						+ action.displayRecorded + ":cancel_edit=" + action.cancelEditRecorded + ":ide=" + action.ideContextApplied + ":collab="
						+ action.collaborationModeAttached + ":live=" + !action.noLiveDispatch);
				case TuiSmokeComposerSubmissionActionKind.QueueDrain:
					trace.push("tui.composer_submission.queue_drain=" + action.queuedAction + ":messages=" + action.queueTransitionText() + ":submitted="
						+ action.submittedNow + ":status_working=" + action.statusWorking);
				case TuiSmokeComposerSubmissionActionKind.RestoreBlockedImages:
					trace.push("tui.composer_submission.restore_blocked_images=" + "model_supports_images=" + action.modelSupportsImages + ":local="
						+ action.localImageAfter + ":remote=" + action.remoteImageAfter + ":restored=" + action.blockedRestored);
				case TuiSmokeComposerSubmissionActionKind.RestoreUnavailableModel:
					trace.push("tui.composer_submission.restore_unavailable_model=" + "model_available=" + action.modelAvailable + ":text="
						+ action.preparedText + ":local=" + action.localImageAfter + ":remote=" + action.remoteImageAfter + ":bindings="
						+ action.mentionBindingCount + ":restored=" + action.blockedRestored);
				case TuiSmokeComposerSubmissionActionKind.HistoryRecord:
					trace.push("tui.composer_submission.history=" + action.preparedText + ":record=" + action.recordHistory + ":staged="
						+ action.historyStaged + ":recorded=" + action.historyRecorded);
				case TuiSmokeComposerSubmissionActionKind.Failure:
					trace.push("tui.composer_submission.failure="
						+ action.failureCode
						+ ":slash_failed="
						+ action.slashValidationFailed
						+ ":too_large="
						+ action.tooLargeRejected
						+ ":empty="
						+ action.emptySuppressed
						+ ":pending_restored="
						+ action.pendingRestored
						+ (action.emptySuppressedBeforeDispatch ? ":pre_dispatch_empty=true" : "")
						+ (action.shellCommandSubmitted ? ":shell=true" : "")
						+ (action.noLiveDispatch ? ":no_live=true" : "")
						+ ":unsupported="
						+ action.unsupportedRejected);
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
					trace.push("tui.composer_attachment.paste="
						+ action.pasteKind
						+ ":chars="
						+ action.charCount
						+ ":threshold="
						+ action.threshold
						+ ":normalized="
						+ action.normalizedText
						+ ":text_inserted="
						+ action.textInserted
						+ ":placeholder="
						+ action.placeholderInserted
						+ ":pending="
						+ action.pendingTransitionText()
						+ ":redraw="
						+ action.needsRedraw
						+ (action.explicitPasteClearsBurst ? ":clears_burst=true" : ""));
				case TuiSmokeComposerAttachmentActionKind.PasteBurstChar:
					trace.push("tui.composer_attachment.burst_char="
						+ action.inputText
						+ ":state="
						+ action.burstBefore
						+ "->"
						+ action.burstAfter
						+ ":buffered="
						+ action.buffered
						+ ":newline="
						+ action.newlineCaptured
						+ ":pending="
						+ action.pendingTransitionText()
						+ (action.charIntervalMs > 0 ? ":interval_ms=" + action.charIntervalMs : "")
						+ (action.shortcutOverlaySuppressed ? ":shortcut_suppressed=true" : ""));
				case TuiSmokeComposerAttachmentActionKind.PasteBurstFlush:
					trace.push("tui.composer_attachment.burst_flush="
						+ action.pasteKind
						+ ":state="
						+ action.burstBefore
						+ "->"
						+ action.burstAfter
						+ ":flushed="
						+ action.flushed
						+ ":chars="
						+ action.charCount
						+ ":pending="
						+ action.pendingTransitionText()
						+ ":redraw="
						+ action.needsRedraw
						+ (action.activeIdleTimeoutMs > 0 ? ":idle_ms=" + action.activeIdleTimeoutMs : ""));
				case TuiSmokeComposerAttachmentActionKind.LargePastePlaceholder:
					trace.push("tui.composer_attachment.large_paste=" + action.placeholder + ":chars=" + action.charCount + ":pending="
						+ action.pendingTransitionText() + ":elements=" + action.elementTransitionText());
				case TuiSmokeComposerAttachmentActionKind.ExpandPendingPastes:
					trace.push("tui.composer_attachment.expand_pending=" + "pending=" + action.pendingTransitionText() + ":elements="
						+ action.elementTransitionText() + ":expanded=" + action.pendingExpanded + ":cleared=" + action.pendingCleared);
				case TuiSmokeComposerAttachmentActionKind.AttachLocalImage:
					trace.push("tui.composer_attachment.local_image=" + action.placeholder + ":path=" + action.path + ":local="
						+ action.localImageTransitionText() + ":remote=" + action.remoteImageAfter + ":attached=" + action.imageAttached);
				case TuiSmokeComposerAttachmentActionKind.SetRemoteImages:
					trace.push("tui.composer_attachment.remote_images=" + action.remoteImageTransitionText() + ":selected="
						+ action.selectedRemoteTransitionText() + ":relabel_locals=" + action.remoteRelabeledLocals);
				case TuiSmokeComposerAttachmentActionKind.SelectRemoteImage:
					trace.push("tui.composer_attachment.remote_select=" + action.keyName + ":selected=" + action.selectedRemoteTransitionText() + ":redraw="
						+ action.needsRedraw);
				case TuiSmokeComposerAttachmentActionKind.DeleteRemoteImage:
					trace.push("tui.composer_attachment.remote_delete=" + action.keyName + ":remote=" + action.remoteImageTransitionText() + ":selected="
						+ action.selectedRemoteTransitionText() + ":relabel_locals=" + action.remoteRelabeledLocals);
				case TuiSmokeComposerAttachmentActionKind.SnapshotDraft:
					trace.push("tui.composer_attachment.snapshot=" + action.attachmentKind + ":text_elements=" + action.textElementAfter + ":local="
						+ action.localImageAfter + ":remote=" + action.remoteImageAfter + ":pending=" + action.pendingAfter + ":stored="
						+ action.draftSnapshotStored);
				case TuiSmokeComposerAttachmentActionKind.RestoreDraft:
					trace.push("tui.composer_attachment.restore=" + action.attachmentKind + ":cursor=" + action.cursorTransitionText() + ":local="
						+ action.localImageTransitionText() + ":remote=" + action.remoteImageTransitionText() + ":pending=" + action.pendingTransitionText()
						+ ":restored=" + action.draftRestored);
				case TuiSmokeComposerAttachmentActionKind.ApplyHistoryEntry:
					trace.push("tui.composer_attachment.history_entry=" + action.attachmentKind + ":local=" + action.localImageAfter + ":remote="
						+ action.remoteImageAfter + ":pending=" + action.pendingAfter + ":applied=" + action.historyEntryApplied);
				case TuiSmokeComposerAttachmentActionKind.PrepareSubmission:
					trace.push("tui.composer_attachment.prepare_submission=" + action.attachmentKind + ":pending=" + action.pendingTransitionText()
						+ ":elements=" + action.elementTransitionText() + ":local_pruned=" + action.localImagesPruned + ":suppressed="
						+ action.submissionSuppressed + ":prepared=" + action.submissionPrepared);
				case TuiSmokeComposerAttachmentActionKind.DrainSubmission:
					trace.push("tui.composer_attachment.drain_submission=" + action.attachmentKind + ":local=" + action.localImageTransitionText()
						+ ":remote_taken=" + action.remoteImagesTaken + ":remote=" + action.remoteImageTransitionText());
				case TuiSmokeComposerAttachmentActionKind.InsertSelectedFile:
					trace.push("tui.composer_attachment.selected_file=" + action.path + ":image_path=" + action.imagePasteEnabled + ":dimensions_checked="
						+ action.imageDimensionsChecked + ":attached=" + action.imageAttached + ":fallback=" + action.pathInsertedFallback + ":no_live_fs="
						+ action.noLiveFilesystem);
				case TuiSmokeComposerAttachmentActionKind.FrameSchedule:
					trace.push("tui.composer_attachment.frame="
						+ "scheduled="
						+ action.frameScheduled
						+ ":redraw="
						+ action.needsRedraw
						+ ":burst="
						+ action.burstAfter
						+ (action.followupDelayMs > 0 ? ":delay_ms=" + action.followupDelayMs : ""));
				case TuiSmokeComposerAttachmentActionKind.Failure:
					trace.push("tui.composer_attachment.failure=" + action.failureCode + ":no_live_clipboard=" + action.noLiveClipboard + ":no_process="
						+ action.noProcessSpawn + ":no_live_fs=" + action.noLiveFilesystem + ":unsupported=" + action.unsupportedRejected);
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
					trace.push("tui.history_search.begin=" + action.keyName + ":active=" + action.activeTransitionText() + ":status=" + action.statusAfter
						+ ":original=" + action.originalDraft + ":paste_flushed=" + action.pasteFlushed + ":file_query_cleared=" + action.fileQueryCleared
						+ ":popups_cleared=" + action.popupsCleared + ":remote_images_cleared=" + action.remoteImageSelectionCleared + ":search_reset="
						+ action.searchReset);
				case TuiSmokeHistorySearchActionKind.QueryEdit:
					trace.push("tui.history_search.query=" + action.queryTransitionText() + ":status=" + action.statusTransitionText()
						+ ":restore_original=" + action.draftRestored + ":direction=" + action.direction);
				case TuiSmokeHistorySearchActionKind.SearchResult:
					trace.push("tui.history_search.result=" + action.result + ":status=" + action.statusTransitionText() + ":preview=" + action.previewText
						+ ":matches=" + action.matchCount + ":selected=" + action.selectionTransitionText() + ":draft_previewed=" + action.draftPreviewed
						+ ":draft_restored=" + action.draftRestored);
				case TuiSmokeHistorySearchActionKind.Navigate:
					trace.push("tui.history_search.navigate=" + action.direction + ":result=" + action.result + ":status=" + action.statusTransitionText()
						+ ":selected=" + action.selectionTransitionText() + ":preview=" + action.previewText);
				case TuiSmokeHistorySearchActionKind.Accept:
					trace.push("tui.history_search.accept=" + action.acceptedText + ":active=" + action.activeTransitionText() + ":status="
						+ action.statusTransitionText() + ":cursor=" + action.cursorTransitionText() + ":draft_accepted=" + action.draftAccepted
						+ ":search_reset=" + action.searchReset);
				case TuiSmokeHistorySearchActionKind.Cancel:
					trace.push("tui.history_search.cancel=" + action.keyName + ":active=" + action.activeTransitionText() + ":restored="
						+ action.restoredText + ":navigation_reset=" + action.navigationReset + ":ctrl_c=" + action.ctrlCConsumed + ":redraw="
						+ action.redrawRequested);
				case TuiSmokeHistorySearchActionKind.LookupRequest:
					trace.push("tui.history_search.lookup_request=" + "offset=" + action.persistentOffset + ":log=" + action.logId + ":direction="
						+ action.direction + ":pending=" + action.pendingStored + ":live=" + !action.noLiveLookup);
				case TuiSmokeHistorySearchActionKind.LookupResponse:
					trace.push("tui.history_search.lookup_response=" + "offset=" + action.persistentOffset + ":log=" + action.logId + ":result="
						+ action.result + ":status=" + action.statusTransitionText() + ":preview=" + action.previewText);
				case TuiSmokeHistorySearchActionKind.FooterRender:
					trace.push("tui.history_search.footer=" + action.footerLine + ":mode=" + action.footerMode + ":status=" + action.statusAfter);
				case TuiSmokeHistorySearchActionKind.Highlight:
					trace.push("tui.history_search.highlight="
						+ action.queryAfter
						+ ":ranges="
						+ action.highlightCount
						+ ":preview="
						+ action.previewText);
				case TuiSmokeHistorySearchActionKind.Keymap:
					trace.push("tui.history_search.keymap=" + action.keyName + ":remapped=" + action.remapped + ":fallback_suppressed="
						+ action.fallbackSuppressed + ":consumed=" + action.keyConsumed);
				case TuiSmokeHistorySearchActionKind.SuppressPopups:
					trace.push("tui.history_search.suppress_popups=" + "file_query_cleared=" + action.fileQueryCleared + ":popups_cleared="
						+ action.popupsCleared + ":frame=" + action.frameScheduled);
				case TuiSmokeHistorySearchActionKind.Failure:
					trace.push("tui.history_search.failure=" + action.failureCode + ":unsupported=" + action.unsupportedRejected);
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
					trace.push("tui.file_mention_popup.sync=" + action.inputText + ":token=" + action.token + ":query=" + action.query + ":popup="
						+ action.popupTransitionText() + ":mentions_v2=" + action.mentionsV2Enabled + ":redraw=" + action.redrawRequested);
				case TuiSmokeFileMentionPopupActionKind.ActivateFile:
					trace.push("tui.file_mention_popup.file.activate=" + action.query + ":created=" + action.popupCreated + ":popup="
						+ action.popupTransitionText() + ":rows=" + action.rowCount + ":max_rows=" + action.maxRows);
				case TuiSmokeFileMentionPopupActionKind.FileSearchStart:
					trace.push("tui.file_mention_popup.file.search_start=" + action.query + ":sent=" + action.queryStartSent + ":same_query_skipped="
						+ action.sameQuerySkipped + ":live_rejected=" + action.liveSearchRejected);
				case TuiSmokeFileMentionPopupActionKind.FileSearchResult:
					trace.push("tui.file_mention_popup.file.result=" + action.query + ":accepted=" + action.resultAccepted + ":stale=" + action.resultStale
						+ ":matches=" + action.matchCount + ":visible=" + action.visibleCount + ":rows=" + action.rowCount + ":selected="
						+ action.selectionTransitionText() + ":scroll=" + action.scrollTransitionText());
				case TuiSmokeFileMentionPopupActionKind.MoveSelection:
					trace.push("tui.file_mention_popup.selection=" + action.popupAfter + ":selected=" + action.selectionTransitionText() + ":scroll="
						+ action.scrollTransitionText());
				case TuiSmokeFileMentionPopupActionKind.InsertFile:
					trace.push("tui.file_mention_popup.file.insert=" + action.selectedPath + ":candidate=" + action.candidateKind + ":draft="
						+ action.draftUpdated + ":popup=" + action.popupTransitionText() + ":frame=" + action.frameScheduled);
				case TuiSmokeFileMentionPopupActionKind.DismissFile:
					trace.push("tui.file_mention_popup.file.dismiss=" + action.token + ":stored=" + action.dismissedTokenStored + ":popup="
						+ action.popupTransitionText() + ":redraw=" + action.redrawRequested);
				case TuiSmokeFileMentionPopupActionKind.ActivateMention:
					trace.push("tui.file_mention_popup.mention.activate=" + action.query + ":created=" + action.popupCreated + ":popup="
						+ action.popupTransitionText() + ":mode=" + action.searchModeAfter + ":files=" + action.fileCandidateCount + ":dirs="
						+ action.directoryCandidateCount + ":skills=" + action.skillCandidateCount + ":plugins=" + action.pluginCandidateCount + ":tools="
						+ action.toolCandidateCount);
				case TuiSmokeFileMentionPopupActionKind.SwitchMentionMode:
					trace.push("tui.file_mention_popup.mention.mode=" + action.searchModeTransitionText() + ":query=" + action.query + ":selected="
						+ action.selectionTransitionText());
				case TuiSmokeFileMentionPopupActionKind.InsertMention:
					trace.push("tui.file_mention_popup.mention.insert=" + action.insertText + ":candidate=" + action.candidateKind + ":path="
						+ action.selectedPath + ":binding=" + action.bindingStored + ":draft=" + action.draftUpdated + ":popup=" +
						action.popupTransitionText());
				case TuiSmokeFileMentionPopupActionKind.DismissMention:
					trace.push("tui.file_mention_popup.mention.dismiss=" + action.token + ":stored=" + action.dismissedTokenStored + ":popup="
						+ action.popupTransitionText() + ":redraw=" + action.redrawRequested);
				case TuiSmokeFileMentionPopupActionKind.ClearQuery:
					trace.push("tui.file_mention_popup.file.clear_query=" + action.query + ":sent=" + action.queryClearSent + ":popup="
						+ action.popupTransitionText());
				case TuiSmokeFileMentionPopupActionKind.Hide:
					trace.push("tui.file_mention_popup.hide="
						+ action.inputText
						+ ":popup="
						+ action.popupTransitionText()
						+ ":reason="
						+ action.failureCode);
				case TuiSmokeFileMentionPopupActionKind.SuppressSlash:
					trace.push("tui.file_mention_popup.suppress_slash=" + action.inputText + ":token=" + action.token + ":suppressed="
						+ action.slashPopupSuppressed + ":popup=" + action.popupTransitionText());
				case TuiSmokeFileMentionPopupActionKind.Failure:
					trace.push("tui.file_mention_popup.failure=" + action.failureCode + ":live_rejected=" + action.liveSearchRejected + ":unsupported="
						+ action.unsupportedRejected);
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
					trace.push("tui.slash_popup.sync=" + action.inputText + ":filter=" + action.filterText + ":active=" + action.activeTransitionText()
						+ ":file_query_cleared=" + action.currentFileQueryCleared + ":redraw=" + action.redrawRequested);
				case TuiSmokeSlashPopupActionKind.Activate:
					trace.push("tui.slash_popup.activate=" + action.filterText + ":match=" + action.matchKind + ":created=" + action.popupCreated
						+ ":commands=" + action.totalCommands + ":visible=" + action.visibleCount + ":aliases_hidden=" + action.hiddenAliasCount);
				case TuiSmokeSlashPopupActionKind.Render:
					trace.push("tui.slash_popup.render=" + action.filterText + ":rows=" + action.rowCount + ":matches=" + action.matchedCount + ":services="
						+ action.serviceTierCount + ":disabled=" + action.disabledCount);
				case TuiSmokeSlashPopupActionKind.Filter:
					trace.push("tui.slash_popup.filter=" + action.filterText + ":match=" + action.matchKind + ":matches=" + action.matchedCount
						+ ":selected=" + action.selectionTransitionText() + ":scroll=" + action.scrollTransitionText());
				case TuiSmokeSlashPopupActionKind.MoveSelection:
					trace.push("tui.slash_popup.selection=" + action.filterText + ":selected=" + action.selectionTransitionText() + ":scroll="
						+ action.scrollTransitionText());
				case TuiSmokeSlashPopupActionKind.Complete:
					trace.push("tui.slash_popup.complete=" + action.commandName + ":kind=" + action.commandKind + ":completion=" + action.completionKind
						+ ":draft_preserved=" + action.draftPreserved + ":text_cleared=" + action.textCleared);
				case TuiSmokeSlashPopupActionKind.Dispatch:
					trace.push("tui.slash_popup.dispatch=" + action.commandName + ":kind=" + action.commandKind + ":command=" + action.commandDispatched
						+ ":service_tier=" + action.serviceTierDispatched + ":history=" + action.historyStaged + "->" + action.historyRecorded
						+ ":text_cleared=" + action.textCleared);
				case TuiSmokeSlashPopupActionKind.RejectUnavailable:
					trace.push("tui.slash_popup.unavailable=" + action.commandName + ":task_running=" + action.taskRunning + ":rejected="
						+ action.unsupportedRejected + ":history=" + action.historyStaged + "->" + action.historyRecorded);
				case TuiSmokeSlashPopupActionKind.Dismiss:
					trace.push("tui.slash_popup.dismiss=" + action.filterText + ":active=" + action.activeTransitionText() + ":dismissed="
						+ action.popupDismissed + ":draft_preserved=" + action.draftPreserved + ":redraw=" + action.redrawRequested);
				case TuiSmokeSlashPopupActionKind.Hide:
					trace.push("tui.slash_popup.hide="
						+ action.inputText
						+ ":active="
						+ action.activeTransitionText()
						+ ":reason="
						+ action.failureCode);
				case TuiSmokeSlashPopupActionKind.SuppressInterrupt:
					trace.push("tui.slash_popup.suppress_interrupt=" + action.filterText + ":task_running=" + action.taskRunning + ":active="
						+ action.activeAfter + ":suppressed=" + action.interruptSuppressed);
				case TuiSmokeSlashPopupActionKind.Failure:
					trace.push("tui.slash_popup.failure=" + action.failureCode + ":rejected=" + action.unsupportedRejected);
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
					trace.push("tui.hooks_browser.open=" + action.pageAfter + ":events=" + action.eventCount + ":hooks=" + action.hookCount
						+ ":needs_review=" + action.needsReviewCount + ":selected=" + action.selectionTransitionText() + ":frame=" + action.frameScheduled);
				case TuiSmokeHooksBrowserActionKind.RenderEvents:
					trace.push("tui.hooks_browser.render_events=" + "events=" + action.eventCount + ":installed=" + action.installedCount + ":active="
						+ action.activeCount + ":needs_review=" + action.needsReviewCount + ":warnings=" + action.warningCount + ":errors="
						+ action.errorCount + ":rows=" + action.visibleRows + ":rendered=" + action.rendered);
				case TuiSmokeHooksBrowserActionKind.MoveSelection:
					trace.push("tui.hooks_browser.selection=" + action.pageBefore + ":event=" + action.eventName + ":selected="
						+ action.selectionTransitionText() + ":scroll=" + action.scrollTransitionText());
				case TuiSmokeHooksBrowserActionKind.OpenEvent:
					trace.push("tui.hooks_browser.open_event=" + action.eventName + ":page=" + action.pageTransitionText() + ":handlers=" + action.hookCount
						+ ":selected=" + action.selectionTransitionText() + ":frame=" + action.frameScheduled);
				case TuiSmokeHooksBrowserActionKind.ReturnToEvents:
					trace.push("tui.hooks_browser.return=" + action.eventName + ":page=" + action.pageTransitionText() + ":selected="
						+ action.selectionTransitionText() + ":frame=" + action.frameScheduled);
				case TuiSmokeHooksBrowserActionKind.RenderHandlers:
					trace.push("tui.hooks_browser.render_handlers=" + action.eventName + ":handlers=" + action.hookCount + ":active=" + action.activeCount
						+ ":needs_review=" + action.needsReviewCount + ":rows=" + action.visibleRows + ":details=" + action.detailLines + ":command_lines="
						+ action.commandDetailLines + ":rendered=" + action.rendered);
				case TuiSmokeHooksBrowserActionKind.ToggleHook:
					trace.push("tui.hooks_browser.toggle=" + action.hookKey + ":event=" + action.eventName + ":source=" + action.hookSource + ":enabled="
						+ action.enabledTransitionText() + ":sent=" + action.setHookEnabledSent);
				case TuiSmokeHooksBrowserActionKind.TrustHook:
					trace.push("tui.hooks_browser.trust=" + action.hookKey + ":event=" + action.eventName + ":trust=" + action.trustTransitionText()
						+ ":sent=" + action.trustHookSent + ":frame=" + action.frameScheduled);
				case TuiSmokeHooksBrowserActionKind.TrustAll:
					trace.push("tui.hooks_browser.trust_all=" + action.eventName + ":updates=" + action.updatesCount + ":needs_review="
						+ action.needsReviewCount + ":sent=" + action.trustHooksSent + ":frame=" + action.frameScheduled);
				case TuiSmokeHooksBrowserActionKind.ManagedNoOp:
					trace.push("tui.hooks_browser.managed_noop=" + action.hookKey + ":event=" + action.eventName + ":managed=" + action.managed
						+ ":enabled=" + action.enabledTransitionText() + ":sent=" + action.setHookEnabledSent);
				case TuiSmokeHooksBrowserActionKind.ReviewNoOp:
					trace.push("tui.hooks_browser.review_noop=" + action.hookKey + ":event=" + action.eventName + ":needs_review=" + action.needsReview
						+ ":trust=" + action.trustTransitionText() + ":sent=" + action.setHookEnabledSent);
				case TuiSmokeHooksBrowserActionKind.Close:
					trace.push("tui.hooks_browser.close=" + action.pageBefore + ":complete=" + action.completeTransitionText() + ":frame="
						+ action.frameScheduled);
				case TuiSmokeHooksBrowserActionKind.Failure:
					trace.push("tui.hooks_browser.failure=" + action.failureCode + ":warnings=" + action.warningCount + ":errors=" + action.errorCount
						+ ":rejected=" + action.unsupportedRejected);
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
					trace.push("tui.mcp_elicitation.pending.note=" + action.mode + ":server=" + action.serverName + ":request=" + action.requestId
						+ ":thread=" + action.threadId + ":message_chars=" + action.messageChars + ":unsupported=" + action.unsupportedRejected);
				case TuiSmokeMcpElicitationActionKind.ParseForm:
					trace.push("tui.mcp_elicitation.parse=" + action.mode + ":fields=" + action.fieldCount + ":required=" + action.requiredFieldCount
						+ ":optional=" + action.optionalFieldCount + ":secret=" + action.secretFieldCount + ":approval_params="
						+ action.approvalDisplayParamCount);
				case TuiSmokeMcpElicitationActionKind.ShowModal:
					trace.push("tui.mcp_elicitation.show=modal" + ":mode=" + action.mode + ":server=" + action.serverName + ":request=" + action.requestId
						+ ":fields=" + action.fieldCount + ":views=" + action.viewStackTransitionText() + ":pause_status=" + action.statusTimerPaused
						+ ":composer_disabled=" + action.composerDisabled + ":focus=" + action.hasInputFocus);
				case TuiSmokeMcpElicitationActionKind.ShowAppLink:
					trace.push("tui.mcp_elicitation.show=app_link" + ":server=" + action.serverName + ":request=" + action.requestId + ":tool="
						+ action.toolId + ":name=" + action.toolName + ":install_url=" + action.toolSuggestionHasInstallUrl + ":views="
						+ action.viewStackTransitionText() + ":pause_status=" + action.statusTimerPaused);
				case TuiSmokeMcpElicitationActionKind.EnqueueActive:
					trace.push("tui.mcp_elicitation.enqueue_active=" + action.mode + ":request=" + action.requestId + ":queue="
						+ action.queueTransitionText() + ":frame=" + action.frameScheduled);
				case TuiSmokeMcpElicitationActionKind.SelectOption:
					trace.push("tui.mcp_elicitation.select=" + action.fieldId + ":input=" + action.fieldInput + ":options=" + action.optionCount
						+ ":selected=" + action.selectionTransitionText() + ":answered=" + action.answerTransitionText());
				case TuiSmokeMcpElicitationActionKind.DraftInput:
					trace.push("tui.mcp_elicitation.draft=" + action.fieldId + ":input=" + action.fieldInput + ":chars=" + action.draftTransitionText()
						+ ":paste_burst=" + action.pendingPasteCount + ":answered=" + action.answerTransitionText());
				case TuiSmokeMcpElicitationActionKind.MoveField:
					trace.push("tui.mcp_elicitation.move_field=" + action.fieldTransitionText() + ":saved_draft_chars=" + action.draftCharsBefore
						+ ":restored_draft_chars=" + action.draftCharsAfter + ":input=" + action.fieldInput);
				case TuiSmokeMcpElicitationActionKind.ValidationError:
					trace.push("tui.mcp_elicitation.validation=" + action.failureCode + ":required_unanswered=" + action.requiredUnansweredBefore + ":jump="
						+ action.fieldTransitionText());
				case TuiSmokeMcpElicitationActionKind.Submit:
					trace.push("tui.mcp_elicitation.submit=" + action.mode + ":decision=" + action.decision + ":content_fields=" + action.contentFieldCount
						+ ":meta_persisted=" + action.metaPersisted + ":required_unanswered=" + action.requiredUnansweredTransitionText() + ":command="
						+ action.appCommandSent + ":complete=" + action.completeTransitionText());
				case TuiSmokeMcpElicitationActionKind.Cancel:
					trace.push("tui.mcp_elicitation.cancel=" + action.mode + ":server=" + action.serverName + ":request=" + action.requestId + ":command="
						+ action.appCommandSent + ":complete=" + action.completeTransitionText());
				case TuiSmokeMcpElicitationActionKind.Resolve:
					trace.push("tui.mcp_elicitation.resolve=" + action.mode + ":server=" + action.serverName + ":request=" + action.requestId + ":decision="
						+ action.decision + ":content_fields=" + action.contentFieldCount + ":meta_persisted=" + action.metaPersisted + ":sent="
						+ action.resolutionSent);
				case TuiSmokeMcpElicitationActionKind.DismissResolved:
					trace.push("tui.mcp_elicitation.dismiss_resolved=" + action.mode + ":server=" + action.serverName + ":request=" + action.requestId
						+ ":matched=" + action.resolvedDismissed + ":stale=" + action.staleResolution + ":queue=" + action.queueTransitionText() + ":views="
						+ action.viewStackTransitionText() + ":resume_status=" + action.statusTimerResumed + ":frame=" + action.frameScheduled);
				case TuiSmokeMcpElicitationActionKind.UnsupportedReject:
					trace.push("tui.mcp_elicitation.unsupported=" + action.mode + ":server=" + action.serverName + ":request=" + action.requestId
						+ ":rejected=" + action.unsupportedRejected + ":failure=" + action.failureCode);
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
		trace.push("tui.terminal_modes." + label + "=" + "raw=" + action.rawModeRestore + ":keyboard=" + action.keyboardRestore
			+ ":disable_bracketed_paste=" + action.bracketedPaste + ":disable_focus=" + action.focusChange + ":cursor_default=" + action.cursorDefault
			+ ":cursor_show=" + action.cursorShow + ":stderr_finish=" + action.terminalStderrFinish);
	}

	static function stringArraysEqual(left:Array<String>, right:Array<String>):Bool {
		if (left.length != right.length)
			return false;
		for (i in 0...left.length) {
			if (left[i] != right[i])
				return false;
		}
		return true;
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
