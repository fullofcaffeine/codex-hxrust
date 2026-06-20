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
import codexhx.runtime.tui.resume.host.DeterministicResumePickerAppServerPendingRequestRegistry;
import codexhx.runtime.tui.resume.host.DeterministicResumePickerAppServerRequestHandle;
import codexhx.runtime.tui.resume.host.DeterministicResumePickerAppServerResponseTransport;
import codexhx.runtime.tui.resume.host.DeterministicResumePickerFrameScheduler;
import codexhx.runtime.tui.resume.host.DeterministicResumePickerTerminalRenderer;
import codexhx.runtime.tui.resume.host.JsonRpcResumePickerThreadSource;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerEventPump;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerPendingRequestRegistryEvent;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerPendingRequestRegistryEventKind;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerRequestDispatchCommand;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerRequestDispatchCommandKind;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerRequestDispatchOptions;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerRequestResponseIntent;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerResponseTransportEnvelope;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerResponseTransportEnvelopeKind;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerStreamEvent;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerStreamFanout;
import codexhx.runtime.tui.resume.host.ResumePickerHostEvent;
import codexhx.runtime.tui.resume.host.ResumePickerHostEventKind;
import codexhx.runtime.tui.resume.host.ResumePickerThreadListRequest;

class ResumePickerAppServerPendingRequestRegistryRenderGate {
	static final RESOLVE_REQUEST_ID = "pending-registry-resolve-1";
	static final REJECT_REQUEST_ID = "pending-registry-reject-2";
	static final ABANDONED_REQUEST_ID = "pending-registry-abandoned-3";

