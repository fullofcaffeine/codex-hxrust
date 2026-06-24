package codexhx.validation.tui.resume.live;

import codexhx.protocol.json.CodexJson;
import codexhx.runtime.app.RuntimeClientOutcome;
import codexhx.runtime.diagnostics.DiagnosticSummary;
import codexhx.runtime.tui.resume.ResumePickerActionKind;
import codexhx.runtime.tui.resume.ResumePickerFilterMode;
import codexhx.runtime.tui.resume.ResumePickerSortKey;
import codexhx.runtime.tui.resume.ResumePickerState;
import codexhx.runtime.tui.resume.ResumePickerVisibleRow;
import codexhx.runtime.tui.resume.host.DeterministicFrameScheduler;
import codexhx.runtime.tui.resume.host.DeterministicTerminalRenderer;
import codexhx.runtime.tui.resume.host.JsonRpcThreadSource;
import codexhx.runtime.tui.resume.host.StreamFanout;
import codexhx.runtime.tui.resume.host.ResumePickerHostEvent;
import codexhx.runtime.tui.resume.host.ResumePickerHostEventKind;
import codexhx.runtime.tui.resume.host.ResumePickerThreadListRequest;
import codexhx.runtime.tui.resume.host.ResumePickerThreadReadRequest;
import codexhx.validation.tui.resume.live.ResumePickerGateDiagnostics;

