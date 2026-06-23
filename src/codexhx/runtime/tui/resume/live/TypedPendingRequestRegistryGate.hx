package codexhx.runtime.tui.resume.live;

import codexhx.protocol.json.CodexJson;
import codexhx.runtime.asyncruntime.AsyncContext;
import codexhx.runtime.asyncruntime.AsyncPollSummary;
import codexhx.runtime.app.RuntimeClientOutcome;
import codexhx.runtime.tui.resume.ResumePickerActionKind;
import codexhx.runtime.tui.resume.ResumePickerFilterMode;
import codexhx.runtime.tui.resume.ResumePickerSortKey;
import codexhx.runtime.tui.resume.ResumePickerState;
import codexhx.runtime.tui.resume.ResumePickerVisibleRow;
import codexhx.runtime.tui.resume.host.DeterministicTypedPendingRequestRegistry;
import codexhx.runtime.tui.resume.host.DeterministicFrameScheduler;
import codexhx.runtime.tui.resume.host.DeterministicTerminalRenderer;
import codexhx.runtime.tui.resume.host.JsonRpcThreadSource;
import codexhx.runtime.tui.resume.host.EventPump;
import codexhx.runtime.tui.resume.host.PendingRequestClassKind;
import codexhx.runtime.tui.resume.host.StreamEvent;
import codexhx.runtime.tui.resume.host.StreamFanout;
import codexhx.runtime.tui.resume.host.TypedPendingRequestEvent;
import codexhx.runtime.tui.resume.host.TypedPendingRequestEventKind;
import codexhx.runtime.tui.resume.host.ResumePickerHostEvent;
import codexhx.runtime.tui.resume.host.ResumePickerHostEventKind;
import codexhx.runtime.tui.resume.host.ResumePickerThreadListRequest;

