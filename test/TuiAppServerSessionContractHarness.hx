import codexhx.protocol.RequestId;
import codexhx.protocol.SessionId;
import codexhx.protocol.ThreadId;
import codexhx.runtime.tui.appserver.FakeTuiAppServerFacade;
import codexhx.runtime.tui.appserver.FakeTuiAppServerJsonRpcLineTransport;
import codexhx.runtime.tui.appserver.JsonRpcTuiPromptTransport;
import codexhx.runtime.tui.appserver.PersistentTuiAppServerJsonRpcLineConnectedTransport;
import codexhx.runtime.tui.appserver.TransportTuiAppServerSession;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcError;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineEndpoint;
import codexhx.runtime.tui.appserver.DryRunTuiAppServerJsonRpcLineConnector;
import codexhx.runtime.tui.appserver.DryRunTuiAppServerJsonRpcLineNativeOpener;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineOpenOutcome;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineTransport;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineTransportAttachment;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineTransportAttacher;
import codexhx.runtime.tui.appserver.TuiAppServerSession;
import codexhx.runtime.tui.chatwidget.ChatWidgetShellState;
import haxe.json.Value;

/**
	Proves that live and deterministic app-server sessions share one runtime contract.
**/
class TuiAppServerSessionContractHarness {
	static function main():Void {
		assertSession(new TransportTuiAppServerSession(ChatWidgetShellState.initial("pending")), "transport");
		assertSession(new FakeTuiAppServerFacade(ChatWidgetShellState.initial("pending")), "fake");
		assertClientResponseTransport();
		Sys.println("tui-app-server-session-contract ok");
	}

	static function assertSession(session:TuiAppServerSession, label:String):Void {
		final sessionId = SessionId.unsafeAssumeValid("00000000-0000-0000-0000-000000210001");
		final threadId = ThreadId.unsafeAssumeValid("00000000-0000-0000-0000-000000210002");
		session.bootstrap(RequestId.fromInteger(1), sessionId, threadId, "gpt-contract");
		if (session.activeSession() == null || !session.activeSession().equals(sessionId))
			throw label + " session did not bootstrap";
		if (session.activeThread() == null || !session.activeThread().equals(threadId))
			throw label + " session did not attach its primary thread";
		final started = session.startTurn(RequestId.fromInteger(2), "contract prompt");
		if (!started.acceptedPrompt())
			throw label + " session did not start a turn";
		while (session.hasPendingEvent()) {
			final event = session.nextEvent();
			if (event != null)
				session.receiveEvent(event);
		}
		if (session.resolveServerRequest(RequestId.fromInteger(3), JNull).code() != "client_transport_unavailable")
			throw label + " session lost the typed server-request result boundary";
		if (session.rejectServerRequest(RequestId.fromInteger(4), new TuiAppServerJsonRpcError(-32000, "unsupported"))
			.code() != "client_transport_unavailable")
			throw label + " session lost the typed server-request error boundary";
		if (session.shutdown("contract_done") == null)
			throw label + " session did not report shutdown";
	}

	static function assertClientResponseTransport():Void {
		final attacher = new SessionClientResponseLineTransportAttacher();
		final transport = new PersistentTuiAppServerJsonRpcLineConnectedTransport(TuiAppServerJsonRpcLineEndpoint.TcpSocket("127.0.0.1", 4501),
			new DryRunTuiAppServerJsonRpcLineConnector(new DryRunTuiAppServerJsonRpcLineNativeOpener(), attacher));
		final session = new TransportTuiAppServerSession(ChatWidgetShellState.initial("pending"), new JsonRpcTuiPromptTransport(transport), null, transport);

		final resolved = session.resolveServerRequest(RequestId.fromString("server-request-1"), JObject(["answer"], [JString("yes")]));
		assertResponse(resolved.isAccepted(), resolved.statusText(), "sent", "resolved response status");
		assertText('{"id":"server-request-1","result":{"answer":"yes"}}\n', attacher.transport.clientResponseLineAt(0), "resolved response line");

		final rejected = session.rejectServerRequest(RequestId.fromInteger(7),
			new TuiAppServerJsonRpcError(-32000, "cannot handle", JObject(["reason"], [JString("unsupported")])));
		assertResponse(rejected.isAccepted(), rejected.statusText(), "sent", "rejected response status");
		assertText('{"error":{"code":-32000,"data":{"reason":"unsupported"},"message":"cannot handle"},"id":7}\n', attacher.transport.clientResponseLineAt(1),
			"rejected response line");
		if (attacher.transport.clientResponseLineCount() != 2)
			throw "client response count: expected 2, got " + attacher.transport.clientResponseLineCount();
		if (transport.lastConnectReport() == null || transport.lastConnectReport().connectionIndex != 1)
			throw "client responses did not share one persistent connection";

		final malformed = session.resolveServerRequest(null, JNull);
		assertResponse(!malformed.isAccepted(), malformed.statusText(), "rejected", "malformed response status");
		assertText("missing_request_id", malformed.code(), "malformed response code");
		final malformedError = session.rejectServerRequest(RequestId.fromInteger(8), null);
		assertResponse(!malformedError.isAccepted(), malformedError.statusText(), "rejected", "malformed error response status");
		assertText("missing_error", malformedError.code(), "malformed error response code");

		final shutdown = session.shutdown("response_contract_done");
		if (!shutdown.lineCloseRecorded || shutdown.outboundLineCount != 2)
			throw "client response shutdown did not report both outbound lines";
		final disconnected = session.resolveServerRequest(RequestId.fromInteger(9), JNull);
		assertResponse(!disconnected.isAccepted(), disconnected.statusText(), "disconnected", "post-shutdown response status");
		assertText("line_connected_transport_closed", disconnected.code(), "post-shutdown response code");
	}

	static function assertResponse(condition:Bool, actual:String, expected:String, label:String):Void {
		if (!condition || actual != expected)
			throw label + ": expected " + expected + ", got " + actual;
	}

	static function assertText(expected:String, actual:String, label:String):Void {
		if (expected != actual)
			throw label + ": expected " + expected + ", got " + actual;
	}
}

class SessionClientResponseLineTransportAttacher implements TuiAppServerJsonRpcLineTransportAttacher {
	public final transport:FakeTuiAppServerJsonRpcLineTransport;

	public function new() {
		this.transport = new FakeTuiAppServerJsonRpcLineTransport();
	}

	public function attach(outcome:TuiAppServerJsonRpcLineOpenOutcome):TuiAppServerJsonRpcLineTransportAttachment {
		final concrete = outcome == null ? TuiAppServerJsonRpcLineOpenOutcome.refused(null) : outcome;
		return concrete.isOpened() ? TuiAppServerJsonRpcLineTransportAttachment.ready(concrete) : TuiAppServerJsonRpcLineTransportAttachment.refused(concrete);
	}

	public function transportFor(attachment:TuiAppServerJsonRpcLineTransportAttachment):Null<TuiAppServerJsonRpcLineTransport> {
		return attachment == null || !attachment.isReady() ? null : transport;
	}
}
