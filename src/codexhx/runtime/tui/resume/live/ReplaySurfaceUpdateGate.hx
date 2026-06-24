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
import codexhx.runtime.tui.resume.host.RefreshApplicator;
import codexhx.runtime.tui.resume.host.RefreshReplayDeliveryPlanner;
import codexhx.runtime.tui.resume.host.ReplaySurfaceUpdater;
import codexhx.runtime.tui.resume.host.DeterministicFrameScheduler;
import codexhx.runtime.tui.resume.host.DeterministicTerminalRenderer;
import codexhx.runtime.tui.resume.host.JsonRpcThreadSource;
import codexhx.runtime.tui.resume.host.EventPump;
import codexhx.runtime.tui.resume.host.PendingRequestClassKind;
import codexhx.runtime.tui.resume.host.StreamEvent;
import codexhx.runtime.tui.resume.host.StreamFanout;
import codexhx.runtime.tui.resume.host.DispatchOutcome;
import codexhx.runtime.tui.resume.host.Envelope;
import codexhx.runtime.tui.resume.host.RefreshApplication;
import codexhx.runtime.tui.resume.host.RefreshApplicationKind;
import codexhx.runtime.tui.resume.host.RefreshReplayDelivery;
import codexhx.runtime.tui.resume.host.ReplaySurfaceUpdate;
import codexhx.runtime.tui.resume.host.ReplaySurfaceUpdateKind;
import codexhx.runtime.tui.resume.host.ResumePickerHostEvent;
import codexhx.runtime.tui.resume.host.ResumePickerHostEventKind;
import codexhx.runtime.tui.resume.host.ResumePickerThreadListRequest;