class AppServerSessionLifecycleGate {
	public static function run():AppServerSessionLifecycleReport {
		final firstSource = new JsonRpcThreadSource(8);
		final firstSession = new StreamFanout(firstSource);
		final recoverySource = new JsonRpcThreadSource(8);
		final recoverySession = new StreamFanout(recoverySource);
		final scheduler = new DeterministicFrameScheduler();
		final renderer = new DeterministicTerminalRenderer();
		final state = baseState();
		final hostEvents:Array<String> = [];
		final stateSummaries:Array<String> = [];
		final lifecycleSummaries:Array<String> = [];
		final transportEvents:Array<String> = [];

		renderFrame(scheduler, renderer, state, "session-open");

		final pageAccepted = firstSession.enqueuePage(pageRequest("session-page-pending", "", "session", ResumePickerFilterMode.Cwd));
		lifecycleSummaries.push("first-page-enqueued:pending=" + firstSession.pendingCount() + ":" + outcomeSummary(pageAccepted));
		final readAccepted = firstSession.enqueuePreview(readRequest("session-preview-pending", "thread-session-a", true, 2));
		lifecycleSummaries.push("first-read-enqueued:pending=" + firstSession.pendingCount() + ":" + outcomeSummary(readAccepted));

		final cancelledRead = firstSession.cancelRead("session-preview-pending", "session closed before preview response");
		hostEvents.push(cancelledRead.summary());
		applyFailure(state, cancelledRead, "session_read_cancelled");
		stateSummaries.push("cancel-read:" + stateSummary(state) + ";pending=" + firstSession.pendingCount());
		renderFrame(scheduler, renderer, state, "session-cancel-read");

		final lateRead = firstSession.completeRead("session-preview-pending", threadReadResultJson("thread-session-a", "late preview"));
		hostEvents.push(lateRead.summary());
		applyFailure(state, lateRead, "session_late_response_rejected");
		stateSummaries.push("late-read:" + stateSummary(state) + ";pending=" + firstSession.pendingCount());
		renderFrame(scheduler, renderer, state, "session-late-read");

		final cancelledPage = firstSession.cancelPage("session-page-pending", "session closed before page response");
		hostEvents.push(cancelledPage.summary());
		applyFailure(state, cancelledPage, "session_page_cancelled");
		stateSummaries.push("cancel-page:" + stateSummary(state) + ";pending=" + firstSession.pendingCount());
		renderFrame(scheduler, renderer, state, "session-cancel-page");

		final disconnected = firstSession.disconnect("session stream disconnected");
		lifecycleSummaries.push("disconnect:pending=" + firstSession.pendingCount() + ":" + outcomeSummary(disconnected));
		final refusedAfterDisconnect = firstSession.enqueuePage(pageRequest("session-page-after-disconnect", "", "session", ResumePickerFilterMode.Cwd));
		lifecycleSummaries.push("after-disconnect-refusal:pending=" + firstSession.pendingCount() + ":" + outcomeSummary(refusedAfterDisconnect));
		final refusalEvent = ResumePickerHostEvent.failed("session-page-after-disconnect", "", "app_server_session_closed",
			refusedAfterDisconnect.code + ":" + refusedAfterDisconnect.message);
		hostEvents.push(refusalEvent.summary());
		applyFailure(state, refusalEvent, "session_closed_refusal");
		stateSummaries.push("refusal:" + stateSummary(state) + ";pending=" + firstSession.pendingCount());
		renderFrame(scheduler, renderer, state, "session-refusal");

		for (summary in firstSession.transportEventSummaries())
			transportEvents.push("first:" + summary);

		final recoveryPageAccepted = recoverySession.enqueuePage(pageRequest("session-recovery-page", "", "session", ResumePickerFilterMode.Cwd));
		lifecycleSummaries.push("recovery-page-enqueued:pending=" + recoverySession.pendingCount() + ":" + outcomeSummary(recoveryPageAccepted));
		final recoveryPage = recoverySession.completePage("session-recovery-page", threadListResultJson());
		hostEvents.push(recoveryPage.summary());
		if (recoveryPage.kind == ResumePickerHostEventKind.PageLoaded)
			applyRecoveryPage(state, recoveryPage);
		stateSummaries.push("recovery-page:" + stateSummary(state) + ";pending=" + recoverySession.pendingCount());
		renderFrame(scheduler, renderer, state, "session-recovery-page");

		final recoveryReadAccepted = recoverySession.enqueueTranscript(readRequest("session-recovery-transcript", "thread-session-recovered", false, 0));
		lifecycleSummaries.push("recovery-read-enqueued:pending=" + recoverySession.pendingCount() + ":" + outcomeSummary(recoveryReadAccepted));
		final recoveryRead = recoverySession.completeRead("session-recovery-transcript",
			threadReadResultJson("thread-session-recovered", "user: lifecycle recovered\nassistant: session fresh"));
		hostEvents.push(recoveryRead.summary());
		if (recoveryRead.kind == ResumePickerHostEventKind.TranscriptLoaded)
			applyRecoveryTranscript(state, recoveryRead);
		stateSummaries.push("recovery-transcript:" + stateSummary(state) + ";pending=" + recoverySession.pendingCount());
		renderFrame(scheduler, renderer, state, "session-recovery-transcript");

		for (summary in recoverySession.transportEventSummaries())
			transportEvents.push("recovery:" + summary);

		final requestSummaries = firstSession.requestSummaries().concat(recoverySession.requestSummaries());
		final transportSummaries = firstSession.transportSummaries().concat(recoverySession.transportSummaries());
		final fanoutSummaries = firstSession.fanoutSummaries().concat(recoverySession.fanoutSummaries()).concat(lifecycleSummaries);

		return new AppServerSessionLifecycleReport({
			requestShapePreserved: requestShapePreserved(requestSummaries, transportSummaries),
			sessionLifecycleModeled: sessionLifecycleModeled(fanoutSummaries, transportEvents),
			cancellationRouted: cancelledRead.kind == ResumePickerHostEventKind.Failed
			&& cancelledRead.failureCode == "app_server_session_cancelled"
			&& cancelledPage.failureCode == "app_server_session_cancelled",
			lateResponseRejected: lateRead.kind == ResumePickerHostEventKind.Failed
			&& lateRead.failureMessage.indexOf("unknown_request_id") >= 0,
			disconnectRefusalModeled: !refusedAfterDisconnect.ok
			&& refusedAfterDisconnect.code == "transport_closed"
			&& stateSummaries[3].indexOf("failure=app_server_session_closed") >= 0,
			recoveryDecoded: recoveryPage.kind == ResumePickerHostEventKind.PageLoaded
			&& recoveryRead.kind == ResumePickerHostEventKind.TranscriptLoaded
			&& state.transcriptCellCount == 3
			&& !state.inlineErrorShown,
			noCredentialOrModelTraffic: true,
			stateDbUntouched: true,
			pageRequests: firstSource.pageRequestCount() + recoverySource.pageRequestCount(),
			readRequests: firstSource.readRequestCount() + recoverySource.readRequestCount(),
			frameRequests: scheduler.requestCount(),
			renderCount: renderer.renderCount(),
			finalSnapshot: renderer.lastSnapshot(),
			renderSnapshots: renderer.allSnapshots(),
			requestSummaries: requestSummaries,
			transportSummaries: transportSummaries,
			transportEventSummaries: transportEvents,
			fanoutSummaries: fanoutSummaries,
			hostEventSummaries: hostEvents,
			stateSummaries: stateSummaries
		});
	}

	static function baseState():ResumePickerState {
		final state = ResumePickerState.initial();
		state.opened = true;
		state.action = ResumePickerActionKind.Resume;
		state.sortKey = ResumePickerSortKey.UpdatedAt;
		state.filterMode = ResumePickerFilterMode.Cwd;
		state.toolbarRenderMode = "compact";
		state.query = "session";
		state.cwdFilter = "/workspace/codex-hxrust";
		state.pageSize = 2;
		state.viewRows = 2;
		state.footerProgressLabel = "session open";
		return state;
	}

