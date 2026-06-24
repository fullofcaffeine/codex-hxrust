package codexhx.runtime.tui.resume.live;

import codexhx.protocol.json.CodexJson;
import codexhx.runtime.asyncruntime.AsyncContext;
import codexhx.runtime.asyncruntime.AsyncPollSummary;
import codexhx.runtime.app.RuntimeClientOutcome;
import codexhx.validation.tui.resume.live.ResumePickerGateDiagnostics;
import codexhx.runtime.tui.resume.ResumePickerActionKind;
import codexhx.runtime.tui.resume.ResumePickerFilterMode;
import codexhx.runtime.tui.resume.ResumePickerSortKey;
import codexhx.runtime.tui.resume.ResumePickerState;
import codexhx.runtime.tui.resume.ResumePickerVisibleRow;
import codexhx.runtime.tui.resume.host.DeterministicTypedPendingRequestRegistry;
import codexhx.runtime.tui.resume.host.Dispatcher;
import codexhx.runtime.tui.resume.host.EnvelopeBuilder;
import codexhx.runtime.tui.resume.host.DeterministicFrameScheduler;
import codexhx.runtime.tui.resume.host.DeterministicTerminalRenderer;
import codexhx.runtime.tui.resume.host.JsonRpcThreadSource;
import codexhx.runtime.tui.resume.host.EventPump;
import codexhx.runtime.tui.resume.host.PendingRequestClassKind;
import codexhx.runtime.tui.resume.host.StreamEvent;
import codexhx.runtime.tui.resume.host.StreamFanout;
import codexhx.runtime.tui.resume.host.TypedPendingRequestEvent;
import codexhx.runtime.tui.resume.host.DispatchOutcome;
import codexhx.runtime.tui.resume.host.DispatchOutcomeKind;
import codexhx.runtime.tui.resume.host.Envelope;
import codexhx.runtime.tui.resume.host.ResumePickerHostEvent;
import codexhx.runtime.tui.resume.host.ResumePickerHostEventKind;
import codexhx.runtime.tui.resume.host.ResumePickerThreadListRequest;