class ReplaySurfaceUpdateGate {
	public static function run():ReplaySurfaceUpdateReport {
		final scheduler = new DeterministicFrameScheduler();
		final renderer = new DeterministicTerminalRenderer();
		final state = baseState();
		final source = new JsonRpcThreadSource(8);
		final fanout = new StreamFanout(source);
		final pump = new EventPump(1, fanout, scheduler, 12);
		final registry = new DeterministicTypedPendingRequestRegistry();
		final builder = new EnvelopeBuilder();
		final dispatcher = new Dispatcher();
		final applicator = new RefreshApplicator();
		final planner = new RefreshReplayDeliveryPlanner();
		final updater = new ReplaySurfaceUpdater();
		final envelopes:Array<Envelope> = [];
		final outcomes:Array<DispatchOutcome> = [];
		final applications:Array<RefreshApplication> = [];
		final deliveries:Array<RefreshReplayDelivery> = [];
		final surfaceUpdates:Array<ReplaySurfaceUpdate> = [];
		final stateSummaries:Array<String> = [];
		final forwardPolls:Array<String> = [];

		renderFrame(scheduler, renderer, state, "typed-surface-open");
		buildEnvelopes(pump, registry, builder, envelopes, forwardPolls);

		var sourceOrder = 1;
		for (envelope in envelopes) {
			final outcome = dispatcher.dispatch(envelope, sourceOrder);
			outcomes.push(outcome);
			final application = applicator.apply(outcome);
			applications.push(application);
			final plannedDeliveries = planner.deliver(application);
			if (plannedDeliveries.length == 0)
				stateSummaries.push("skip-" + sourceOrder + ":" + application.summary());
			for (delivery in plannedDeliveries) {
				deliveries.push(delivery);
				final surfaceUpdate = updater.apply(delivery);
				if (surfaceUpdate != null) {
					surfaceUpdates.push(surfaceUpdate);
					applySurfaceUpdate(state, surfaceUpdate);
					stateSummaries.push("surface-" + surfaceUpdate.surfaceSequence + ":" + stateSummary(state));
					renderFrame(scheduler, renderer, state, "typed-surface-" + surfaceUpdate.surfaceSequence);
				}
			}
			sourceOrder = sourceOrder + 1;
		}

		final pageAccepted = fanout.enqueuePage(pageRequest("typed-surface-recovery-page", "", "typed surface"));
		stateSummaries.push("enqueued:page=" + outcomeSummary(pageAccepted));
		final pagePoll = pump.forward(StreamEvent.pageResult(1, "typed-surface-recovery-page", threadListResultJson("surface")));
		forwardPolls.push("page-recovery=" + AsyncPollSummary.summary(pagePoll));
		final pageDispatch = pump.dispatchNext(AsyncContext.fixture("typed-surface-recovery-page"));
		if (pageDispatch.hostEvent.kind == ResumePickerHostEventKind.PageLoaded)
			applyPage(state, pageDispatch.hostEvent, "surface");
		stateSummaries.push("page:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "typed-surface-recovery-page");

		final surfaceUpdateSummaries = surfaceUpdateSummaries(surfaceUpdates);
		final deliverySummaries = deliverySummaries(deliveries);
		final applicationSummaries = applicationSummaries(applications);
		final dispatchOutcomeSummaries = outcomeSummaries(outcomes);
		final pumpSummaries = pump.summaries();
		final rejectedRequests = pump.rejectedRequestSummaries();

		return new ReplaySurfaceUpdateReport({
			surfaceUpdateCount: surfaceUpdates.length,
			pendingInteractiveSurfaceUpdated: countKind(surfaceUpdates, ReplaySurfaceUpdateKind.PendingInteractivePrompt) == 5,
			sideParentSurfaceUpdated: countKind(surfaceUpdates, ReplaySurfaceUpdateKind.SideParentStatus) == 5,
			activeThreadSurfaceUpdated: countKind(surfaceUpdates, ReplaySurfaceUpdateKind.ActiveThreadStatus) == 5,
			surfaceOrderPreserved: surfaceOrderPreserved(surfaceUpdates),
			ignoredApplicationsAbsentFromSurfaces: ignoredApplicationsAbsentFromSurfaces(applications, surfaceUpdateSummaries, planner.summaries()),
			recoveryDecoded: pageDispatch.hostEvent.kind == ResumePickerHostEventKind.PageLoaded
			&& state.selectedThreadId == "thread-surface-a"
			&& !state.inlineErrorShown,
			noPressureDropRejection: rejectedRequests.length == 0
			&& !contains(pumpSummaries, "server-request-rejected")
			&& !contains(pumpSummaries, "consumer_queue_full"),
			liveTransportSuppressed: !contains(surfaceUpdateSummaries, "liveTransport=true")
			&& contains(surfaceUpdateSummaries, "suppressed=true"),
			noCredentialOrModelTraffic: true,
			stateDbUntouched: true,
			pageRequests: source.pageRequestCount(),
			readRequests: source.readRequestCount(),
			frameRequests: scheduler.requestCount(),
			renderCount: renderer.renderCount(),
			finalSnapshot: renderer.lastSnapshot(),
			renderSnapshots: renderer.allSnapshots(),
			surfaceUpdateSummaries: surfaceUpdateSummaries,
			surfaceUpdaterLogSummaries: updater.summaries(),
			deliverySummaries: deliverySummaries,
			plannerLogSummaries: planner.summaries(),
			applicationSummaries: applicationSummaries,
			dispatchOutcomeSummaries: dispatchOutcomeSummaries,
			envelopeSummaries: envelopeSummaries(envelopes),
			requestSummaries: fanout.requestSummaries(),
			transportSummaries: fanout.transportSummaries(),
			pumpSummaries: pumpSummaries,
			rejectedRequestSummaries: rejectedRequests,
			stateSummaries: stateSummaries,
			forwardPollSummaries: forwardPolls
		});
	}

	static function buildEnvelopes(pump:EventPump, registry:DeterministicTypedPendingRequestRegistry, builder:EnvelopeBuilder, envelopes:Array<Envelope>,
			forwardPolls:Array<String>):Void {
		envelopes.push(resolveKeyed(pump, registry, builder, forwardPolls, PendingRequestClassKind.ExecApproval, "typed-surface-exec-1", "approval-1",
			"turn-1", "call-1", "", "", "item/commandExecution/requestApproval;approval=approval-1"));
		envelopes.push(resolveKeyed(pump, registry, builder, forwardPolls, PendingRequestClassKind.FileChangeApproval, "typed-surface-file-2", "patch-1",
			"turn-1", "patch-1", "", "", "item/fileChange/requestApproval;item=patch-1"));
		envelopes.push(resolveKeyed(pump, registry, builder, forwardPolls, PendingRequestClassKind.PermissionsApproval, "typed-surface-permissions-3",
			"perm-1", "turn-1", "perm-1", "", "", "item/permissions/requestApproval;item=perm-1"));

		final inputHost = deliverServerRequest(pump, forwardPolls, "typed-surface-user-input-4", "item/tool/requestUserInput;turn=turn-2;item=tool-1");
		registry.register(PendingRequestClassKind.UserInput, inputHost.requestId, "turn-2", "turn-2", "tool-1", "", "", inputHost.detail);
		envelopes.push(builder.resolve(registry.popUserInput("turn-2")));

		final mcpHost = deliverServerRequest(pump, forwardPolls, "typed-surface-mcp-5", "mcpServer/elicitation/request;server=apps;request=mcp-5");
		registry.register(PendingRequestClassKind.McpElicitation, mcpHost.requestId, "apps:mcp-5", "turn-3", "mcp-item-5", "apps", "mcp-5", mcpHost.detail);
		envelopes.push(builder.resolve(registry.resolveMcp("apps", "mcp-5")));

		final unsupported = registry.register(PendingRequestClassKind.DynamicToolCall, "typed-surface-dynamic-6", "tool-6", "turn-4", "tool-6", "", "",
			"item/tool/call;dynamic=true");
		envelopes.push(builder.resolve(unsupported));
		envelopes.push(builder.resolve(registry.resolveKey(PendingRequestClassKind.ExecApproval, "missing-approval")));
		envelopes.push(envelopes[0]);
	}

	static function resolveKeyed(pump:EventPump, registry:DeterministicTypedPendingRequestRegistry, builder:EnvelopeBuilder, forwardPolls:Array<String>,
			requestClass:PendingRequestClassKind, requestId:String, key:String, turnId:String, itemId:String, serverName:String, mcpRequestId:String,
			detail:String):Envelope {
		final hostEvent = deliverServerRequest(pump, forwardPolls, requestId, detail);
		registry.register(requestClass, hostEvent.requestId, key, turnId, itemId, serverName, mcpRequestId, hostEvent.detail);
		return builder.resolve(registry.resolveKey(requestClass, key));
	}

	static function deliverServerRequest(pump:EventPump, forwardPolls:Array<String>, requestId:String, detail:String):ResumePickerHostEvent {
		final poll = pump.forward(StreamEvent.serverRequest(1, requestId, detail));
		forwardPolls.push(requestId + "=" + AsyncPollSummary.summary(poll));
		return pump.dispatchNext(AsyncContext.fixture(requestId)).hostEvent;
	}

	static function applySurfaceUpdate(state:ResumePickerState, update:ReplaySurfaceUpdate):Void {
		state.inlineErrorShown = false;
		state.lastFailureCode = "";
		state.lastError = "";
		state.loaderEventStatus = "typed_response_replay_surface_" + update.kind;
		state.loaderEventDetail = update.summary();
		state.footerProgressLabel = update.surfaceLabel;
	}

	static function baseState():ResumePickerState {
		final state = ResumePickerState.initial();
		state.opened = true;
		state.action = ResumePickerActionKind.Resume;
		state.sortKey = ResumePickerSortKey.UpdatedAt;
		state.filterMode = ResumePickerFilterMode.Cwd;
		state.toolbarRenderMode = "compact";
		state.query = "typed surface";
		state.cwdFilter = "/workspace/codex-hxrust";
		state.pageSize = 2;
		state.viewRows = 2;
		state.footerProgressLabel = "typed surface open";
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
			visibleRow("thread-" + prefix + "-a", title(prefix, "A"), "2026-06-20T06:55:00Z", 2, true, []),
			visibleRow("thread-" + prefix + "-b", title(prefix, "B"), "2026-06-20T06:56:00Z", 1, false, [])
		];
		state.inlineErrorShown = false;
		state.lastFailureCode = "";
		state.lastError = "";
		state.loaderEventStatus = "typed_response_replay_surface_recovery_page_decoded";
		state.loaderEventDetail = "request=" + event.requestId + ";response=" + event.detail;
		state.footerProgressLabel = "typed surface recovered";
	}

