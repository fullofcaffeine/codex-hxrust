import codexhx.protocol.RequestId;
import codexhx.protocol.SessionId;
import codexhx.protocol.ThreadId;
import codexhx.runtime.tui.appserver.FakeTuiAppServerFacade;
import codexhx.runtime.tui.appserver.TransportTuiAppServerSession;
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
		if (session.resolveServerRequest(RequestId.fromInteger(3), JNull).code() != "server_request_response_unsupported")
			throw label + " session lost the typed server-request result boundary";
		if (session.rejectServerRequest(RequestId.fromInteger(4), JNull).code() != "server_request_response_unsupported")
			throw label + " session lost the typed server-request error boundary";
		if (session.shutdown("contract_done") == null)
			throw label + " session did not report shutdown";
	}
}
