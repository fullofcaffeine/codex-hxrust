package codexhx.runtime.tui.live;

import codexhx.protocol.SessionId;
import codexhx.protocol.ThreadId;
import codexhx.runtime.tui.appserver.DryRunTuiAppServerJsonRpcLineConnector;
import codexhx.runtime.tui.appserver.DryRunTuiAppServerJsonRpcLineConnectedTransport;
import codexhx.runtime.tui.appserver.JsonRpcTuiPromptTransport;
import codexhx.runtime.tui.appserver.PersistentTuiAppServerJsonRpcLineConnectedTransport;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineConnector;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineEndpoint;
import codexhx.runtime.tui.appserver.TuiAppServerClientTransport;
import codexhx.runtime.tui.appserver.TuiAppServerEvent;
import codexhx.runtime.tui.appserver.TuiAppServerPumpEvent;
import codexhx.runtime.tui.appserver.TuiAppServerReadinessEvent;
import codexhx.runtime.tui.appserver.TuiAppServerSession;
import codexhx.runtime.tui.appserver.TransportTuiAppServerSession;
import codexhx.runtime.tui.appserver.AdoptedTuiAppServerStartupTransport;
import codexhx.runtime.tui.appserver.TuiAppServerStartupRequest;
import codexhx.runtime.tui.appserver.TuiAppServerStartupTransport;
import codexhx.runtime.tui.appserver.TuiAppServerThreadOpenMode;
import codexhx.runtime.tui.chatwidget.ChatWidgetShellState;
import codexhx.runtime.tui.terminal.TerminalBackend;
import codexhx.runtime.tui.terminal.TerminalRedrawScheduler;
import codexhx.runtime.tui.terminal.TerminalSetup;

/**
	Typed startup request for the minimal runnable TUI shell.

	The required fields are the live boundary facts: terminal backend/setup and
	the session/thread identity. Optional builder methods let tests inject
	existing state without widening the runner with opaque configuration or
	anonymous records whose backend field type can drift in generated Rust.
**/
class TuiLiveShellRunRequest {
	public final backend:TerminalBackend;
	public final setup:TerminalSetup;
	public final sessionId:SessionId;
	public final primaryThreadId:ThreadId;
	public final modelLabel:String;
	public var shell:ChatWidgetShellState;
	public var session:TuiAppServerSession;
	public var scheduler:TerminalRedrawScheduler;
	public var policy:TuiLiveShellRunPolicy;
	public var initialEvents:Array<TuiAppServerEvent>;
	public var pumpEvents:Array<TuiAppServerPumpEvent>;
	public var readinessEvents:Array<TuiAppServerReadinessEvent>;
	public var readinessSource:TuiLiveShellReadinessSource;
	public var startupRequest:Null<TuiAppServerStartupRequest>;

	public function new(backend:TerminalBackend, setup:TerminalSetup, sessionId:SessionId, primaryThreadId:ThreadId, modelLabel:String) {
		this.backend = backend;
		this.setup = setup;
		this.sessionId = sessionId;
		this.primaryThreadId = primaryThreadId;
		this.modelLabel = normalize(modelLabel, "gpt-live");
		this.shell = ChatWidgetShellState.initial("pending");
		this.session = adoptedSession(this.shell, null, null);
		this.startupRequest = startup(TuiAppServerThreadOpenMode.Start, null);
		this.scheduler = new TerminalRedrawScheduler(setup.size);
		this.policy = TuiLiveShellRunPolicy.bounded(64, 4);
		this.initialEvents = [];
		this.pumpEvents = [];
		this.readinessEvents = [];
		this.readinessSource = TuiLiveShellReadinessSource.empty();
	}

	public function withShell(shell:ChatWidgetShellState):TuiLiveShellRunRequest {
		this.shell = shell == null ? ChatWidgetShellState.initial("pending") : shell;
		this.session = adoptedSession(this.shell, null, null);
		return this;
	}

	public function withSession(session:TuiAppServerSession):TuiLiveShellRunRequest {
		this.session = session == null ? new TransportTuiAppServerSession(this.shell) : session;
		this.shell = this.session.shell();
		this.startupRequest = null;
		return this;
	}

	public function withStartupTransport(transport:TuiAppServerStartupTransport, request:TuiAppServerStartupRequest):TuiLiveShellRunRequest {
		this.startupRequest = request;
		this.session = new TransportTuiAppServerSession(this.shell, null, transport);
		return this;
	}

