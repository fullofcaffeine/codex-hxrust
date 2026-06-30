import codexhx.protocol.RequestId;
import codexhx.protocol.SessionId;
import codexhx.protocol.ThreadId;
import codexhx.runtime.tui.appserver.FakeTuiAppServerJsonRpcLineTransport;
import codexhx.runtime.tui.appserver.TuiPromptJsonRpcRequest;
import codexhx.runtime.tui.appserver.TuiPromptSubmitEnvelope;
import codexhx.runtime.tui.appserver.TuiAppServerJsonRpcProcessEnvVar;
import codexhx.runtime.tui.appserver.TuiAppServerEvent;
import codexhx.runtime.tui.live.TuiLiveShellDemoConfig;
import codexhx.runtime.tui.live.TuiLiveShellDemoMain;
import codexhx.runtime.tui.live.TuiLiveShellDemoTransportMode;
import codexhx.runtime.tui.live.TuiLiveShellRunPolicy;
import codexhx.runtime.tui.live.TuiLiveShellRunRequest;
import codexhx.runtime.tui.live.TuiLiveShellRunner;
import codexhx.runtime.tui.terminal.LiveTerminalBackend;
import codexhx.runtime.tui.terminal.TerminalSetup;
import codexhx.runtime.tui.terminal.TerminalSize;

class TuiLiveShellDemoHarness {
	static function main():Void {
		testPollTimeoutConfiguration();
		testDemoConfigDefaultsToFake();
		testDemoConfigParsesLineStdio();
		testDemoConfigParsesProcessStdio();
		testDemoConfigRejectsInvalidArgs();
		testNoTtyDemoRunCompletes();
		testHeadlessDemoLineTransportSubmitsPrompt();
		testHeadlessDemoProcessTransportSubmitsPrompt();
		Sys.println("tui-live-shell-demo ok");
	}

	static function testPollTimeoutConfiguration():Void {
		final negative = new LiveTerminalBackend(-10);
		assertIntEquals(0, negative.pollTimeoutMs(), "negative timeout clamps to zero");
		final configured = new LiveTerminalBackend().withPollTimeoutMs(75);
		assertIntEquals(75, configured.pollTimeoutMs(), "configured timeout");
		final capped = new LiveTerminalBackend(2000);
		assertIntEquals(1000, capped.pollTimeoutMs(), "large timeout cap");
	}

	static function testDemoConfigDefaultsToFake():Void {
		final config = TuiLiveShellDemoConfig.parse([]);
		assertTrue(config.ok, "default config ok");
		assertStringEquals("fake", config.transportCode(), "default transport");
		assertStringEquals("fake", config.code, "default config code");
		assertTrue(!config.hasScriptedPrompt(), "default config has no scripted prompt");
	}

	static function testDemoConfigParsesLineStdio():Void {
		final config = TuiLiveShellDemoConfig.parse([
			"--transport=line-stdio",
			"--line-command=codex-dev",
			"--line-cwd=/workspace",
			"--line-arg=app-server",
			"--line-arg=--json-rpc",
			"--line-env=CODEX_HOME=/tmp/codex-home",
			"--line-rejection-code=fixture_reject",
			"--scripted-prompt=demo prompt"
		]);
		assertTrue(config.ok, "line config ok");
		assertStringEquals("line_stdio", config.transportCode(), "line config transport");
		assertStringEquals("fixture_reject", config.rejectionCode, "line rejection code");
		assertStringEquals("demo prompt", config.scriptedPrompt, "line scripted prompt");
		assertTrue(config.hasScriptedPrompt(), "line config has scripted prompt");
		switch config.transportMode {
			case Fake:
				throw "line config should not select fake transport";
			case LineStdio(plan):
				assertStringEquals("codex-dev", plan.command, "line command");
				assertStringEquals("/workspace", plan.cwd, "line cwd");
				assertIntEquals(2, plan.argCount(), "line arg count");
				assertStringEquals("app-server", plan.argAt(0), "line arg 0");
				assertStringEquals("--json-rpc", plan.argAt(1), "line arg 1");
				assertIntEquals(1, plan.envCount(), "line env count");
				assertEnvEquals(new TuiAppServerJsonRpcProcessEnvVar("CODEX_HOME", "/tmp/codex-home"), plan.envAt(0), "line env");
			case ProcessStdio(_):
				throw "line config should not select process transport";
		}
	}

	static function testDemoConfigParsesProcessStdio():Void {
		final config = TuiLiveShellDemoConfig.parse([
			"--transport=process-stdio",
			"--line-command=sh",
			"--line-arg=-c",
			"--line-arg=cat >/dev/null",
			"--scripted-prompt=demo prompt"
		]);
		assertTrue(config.ok, "process config ok");
		assertStringEquals("process_stdio", config.transportCode(), "process config transport");
		assertStringEquals("demo prompt", config.scriptedPrompt, "process scripted prompt");
		switch config.transportMode {
			case Fake:
				throw "process config should not select fake transport";
			case LineStdio(_):
				throw "process config should not select dry-run line transport";
			case ProcessStdio(plan):
				assertStringEquals("sh", plan.command, "process command");
				assertStringEquals("", plan.cwd, "process cwd");
				assertIntEquals(2, plan.argCount(), "process arg count");
				assertStringEquals("-c", plan.argAt(0), "process arg 0");
				assertStringEquals("cat >/dev/null", plan.argAt(1), "process arg 1");
		}
	}

	static function testDemoConfigRejectsInvalidArgs():Void {
		final unknown = TuiLiveShellDemoConfig.parse(["--not-a-demo-flag"]);
		assertTrue(!unknown.ok, "unknown config rejected");
		assertStringEquals("unknown_argument", unknown.code, "unknown config code");
		final invalidEnv = TuiLiveShellDemoConfig.parse(["--line-stdio", "--line-env=missing_equals"]);
		assertTrue(!invalidEnv.ok, "invalid env rejected");
		assertStringEquals("invalid_line_env", invalidEnv.code, "invalid env code");
	}

