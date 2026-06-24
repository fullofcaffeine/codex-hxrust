package codexhx.validation.tui.resume.live;

import codexhx.protocol.json.CodexJson;
import codexhx.runtime.asyncruntime.AsyncContext;
import codexhx.runtime.asyncruntime.AsyncPollSummary;
import codexhx.runtime.app.RuntimeClientOutcome;
import codexhx.runtime.diagnostics.DiagnosticSummary;
import codexhx.runtime.tui.resume.ResumePickerActionKind;
import codexhx.runtime.tui.resume.ResumePickerFilterMode;
import codexhx.runtime.tui.resume.ResumePickerSortKey;
import codexhx.runtime.tui.resume.ResumePickerState;
import codexhx.runtime.tui.resume.ResumePickerVisibleRow;
import codexhx.runtime.tui.resume.host.DeterministicRequestHandle;
import codexhx.runtime.tui.resume.host.DeterministicFrameScheduler;
import codexhx.runtime.tui.resume.host.DeterministicTerminalRenderer;
import codexhx.runtime.tui.resume.host.JsonRpcThreadSource;
import codexhx.runtime.tui.resume.host.EventPump;
import codexhx.runtime.tui.resume.host.RequestDispatchCommand;
import codexhx.runtime.tui.resume.host.RequestDispatchCommandKind;
import codexhx.runtime.tui.resume.host.RequestDispatchOptions;
import codexhx.runtime.tui.resume.host.RequestResponseIntent;
import codexhx.runtime.tui.resume.host.StreamEvent;
import codexhx.runtime.tui.resume.host.StreamFanout;
import codexhx.runtime.tui.resume.host.ResumePickerHostEvent;
import codexhx.runtime.tui.resume.host.ResumePickerHostEventKind;
import codexhx.runtime.tui.resume.host.ResumePickerThreadListRequest;
import codexhx.validation.tui.resume.live.ResumePickerGateDiagnostics;

class AppServerResponseDispatchIntentGate {
	static final REFUSED_REQUEST_ID = "server-request-dispatch-refused-1";
	static final RESOLVED_REQUEST_ID = "server-request-dispatch-resolved-2";