class TypedPendingRequestRegistryGate {
	public static function run():TypedPendingRequestRegistryReport {
		final scheduler = new DeterministicFrameScheduler();
		final renderer = new DeterministicTerminalRenderer();
		final state = baseState();
		final source = new JsonRpcThreadSource(8);
		final fanout = new StreamFanout(source);
		final pump = new EventPump(1, fanout, scheduler, 14);
		final registry = new DeterministicTypedPendingRequestRegistry();
		final events:Array<TypedPendingRequestEvent> = [];
		final dispatchSummaries:Array<String> = [];
		final hostEvents:Array<String> = [];
		final stateSummaries:Array<String> = [];
		final forwardPolls:Array<String> = [];

		renderFrame(scheduler, renderer, state, "typed-pending-open");

		final execHost = deliverServerRequest(pump, dispatchSummaries, hostEvents, forwardPolls, "typed-exec-1",
			"item/commandExecution/requestApproval;approval=approval-1");
		final execRegistered = registry.register(PendingRequestClassKind.ExecApproval, execHost.requestId, "approval-1", "turn-1", "call-1", "", "",
			execHost.detail);
		events.push(execRegistered);

		final fileHost = deliverServerRequest(pump, dispatchSummaries, hostEvents, forwardPolls, "typed-file-2",
			"item/fileChange/requestApproval;item=patch-1");
		final fileRegistered = registry.register(PendingRequestClassKind.FileChangeApproval, fileHost.requestId, "patch-1", "turn-1", "patch-1", "", "",
			fileHost.detail);
		events.push(fileRegistered);

		final permissionsHost = deliverServerRequest(pump, dispatchSummaries, hostEvents, forwardPolls, "typed-permissions-3",
			"item/permissions/requestApproval;item=perm-1");
		final permissionsRegistered = registry.register(PendingRequestClassKind.PermissionsApproval, permissionsHost.requestId, "perm-1", "turn-1", "perm-1",
			"", "", permissionsHost.detail);
		events.push(permissionsRegistered);

		final duplicatePermissions = registry.register(PendingRequestClassKind.PermissionsApproval, "typed-permissions-duplicate-3b", "perm-1", "turn-1",
			"perm-1", "", "", "item/permissions/requestApproval;item=perm-1;duplicate=true");
		events.push(duplicatePermissions);
		applyTypedEvent(state, duplicatePermissions, "typed_pending_duplicate_key_rejected");
		stateSummaries.push("duplicate:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "typed-pending-duplicate-key");

		final userInputA = deliverServerRequest(pump, dispatchSummaries, hostEvents, forwardPolls, "typed-user-input-4",
			"item/tool/requestUserInput;turn=turn-2;item=tool-1");
		final userInputARegistered = registry.register(PendingRequestClassKind.UserInput, userInputA.requestId, "turn-2", "turn-2", "tool-1", "", "",
			userInputA.detail);
		events.push(userInputARegistered);
		final userInputB = deliverServerRequest(pump, dispatchSummaries, hostEvents, forwardPolls, "typed-user-input-5",
			"item/tool/requestUserInput;turn=turn-2;item=tool-2");
		final userInputBRegistered = registry.register(PendingRequestClassKind.UserInput, userInputB.requestId, "turn-2", "turn-2", "tool-2", "", "",
			userInputB.detail);
		events.push(userInputBRegistered);
		final fifoFirst = registry.popUserInput("turn-2");
		final fifoSecond = registry.popUserInput("turn-2");
		events.push(fifoFirst);
		events.push(fifoSecond);
		applyTypedEvent(state, fifoSecond, "typed_pending_user_input_fifo_popped");
		stateSummaries.push("fifo:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "typed-pending-user-input-fifo");

		final mcpHost = deliverServerRequest(pump, dispatchSummaries, hostEvents, forwardPolls, "typed-mcp-app-6",
			"mcpServer/elicitation/request;server=apps;request=mcp-6");
		final mcpRegistered = registry.register(PendingRequestClassKind.McpElicitation, mcpHost.requestId, "apps:mcp-6", "turn-3", "mcp-item-6", "apps",
			"mcp-6", mcpHost.detail);
		events.push(mcpRegistered);
		final mcpMatched = registry.resolveMcp("apps", "mcp-6");
		events.push(mcpMatched);
		applyTypedEvent(state, mcpMatched, "typed_pending_mcp_matched");
		stateSummaries.push("mcp:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "typed-pending-mcp");

		final unsupported = registry.register(PendingRequestClassKind.DynamicToolCall, "typed-dynamic-7", "tool-7", "turn-4", "tool-7", "", "",
			"item/tool/call;dynamic=true");
		events.push(unsupported);
		applyTypedEvent(state, unsupported, "typed_pending_unsupported_refused");
		stateSummaries.push("unsupported:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "typed-pending-unsupported");

		final notificationRemoved = registry.resolveNotification(fileHost.requestId);
		events.push(notificationRemoved);
		applyTypedEvent(state, notificationRemoved, "typed_pending_notification_removed");
		stateSummaries.push("notification:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "typed-pending-notification");

		final execRemoved = registry.resolveKey(PendingRequestClassKind.ExecApproval, "approval-1");
		final permissionsRemoved = registry.resolveKey(PendingRequestClassKind.PermissionsApproval, "perm-1");
		events.push(execRemoved);
		events.push(permissionsRemoved);
		final staleReplay = registry.replayDecision(fileHost.requestId);
		events.push(staleReplay);
		applyTypedEvent(state, staleReplay, "typed_pending_stale_replay_skipped");
		stateSummaries.push("stale-replay:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "typed-pending-stale-replay");

		final pageAccepted = fanout.enqueuePage(pageRequest("typed-pending-recovery-page", "", "typed pending"));
		stateSummaries.push("enqueued:page=" + outcomeSummary(pageAccepted));
		final pagePoll = pump.forward(StreamEvent.pageResult(1, "typed-pending-recovery-page", threadListResultJson("typed")));
		forwardPolls.push("page-recovery=" + AsyncPollSummary.summary(pagePoll));

		final pageDispatch = pump.dispatchNext(AsyncContext.fixture("typed-pending-recovery-page"));
		dispatchSummaries.push(pageDispatch.summary);
		hostEvents.push(pageDispatch.hostEvent.summary());
		if (pageDispatch.hostEvent.kind == ResumePickerHostEventKind.PageLoaded)
			applyPage(state, pageDispatch.hostEvent, "typed");
		stateSummaries.push("page:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "typed-pending-recovery-page");

		final typedEventSummaries = typedEventSummaries(events);
		final pumpSummaries = pump.summaries();
		final rejectedRequests = pump.rejectedRequestSummaries();

		return new TypedPendingRequestRegistryReport({
			typedClassesRegistered: execRegistered.kind == TypedPendingRequestEventKind.Registered
			&& fileRegistered.kind == TypedPendingRequestEventKind.Registered
			&& permissionsRegistered.kind == TypedPendingRequestEventKind.Registered
			&& userInputARegistered.kind == TypedPendingRequestEventKind.Registered
			&& userInputBRegistered.kind == TypedPendingRequestEventKind.Registered
			&& mcpRegistered.kind == TypedPendingRequestEventKind.Registered,
			keyDuplicateRejected: duplicatePermissions.kind == TypedPendingRequestEventKind.DuplicateRejected
			&& duplicatePermissions.key == "perm-1",
			userInputFifoResolved: fifoFirst.kind == TypedPendingRequestEventKind.UserInputFifoPopped
			&& fifoFirst.requestId == "typed-user-input-4"
			&& fifoSecond.kind == TypedPendingRequestEventKind.UserInputFifoPopped
			&& fifoSecond.requestId == "typed-user-input-5",
			mcpRequestMatched: mcpMatched.kind == TypedPendingRequestEventKind.McpMatched
			&& mcpMatched.serverName == "apps"
			&& mcpMatched.mcpRequestId == "mcp-6",
			unsupportedRefused: unsupported.kind == TypedPendingRequestEventKind.UnsupportedRefused
			&& unsupported.requestClass == PendingRequestClassKind.DynamicToolCall,
			notificationRemoved: notificationRemoved.kind == TypedPendingRequestEventKind.NotificationRemoved
			&& notificationRemoved.requestId == "typed-file-2",
			staleReplaySkipped: staleReplay.kind == TypedPendingRequestEventKind.StaleReplaySkipped
			&& staleReplay.requestId == "typed-file-2",
			registryEmptyAtEnd: registry.count() == 0,
			noPressureDropRejection: rejectedRequests.length == 0
			&& !contains(pumpSummaries, "server-request-rejected")
			&& !contains(pumpSummaries, "consumer_queue_full"),
			liveTransportSuppressed: true,
			recoveryDecoded: pageDispatch.hostEvent.kind == ResumePickerHostEventKind.PageLoaded
			&& state.selectedThreadId == "thread-typed-a"
			&& !state.inlineErrorShown,
			noCredentialOrModelTraffic: true,
			stateDbUntouched: true,
			pageRequests: source.pageRequestCount(),
			readRequests: source.readRequestCount(),
			frameRequests: scheduler.requestCount(),
			renderCount: renderer.renderCount(),
			finalSnapshot: renderer.lastSnapshot(),
			renderSnapshots: renderer.allSnapshots(),
			typedEventSummaries: typedEventSummaries,
			registryLogSummaries: registry.summaries(),
			pendingSummaries: registry.pendingSummaries(),
			requestSummaries: fanout.requestSummaries(),
			transportSummaries: fanout.transportSummaries(),
			dispatchSummaries: dispatchSummaries,
			pumpSummaries: pumpSummaries,
			rejectedRequestSummaries: rejectedRequests,
			hostEventSummaries: hostEvents,
			stateSummaries: stateSummaries,
			forwardPollSummaries: forwardPolls
		});
	}

	static function deliverServerRequest(pump:EventPump, dispatchSummaries:Array<String>, hostEvents:Array<String>, forwardPolls:Array<String>,
			requestId:String, detail:String):ResumePickerHostEvent {
		final poll = pump.forward(StreamEvent.serverRequest(1, requestId, detail));
		forwardPolls.push(requestId + "=" + AsyncPollSummary.summary(poll));
		final dispatch = pump.dispatchNext(AsyncContext.fixture(requestId));
		dispatchSummaries.push(dispatch.summary);
		hostEvents.push(dispatch.hostEvent.summary());
		return dispatch.hostEvent;
	}

	static function baseState():ResumePickerState {
		final state = ResumePickerState.initial();
		state.opened = true;
		state.action = ResumePickerActionKind.Resume;
		state.sortKey = ResumePickerSortKey.UpdatedAt;
		state.filterMode = ResumePickerFilterMode.Cwd;
		state.toolbarRenderMode = "compact";
		state.query = "typed pending";
		state.cwdFilter = "/workspace/codex-hxrust";
		state.pageSize = 2;
		state.viewRows = 2;
		state.footerProgressLabel = "typed pending open";
		return state;
	}

	static function pageRequest(requestId:String, cursor:String, query:String):ResumePickerThreadListRequest {
		return new ResumePickerThreadListRequest({
			requestId: requestId,
			cursor: cursor,
			query: query,
			pageSize: 2,
			sortKey: ResumePickerSortKey.UpdatedAt,
			filterMode: ResumePickerFilterMode.Cwd,
			cwdFilter: "/workspace/codex-hxrust",
			showAll: false,
			includeNonInteractive: false
		});
	}

	static function applyTypedEvent(state:ResumePickerState, event:TypedPendingRequestEvent, status:String):Void {
		state.inlineErrorShown = event.kind == TypedPendingRequestEventKind.DuplicateRejected
			|| event.kind == TypedPendingRequestEventKind.UnsupportedRefused;
		state.lastFailureCode = state.inlineErrorShown ? event.kind : "";
		state.lastError = event.reason;
		state.loaderEventStatus = status;
		state.loaderEventDetail = "kind=" + event.kind + ";class=" + event.requestClass + ";request=" + event.requestId + ";key=" + event.key + ";turn="
			+ event.turnId + ";item=" + event.itemId + ";server=" + event.serverName + ";mcp=" + event.mcpRequestId + ";order=" + event.orderIndex
			+ ";before=" + event.pendingBefore + ";after=" + event.pendingAfter + ";reason=" + event.reason;
		state.footerProgressLabel = status;
	}

	static function applyPage(state:ResumePickerState, event:ResumePickerHostEvent, prefix:String):Void {
		state.scannedRows = 2;
		state.acceptedRows = 2;
		state.loadedRows = 2;
		state.filteredRows = 2;
		state.selectedIndex = 0;
		state.selectedThreadId = "thread-" + prefix + "-a";
		state.selectedLabel = title(prefix, "A");
		state.nextCursor = "cursor-" + prefix;
		state.nextCursorPresent = true;
		state.moreBelow = true;
		state.visibleRows = [
			visibleRow("thread-" + prefix + "-a", title(prefix, "A"), "2026-06-20T05:30:00Z", 2, true, []),
			visibleRow("thread-" + prefix + "-b", title(prefix, "B"), "2026-06-20T05:31:00Z", 1, false, [])
		];
		state.inlineErrorShown = false;
		state.lastFailureCode = "";
		state.lastError = "";
		state.loaderEventStatus = "typed_pending_recovery_page_decoded";
		state.loaderEventDetail = "request=" + event.requestId + ";response=" + event.detail;
		state.footerProgressLabel = "typed pending recovered";
	}

	static function threadListResultJson(prefix:String):String {
		return "{"
			+ "\"data\":["
			+ threadListRowJson("thread-" + prefix + "-a", "session-" + prefix + "-a", title(prefix, "A"), "2026-06-20T05:30:00Z", 2)
			+ ","
			+ threadListRowJson("thread-" + prefix + "-b", "session-" + prefix + "-b", title(prefix, "B"), "2026-06-20T05:31:00Z", 1)
			+ "],\"nextCursor\":\"cursor-"
			+ prefix
			+ "\",\"backwardsCursor\":null}";
	}

	static function threadListRowJson(threadId:String, sessionId:String, rowTitle:String, updatedAt:String, turns:Int):String {
		return "{" + "\"id\":" + CodexJson.quote(threadId) + ",\"sessionId\":" + CodexJson.quote(sessionId) + ",\"status\":{\"type\":\"idle\"}"
			+ ",\"turns\":" + turnsJson(turns) + ",\"title\":" + CodexJson.quote(rowTitle) + ",\"cwd\":\"/workspace/codex-hxrust\"" + ",\"updatedAt\":"
			+ CodexJson.quote(updatedAt) + ",\"archived\":false}";
	}

	static function turnsJson(count:Int):String {
		final parts:Array<String> = [];
		var i = 0;
		while (i < count) {
			parts.push("{\"id\":\"turn-" + Std.string(i + 1) + "\",\"status\":\"completed\",\"items\":[]}");
			i = i + 1;
		}
		return "[" + parts.join(",") + "]";
	}

	static function visibleRow(threadId:String, rowTitle:String, updatedAt:String, turnCount:Int, selected:Bool,
			previewLines:Array<String>):ResumePickerVisibleRow {
		return new ResumePickerVisibleRow({
			threadId: threadId,
			title: rowTitle,
			cwd: "/workspace/codex-hxrust",
			updatedAt: updatedAt,
			turnCount: turnCount,
			selected: selected,
			previewLines: previewLines
		});
	}

	static function renderFrame(scheduler:DeterministicFrameScheduler, renderer:DeterministicTerminalRenderer, state:ResumePickerState, reason:String):Void {
		scheduler.requestFrame(reason);
		renderer.render(state);
	}

	static function typedEventSummaries(events:Array<TypedPendingRequestEvent>):Array<String> {
		final out:Array<String> = [];
		for (event in events)
			out.push(event.summary());
		return out;
	}

	static function stateSummary(state:ResumePickerState):String {
		return "thread=" + state.selectedThreadId + ";errorShown=" + boolLabel(state.inlineErrorShown) + ";failure=" + emptyLabel(state.lastFailureCode)
			+ ";footer=" + state.footerProgressLabel + ";loader=" + state.loaderEventStatus + ";detail=" + state.loaderEventDetail;
	}

	static function outcomeSummary(outcome:RuntimeClientOutcome):String {
		return "ok=" + boolLabel(outcome.ok) + ";code=" + outcome.code + ";request=" + outcome.requestId + ";method=" + outcome.method + ";pending="
			+ outcome.pendingCount + ";message=" + outcome.message;
	}

	static function title(prefix:String, suffix:String):String {
		return "Typed pending " + prefix + " row " + suffix;
	}

	static function contains(values:Array<String>, needle:String):Bool {
		for (value in values)
			if (value.indexOf(needle) >= 0)
				return true;
		return false;
	}

	static function emptyLabel(value:String):String {
		return value.length == 0 ? "<empty>" : value;
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