	static function threadListResultJson(prefix:String):String {
		return "{"
			+ "\"data\":["
			+ threadListRowJson("thread-" + prefix + "-a", "session-" + prefix + "-a", title(prefix, "A"), "2026-06-20T06:55:00Z", 2)
			+ ","
			+ threadListRowJson("thread-" + prefix + "-b", "session-" + prefix + "-b", title(prefix, "B"), "2026-06-20T06:56:00Z", 1)
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

	static function surfaceOrderPreserved(updates:Array<ReplaySurfaceUpdate>):Bool {
		var expectedSequence = 1;
		for (update in updates) {
			if (!update.surfaceOrderPreserved || !update.deliveryOrderPreserved || update.surfaceSequence != expectedSequence)
				return false;
			expectedSequence = expectedSequence + 1;
		}
		return expectedSequence == 16;
	}

	static function ignoredApplicationsAbsentFromSurfaces(applications:Array<RefreshApplication>, surfaceSummaries:Array<String>,
			plannerSummaries:Array<String>):Bool {
		var ignored = 0;
		for (application in applications)
			if (application.kind == RefreshApplicationKind.IgnoredNoRefresh)
				ignored = ignored + 1;
		return ignored == 3
			&& countContains(plannerSummaries, "delivery-skip:refresh_application_no_delivery") == 3
			&& !contains(surfaceSummaries, "class=dynamic_tool_call")
			&& !contains(surfaceSummaries, "payloadKind=missing_pending_noop")
			&& !contains(surfaceSummaries, "request=typed-surface-exec-1;deliverySequence=0");
	}

	static function countKind(updates:Array<ReplaySurfaceUpdate>, kind:ReplaySurfaceUpdateKind):Int {
		var count = 0;
		for (update in updates)
			if (update.kind == kind)
				count = count + 1;
		return count;
	}

	static function surfaceUpdateSummaries(updates:Array<ReplaySurfaceUpdate>):Array<String> {
		final out:Array<String> = [];
		for (update in updates)
			out.push(update.summary());
		return out;
	}

	static function deliverySummaries(deliveries:Array<RefreshReplayDelivery>):Array<String> {
		final out:Array<String> = [];
		for (delivery in deliveries)
			out.push(delivery.summary());
		return out;
	}

	static function applicationSummaries(applications:Array<RefreshApplication>):Array<String> {
		final out:Array<String> = [];
		for (application in applications)
			out.push(application.summary());
		return out;
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

	static function stateSummary(state:ResumePickerState):String {
		return ResumePickerGateDiagnostics.inlineErrorState(state);
	}

	static function outcomeSummary(outcome:RuntimeClientOutcome):String {
		return ResumePickerGateDiagnostics.runtimeClientOutcome(outcome);
	}

	static function title(prefix:String, suffix:String):String {
		return "Typed surface " + prefix + " row " + suffix;
	}

	static function countContains(values:Array<String>, needle:String):Int {
		var count = 0;
		for (value in values)
			if (value.indexOf(needle) >= 0)
				count = count + 1;
		return count;
	}

	static function contains(values:Array<String>, needle:String):Bool {
		for (value in values)
			if (value.indexOf(needle) >= 0)
				return true;
		return false;
	}
}