	public static function run():AppServerResponseDispatchIntentReport {
		final scheduler = new DeterministicFrameScheduler();
		final renderer = new DeterministicTerminalRenderer();
		final state = baseState();
		final source = new JsonRpcThreadSource(8);
		final fanout = new StreamFanout(source);
		final pump = new EventPump(1, fanout, scheduler, 6);
		final requestHandle = new DeterministicRequestHandle();
		final dispatchSummaries:Array<String> = [];
		final hostEvents:Array<String> = [];
		final stateSummaries:Array<String> = [];
		final forwardPolls:Array<String> = [];
		final responseIntents:Array<RequestResponseIntent> = [];
		final dispatchCommands:Array<RequestDispatchCommand> = [];

		renderFrame(scheduler, renderer, state, "response-dispatch-open");

		final refusedEvent = deliverServerRequest(pump, dispatchSummaries, hostEvents, forwardPolls, REFUSED_REQUEST_ID,
			"tool/request_user_input;surface=resume_picker;prompt=unsupported-fixture");
		final refusedIntent = RequestResponseIntent.refused(refusedEvent.requestId, refusedEvent.detail,
			"resume_picker_fixture_has_no_interactive_bottom_pane", "unsupported_in_fixture");
		responseIntents.push(refusedIntent);
		final refusedCommand = requestHandle.dispatch(refusedIntent, dispatchOptions(true, true, requestHandle.commandCount()));
		dispatchCommands.push(refusedCommand);
		applyResponseDispatch(state, refusedEvent, refusedCommand, "response_dispatch_refused");
		stateSummaries.push("refused:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "response-dispatch-refused");

		final resolvedEvent = deliverServerRequest(pump, dispatchSummaries, hostEvents, forwardPolls, RESOLVED_REQUEST_ID,
			"tool/request_user_input;surface=resume_picker;prompt=fixture-answer");
		final resolvedIntent = RequestResponseIntent.resolved(resolvedEvent.requestId, resolvedEvent.detail, "{\"answer\":\"continue\"}");
		responseIntents.push(resolvedIntent);
		final resolvedCommand = requestHandle.dispatch(resolvedIntent, dispatchOptions(true, true, requestHandle.commandCount()));
		dispatchCommands.push(resolvedCommand);
		applyResponseDispatch(state, resolvedEvent, resolvedCommand, "response_dispatch_resolved");
		stateSummaries.push("resolved:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "response-dispatch-resolved");

		final pageAccepted = fanout.enqueuePage(pageRequest("response-dispatch-recovery-page", "", "dispatch"));
		stateSummaries.push("enqueued:page=" + outcomeSummary(pageAccepted));
		final pagePoll = pump.forward(StreamEvent.pageResult(1, "response-dispatch-recovery-page", threadListResultJson("dispatch")));
		forwardPolls.push("page-recovery=" + AsyncPollSummary.summary(pagePoll));

		final pageDispatch = pump.dispatchNext(AsyncContext.fixture("response-dispatch-recovery-page"));
		dispatchSummaries.push(pageDispatch.summary);
		hostEvents.push(pageDispatch.hostEvent.summary());
		if (pageDispatch.hostEvent.kind == ResumePickerHostEventKind.PageLoaded)
			applyPage(state, pageDispatch.hostEvent, "dispatch");
		stateSummaries.push("page:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "response-dispatch-recovery-page");

		final pumpSummaries = pump.summaries();
		final rejectedRequests = pump.rejectedRequestSummaries();
		final fanoutSummaries = fanout.fanoutSummaries();
		final requestSummaries = fanout.requestSummaries();
		final transportSummaries = fanout.transportSummaries();
		final responseIntentSummaries = responseIntentSummaries(responseIntents);
		final commandSummaries = commandSummaries(dispatchCommands);
		final requestHandleSummaries = requestHandle.summaries();

		return new AppServerResponseDispatchIntentReport({
			deliveredRequestsMatched: refusedEvent.kind == ResumePickerHostEventKind.ServerRequestDelivered
			&& resolvedEvent.kind == ResumePickerHostEventKind.ServerRequestDelivered
			&& refusedCommand.requestId == REFUSED_REQUEST_ID
			&& resolvedCommand.requestId == RESOLVED_REQUEST_ID,
			dispatchCommandsTyped: refusedCommand.kind == RequestDispatchCommandKind.RejectServerRequest
			&& resolvedCommand.kind == RequestDispatchCommandKind.ResolveServerRequest,
			responseOrderingPreserved: refusedCommand.orderIndex == 1
			&& resolvedCommand.orderIndex == 2
			&& contains(commandSummaries, "order=1")
			&& contains(commandSummaries, "order=2"),
			unsupportedRefusalDistinctFromPressureDrop: rejectedRequests.length == 0
			&& !contains(pumpSummaries, "server-request-rejected")
			&& contains(commandSummaries, "kind=reject_server_request")
			&& contains(commandSummaries, "unsupported_in_fixture"),
			liveTransportSuppressed: !contains(commandSummaries, "liveTransport=true") && contains(commandSummaries, "suppressed=true"),
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
			responseIntentSummaries: responseIntentSummaries,
			dispatchCommandSummaries: commandSummaries,
			requestHandleSummaries: requestHandleSummaries,
			requestSummaries: requestSummaries,
			transportSummaries: transportSummaries,
			dispatchSummaries: dispatchSummaries,
			pumpSummaries: pumpSummaries,
			rejectedRequestSummaries: rejectedRequests,
			fanoutSummaries: fanoutSummaries,
			hostEventSummaries: hostEvents,
			stateSummaries: stateSummaries,
			forwardPollSummaries: forwardPolls
		});
	}

	static function deliverServerRequest(pump:EventPump, dispatchSummaries:Array<String>, hostEvents:Array<String>, forwardPolls:Array<String>,
			requestId:String, detail:String):ResumePickerHostEvent {
		final serverPoll = pump.forward(StreamEvent.serverRequest(1, requestId, detail));
		forwardPolls.push(requestId + "=" + AsyncPollSummary.summary(serverPoll));
		final dispatch = pump.dispatchNext(AsyncContext.fixture(requestId));
		dispatchSummaries.push(dispatch.summary);
		hostEvents.push(dispatch.hostEvent.summary());
		return dispatch.hostEvent;
	}

	static function dispatchOptions(appServerSessionAvailable:Bool, transportSendSucceeds:Bool, previousDispatchCount:Int):RequestDispatchOptions {
		return new RequestDispatchOptions({
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
		state.query = "dispatch";
		state.cwdFilter = "/workspace/codex-hxrust";
		state.pageSize = 2;
		state.viewRows = 2;
		state.footerProgressLabel = "response dispatch open";
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

	static function applyResponseDispatch(state:ResumePickerState, event:ResumePickerHostEvent, command:RequestDispatchCommand, status:String):Void {
		state.inlineErrorShown = false;
		state.lastFailureCode = "";
		state.lastError = "";
		state.loaderEventStatus = status;
		state.loaderEventDetail = DiagnosticSummary.render([
			DiagnosticSummary.text("request", event.requestId),
			DiagnosticSummary.enumValue("hostKind", Std.string(event.kind)),
			DiagnosticSummary.enumValue("command", Std.string(command.kind)),
			DiagnosticSummary.intValue("order", command.orderIndex),
			DiagnosticSummary.boolValue("liveTransport", command.liveTransportAttempted),
			DiagnosticSummary.boolValue("suppressed", command.liveTransportSuppressed)
		]);
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
			visibleRow("thread-" + prefix + "-a", title(prefix, "A"), "2026-06-20T04:30:00Z", 2, true, []),
			visibleRow("thread-" + prefix + "-b", title(prefix, "B"), "2026-06-20T04:31:00Z", 1, false, [])
		];
		state.inlineErrorShown = false;
		state.lastFailureCode = "";
		state.lastError = "";
		state.loaderEventStatus = "response_dispatch_recovery_page_decoded";
		state.loaderEventDetail = "request=" + event.requestId + ";response=" + event.detail;
		state.footerProgressLabel = "response dispatch recovered";
	}

	static function threadListResultJson(prefix:String):String {
		return "{"
			+ "\"data\":["
			+ threadListRowJson("thread-" + prefix + "-a", "session-" + prefix + "-a", title(prefix, "A"), "2026-06-20T04:30:00Z", 2)
			+ ","
			+ threadListRowJson("thread-" + prefix + "-b", "session-" + prefix + "-b", title(prefix, "B"), "2026-06-20T04:31:00Z", 1)
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

	static function responseIntentSummaries(intents:Array<RequestResponseIntent>):Array<String> {
		final out:Array<String> = [];
		for (intent in intents)
			out.push(intent.summary());
		return out;
	}

	static function commandSummaries(commands:Array<RequestDispatchCommand>):Array<String> {
		final out:Array<String> = [];
		for (command in commands)
			out.push(command.summary());
		return out;
	}

	static function stateSummary(state:ResumePickerState):String {
		return ResumePickerGateDiagnostics.inlineErrorState(state);
	}

	static function outcomeSummary(outcome:RuntimeClientOutcome):String {
		return ResumePickerGateDiagnostics.runtimeClientOutcome(outcome);
	}

	static function title(prefix:String, suffix:String):String {
		return "Response dispatch " + prefix + " row " + suffix;
	}

	static function contains(values:Array<String>, needle:String):Bool {
		for (value in values)
			if (value.indexOf(needle) >= 0)
				return true;
		return false;
	}
}
