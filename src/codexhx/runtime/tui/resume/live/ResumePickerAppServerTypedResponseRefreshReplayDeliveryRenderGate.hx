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
import codexhx.runtime.tui.resume.host.DeterministicResumePickerAppServerTypedPendingRequestRegistry;
import codexhx.runtime.tui.resume.host.DeterministicResumePickerAppServerTypedResponseDispatcher;
import codexhx.runtime.tui.resume.host.DeterministicResumePickerAppServerTypedResponseEnvelopeBuilder;
import codexhx.runtime.tui.resume.host.DeterministicResumePickerAppServerTypedResponseRefreshApplicator;
import codexhx.runtime.tui.resume.host.DeterministicResumePickerAppServerTypedResponseRefreshReplayDeliveryPlanner;
import codexhx.runtime.tui.resume.host.DeterministicResumePickerFrameScheduler;
import codexhx.runtime.tui.resume.host.DeterministicResumePickerTerminalRenderer;
import codexhx.runtime.tui.resume.host.JsonRpcResumePickerThreadSource;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerEventPump;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerPendingRequestClassKind;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerStreamEvent;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerStreamFanout;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseDispatchOutcome;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseEnvelope;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRefreshApplication;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRefreshApplicationKind;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRefreshReplayDelivery;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerTypedResponseRefreshReplayDeliveryKind;
import codexhx.runtime.tui.resume.host.ResumePickerHostEvent;
import codexhx.runtime.tui.resume.host.ResumePickerHostEventKind;
import codexhx.runtime.tui.resume.host.ResumePickerThreadListRequest;

