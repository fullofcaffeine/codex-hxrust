package codexhx.runtime.tui.resume.live;

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
import codexhx.runtime.tui.resume.host.DeterministicTypedPendingRequestRegistry;
import codexhx.runtime.tui.resume.host.EnvelopeBuilder;
import codexhx.runtime.tui.resume.host.DeterministicFrameScheduler;
import codexhx.runtime.tui.resume.host.DeterministicTerminalRenderer;
import codexhx.runtime.tui.resume.host.JsonRpcThreadSource;
import codexhx.runtime.tui.resume.host.EventPump;
import codexhx.runtime.tui.resume.host.PendingRequestClassKind;
import codexhx.runtime.tui.resume.host.StreamEvent;
import codexhx.runtime.tui.resume.host.StreamFanout;
import codexhx.runtime.tui.resume.host.TypedPendingRequestEvent;
import codexhx.runtime.tui.resume.host.Envelope;
import codexhx.runtime.tui.resume.host.EnvelopeKind;
import codexhx.runtime.tui.resume.host.PayloadKind;
import codexhx.runtime.tui.resume.host.ResumePickerHostEvent;
import codexhx.runtime.tui.resume.host.ResumePickerHostEventKind;
import codexhx.runtime.tui.resume.host.ResumePickerThreadListRequest;
import codexhx.validation.tui.resume.live.ResumePickerGateDiagnostics;

