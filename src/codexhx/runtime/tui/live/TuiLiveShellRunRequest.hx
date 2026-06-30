package codexhx.runtime.tui.live;

import codexhx.protocol.SessionId;
import codexhx.protocol.ThreadId;
import codexhx.runtime.tui.appserver.DryRunTuiAppServerJsonRpcLineConnector;
import codexhx.runtime.tui.appserver.DryRunTuiAppServerJsonRpcLineConnectedTransport;
import codexhx.runtime.tui.appserver.FakeTuiAppServerFacade;
import codexhx.runtime.tui.appserver.JsonRpcTuiPromptTransport;
import codexhx.runtime.tui.appserver.PersistentTuiAppServerJsonRpcLineConnectedTransport;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineConnector;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcLineEndpoint;
import codexhx.runtime.tui.appserver.TuiAppServerEvent;
import codexhx.runtime.tui.chatwidget.ChatWidgetShellState;
import codexhx.runtime.tui.terminal.TerminalBackend;
import codexhx.runtime.tui.terminal.TerminalRedrawScheduler;
import codexhx.runtime.tui.terminal.TerminalSetup;

/**
	Typed startup request for the minimal runnable TUI shell.

	The required fields are the live boundary facts: terminal backend/setup and
	the fake session/thread identity. Optional builder methods let tests inject
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
	public var facade:FakeTuiAppServerFacade;
	public var scheduler:TerminalRedrawScheduler;
	public var policy:TuiLiveShellRunPolicy;
	public var initialEvents:Array<TuiAppServerEvent>;

	public function new(backend:TerminalBackend, setup:TerminalSetup, sessionId:SessionId, primaryThreadId:ThreadId, modelLabel:String) {
		this.backend = backend;
		this.setup = setup;
		this.sessionId = sessionId;
		this.primaryThreadId = primaryThreadId;
		this.modelLabel = normalize(modelLabel, "gpt-live");
		this.shell = ChatWidgetShellState.initial("pending");
		this.facade = new FakeTuiAppServerFacade(this.shell);
		this.scheduler = new TerminalRedrawScheduler(setup.size);
		this.policy = TuiLiveShellRunPolicy.bounded(64, 4);
		this.initialEvents = [];
	}

	public function withShell(shell:ChatWidgetShellState):TuiLiveShellRunRequest {
		this.shell = shell == null ? ChatWidgetShellState.initial("pending") : shell;
		this.facade = new FakeTuiAppServerFacade(this.shell);
		return this;
	}

	public function withFacade(facade:FakeTuiAppServerFacade):TuiLiveShellRunRequest {
		this.facade = facade == null ? new FakeTuiAppServerFacade(this.shell) : facade;
		return this;
	}

	public function withJsonRpcPromptTransport(promptTransport:JsonRpcTuiPromptTransport):TuiLiveShellRunRequest {
		this.facade = new FakeTuiAppServerFacade(this.shell, promptTransport);
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
		return
			withJsonRpcPromptTransport(new JsonRpcTuiPromptTransport(PersistentTuiAppServerJsonRpcLineConnectedTransport.withPersistentStdioSession(endpoint,
				maxInboundLinesPerPrompt)));
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

	static function normalize(value:String, fallback:String):String {
		if (value == null || value.length == 0)
			return fallback;
		return value;
	}
}
