package codexhx.validation.tui.resume.live;

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
import codexhx.runtime.tui.resume.host.DeterministicFrameScheduler;
import codexhx.runtime.tui.resume.host.DeterministicTerminalRenderer;
import codexhx.runtime.tui.resume.host.JsonRpcThreadSource;
import codexhx.runtime.tui.resume.host.EventPump;
import codexhx.runtime.tui.resume.host.RequestResponseIntent;
import codexhx.runtime.tui.resume.host.RequestResponseIntentKind;
import codexhx.runtime.tui.resume.host.StreamEvent;
import codexhx.runtime.tui.resume.host.StreamFanout;
import codexhx.runtime.tui.resume.host.ResumePickerHostEvent;
import codexhx.runtime.tui.resume.host.ResumePickerHostEventKind;
import codexhx.runtime.tui.resume.host.ResumePickerThreadListRequest;

class AppServerServerRequestDeliveryGate {
	static final SERVER_REQUEST_ID = "server-request-delivery-1";

	public static function run():AppServerServerRequestDeliveryReport {
		final scheduler = new DeterministicFrameScheduler();
		final renderer = new DeterministicTerminalRenderer();
		final state = baseState();
		final source = new JsonRpcThreadSource(8);
		final fanout = new StreamFanout(source);
		final pump = new EventPump(1, fanout, scheduler, 4);
		final dispatchSummaries:Array<String> = [];
		final hostEvents:Array<String> = [];
		final stateSummaries:Array<String> = [];
		final forwardPolls:Array<String> = [];
		final responseIntents:Array<RequestResponseIntent> = [];

		renderFrame(scheduler, renderer, state, "server-request-delivery-open");

		final requestDetail = "tool/request_user_input;surface=resume_picker;prompt=confirm-resume";
		final serverPoll = pump.forward(StreamEvent.serverRequest(1, SERVER_REQUEST_ID, requestDetail));
		forwardPolls.push("server-request=" + AsyncPollSummary.summary(serverPoll));

		final serverDispatch = pump.dispatchNext(AsyncContext.fixture("server-request-delivery"));
		dispatchSummaries.push(serverDispatch.summary);
		hostEvents.push(serverDispatch.hostEvent.summary());
		final intent = RequestResponseIntent.refused(serverDispatch.hostEvent.requestId, serverDispatch.hostEvent.detail,
			"resume_picker_fixture_has_no_interactive_bottom_pane", "unsupported_in_fixture");
		responseIntents.push(intent);
		applyServerRequestDelivery(state, serverDispatch.hostEvent, intent);
		stateSummaries.push("server-request:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "server-request-delivered");

		final pageAccepted = fanout.enqueuePage(pageRequest("server-request-recovery-page", "", "delivery"));
		stateSummaries.push("enqueued:page=" + outcomeSummary(pageAccepted));
		final pagePoll = pump.forward(StreamEvent.pageResult(1, "server-request-recovery-page", threadListResultJson("delivery")));
		forwardPolls.push("page-recovery=" + AsyncPollSummary.summary(pagePoll));

		final pageDispatch = pump.dispatchNext(AsyncContext.fixture("server-request-recovery-page"));
		dispatchSummaries.push(pageDispatch.summary);
		hostEvents.push(pageDispatch.hostEvent.summary());
		if (pageDispatch.hostEvent.kind == ResumePickerHostEventKind.PageLoaded)
			applyPage(state, pageDispatch.hostEvent, "delivery");
		stateSummaries.push("page:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "server-request-recovery-page");

		final pumpSummaries = pump.summaries();
		final rejectedRequests = pump.rejectedRequestSummaries();
		final fanoutSummaries = fanout.fanoutSummaries();
		final requestSummaries = fanout.requestSummaries();
		final transportSummaries = fanout.transportSummaries();
		final responseIntentSummaries = responseIntentSummaries(responseIntents);

		return new AppServerServerRequestDeliveryReport({
			serverRequestTyped: serverDispatch.hostEvent.kind == ResumePickerHostEventKind.ServerRequestDelivered
			&& contains(pumpSummaries, "forward:generation=1;kind=server_request")
			&& contains(forwardPolls, "server-request=kind=ready"),
			serverRequestDelivered: serverDispatch.hostEvent.kind == ResumePickerHostEventKind.ServerRequestDelivered
			&& serverDispatch.hostEvent.requestId == SERVER_REQUEST_ID
			&& contains(hostEvents, "kind=server_request_delivered"),
			deliveryNotDropped: rejectedRequests.length == 0
			&& pump.skippedBestEffortEvents() == 0
			&& !contains(pumpSummaries, "server-request-rejected"),
			responseIntentRecorded: intent.kind == RequestResponseIntentKind.Refused
			&& contains(responseIntentSummaries, "request=" + SERVER_REQUEST_ID)
			&& contains(responseIntentSummaries, "failure=unsupported_in_fixture"),
			recoveryDecoded: pageDispatch.hostEvent.kind == ResumePickerHostEventKind.PageLoaded
			&& state.selectedThreadId == "thread-delivery-a"
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

	static function baseState():ResumePickerState {
		final state = ResumePickerState.initial();
		state.opened = true;
		state.action = ResumePickerActionKind.Resume;
		state.sortKey = ResumePickerSortKey.UpdatedAt;
		state.filterMode = ResumePickerFilterMode.Cwd;
		state.toolbarRenderMode = "compact";
		state.query = "delivery";
		state.cwdFilter = "/workspace/codex-hxrust";
		state.pageSize = 2;
		state.viewRows = 2;
		state.footerProgressLabel = "server request delivery open";
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

	static function applyServerRequestDelivery(state:ResumePickerState, event:ResumePickerHostEvent, intent:RequestResponseIntent):Void {
		state.inlineErrorShown = false;
		state.lastFailureCode = "";
		state.lastError = "";
		state.loaderEventStatus = "server_request_delivered";
		state.loaderEventDetail = "request=" + event.requestId + ";kind=" + event.kind + ";detail=" + event.detail + ";intent=" + intent.kind + ";reason="
			+ intent.reason;
		state.footerProgressLabel = "server request refused in fixture";
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
			visibleRow("thread-" + prefix + "-a", title(prefix, "A"), "2026-06-19T23:52:00Z", 2, true, []),
			visibleRow("thread-" + prefix + "-b", title(prefix, "B"), "2026-06-19T23:53:00Z", 1, false, [])
		];
		state.inlineErrorShown = false;
		state.lastFailureCode = "";
		state.lastError = "";
		state.loaderEventStatus = "server_request_recovery_page_decoded";
		state.loaderEventDetail = "request=" + event.requestId + ";response=" + event.detail;
		state.footerProgressLabel = "server request delivery recovered";
	}

	static function threadListResultJson(prefix:String):String {
		return "{"
			+ "\"data\":["
			+ threadListRowJson("thread-" + prefix + "-a", "session-" + prefix + "-a", title(prefix, "A"), "2026-06-19T23:52:00Z", 2)
			+ ","
			+ threadListRowJson("thread-" + prefix + "-b", "session-" + prefix + "-b", title(prefix, "B"), "2026-06-19T23:53:00Z", 1)
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

	static function stateSummary(state:ResumePickerState):String {
		return ResumePickerGateDiagnostics.inlineErrorState(state);
	}

	static function outcomeSummary(outcome:RuntimeClientOutcome):String {
		return ResumePickerGateDiagnostics.runtimeClientOutcome(outcome);
	}

	static function title(prefix:String, suffix:String):String {
		return "Server request " + prefix + " row " + suffix;
	}

	static function contains(values:Array<String>, needle:String):Bool {
		for (value in values)
			if (value.indexOf(needle) >= 0)
				return true;
		return false;
	}
}