class PayloadEnvelopeGate {
	public static function run():PayloadEnvelopeReport {
		final scheduler = new DeterministicFrameScheduler();
		final renderer = new DeterministicTerminalRenderer();
		final state = baseState();
		final source = new JsonRpcThreadSource(8);
		final fanout = new StreamFanout(source);
		final pump = new EventPump(1, fanout, scheduler, 12);
		final registry = new DeterministicTypedPendingRequestRegistry();
		final builder = new EnvelopeBuilder();
		final events:Array<TypedPendingRequestEvent> = [];
		final envelopes:Array<Envelope> = [];
		final dispatchSummaries:Array<String> = [];
		final hostEvents:Array<String> = [];
		final stateSummaries:Array<String> = [];
		final forwardPolls:Array<String> = [];

		renderFrame(scheduler, renderer, state, "typed-response-open");

		final exec = resolveKeyed(pump, registry, builder, events, envelopes, dispatchSummaries, hostEvents, forwardPolls,
			PendingRequestClassKind.ExecApproval, "typed-response-exec-1", "approval-1", "turn-1", "call-1", "", "",
			"item/commandExecution/requestApproval;approval=approval-1");
		applyEnvelope(state, exec, "typed_response_exec_payload");
		stateSummaries.push("exec:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "typed-response-exec");

		final file = resolveKeyed(pump, registry, builder, events, envelopes, dispatchSummaries, hostEvents, forwardPolls,
			PendingRequestClassKind.FileChangeApproval, "typed-response-file-2", "patch-1", "turn-1", "patch-1", "", "",
			"item/fileChange/requestApproval;item=patch-1");
		applyEnvelope(state, file, "typed_response_file_payload");
		stateSummaries.push("file:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "typed-response-file");

		final permissions = resolveKeyed(pump, registry, builder, events, envelopes, dispatchSummaries, hostEvents, forwardPolls,
			PendingRequestClassKind.PermissionsApproval, "typed-response-permissions-3", "perm-1", "turn-1", "perm-1", "", "",
			"item/permissions/requestApproval;item=perm-1");
		applyEnvelope(state, permissions, "typed_response_permissions_payload");
		stateSummaries.push("permissions:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "typed-response-permissions");

		final userInputHost = deliverServerRequest(pump, dispatchSummaries, hostEvents, forwardPolls, "typed-response-user-input-4",
			"item/tool/requestUserInput;turn=turn-2;item=tool-1");
		registry.register(PendingRequestClassKind.UserInput, userInputHost.requestId, "turn-2", "turn-2", "tool-1", "", "", userInputHost.detail);
		final userInputEvent = registry.popUserInput("turn-2");
		events.push(userInputEvent);
		final userInput = builder.resolve(userInputEvent);
		envelopes.push(userInput);
		applyEnvelope(state, userInput, "typed_response_user_input_payload");
		stateSummaries.push("user-input:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "typed-response-user-input");

		final mcpHost = deliverServerRequest(pump, dispatchSummaries, hostEvents, forwardPolls, "typed-response-mcp-5",
			"mcpServer/elicitation/request;server=apps;request=mcp-5");
		registry.register(PendingRequestClassKind.McpElicitation, mcpHost.requestId, "apps:mcp-5", "turn-3", "mcp-item-5", "apps", "mcp-5", mcpHost.detail);
		final mcpEvent = registry.resolveMcp("apps", "mcp-5");
		events.push(mcpEvent);
		final mcp = builder.resolve(mcpEvent);
		envelopes.push(mcp);
		applyEnvelope(state, mcp, "typed_response_mcp_payload");
		stateSummaries.push("mcp:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "typed-response-mcp");

		final unsupportedEvent = registry.register(PendingRequestClassKind.DynamicToolCall, "typed-response-dynamic-6", "tool-6", "turn-4", "tool-6", "", "",
			"item/tool/call;dynamic=true");
		events.push(unsupportedEvent);
		final unsupported = builder.resolve(unsupportedEvent);
		envelopes.push(unsupported);
		applyEnvelope(state, unsupported, "typed_response_unsupported_error");
		stateSummaries.push("unsupported:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "typed-response-unsupported");

		final missingEvent = registry.resolveKey(PendingRequestClassKind.ExecApproval, "missing-approval");
		events.push(missingEvent);
		final missing = builder.resolve(missingEvent);
		envelopes.push(missing);
		applyEnvelope(state, missing, "typed_response_missing_pending_noop");
		stateSummaries.push("missing:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "typed-response-missing");

		final pageAccepted = fanout.enqueuePage(pageRequest("typed-response-recovery-page", "", "typed response"));
		stateSummaries.push("enqueued:page=" + outcomeSummary(pageAccepted));
		final pagePoll = pump.forward(StreamEvent.pageResult(1, "typed-response-recovery-page", threadListResultJson("response")));
		forwardPolls.push("page-recovery=" + AsyncPollSummary.summary(pagePoll));

		final pageDispatch = pump.dispatchNext(AsyncContext.fixture("typed-response-recovery-page"));
		dispatchSummaries.push(pageDispatch.summary);
		hostEvents.push(pageDispatch.hostEvent.summary());
		if (pageDispatch.hostEvent.kind == ResumePickerHostEventKind.PageLoaded)
			applyPage(state, pageDispatch.hostEvent, "response");
		stateSummaries.push("page:" + stateSummary(state));
		renderFrame(scheduler, renderer, state, "typed-response-recovery-page");

		final envelopeSummaries = envelopeSummaries(envelopes);
		final eventSummaries = eventSummaries(events);
		final pumpSummaries = pump.summaries();
		final rejectedRequests = pump.rejectedRequestSummaries();

		return new PayloadEnvelopeReport({
			execPayloadRecorded: exec.payloadKind == PayloadKind.CommandExecutionApprovalResponse
			&& contains(envelopeSummaries, "\"decision\":\"accept\""),
			filePayloadRecorded: file.payloadKind == PayloadKind.FileChangeApprovalResponse
			&& contains(envelopeSummaries, "\"decision\":\"apply\""),
			permissionsPayloadRecorded: permissions.payloadKind == PayloadKind.PermissionsApprovalResponse
			&& contains(envelopeSummaries, "\"scope\":\"session\""),
			userInputPayloadRecorded: userInput.payloadKind == PayloadKind.ToolRequestUserInputResponse
			&& contains(envelopeSummaries, "\"answers\"")
			&& contains(envelopeSummaries, "\"itemId\":\"tool-1\""),
			mcpPayloadRecorded: mcp.payloadKind == PayloadKind.McpElicitationResponse
			&& contains(envelopeSummaries, "\"action\":\"accept\"")
			&& contains(envelopeSummaries, "\"server\":\"apps\""),
			unsupportedErrorRecorded: unsupported.kind == EnvelopeKind.RejectError
			&& unsupported.errorJson.indexOf("unsupported_request_class") >= 0,
			missingPendingNoopRecorded: missing.kind == EnvelopeKind.MissingPendingNoop && missing.localOnly,
			requestIdsCorrelated: exec.correlationKey == "server:typed-response-exec-1"
			&& file.correlationKey == "server:typed-response-file-2"
			&& permissions.correlationKey == "server:typed-response-permissions-3"
			&& userInput.correlationKey == "server:typed-response-user-input-4"
			&& mcp.correlationKey == "server:typed-response-mcp-5",
			noPressureDropRejection: rejectedRequests.length == 0
			&& !contains(pumpSummaries, "server-request-rejected")
			&& !contains(pumpSummaries, "consumer_queue_full"),
			liveTransportSuppressed: !contains(envelopeSummaries, "liveTransport=true") && contains(envelopeSummaries, "suppressed=true"),
			recoveryDecoded: pageDispatch.hostEvent.kind == ResumePickerHostEventKind.PageLoaded
			&& state.selectedThreadId == "thread-response-a"
			&& !state.inlineErrorShown,
			noCredentialOrModelTraffic: true,
			stateDbUntouched: true,
			pageRequests: source.pageRequestCount(),
			readRequests: source.readRequestCount(),
			frameRequests: scheduler.requestCount(),
			renderCount: renderer.renderCount(),
			finalSnapshot: renderer.lastSnapshot(),
			renderSnapshots: renderer.allSnapshots(),
			typedEventSummaries: eventSummaries,
			envelopeSummaries: envelopeSummaries,
			envelopeLogSummaries: builder.summaries(),
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

	static function resolveKeyed(pump:EventPump, registry:DeterministicTypedPendingRequestRegistry, builder:EnvelopeBuilder,
			events:Array<TypedPendingRequestEvent>, envelopes:Array<Envelope>, dispatchSummaries:Array<String>, hostEvents:Array<String>,
			forwardPolls:Array<String>, requestClass:PendingRequestClassKind, requestId:String, key:String, turnId:String, itemId:String, serverName:String,
			mcpRequestId:String, detail:String):Envelope {
		final hostEvent = deliverServerRequest(pump, dispatchSummaries, hostEvents, forwardPolls, requestId, detail);
		registry.register(requestClass, hostEvent.requestId, key, turnId, itemId, serverName, mcpRequestId, hostEvent.detail);
		final resolved = registry.resolveKey(requestClass, key);
		events.push(resolved);
		final envelope = builder.resolve(resolved);
		envelopes.push(envelope);
		return envelope;
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
		state.query = "typed response";
		state.cwdFilter = "/workspace/codex-hxrust";
		state.pageSize = 2;
		state.viewRows = 2;
		state.footerProgressLabel = "typed response open";
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

	static function applyEnvelope(state:ResumePickerState, envelope:Envelope, status:String):Void {
		state.inlineErrorShown = envelope.kind == EnvelopeKind.RejectError;
		state.lastFailureCode = state.inlineErrorShown ? envelope.payloadKind : "";
		state.lastError = envelope.errorJson;
		state.loaderEventStatus = status;
		state.loaderEventDetail = DiagnosticSummary.render([
			DiagnosticSummary.enumValue("kind", Std.string(envelope.kind)),
			DiagnosticSummary.enumValue("class", Std.string(envelope.requestClass)),
			DiagnosticSummary.text("payloadKind", envelope.payloadKind),
			DiagnosticSummary.text("request", envelope.requestId),
			DiagnosticSummary.text("method", envelope.method),
			DiagnosticSummary.text("correlation", envelope.correlationKey),
			DiagnosticSummary.boolValue("localOnly", envelope.localOnly),
			DiagnosticSummary.boolValue("sendIntent", envelope.sendIntentRecorded),
			DiagnosticSummary.boolValue("suppressed", envelope.liveTransportSuppressed)
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
			visibleRow("thread-" + prefix + "-a", title(prefix, "A"), "2026-06-20T05:45:00Z", 2, true, []),
			visibleRow("thread-" + prefix + "-b", title(prefix, "B"), "2026-06-20T05:46:00Z", 1, false, [])
		];
		state.inlineErrorShown = false;
		state.lastFailureCode = "";
		state.lastError = "";
		state.loaderEventStatus = "typed_response_recovery_page_decoded";
		state.loaderEventDetail = "request=" + event.requestId + ";response=" + event.detail;
		state.footerProgressLabel = "typed response recovered";
	}

	static function threadListResultJson(prefix:String):String {
		return "{"
			+ "\"data\":["
			+ threadListRowJson("thread-" + prefix + "-a", "session-" + prefix + "-a", title(prefix, "A"), "2026-06-20T05:45:00Z", 2)
			+ ","
			+ threadListRowJson("thread-" + prefix + "-b", "session-" + prefix + "-b", title(prefix, "B"), "2026-06-20T05:46:00Z", 1)
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

	static function stateSummary(state:ResumePickerState):String {
		return ResumePickerGateDiagnostics.inlineErrorState(state);
	}

	static function outcomeSummary(outcome:RuntimeClientOutcome):String {
		return ResumePickerGateDiagnostics.runtimeClientOutcome(outcome);
	}

	static function title(prefix:String, suffix:String):String {
		return "Typed response " + prefix + " row " + suffix;
	}

	static function contains(values:Array<String>, needle:String):Bool {
		for (value in values)
			if (value.indexOf(needle) >= 0)
				return true;
		return false;
	}
}