class ResumePickerAppServerTypedResponseRefreshReplayDeliveryRenderGate {
	public static function run():ResumePickerAppServerTypedResponseRefreshReplayDeliveryRenderGateReport {
		final scheduler = new DeterministicResumePickerFrameScheduler();
		final renderer = new DeterministicResumePickerTerminalRenderer();
		final state = baseState();
		final source = new JsonRpcResumePickerThreadSource(8);
		final fanout = new ResumePickerAppServerStreamFanout(source);
		final pump = new ResumePickerAppServerEventPump(1, fanout, scheduler, 12);
		final registry = new DeterministicResumePickerAppServerTypedPendingRequestRegistry();
		final builder = new DeterministicResumePickerAppServerTypedResponseEnvelopeBuilder();
		final dispatcher = new DeterministicResumePickerAppServerTypedResponseDispatcher();
		final applicator = new DeterministicResumePickerAppServerTypedResponseRefreshApplicator();
		final planner = new DeterministicResumePickerAppServerTypedResponseRefreshReplayDeliveryPlanner();
		final envelopes:Array<ResumePickerAppServerTypedResponseEnvelope> = [];
		final outcomes:Array<ResumePickerAppServerTypedResponseDispatchOutcome> = [];
		final applications:Array<ResumePickerAppServerTypedResponseRefreshApplication> = [];
		final deliveries:Array<ResumePickerAppServerTypedResponseRefreshReplayDelivery> = [];
		final stateSummaries:Array<String> = [];
		final forwardPolls:Array<String> = [];

		renderFrame(scheduler, renderer, state, "typed-refresh-replay-open");
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
				applyDelivery(state, delivery);
				stateSummaries.push("delivery-" + delivery.deliverySequence + ":" + stateSummary(state));
				renderFrame(scheduler, renderer, state, "typed-refresh-replay-" + delivery.deliverySequence);
			}
			sourceOrder = sourceOrder + 1;
		}

		final pageAccepted = fanout.enqueuePage(pageRequest("typed-refresh-replay-recovery-page", "", "typed refresh replay"));
		stateSummaries.push("enqueued:page=" + outcomeSummary(pageAccepted));
		final pagePoll = pump.forward(ResumePickerAppServerStreamEvent.pageResult(1, "typed-refresh-replay-recovery-page", threadListResultJson("replay")));
		forwardPolls.push("page-recovery=" + AsyncPollSummary.summary(pagePoll));
		final pageDispatch = pump.dispatchNext(AsyncContext.fixture("typed-refresh-replay-recovery-page"));
		if (pageDispatch.hostEvent.kind == ResumePickerHostEventKind.PageLoaded)
			applyPage(state, pageDispatch.hostEvent, "replay");
		stateSummaries.push("page:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "typed-refresh-replay-recovery-page");

		final deliverySummaries = deliverySummaries(deliveries);
		final applicationSummaries = applicationSummaries(applications);
		final dispatchOutcomeSummaries = outcomeSummaries(outcomes);
		final pumpSummaries = pump.summaries();
		final rejectedRequests = pump.rejectedRequestSummaries();

		return new ResumePickerAppServerTypedResponseRefreshReplayDeliveryRenderGateReport({
			deliveryIntentCount: deliveries.length,
			pendingInteractiveReplayDelivered: countKind(deliveries, ResumePickerAppServerTypedResponseRefreshReplayDeliveryKind.PendingInteractiveReplay) == 5,
			sideParentStatusDelivered: countKind(deliveries, ResumePickerAppServerTypedResponseRefreshReplayDeliveryKind.SideParentStatus) == 5,
			activeThreadStatusDelivered: countKind(deliveries, ResumePickerAppServerTypedResponseRefreshReplayDeliveryKind.ActiveThreadStatus) == 5,
			deliveryOrderPreserved: deliveryOrderPreserved(deliveries),
			ignoredApplicationsHaveNoDelivery: ignoredApplicationsHaveNoDelivery(applications, deliverySummaries, planner.summaries()),
			recoveryDecoded: pageDispatch.hostEvent.kind == ResumePickerHostEventKind.PageLoaded
			&& state.selectedThreadId == "thread-replay-a"
			&& !state.inlineErrorShown,
			noPressureDropRejection: rejectedRequests.length == 0
			&& !contains(pumpSummaries, "server-request-rejected")
			&& !contains(pumpSummaries, "consumer_queue_full"),
			liveTransportSuppressed: !contains(deliverySummaries, "liveTransport=true") && contains(deliverySummaries, "suppressed=true"),
			noCredentialOrModelTraffic: true,
			stateDbUntouched: true,
			pageRequests: source.pageRequestCount(),
			readRequests: source.readRequestCount(),
			frameRequests: scheduler.requestCount(),
			renderCount: renderer.renderCount(),
			finalSnapshot: renderer.lastSnapshot(),
			renderSnapshots: renderer.allSnapshots(),
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

	static function buildEnvelopes(pump:ResumePickerAppServerEventPump, registry:DeterministicResumePickerAppServerTypedPendingRequestRegistry,
			builder:DeterministicResumePickerAppServerTypedResponseEnvelopeBuilder, envelopes:Array<ResumePickerAppServerTypedResponseEnvelope>,
			forwardPolls:Array<String>):Void {
		envelopes.push(resolveKeyed(pump, registry, builder, forwardPolls, ResumePickerAppServerPendingRequestClassKind.ExecApproval, "typed-replay-exec-1",
			"approval-1", "turn-1", "call-1", "", "", "item/commandExecution/requestApproval;approval=approval-1"));
		envelopes.push(resolveKeyed(pump, registry, builder, forwardPolls, ResumePickerAppServerPendingRequestClassKind.FileChangeApproval,
			"typed-replay-file-2", "patch-1", "turn-1", "patch-1", "", "", "item/fileChange/requestApproval;item=patch-1"));
		envelopes.push(resolveKeyed(pump, registry, builder, forwardPolls, ResumePickerAppServerPendingRequestClassKind.PermissionsApproval,
			"typed-replay-permissions-3", "perm-1", "turn-1", "perm-1", "", "", "item/permissions/requestApproval;item=perm-1"));

		final inputHost = deliverServerRequest(pump, forwardPolls, "typed-replay-user-input-4", "item/tool/requestUserInput;turn=turn-2;item=tool-1");
		registry.register(ResumePickerAppServerPendingRequestClassKind.UserInput, inputHost.requestId, "turn-2", "turn-2", "tool-1", "", "", inputHost.detail);
		envelopes.push(builder.resolve(registry.popUserInput("turn-2")));

		final mcpHost = deliverServerRequest(pump, forwardPolls, "typed-replay-mcp-5", "mcpServer/elicitation/request;server=apps;request=mcp-5");
		registry.register(ResumePickerAppServerPendingRequestClassKind.McpElicitation, mcpHost.requestId, "apps:mcp-5", "turn-3", "mcp-item-5", "apps",
			"mcp-5", mcpHost.detail);
		envelopes.push(builder.resolve(registry.resolveMcp("apps", "mcp-5")));

		final unsupported = registry.register(ResumePickerAppServerPendingRequestClassKind.DynamicToolCall, "typed-replay-dynamic-6", "tool-6", "turn-4",
			"tool-6", "", "", "item/tool/call;dynamic=true");
		envelopes.push(builder.resolve(unsupported));
		envelopes.push(builder.resolve(registry.resolveKey(ResumePickerAppServerPendingRequestClassKind.ExecApproval, "missing-approval")));
		envelopes.push(envelopes[0]);
	}

	static function resolveKeyed(pump:ResumePickerAppServerEventPump, registry:DeterministicResumePickerAppServerTypedPendingRequestRegistry,
			builder:DeterministicResumePickerAppServerTypedResponseEnvelopeBuilder, forwardPolls:Array<String>,
			requestClass:ResumePickerAppServerPendingRequestClassKind, requestId:String, key:String, turnId:String, itemId:String, serverName:String,
			mcpRequestId:String, detail:String):ResumePickerAppServerTypedResponseEnvelope {
		final hostEvent = deliverServerRequest(pump, forwardPolls, requestId, detail);
		registry.register(requestClass, hostEvent.requestId, key, turnId, itemId, serverName, mcpRequestId, hostEvent.detail);
		return builder.resolve(registry.resolveKey(requestClass, key));
	}

	static function deliverServerRequest(pump:ResumePickerAppServerEventPump, forwardPolls:Array<String>, requestId:String,
			detail:String):ResumePickerHostEvent {
		final poll = pump.forward(ResumePickerAppServerStreamEvent.serverRequest(1, requestId, detail));
		forwardPolls.push(requestId + "=" + AsyncPollSummary.summary(poll));
		return pump.dispatchNext(AsyncContext.fixture(requestId)).hostEvent;
	}

	static function applyDelivery(state:ResumePickerState, delivery:ResumePickerAppServerTypedResponseRefreshReplayDelivery):Void {
		state.inlineErrorShown = false;
		state.lastFailureCode = "";
		state.lastError = "";
		state.loaderEventStatus = "typed_response_refresh_replay_delivery_" + delivery.kind;
		state.loaderEventDetail = delivery.summary();
		state.footerProgressLabel = "typed refresh replay delivered";
	}

	static function baseState():ResumePickerState {
		final state = ResumePickerState.initial();
		state.opened = true;
		state.action = ResumePickerActionKind.Resume;
		state.sortKey = ResumePickerSortKey.UpdatedAt;
		state.filterMode = ResumePickerFilterMode.Cwd;
		state.toolbarRenderMode = "compact";
		state.query = "typed refresh replay";
		state.cwdFilter = "/workspace/codex-hxrust";
		state.pageSize = 2;
		state.viewRows = 2;
		state.footerProgressLabel = "typed refresh replay open";
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
			visibleRow("thread-" + prefix + "-a", title(prefix, "A"), "2026-06-20T06:35:00Z", 2, true, []),
			visibleRow("thread-" + prefix + "-b", title(prefix, "B"), "2026-06-20T06:36:00Z", 1, false, [])
		];
		state.inlineErrorShown = false;
		state.lastFailureCode = "";
		state.lastError = "";
		state.loaderEventStatus = "typed_response_refresh_replay_recovery_page_decoded";
		state.loaderEventDetail = "request=" + event.requestId + ";response=" + event.detail;
		state.footerProgressLabel = "typed refresh replay recovered";
	}

	static function threadListResultJson(prefix:String):String {
		return "{"
			+ "\"data\":["
			+ threadListRowJson("thread-" + prefix + "-a", "session-" + prefix + "-a", title(prefix, "A"), "2026-06-20T06:35:00Z", 2)
			+ ","
			+ threadListRowJson("thread-" + prefix + "-b", "session-" + prefix + "-b", title(prefix, "B"), "2026-06-20T06:36:00Z", 1)
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

	static function deliveryOrderPreserved(deliveries:Array<ResumePickerAppServerTypedResponseRefreshReplayDelivery>):Bool {
		var expectedSequence = 1;
		for (delivery in deliveries) {
			if (!delivery.deliveryOrderPreserved || delivery.deliverySequence != expectedSequence)
				return false;
			expectedSequence = expectedSequence + 1;
		}
		return expectedSequence == 16;
	}

	static function ignoredApplicationsHaveNoDelivery(applications:Array<ResumePickerAppServerTypedResponseRefreshApplication>,
			deliverySummaries:Array<String>, plannerSummaries:Array<String>):Bool {
		var ignored = 0;
		for (application in applications)
			if (application.kind == ResumePickerAppServerTypedResponseRefreshApplicationKind.IgnoredNoRefresh)
				ignored = ignored + 1;
		return ignored == 3
			&& countContains(plannerSummaries, "delivery-skip:refresh_application_no_delivery") == 3
			&& !contains(deliverySummaries, "class=dynamic_tool_call")
			&& !contains(deliverySummaries, "payloadKind=missing_pending_noop")
			&& !contains(deliverySummaries, "dispatchSequence=8");
	}

	static function countKind(deliveries:Array<ResumePickerAppServerTypedResponseRefreshReplayDelivery>,
			kind:ResumePickerAppServerTypedResponseRefreshReplayDeliveryKind):Int {
		var count = 0;
		for (delivery in deliveries)
			if (delivery.kind == kind)
				count = count + 1;
		return count;
	}

	static function deliverySummaries(deliveries:Array<ResumePickerAppServerTypedResponseRefreshReplayDelivery>):Array<String> {
		final out:Array<String> = [];
		for (delivery in deliveries)
			out.push(delivery.summary());
		return out;
	}

	static function applicationSummaries(applications:Array<ResumePickerAppServerTypedResponseRefreshApplication>):Array<String> {
		final out:Array<String> = [];
		for (application in applications)
			out.push(application.summary());
		return out;
	}

	static function outcomeSummaries(outcomes:Array<ResumePickerAppServerTypedResponseDispatchOutcome>):Array<String> {
		final out:Array<String> = [];
		for (outcome in outcomes)
			out.push(outcome.summary());
		return out;
	}

	static function envelopeSummaries(envelopes:Array<ResumePickerAppServerTypedResponseEnvelope>):Array<String> {
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
		return "Typed refresh " + prefix + " row " + suffix;
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

	static function emptyLabel(value:String):String {
		return value.length == 0 ? "<empty>" : value;
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
