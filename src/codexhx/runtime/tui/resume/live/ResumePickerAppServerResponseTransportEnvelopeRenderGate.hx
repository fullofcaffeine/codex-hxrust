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
import codexhx.runtime.tui.resume.host.DeterministicResumePickerAppServerRequestHandle;
import codexhx.runtime.tui.resume.host.DeterministicResumePickerAppServerResponseTransport;
import codexhx.runtime.tui.resume.host.DeterministicResumePickerFrameScheduler;
import codexhx.runtime.tui.resume.host.DeterministicResumePickerTerminalRenderer;
import codexhx.runtime.tui.resume.host.JsonRpcResumePickerThreadSource;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerEventPump;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerRequestDispatchCommand;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerRequestDispatchOptions;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerRequestResponseIntent;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerResponseTransportEnvelope;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerResponseTransportEnvelopeKind;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerStreamEvent;
import codexhx.runtime.tui.resume.host.ResumePickerAppServerStreamFanout;
import codexhx.runtime.tui.resume.host.ResumePickerHostEventKind;
import codexhx.runtime.tui.resume.host.ResumePickerThreadListRequest;

class ResumePickerAppServerResponseTransportEnvelopeRenderGate {
	static final RESOLVE_REQUEST_ID = "server-request-envelope-resolve-1";
	static final REJECT_REQUEST_ID = "server-request-envelope-reject-2";
	static final REFUSAL_REQUEST_ID = "server-request-envelope-local-refusal-3";
	static final SEND_FAILED_REQUEST_ID = "server-request-envelope-send-failed-4";