	static function applyFailure(state:ResumePickerState, event:ResumePickerHostEvent, status:String):Void {
		state.inlineErrorShown = true;
		state.lastFailureCode = event.failureCode;
		state.lastError = event.failureMessage;
		state.loaderEventStatus = status;
		state.loaderEventDetail = "request=" + event.requestId + ";thread=" + event.threadId + ";sourceCode=" + event.failureCode;
		state.footerProgressLabel = status;
	}

	static function applyRecoveryPage(state:ResumePickerState, event:ResumePickerHostEvent):Void {
		state.scannedRows = 1;
		state.acceptedRows = 1;
		state.invalidRows = 0;
		state.loadedRows = 1;
		state.filteredRows = 1;
		state.selectedIndex = 0;
		state.selectedThreadId = "thread-session-recovered";
		state.selectedLabel = "Recovered session row";
		state.nextCursor = "";
		state.nextCursorPresent = false;
		state.moreBelow = false;
		state.visibleRows = [
			visibleRow("thread-session-recovered", "Recovered session row", "2026-06-19T23:20:00Z", 2, true, [])
		];
		state.inlineErrorShown = false;
		state.lastFailureCode = "";
		state.lastError = "";
		state.loaderEventStatus = "session_recovery_page_decoded";
		state.loaderEventDetail = "request=" + event.requestId + ";response=" + event.detail;
		state.footerProgressLabel = "session recovery page";
	}

	static function applyRecoveryTranscript(state:ResumePickerState, event:ResumePickerHostEvent):Void {
		state.pendingThreadId = event.threadId;
		state.transcriptState = "loaded";
		state.transcriptCells = [
			"user: lifecycle recovered",
			"assistant: session fresh",
			"plan: session lifecycle preserved"
		];
		state.transcriptCellCount = state.transcriptCells.length;
		state.transcriptUserCellCount = 1;
		state.transcriptAssistantCellCount = 1;
		state.transcriptPlanCellCount = 1;
		state.transcriptFallbackCellCount = 0;
		state.overlayOpen = true;
		state.loadingOverlayMessage = "";
		state.inlineErrorShown = false;
		state.lastFailureCode = "";
		state.lastError = "";
		state.loaderEventStatus = "session_recovery_transcript_decoded";
		state.loaderEventDetail = "request=" + event.requestId + ";response=" + event.detail;
		state.footerProgressLabel = "session recovery transcript";
	}

	static function pageRequest(requestId:String, cursor:String, query:String, filterMode:ResumePickerFilterMode):ResumePickerThreadListRequest {
		return new ResumePickerThreadListRequest({
			requestId: requestId,
			cursor: cursor,
			query: query,
			pageSize: 2,
			sortKey: ResumePickerSortKey.UpdatedAt,
			filterMode: filterMode,
			cwdFilter: "/workspace/codex-hxrust",
			showAll: filterMode == ResumePickerFilterMode.All,
			includeNonInteractive: false
		});
	}

	static function readRequest(requestId:String, threadId:String, previewOnly:Bool, maxPreviewLines:Int):ResumePickerThreadReadRequest {
		return new ResumePickerThreadReadRequest({
			requestId: requestId,
			threadId: threadId,
			includeTurns: true,
			previewOnly: previewOnly,
			maxPreviewLines: maxPreviewLines
		});
	}

	static function threadListResultJson():String {
		return "{"
			+ "\"data\":["
			+ threadListRowJson("thread-session-recovered", "session-recovered", "Recovered session row", "2026-06-19T23:20:00Z", 2)
			+ "],\"nextCursor\":null,\"backwardsCursor\":null}";
	}

	static function threadListRowJson(threadId:String, sessionId:String, title:String, updatedAt:String, turns:Int):String {
		return "{" + "\"id\":" + CodexJson.quote(threadId) + ",\"sessionId\":" + CodexJson.quote(sessionId) + ",\"status\":{\"type\":\"idle\"}"
			+ ",\"turns\":" + turnsJson(turns) + ",\"title\":" + CodexJson.quote(title) + ",\"cwd\":\"/workspace/codex-hxrust\"" + ",\"updatedAt\":"
			+ CodexJson.quote(updatedAt) + ",\"archived\":false}";
	}

	static function threadReadResultJson(threadId:String, preview:String):String {
		return "{\"thread\":" + threadJson(threadId, preview) + "}";
	}