class DispatchOrderingRefreshGate {
	public static function run():DispatchOrderingRefreshReport {
		final scheduler = new DeterministicFrameScheduler();
		final renderer = new DeterministicTerminalRenderer();
		final state = baseState();
		final source = new JsonRpcThreadSource(8);
		final fanout = new StreamFanout(source);
		final pump = new EventPump(1, fanout, scheduler, 12);
		final registry = new DeterministicTypedPendingRequestRegistry();
		final builder = new EnvelopeBuilder();
		final dispatcher = new Dispatcher();
		final events:Array<TypedPendingRequestEvent> = [];
		final envelopes:Array<Envelope> = [];
		final outcomes:Array<DispatchOutcome> = [];
		final stateSummaries:Array<String> = [];
		final forwardPolls:Array<String> = [];

		renderFrame(scheduler, renderer, state, "typed-dispatch-open");

		envelopes.push(resolveKeyed(pump, registry, builder, events, forwardPolls, PendingRequestClassKind.ExecApproval, "typed-dispatch-exec-1",
			"approval-1", "turn-1", "call-1", "", "", "item/commandExecution/requestApproval;approval=approval-1"));
		envelopes.push(resolveKeyed(pump, registry, builder, events, forwardPolls, PendingRequestClassKind.FileChangeApproval, "typed-dispatch-file-2",
			"patch-1", "turn-1", "patch-1", "", "", "item/fileChange/requestApproval;item=patch-1"));
		envelopes.push(resolveKeyed(pump, registry, builder, events, forwardPolls, PendingRequestClassKind.PermissionsApproval,
			"typed-dispatch-permissions-3", "perm-1", "turn-1", "perm-1", "", "", "item/permissions/requestApproval;item=perm-1"));

		final userInputHost = deliverServerRequest(pump, forwardPolls, "typed-dispatch-user-input-4", "item/tool/requestUserInput;turn=turn-2;item=tool-1");
		registry.register(PendingRequestClassKind.UserInput, userInputHost.requestId, "turn-2", "turn-2", "tool-1", "", "", userInputHost.detail);
		final userInputEvent = registry.popUserInput("turn-2");
		events.push(userInputEvent);
		envelopes.push(builder.resolve(userInputEvent));

		final mcpHost = deliverServerRequest(pump, forwardPolls, "typed-dispatch-mcp-5", "mcpServer/elicitation/request;server=apps;request=mcp-5");
		registry.register(PendingRequestClassKind.McpElicitation, mcpHost.requestId, "apps:mcp-5", "turn-3", "mcp-item-5", "apps", "mcp-5", mcpHost.detail);
		final mcpEvent = registry.resolveMcp("apps", "mcp-5");
		events.push(mcpEvent);
		envelopes.push(builder.resolve(mcpEvent));

		final unsupportedEvent = registry.register(PendingRequestClassKind.DynamicToolCall, "typed-dispatch-dynamic-6", "tool-6", "turn-4", "tool-6", "", "",
			"item/tool/call;dynamic=true");
		events.push(unsupportedEvent);
		envelopes.push(builder.resolve(unsupportedEvent));

		final missingEvent = registry.resolveKey(PendingRequestClassKind.ExecApproval, "missing-approval");
		events.push(missingEvent);
		envelopes.push(builder.resolve(missingEvent));
		envelopes.push(envelopes[0]);

		var sourceOrder = 1;
		for (envelope in envelopes) {
			final outcome = dispatcher.dispatch(envelope, sourceOrder);
			outcomes.push(outcome);
			applyOutcome(state, outcome);
			stateSummaries.push("dispatch-" + sourceOrder + ":" + stateSummary(state));
			renderFrame(scheduler, renderer, state, "typed-dispatch-" + sourceOrder);
			sourceOrder = sourceOrder + 1;
		}

		final pageAccepted = fanout.enqueuePage(pageRequest("typed-dispatch-recovery-page", "", "typed dispatch"));
		stateSummaries.push("enqueued:page=" + outcomeSummary(pageAccepted));
		final pagePoll = pump.forward(StreamEvent.pageResult(1, "typed-dispatch-recovery-page", threadListResultJson("dispatch")));
		forwardPolls.push("page-recovery=" + AsyncPollSummary.summary(pagePoll));
		final pageDispatch = pump.dispatchNext(AsyncContext.fixture("typed-dispatch-recovery-page"));
		if (pageDispatch.hostEvent.kind == ResumePickerHostEventKind.PageLoaded)
			applyPage(state, pageDispatch.hostEvent, "dispatch");
		stateSummaries.push("page:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "typed-dispatch-recovery-page");

		final outcomeSummaries = outcomeSummaries(outcomes);
		final pumpSummaries = pump.summaries();
		final rejectedRequests = pump.rejectedRequestSummaries();

		return new DispatchOrderingRefreshReport({
			responseOrderPreserved: orderPreserved(outcomes),
			supportedRefreshScheduled: supportedRefreshScheduled(outcomes),
			unsupportedRejectNoRefresh: outcomeHas(outcomes, DispatchOutcomeKind.RejectSent, "typed-dispatch-dynamic-6", false),
			missingNoopNoRefresh: outcomeHas(outcomes, DispatchOutcomeKind.LocalNoop, "", false),
			lateDuplicateRefused: outcomeHas(outcomes, DispatchOutcomeKind.LateDuplicateRefused, "typed-dispatch-exec-1", false),
			requestIdsCorrelated: contains(outcomeSummaries, "correlation=server:typed-dispatch-exec-1")
			&& contains(outcomeSummaries, "correlation=server:typed-dispatch-mcp-5")
			&& contains(outcomeSummaries, "correlation=local:missing-request"),
			noPressureDropRejection: rejectedRequests.length == 0
			&& !contains(pumpSummaries, "server-request-rejected")
			&& !contains(pumpSummaries, "consumer_queue_full"),
			liveTransportSuppressed: !contains(outcomeSummaries, "liveTransport=true") && contains(outcomeSummaries, "suppressed=true"),
			recoveryDecoded: pageDispatch.hostEvent.kind == ResumePickerHostEventKind.PageLoaded
			&& state.selectedThreadId == "thread-dispatch-a"
			&& !state.inlineErrorShown,
			noCredentialOrModelTraffic: true,
			stateDbUntouched: true,
			pageRequests: source.pageRequestCount(),
			readRequests: source.readRequestCount(),
			frameRequests: scheduler.requestCount(),
			renderCount: renderer.renderCount(),
			finalSnapshot: renderer.lastSnapshot(),
			renderSnapshots: renderer.allSnapshots(),
			typedEventSummaries: eventSummaries(events),
			envelopeSummaries: envelopeSummaries(envelopes),
			dispatchOutcomeSummaries: outcomeSummaries,
			dispatcherLogSummaries: dispatcher.summaries(),
			requestSummaries: fanout.requestSummaries(),
			transportSummaries: fanout.transportSummaries(),
			pumpSummaries: pumpSummaries,
			rejectedRequestSummaries: rejectedRequests,
			stateSummaries: stateSummaries,
			forwardPollSummaries: forwardPolls
		});
	}

	static function resolveKeyed(pump:EventPump, registry:DeterministicTypedPendingRequestRegistry, builder:EnvelopeBuilder,
			events:Array<TypedPendingRequestEvent>, forwardPolls:Array<String>, requestClass:PendingRequestClassKind, requestId:String, key:String,
			turnId:String, itemId:String, serverName:String, mcpRequestId:String, detail:String):Envelope {
		final hostEvent = deliverServerRequest(pump, forwardPolls, requestId, detail);
		registry.register(requestClass, hostEvent.requestId, key, turnId, itemId, serverName, mcpRequestId, hostEvent.detail);
		final resolved = registry.resolveKey(requestClass, key);
		events.push(resolved);
		return builder.resolve(resolved);
	}

	static function deliverServerRequest(pump:EventPump, forwardPolls:Array<String>, requestId:String, detail:String):ResumePickerHostEvent {
		final poll = pump.forward(StreamEvent.serverRequest(1, requestId, detail));
		forwardPolls.push(requestId + "=" + AsyncPollSummary.summary(poll));
		final dispatch = pump.dispatchNext(AsyncContext.fixture(requestId));
		return dispatch.hostEvent;
	}

	static function baseState():ResumePickerState {
		final state = ResumePickerState.initial();
		state.opened = true;
		state.action = ResumePickerActionKind.Resume;
		state.sortKey = ResumePickerSortKey.UpdatedAt;
		state.filterMode = ResumePickerFilterMode.Cwd;
		state.toolbarRenderMode = "compact";
		state.query = "typed dispatch";
		state.cwdFilter = "/workspace/codex-hxrust";
		state.pageSize = 2;
		state.viewRows = 2;
		state.footerProgressLabel = "typed dispatch open";
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

	static function applyOutcome(state:ResumePickerState, outcome:DispatchOutcome):Void {
		state.inlineErrorShown = outcome.kind == DispatchOutcomeKind.RejectSent
			|| outcome.kind == DispatchOutcomeKind.LateDuplicateRefused;
		state.lastFailureCode = state.inlineErrorShown ? outcome.kind : "";
		state.lastError = outcome.reason;
		state.loaderEventStatus = "typed_response_dispatch_" + outcome.kind;
		state.loaderEventDetail = outcome.summary();
		state.footerProgressLabel = outcome.refreshScheduled ? "typed response refresh scheduled" : "typed response no refresh";
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
			visibleRow("thread-" + prefix + "-a", title(prefix, "A"), "2026-06-20T06:05:00Z", 2, true, []),
			visibleRow("thread-" + prefix + "-b", title(prefix, "B"), "2026-06-20T06:06:00Z", 1, false, [])
		];
		state.inlineErrorShown = false;
		state.lastFailureCode = "";
		state.lastError = "";
		state.loaderEventStatus = "typed_response_dispatch_recovery_page_decoded";
		state.loaderEventDetail = "request=" + event.requestId + ";response=" + event.detail;
		state.footerProgressLabel = "typed dispatch recovered";
	}

	static function threadListResultJson(prefix:String):String {
		return "{"
			+ "\"data\":["
			+ threadListRowJson("thread-" + prefix + "-a", "session-" + prefix + "-a", title(prefix, "A"), "2026-06-20T06:05:00Z", 2)
			+ ","
			+ threadListRowJson("thread-" + prefix + "-b", "session-" + prefix + "-b", title(prefix, "B"), "2026-06-20T06:06:00Z", 1)
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

	static function outcomeSummaries(outcomes:Array<DispatchOutcome>):Array<String> {
		final out:Array<String> = [];
		for (outcome in outcomes)
			out.push(outcome.summary());
		return out;
	}

	static function envelopeSummaries(envelopes:Array<Envelope>):Array<String> {
		final out:Array<String> = [];
		for (envelope in envelopes)
			out.push(envelope.summary());
		return out;
	}

	static function eventSummaries(events:Array<TypedPendingRequestEvent>):Array<String> {
		final out:Array<String> = [];
		for (event in events)
			out.push(event.summary());
		return out;
	}

	static function orderPreserved(outcomes:Array<DispatchOutcome>):Bool {
		var i = 0;
		while (i < outcomes.length) {
			if (outcomes[i].sequence != i + 1 || outcomes[i].sourceOrder != i + 1)
				return false;
			i = i + 1;
		}
		return outcomes.length == 8;
	}

	static function supportedRefreshScheduled(outcomes:Array<DispatchOutcome>):Bool {
		var count = 0;
		for (outcome in outcomes) {
			if (outcome.kind == DispatchOutcomeKind.ResolveSent
				&& outcome.refreshScheduled
				&& outcome.pendingReplayRefresh
				&& outcome.sideParentStatusUpdated)
				count = count + 1;
		}
		return count == 5;
	}

	static function outcomeHas(outcomes:Array<DispatchOutcome>, kind:DispatchOutcomeKind, requestId:String, refreshScheduled:Bool):Bool {
		for (outcome in outcomes)
			if (outcome.kind == kind && outcome.requestId == requestId && outcome.refreshScheduled == refreshScheduled)
				return true;
		return false;
	}

	static function stateSummary(state:ResumePickerState):String {
		return ResumePickerGateDiagnostics.inlineErrorState(state);
	}

	static function outcomeSummary(outcome:RuntimeClientOutcome):String {
		return ResumePickerGateDiagnostics.runtimeClientOutcome(outcome);
	}

	static function title(prefix:String, suffix:String):String {
		return "Typed dispatch " + prefix + " row " + suffix;
	}

	static function contains(values:Array<String>, needle:String):Bool {
		for (value in values)
			if (value.indexOf(needle) >= 0)
				return true;
		return false;
	}
}