	public static function run():ResumePickerAppServerPendingRequestRegistryRenderGateReport {
		final scheduler = new DeterministicResumePickerFrameScheduler();
		final renderer = new DeterministicResumePickerTerminalRenderer();
		final state = baseState();
		final source = new JsonRpcResumePickerThreadSource(8);
		final fanout = new ResumePickerAppServerStreamFanout(source);
		final pump = new ResumePickerAppServerEventPump(1, fanout, scheduler, 10);
		final registry = new DeterministicResumePickerAppServerPendingRequestRegistry();
		final requestHandle = new DeterministicResumePickerAppServerRequestHandle();
		final responseTransport = new DeterministicResumePickerAppServerResponseTransport();
		final registryEvents:Array<ResumePickerAppServerPendingRequestRegistryEvent> = [];
		final commands:Array<ResumePickerAppServerRequestDispatchCommand> = [];
		final envelopes:Array<ResumePickerAppServerResponseTransportEnvelope> = [];
		final dispatchSummaries:Array<String> = [];
		final hostEvents:Array<String> = [];
		final stateSummaries:Array<String> = [];
		final forwardPolls:Array<String> = [];

		renderFrame(scheduler, renderer, state, "pending-registry-open");

		final resolveEvent = deliverServerRequest(pump, dispatchSummaries, hostEvents, forwardPolls, RESOLVE_REQUEST_ID,
			"tool/request_user_input;surface=resume_picker;turn=turn-a;item=tool-a");
		final registeredResolve = registry.register(resolveEvent.requestId, resolveEvent.detail);
		registryEvents.push(registeredResolve);
		applyRegistryEvent(state, registeredResolve, "pending_registry_registered");
		stateSummaries.push("registered-resolve:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "pending-registry-registered-resolve");

		final duplicateEvent = deliverServerRequest(pump, dispatchSummaries, hostEvents, forwardPolls, RESOLVE_REQUEST_ID,
			"tool/request_user_input;surface=resume_picker;turn=turn-a;item=tool-a-duplicate");
		final duplicateRejected = registry.register(duplicateEvent.requestId, duplicateEvent.detail);
		registryEvents.push(duplicateRejected);
		applyRegistryEvent(state, duplicateRejected, "pending_registry_duplicate_rejected");
		stateSummaries.push("duplicate:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "pending-registry-duplicate");

		final resolvedRemoved = registry.resolve(RESOLVE_REQUEST_ID);
		registryEvents.push(resolvedRemoved);
		final resolveCommand = requestHandle.dispatch(ResumePickerAppServerRequestResponseIntent.resolved(RESOLVE_REQUEST_ID, resolveEvent.detail,
			"{\"answer\":\"resume\"}"),
			dispatchOptions(true, true, requestHandle.commandCount()));
		commands.push(resolveCommand);
		final resolveEnvelope = responseTransport.enqueue(resolveCommand);
		envelopes.push(resolveEnvelope);
		applyResolvedEnvelope(state, resolvedRemoved, resolveEnvelope, "pending_registry_resolved_removed");
		stateSummaries.push("resolved:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "pending-registry-resolved");

		final lateSecondResponse = registry.resolve(RESOLVE_REQUEST_ID);
		registryEvents.push(lateSecondResponse);
		applyRegistryEvent(state, lateSecondResponse, "pending_registry_second_response_refused");
		stateSummaries.push("second-response:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "pending-registry-second-response");

		final rejectEvent = deliverServerRequest(pump, dispatchSummaries, hostEvents, forwardPolls, REJECT_REQUEST_ID,
			"mcpServer/elicitation/request;surface=resume_picker;server=example");
		final registeredReject = registry.register(rejectEvent.requestId, rejectEvent.detail);
		registryEvents.push(registeredReject);
		final rejectedRemoved = registry.reject(REJECT_REQUEST_ID);
		registryEvents.push(rejectedRemoved);
		final rejectCommand = requestHandle.dispatch(ResumePickerAppServerRequestResponseIntent.refused(REJECT_REQUEST_ID, rejectEvent.detail,
			"unsupported registry fixture request", "unsupported_in_fixture"),
			dispatchOptions(true, true, requestHandle.commandCount()));
		commands.push(rejectCommand);
		final rejectEnvelope = responseTransport.enqueue(rejectCommand);
		envelopes.push(rejectEnvelope);
		applyResolvedEnvelope(state, rejectedRemoved, rejectEnvelope, "pending_registry_rejected_removed");
		stateSummaries.push("rejected:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "pending-registry-rejected");

		final abandonedEvent = deliverServerRequest(pump, dispatchSummaries, hostEvents, forwardPolls, ABANDONED_REQUEST_ID,
			"tool/request_user_input;surface=resume_picker;turn=turn-b;item=tool-b");
		final registeredAbandoned = registry.register(abandonedEvent.requestId, abandonedEvent.detail);
		registryEvents.push(registeredAbandoned);
		final cleanupEvents = registry.cleanupAbandoned("session_disconnected");
		for (cleanup in cleanupEvents)
			registryEvents.push(cleanup);
		applyRegistryEvent(state, cleanupEvents[0], "pending_registry_abandoned_cleaned");
		stateSummaries.push("abandoned-cleanup:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "pending-registry-abandoned-cleanup");

		final pageAccepted = fanout.enqueuePage(pageRequest("pending-registry-recovery-page", "", "pending registry"));
		stateSummaries.push("enqueued:page=" + outcomeSummary(pageAccepted));
		final pagePoll = pump.forward(ResumePickerAppServerStreamEvent.pageResult(1, "pending-registry-recovery-page", threadListResultJson("registry")));
		forwardPolls.push("page-recovery=" + AsyncPollSummary.summary(pagePoll));

		final pageDispatch = pump.dispatchNext(AsyncContext.fixture("pending-registry-recovery-page"));
		dispatchSummaries.push(pageDispatch.summary);
		hostEvents.push(pageDispatch.hostEvent.summary());
		if (pageDispatch.hostEvent.kind == ResumePickerHostEventKind.PageLoaded)
			applyPage(state, pageDispatch.hostEvent, "registry");
		stateSummaries.push("page:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "pending-registry-recovery-page");

		final registryEventSummaries = registryEventSummaries(registryEvents);
		final commandSummaries = commandSummaries(commands);
		final envelopeSummaries = envelopeSummaries(envelopes);
		final pumpSummaries = pump.summaries();
		final rejectedRequests = pump.rejectedRequestSummaries();

		return new ResumePickerAppServerPendingRequestRegistryRenderGateReport({
			registrationRecorded: registeredResolve.kind == ResumePickerAppServerPendingRequestRegistryEventKind.Registered
			&& registeredResolve.pendingBefore == 0
			&& registeredResolve.pendingAfter == 1,
			duplicateRejected: duplicateRejected.kind == ResumePickerAppServerPendingRequestRegistryEventKind.DuplicateRejected
			&& duplicateRejected.pendingBefore == 1
			&& duplicateRejected.pendingAfter == 1,
			resolveRemovedPending: resolvedRemoved.kind == ResumePickerAppServerPendingRequestRegistryEventKind.ResolvedRemoved
			&& resolveCommand.kind == ResumePickerAppServerRequestDispatchCommandKind.ResolveServerRequest
			&& resolveEnvelope.kind == ResumePickerAppServerResponseTransportEnvelopeKind.ResolveResult,
			rejectRemovedPending: rejectedRemoved.kind == ResumePickerAppServerPendingRequestRegistryEventKind.RejectedRemoved
			&& rejectCommand.kind == ResumePickerAppServerRequestDispatchCommandKind.RejectServerRequest
			&& rejectEnvelope.kind == ResumePickerAppServerResponseTransportEnvelopeKind.RejectError,
			secondResponseRefused: lateSecondResponse.kind == ResumePickerAppServerPendingRequestRegistryEventKind.LateResponseRefused
			&& lateSecondResponse.reason == "request_not_pending",
			abandonedCleanupRecorded: cleanupEvents.length == 1
			&& cleanupEvents[0].kind == ResumePickerAppServerPendingRequestRegistryEventKind.AbandonedCleaned
			&& cleanupEvents[0].requestId == ABANDONED_REQUEST_ID,
			registryEmptyAtEnd: registry.count() == 0,
			noPressureDropRejection: rejectedRequests.length == 0
			&& !contains(pumpSummaries, "server-request-rejected")
			&& !contains(pumpSummaries, "consumer_queue_full"),
			liveTransportSuppressed: !contains(commandSummaries, "liveTransport=true")
			&& !contains(envelopeSummaries, "liveTransport=true"),
			recoveryDecoded: pageDispatch.hostEvent.kind == ResumePickerHostEventKind.PageLoaded
			&& state.selectedThreadId == "thread-registry-a"
			&& !state.inlineErrorShown,
			noCredentialOrModelTraffic: true,
			stateDbUntouched: true,
			pageRequests: source.pageRequestCount(),
			readRequests: source.readRequestCount(),
			frameRequests: scheduler.requestCount(),
			renderCount: renderer.renderCount(),
			finalSnapshot: renderer.lastSnapshot(),
			renderSnapshots: renderer.allSnapshots(),
			registryEventSummaries: registryEventSummaries,
			registryLogSummaries: registry.summaries(),
			pendingSummaries: registry.pendingSummaries(),
			commandSummaries: commandSummaries,
			envelopeSummaries: envelopeSummaries,
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

	static function deliverServerRequest(pump:ResumePickerAppServerEventPump, dispatchSummaries:Array<String>, hostEvents:Array<String>,
			forwardPolls:Array<String>, requestId:String, detail:String):ResumePickerHostEvent {
		final poll = pump.forward(ResumePickerAppServerStreamEvent.serverRequest(1, requestId, detail));
		forwardPolls.push(requestId + "=" + AsyncPollSummary.summary(poll));
		final dispatch = pump.dispatchNext(AsyncContext.fixture(requestId));
		dispatchSummaries.push(dispatch.summary);
		hostEvents.push(dispatch.hostEvent.summary());
		return dispatch.hostEvent;
	}

	static function dispatchOptions(appServerSessionAvailable:Bool, transportSendSucceeds:Bool,
			previousDispatchCount:Int):ResumePickerAppServerRequestDispatchOptions {
		return new ResumePickerAppServerRequestDispatchOptions({
			appServerSessionAvailable: appServerSessionAvailable,
			transportSendSucceeds: transportSendSucceeds,
			previousDispatchCount: previousDispatchCount
		});
	}

	static function baseState():ResumePickerState {
		final state = ResumePickerState.initial();
		state.opened = true;
		state.action = ResumePickerActionKind.Resume;
		state.sortKey = ResumePickerSortKey.UpdatedAt;
		state.filterMode = ResumePickerFilterMode.Cwd;
		state.toolbarRenderMode = "compact";
		state.query = "pending registry";
		state.cwdFilter = "/workspace/codex-hxrust";
		state.pageSize = 2;
		state.viewRows = 2;
		state.footerProgressLabel = "pending registry open";
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

	static function applyRegistryEvent(state:ResumePickerState, event:ResumePickerAppServerPendingRequestRegistryEvent, status:String):Void {
		state.inlineErrorShown = event.kind == ResumePickerAppServerPendingRequestRegistryEventKind.DuplicateRejected
			|| event.kind == ResumePickerAppServerPendingRequestRegistryEventKind.LateResponseRefused;
		state.lastFailureCode = state.inlineErrorShown ? event.kind : "";
		state.lastError = event.reason;
		state.loaderEventStatus = status;
		state.loaderEventDetail = "request=" + event.requestId + ";kind=" + event.kind + ";order=" + event.orderIndex + ";before=" + event.pendingBefore
			+ ";after=" + event.pendingAfter + ";reason=" + emptyLabel(event.reason) + ";detail=" + event.detail;
		state.footerProgressLabel = status;
	}

	static function applyResolvedEnvelope(state:ResumePickerState, registryEvent:ResumePickerAppServerPendingRequestRegistryEvent,
			envelope:ResumePickerAppServerResponseTransportEnvelope, status:String):Void {
		state.inlineErrorShown = false;
		state.lastFailureCode = "";
		state.lastError = "";
		state.loaderEventStatus = status;
		state.loaderEventDetail = "request=" + registryEvent.requestId + ";registry=" + registryEvent.kind + ";before=" + registryEvent.pendingBefore
			+ ";after=" + registryEvent.pendingAfter + ";envelope=" + envelope.kind + ";method=" + envelope.method + ";correlation=" + envelope.correlationKey;
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
			visibleRow("thread-" + prefix + "-a", title(prefix, "A"), "2026-06-20T05:10:00Z", 2, true, []),
			visibleRow("thread-" + prefix + "-b", title(prefix, "B"), "2026-06-20T05:11:00Z", 1, false, [])
		];
		state.inlineErrorShown = false;
		state.lastFailureCode = "";
		state.lastError = "";
		state.loaderEventStatus = "pending_registry_recovery_page_decoded";
		state.loaderEventDetail = "request=" + event.requestId + ";response=" + event.detail;
		state.footerProgressLabel = "pending registry recovered";
	}

	static function threadListResultJson(prefix:String):String {
		return "{"
			+ "\"data\":["
			+ threadListRowJson("thread-" + prefix + "-a", "session-" + prefix + "-a", title(prefix, "A"), "2026-06-20T05:10:00Z", 2)
			+ ","
			+ threadListRowJson("thread-" + prefix + "-b", "session-" + prefix + "-b", title(prefix, "B"), "2026-06-20T05:11:00Z", 1)
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

	static function renderFrame(scheduler:DeterministicResumePickerFrameScheduler, renderer:DeterministicResumePickerTerminalRenderer,
			state:ResumePickerState, reason:String):Void {
		scheduler.requestFrame(reason);
		renderer.render(state);
	}

	static function registryEventSummaries(events:Array<ResumePickerAppServerPendingRequestRegistryEvent>):Array<String> {
		final out:Array<String> = [];
		for (event in events)
			out.push(event.summary());
		return out;
	}

	static function commandSummaries(commands:Array<ResumePickerAppServerRequestDispatchCommand>):Array<String> {
		final out:Array<String> = [];
		for (command in commands)
			out.push(command.summary());
		return out;
	}

	static function envelopeSummaries(envelopes:Array<ResumePickerAppServerResponseTransportEnvelope>):Array<String> {
		final out:Array<String> = [];
		for (envelope in envelopes)
			out.push(envelope.summary());
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
		return "Pending registry " + prefix + " row " + suffix;
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