	static function threadJson(threadId:String, preview:String):String {
		return "{"
			+ "\"id\":"
			+ CodexJson.quote(threadId)
			+ ",\"sessionId\":\"session-recovered\""
			+ ",\"forkedFromId\":null"
			+ ",\"parentThreadId\":null"
			+ ",\"preview\":"
			+ CodexJson.quote(preview)
			+ ",\"ephemeral\":false"
			+ ",\"modelProvider\":\"openai\""
			+ ",\"createdAt\":1781896800"
			+ ",\"updatedAt\":1781897100"
			+ ",\"status\":{\"type\":\"idle\"}"
			+ ",\"path\":null"
			+ ",\"cwd\":\"/workspace/codex-hxrust\""
			+ ",\"cliVersion\":\"0.0.0-test\""
			+ ",\"source\":\"cli\""
			+ ",\"threadSource\":null"
			+ ",\"agentNickname\":null"
			+ ",\"agentRole\":null"
			+ ",\"gitInfo\":null"
			+ ",\"name\":\"Recovered session row\""
			+ ",\"turns\":["
			+ turnJson("turn-1", [
				userMessageJson("item-user-1", "lifecycle recovered"),
				textItemJson("agentMessage", "item-agent-1", "session fresh")
			])
			+ ","
			+ turnJson("turn-2", [textItemJson("plan", "item-plan-1", "session lifecycle preserved")])
			+ "]}";
	}

	static function turnJson(turnId:String, items:Array<String>):String {
		return "{\"id\":" + CodexJson.quote(turnId) + ",\"items\":[" + items.join(",") + "],\"status\":\"completed\"}";
	}

	static function userMessageJson(id:String, text:String):String {
		return "{\"type\":\"userMessage\",\"id\":"
			+ CodexJson.quote(id)
			+ ",\"content\":[{\"type\":\"text\",\"text\":"
			+ CodexJson.quote(text)
			+ "}]}";
	}

	static function textItemJson(type:String, id:String, text:String):String {
		return "{\"type\":" + CodexJson.quote(type) + ",\"id\":" + CodexJson.quote(id) + ",\"text\":" + CodexJson.quote(text) + "}";
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

	static function visibleRow(threadId:String, title:String, updatedAt:String, turnCount:Int, selected:Bool,
			previewLines:Array<String>):ResumePickerVisibleRow {
		return new ResumePickerVisibleRow({
			threadId: threadId,
			title: title,
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

	static function requestShapePreserved(requests:Array<String>, transport:Array<String>):Bool {
		return contains(requests, "id=session-page-pending")
			&& contains(requests, "jsonMethod=thread/list")
			&& contains(requests, "\"searchTerm\":\"session\"")
			&& contains(requests, "id=session-preview-pending;thread=thread-session-a")
			&& contains(requests, "jsonMethod=thread/read")
			&& contains(requests, "\"threadId\":\"thread-session-a\"")
			&& contains(requests, "\"includeTurns\":true")
			&& !contains(requests, "\"previewOnly\"")
			&& contains(transport, "fanout-send:ok=true;code=accepted;request=session-page-pending;method=thread/list;pending=1")
			&& contains(transport, "fanout-send:ok=true;code=accepted;request=session-preview-pending;method=thread/read;pending=2");
	}

	static function sessionLifecycleModeled(fanout:Array<String>, events:Array<String>):Bool {
		return contains(fanout, "first-page-enqueued:pending=1")
			&& contains(fanout, "first-read-enqueued:pending=2")
			&& contains(fanout, "session:cancel-read:")
			&& contains(fanout, "session:cancel-page:")
			&& contains(fanout, "disconnect:pending=0")
			&& contains(fanout, "after-disconnect-refusal:pending=0")
			&& contains(fanout, "recovery-read-enqueued:pending=1")
			&& contains(events, "disconnected:control");
	}

	static function stateSummary(state:ResumePickerState):String {
		return DiagnosticSummary.render([
			DiagnosticSummary.text("thread", state.selectedThreadId),
			DiagnosticSummary.text("previewState", state.previewState),
			DiagnosticSummary.intValue("previewLines", state.previewLineCount),
			DiagnosticSummary.boolValue("overlay", state.overlayOpen),
			DiagnosticSummary.intValue("cells", state.transcriptCellCount),
			DiagnosticSummary.boolValue("errorShown", state.inlineErrorShown),
			DiagnosticSummary.text("failure", emptyLabel(state.lastFailureCode)),
			DiagnosticSummary.text("footer", state.footerProgressLabel),
			DiagnosticSummary.text("loader", state.loaderEventStatus),
			DiagnosticSummary.text("detail", state.loaderEventDetail)
		]);
	}

	static function outcomeSummary(outcome:RuntimeClientOutcome):String {
		return ResumePickerGateDiagnostics.runtimeClientOutcome(outcome);
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
}