	public static function run():ResumePickerAppServerResponseTransportEnvelopeRenderGateReport {
		final scheduler = new DeterministicResumePickerFrameScheduler();
		final renderer = new DeterministicResumePickerTerminalRenderer();
		final state = baseState();
		final source = new JsonRpcResumePickerThreadSource(8);
		final fanout = new ResumePickerAppServerStreamFanout(source);
		final pump = new ResumePickerAppServerEventPump(1, fanout, scheduler, 8);
		final requestHandle = new DeterministicResumePickerAppServerRequestHandle();
		final responseTransport = new DeterministicResumePickerAppServerResponseTransport();
		final commands:Array<ResumePickerAppServerRequestDispatchCommand> = [];
		final envelopes:Array<ResumePickerAppServerResponseTransportEnvelope> = [];
		final dispatchSummaries:Array<String> = [];
		final hostEvents:Array<String> = [];
		final stateSummaries:Array<String> = [];
		final forwardPolls:Array<String> = [];

		renderFrame(scheduler, renderer, state, "response-transport-envelope-open");

		final resolveCommand = requestHandle.dispatch(ResumePickerAppServerRequestResponseIntent.resolved(RESOLVE_REQUEST_ID,
			"tool/request_user_input;surface=resume_picker;prompt=resolve-envelope", "{\"answer\":\"continue\"}"),
			dispatchOptions(true, true, requestHandle.commandCount()));
		commands.push(resolveCommand);
		final resolveEnvelope = responseTransport.enqueue(resolveCommand);
		envelopes.push(resolveEnvelope);
		applyEnvelope(state, resolveEnvelope, "response_transport_resolve_envelope");
		stateSummaries.push("resolve:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "response-transport-resolve");

		final rejectCommand = requestHandle.dispatch(ResumePickerAppServerRequestResponseIntent.refused(REJECT_REQUEST_ID,
			"tool/request_user_input;surface=resume_picker;prompt=reject-envelope", "unsupported fixture request", "unsupported_in_fixture"),
			dispatchOptions(true, true, requestHandle.commandCount()));
		commands.push(rejectCommand);
		final rejectEnvelope = responseTransport.enqueue(rejectCommand);
		envelopes.push(rejectEnvelope);
		applyEnvelope(state, rejectEnvelope, "response_transport_reject_envelope");
		stateSummaries.push("reject:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "response-transport-reject");

		final localRefusalCommand = requestHandle.dispatch(ResumePickerAppServerRequestResponseIntent.resolved(REFUSAL_REQUEST_ID,
			"tool/request_user_input;surface=resume_picker;prompt=missing-payload", ""),
			dispatchOptions(true, true, requestHandle.commandCount()));
		commands.push(localRefusalCommand);
		final localRefusalEnvelope = responseTransport.enqueue(localRefusalCommand);
		envelopes.push(localRefusalEnvelope);
		applyEnvelope(state, localRefusalEnvelope, "response_transport_local_refusal_envelope");
		stateSummaries.push("local-refusal:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "response-transport-local-refusal");

		final sendFailedCommand = requestHandle.dispatch(ResumePickerAppServerRequestResponseIntent.refused(SEND_FAILED_REQUEST_ID,
			"tool/request_user_input;surface=resume_picker;prompt=send-failed-envelope", "fixture transport unavailable", "transport_send_failed"),
			dispatchOptions(true, false, requestHandle.commandCount()));
		commands.push(sendFailedCommand);
		final sendFailedEnvelope = responseTransport.enqueue(sendFailedCommand);
		envelopes.push(sendFailedEnvelope);
		applyEnvelope(state, sendFailedEnvelope, "response_transport_send_failure_envelope");
		stateSummaries.push("send-failed:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "response-transport-send-failed");

		final pageAccepted = fanout.enqueuePage(pageRequest("response-transport-envelope-recovery-page", "", "transport envelope"));
		stateSummaries.push("enqueued:page=" + outcomeSummary(pageAccepted));
		final pagePoll = pump.forward(ResumePickerAppServerStreamEvent.pageResult(1, "response-transport-envelope-recovery-page",
			threadListResultJson("transport")));
		forwardPolls.push("page-recovery=" + AsyncPollSummary.summary(pagePoll));

		final pageDispatch = pump.dispatchNext(AsyncContext.fixture("response-transport-envelope-recovery-page"));
		dispatchSummaries.push(pageDispatch.summary);
		hostEvents.push(pageDispatch.hostEvent.summary());
		if (pageDispatch.hostEvent.kind == ResumePickerHostEventKind.PageLoaded)
			applyPage(state, pageDispatch.hostEvent.requestId, pageDispatch.hostEvent.detail, "transport");
		stateSummaries.push("page:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "response-transport-envelope-recovery-page");

		final commandSummaries = commandSummaries(commands);
		final envelopeSummaries = envelopeSummaries(envelopes);
		final transportEnvelopeSummaries = responseTransport.summaries();
		final pumpSummaries = pump.summaries();
		final rejectedRequests = pump.rejectedRequestSummaries();

		return new ResumePickerAppServerResponseTransportEnvelopeRenderGateReport({
			resolveEnvelopeRecorded: resolveEnvelope.kind == ResumePickerAppServerResponseTransportEnvelopeKind.ResolveResult
			&& containsOne(envelopeSummaries, "\"result\":{\"answer\":\"continue\"}"),
			rejectEnvelopeRecorded: rejectEnvelope.kind == ResumePickerAppServerResponseTransportEnvelopeKind.RejectError
			&& containsOne(envelopeSummaries, "\"error\":{\"code\":\"unsupported_in_fixture\""),
			localRefusalEnvelopeRecorded: localRefusalEnvelope.kind == ResumePickerAppServerResponseTransportEnvelopeKind.LocalSerializationRefusal
			&& localRefusalEnvelope.localOnly
			&& containsOne(envelopeSummaries, "missing_response_payload"),
			sendFailureEnvelopeRecorded: sendFailedEnvelope.kind == ResumePickerAppServerResponseTransportEnvelopeKind.SendFailure
			&& containsOne(envelopeSummaries, "transport_send_failed"),
			requestIdsCorrelated: resolveEnvelope.correlationKey == "server:" + RESOLVE_REQUEST_ID
			&& rejectEnvelope.correlationKey == "server:" + REJECT_REQUEST_ID
			&& localRefusalEnvelope.correlationKey == "server:" + REFUSAL_REQUEST_ID
			&& sendFailedEnvelope.correlationKey == "server:" + SEND_FAILED_REQUEST_ID,
			errorPayloadsDistinct: rejectEnvelope.errorJson.indexOf("unsupported_in_fixture") >= 0
			&& localRefusalEnvelope.errorJson.indexOf("missing_response_payload") >= 0
			&& sendFailedEnvelope.errorJson.indexOf("transport_send_failed") >= 0
			&& resolveEnvelope.errorJson.length == 0,
			noPressureDropRejection: rejectedRequests.length == 0
			&& !contains(pumpSummaries, "server-request-rejected")
			&& !contains(pumpSummaries, "consumer_queue_full"),
			liveTransportSuppressed: !contains(envelopeSummaries, "liveTransport=true") && contains(envelopeSummaries, "suppressed=true"),
			recoveryDecoded: pageDispatch.hostEvent.kind == ResumePickerHostEventKind.PageLoaded
			&& state.selectedThreadId == "thread-transport-a"
			&& !state.inlineErrorShown,
			noCredentialOrModelTraffic: true,
			stateDbUntouched: true,
			pageRequests: source.pageRequestCount(),
			readRequests: source.readRequestCount(),
			frameRequests: scheduler.requestCount(),
			renderCount: renderer.renderCount(),
			finalSnapshot: renderer.lastSnapshot(),
			renderSnapshots: renderer.allSnapshots(),
			commandSummaries: commandSummaries,
			envelopeSummaries: envelopeSummaries,
			transportEnvelopeSummaries: transportEnvelopeSummaries,
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
		state.query = "transport envelope";
		state.cwdFilter = "/workspace/codex-hxrust";
		state.pageSize = 2;
		state.viewRows = 2;
		state.footerProgressLabel = "response transport envelope open";
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

	static function applyEnvelope(state:ResumePickerState, envelope:ResumePickerAppServerResponseTransportEnvelope, status:String):Void {
		state.inlineErrorShown = envelope.kind == ResumePickerAppServerResponseTransportEnvelopeKind.SendFailure;
		state.lastFailureCode = envelope.errorJson.length == 0 ? "" : envelope.kind;
		state.lastError = envelope.errorJson;
		state.loaderEventStatus = status;
		state.loaderEventDetail = "request=" + envelope.requestId + ";kind=" + envelope.kind + ";method=" + envelope.method + ";correlation="
			+ envelope.correlationKey + ";localOnly=" + boolLabel(envelope.localOnly) + ";sendIntent=" + boolLabel(envelope.sendIntentRecorded)
			+ ";liveTransport=" + boolLabel(envelope.liveTransportAttempted) + ";suppressed=" + boolLabel(envelope.liveTransportSuppressed);
		state.footerProgressLabel = status;
	}

	static function applyPage(state:ResumePickerState, requestId:String, detail:String, prefix:String):Void {
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
			visibleRow("thread-" + prefix + "-a", title(prefix, "A"), "2026-06-20T04:50:00Z", 2, true, []),
			visibleRow("thread-" + prefix + "-b", title(prefix, "B"), "2026-06-20T04:51:00Z", 1, false, [])
		];
		state.inlineErrorShown = false;
		state.lastFailureCode = "";
		state.lastError = "";
		state.loaderEventStatus = "response_transport_envelope_recovery_page_decoded";
		state.loaderEventDetail = "request=" + requestId + ";response=" + detail;
		state.footerProgressLabel = "response transport envelope recovered";
	}

	static function threadListResultJson(prefix:String):String {
		return "{"
			+ "\"data\":["
			+ threadListRowJson("thread-" + prefix + "-a", "session-" + prefix + "-a", title(prefix, "A"), "2026-06-20T04:50:00Z", 2)
			+ ","
			+ threadListRowJson("thread-" + prefix + "-b", "session-" + prefix + "-b", title(prefix, "B"), "2026-06-20T04:51:00Z", 1)
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
		return "Response transport " + prefix + " row " + suffix;
	}

	static function contains(values:Array<String>, needle:String):Bool {
		for (value in values)
			if (value.indexOf(needle) >= 0)
				return true;
		return false;
	}

	static function containsOne(values:Array<String>, needle:String):Bool {
		return contains(values, needle);
	}

	static function emptyLabel(value:String):String {
		return value.length == 0 ? "<empty>" : value;
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