	public function withJsonRpcPromptTransport(promptTransport:JsonRpcTuiPromptTransport):TuiLiveShellRunRequest {
		this.session = adoptedSession(this.shell, promptTransport, null);
		return this;
	}

	public function withLineConnectedPromptTransport(endpoint:TuiAppServerJsonRpcLineEndpoint, rejectionCode:String = ""):TuiLiveShellRunRequest {
		return withJsonRpcPromptTransport(new JsonRpcTuiPromptTransport(DryRunTuiAppServerJsonRpcLineConnectedTransport.dryRun(endpoint,
			normalize(rejectionCode, ""))));
	}

	public function withLineConnectedPromptTransportUsingConnector(endpoint:TuiAppServerJsonRpcLineEndpoint, rejectionCode:String,
			connector:TuiAppServerJsonRpcLineConnector):TuiLiveShellRunRequest {
		return withJsonRpcPromptTransport(new JsonRpcTuiPromptTransport(DryRunTuiAppServerJsonRpcLineConnectedTransport.withConnector(endpoint,
			normalize(rejectionCode, ""), connector)));
	}

	public function withProcessBackedLineConnectedPromptTransport(endpoint:TuiAppServerJsonRpcLineEndpoint, rejectionCode:String = ""):TuiLiveShellRunRequest {
		return withLineConnectedPromptTransportUsingConnector(endpoint, rejectionCode, DryRunTuiAppServerJsonRpcLineConnector.processBacked());
	}

	public function withPersistentStdioLineConnectedPromptTransport(endpoint:TuiAppServerJsonRpcLineEndpoint,
			maxInboundLinesPerPrompt:Int = 10):TuiLiveShellRunRequest {
		final transport = PersistentTuiAppServerJsonRpcLineConnectedTransport.withPersistentStdioSession(endpoint, maxInboundLinesPerPrompt);
		this.session = adoptedSession(this.shell, new JsonRpcTuiPromptTransport(transport), transport);
		return this;
	}

	public function withScheduler(scheduler:TerminalRedrawScheduler):TuiLiveShellRunRequest {
		this.scheduler = scheduler == null ? new TerminalRedrawScheduler(setup.size) : scheduler;
		return this;
	}

	public function withPolicy(policy:TuiLiveShellRunPolicy):TuiLiveShellRunRequest {
		this.policy = policy == null ? TuiLiveShellRunPolicy.bounded(64, 4) : policy;
		return this;
	}

	public function withInitialEvents(events:Array<TuiAppServerEvent>):TuiLiveShellRunRequest {
		this.initialEvents = events == null ? [] : events.copy();
		return this;
	}

	public function withPumpEvents(events:Array<TuiAppServerPumpEvent>):TuiLiveShellRunRequest {
		this.pumpEvents = events == null ? [] : events.copy();
		return this;
	}

	public function withReadinessEvents(events:Array<TuiAppServerReadinessEvent>):TuiLiveShellRunRequest {
		this.readinessEvents = events == null ? [] : events.copy();
		return this;
	}

	public function withReadinessSource(source:TuiLiveShellReadinessSource):TuiLiveShellRunRequest {
		this.readinessSource = source == null ? TuiLiveShellReadinessSource.empty() : source;
		return this;
	}

	public function shiftPumpEvent():Null<TuiAppServerPumpEvent> {
		if (pumpEvents.length == 0)
			return null;
		return pumpEvents.shift();
	}

	public function shiftReadinessEvent():Null<TuiAppServerReadinessEvent> {
		if (readinessEvents.length > 0)
			return readinessEvents.shift();
		if (readinessSource == null)
			return null;
		return readinessSource.nextEvent();
	}

	static function normalize(value:String, fallback:String):String {
		if (value == null || value.length == 0)
			return fallback;
		return value;
	}

	function adoptedSession(shell:ChatWidgetShellState, promptTransport:Null<JsonRpcTuiPromptTransport>,
			clientTransport:Null<TuiAppServerClientTransport>):TuiAppServerSession {
		return new TransportTuiAppServerSession(shell, promptTransport, new AdoptedTuiAppServerStartupTransport(sessionId, primaryThreadId), clientTransport);
	}

	function startup(mode:TuiAppServerThreadOpenMode, resumeThreadId:Null<ThreadId>):TuiAppServerStartupRequest {
		return new TuiAppServerStartupRequest({
			requestId: codexhx.protocol.RequestId.fromInteger(1),
			mode: mode,
			resumeThreadId: resumeThreadId,
			modelLabel: modelLabel,
			clientName: "codex-hxrust-tui",
			clientVersion: "0.0.0"
		});
	}
}