	static function testNoTtyDemoRunCompletes():Void {
		final backend = new LiveTerminalBackend(25);
		final outcome = TuiLiveShellRunner.run(new TuiLiveShellRunRequest(backend, TerminalSetup.live(TerminalSize.of(96, 16)),
			SessionId.unsafeAssumeValid("00000000-0000-0000-0000-000000129999"), ThreadId.unsafeAssumeValid("00000000-0000-0000-0000-000000120001"),
			"gpt-live-demo").withPolicy(TuiLiveShellRunPolicy.bounded(8, 2)).withInitialEvents([
				TuiAppServerEvent.AgentThreadUpsert(ThreadId.unsafeAssumeValid("00000000-0000-0000-0000-000000120002"), "Demo agent", "worker", false)
			]));

		assertTrue(outcome.setupAccepted(), "setup accepted or no-tty skipped");
		assertTrue(outcome.restored(), "restore");
		assertTrue(outcome.drawFrames() >= 1, "initial frame drawn");
		assertStringEquals("Codex | model: gpt-live-demo | status: session started | agent: Main [default]", outcome.finalFrameLineAt(0), "demo header");
		assertIntEquals(2, outcome.noEvents(), "bounded no-tty idle exit");
	}

	static function testHeadlessDemoLineTransportSubmitsPrompt():Void {
		final config = TuiLiveShellDemoConfig.parse(["--line-stdio", "--scripted-prompt=demo"]);
		final backend = TuiLiveShellDemoMain.scriptedBackend(config.scriptedPrompt);
		final request = config.apply(TuiLiveShellDemoMain.baseRequest(backend, TerminalSetup.headless(TerminalSize.of(96, 16)),
			TuiLiveShellRunPolicy.bounded(24, 2)));
		final outcome = TuiLiveShellRunner.run(request);

		assertTrue(config.ok, "line demo config ok");
		assertStringEquals("line_stdio", config.transportCode(), "line demo transport");
		assertTrue(config.hasScriptedPrompt(), "line demo scripted prompt");
		assertIntEquals(1, outcome.acceptedPrompts(), "line demo accepted prompt");
		assertStringEquals("assistant> echo: demo", outcome.finalFrameLineAt(4), "line demo assistant echo");
	}

	static function testHeadlessDemoProcessTransportSubmitsPrompt():Void {
		final prompt = "demo";
		final configArgs = ["--process-stdio", "--line-command=sh", "--scripted-prompt=" + prompt];
		for (arg in stdioEchoArgs(expectedInboundLines(prompt)))
			configArgs.push("--line-arg=" + arg);
		final config = TuiLiveShellDemoConfig.parse(configArgs);
		final backend = TuiLiveShellDemoMain.scriptedBackend(config.scriptedPrompt);
		final request = config.apply(TuiLiveShellDemoMain.baseRequest(backend, TerminalSetup.headless(TerminalSize.of(96, 16)),
			TuiLiveShellRunPolicy.bounded(24, 2)));
		final outcome = TuiLiveShellRunner.run(request);

		assertTrue(config.ok, "process demo config ok");
		assertStringEquals("process_stdio", config.transportCode(), "process demo transport");
		assertTrue(config.hasScriptedPrompt(), "process demo scripted prompt");
		assertIntEquals(1, outcome.acceptedPrompts(), "process demo accepted prompt");
		assertStringEquals("assistant> echo: demo", outcome.finalFrameLineAt(4), "process demo assistant echo");
	}

	static function expectedInboundLines(prompt:String):Array<String> {
		final requestId = RequestId.fromInteger(2 + prompt.length);
		final sessionId = SessionId.unsafeAssumeValid("00000000-0000-0000-0000-000000120001");
		final threadId = ThreadId.unsafeAssumeValid("00000000-0000-0000-0000-000000120101");
		final envelope = new TuiPromptSubmitEnvelope(requestId, sessionId, threadId, prompt);
		final request = TuiPromptJsonRpcRequest.turnStart(envelope);
		final outcome = new FakeTuiAppServerJsonRpcLineTransport().sendPromptLine(request, envelope, request.messageJson() + "\n");
		return outcome.inboundLines();
	}

	static function stdioEchoArgs(lines:Array<String>):Array<String> {
		final args = ["-c", "cat >/dev/null; printf '%s\\n' \"$@\"", "codex-hxrust-stdio-echo"];
		for (line in lines)
			args.push(withoutTrailingNewline(line));
		return args;
	}

	static function withoutTrailingNewline(line:String):String {
		if (line == null || line.length == 0)
			return "";
		if (StringTools.endsWith(line, "\n"))
			return line.substr(0, line.length - 1);
		return line;
	}

	static function assertEnvEquals(expected:TuiAppServerJsonRpcProcessEnvVar, actual:TuiAppServerJsonRpcProcessEnvVar, label:String):Void {
		assertTrue(actual != null, label + " exists");
		assertStringEquals(expected.name, actual.name, label + " name");
		assertStringEquals(expected.value, actual.value, label + " value");
	}

	static function assertStringEquals(expected:String, actual:String, label:String):Void {
		if (expected != actual)
			throw label + ": expected " + expected + " but got " + actual;
	}

	static function assertIntEquals(expected:Int, actual:Int, label:String):Void {
		if (expected != actual)
			throw label + ": expected " + expected + " but got " + actual;
	}

	static function assertTrue(value:Bool, label:String):Void {
		if (!value)
			throw label;
	}
}
