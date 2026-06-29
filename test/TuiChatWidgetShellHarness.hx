import codexhx.runtime.tui.chatwidget.ChatWidgetShellEffect;
import codexhx.runtime.tui.chatwidget.ChatWidgetShellRenderer;
import codexhx.runtime.tui.chatwidget.ChatWidgetShellState;
import codexhx.runtime.tui.chatwidget.ChatWidgetStatusKind;
import codexhx.runtime.tui.chatwidget.ChatWidgetTranscriptRole;
import codexhx.runtime.tui.terminal.HeadlessTerminalBackend;
import codexhx.runtime.tui.terminal.LiveTerminalBackend;
import codexhx.runtime.tui.terminal.LiveTerminalProbeStatus;
import codexhx.runtime.tui.terminal.TerminalFrame;
import codexhx.runtime.tui.terminal.TerminalInputEvent;
import codexhx.runtime.tui.terminal.TerminalOperationKind;
import codexhx.runtime.tui.terminal.TerminalRestoreReason;
import codexhx.runtime.tui.terminal.TerminalSetup;
import codexhx.runtime.tui.terminal.TerminalSize;

class TuiChatWidgetShellHarness {
	static function main():Void {
		testStateAndEffects();
		testRenderFrameFacts();
		testTranscriptViewportKeepsLatestRows();
		testHeadlessBackendDrawsShellFrame();
		testLiveBackendDrawsShellFrameAndRestores();
		Sys.println("tui-chatwidget-shell ok");
	}

	static function testStateAndEffects():Void {
		final state = ChatWidgetShellState.initial("gpt-live");
		assertStringEquals("gpt-live", state.modelLabel(), "initial model");
		assertStatusKindEquals(ChatWidgetStatusKind.Idle, state.statusKind(), "initial status kind");
		assertStringEquals("idle", state.statusText(), "initial status text");
		assertIntEquals(0, state.transcriptCount(), "initial transcript count");

		assertDrawOnly(state.appendTranscript(ChatWidgetTranscriptRole.System, "session ready"), "append system");
		assertIntEquals(1, state.transcriptCount(), "after append count");
		assertStringEquals("system> session ready", state.transcriptAt(0).renderText(), "system row text");

		assertDrawOnly(state.applyInput(TerminalInputEvent.Text("hello")), "typed composer text");
		assertStringEquals("hello", state.composer().buffer(), "composer buffer");
		final submitEffects = state.applyInput(TerminalInputEvent.Submit);
		assertPromptSubmit("hello", submitEffects, "submit effects");
		assertIntEquals(2, state.transcriptCount(), "transcript after submit");
		assertStringEquals("user> hello", state.transcriptAt(1).renderText(), "submitted user row");
		assertStringEquals("", state.composer().buffer(), "composer after submit");

		assertDrawOnly(state.setStatus(ChatWidgetStatusKind.Working, "thinking"), "set working status");
		assertStatusKindEquals(ChatWidgetStatusKind.Working, state.statusKind(), "working status kind");
		assertStringEquals("thinking", state.statusText(), "working status text");
		assertDrawOnly(state.setModelLabel("gpt-5.5-pro"), "set model");
		assertStringEquals("gpt-5.5-pro", state.modelLabel(), "updated model");
	}

	static function testRenderFrameFacts():Void {
		final state = ChatWidgetShellState.initial("gpt-live");
		state.appendTranscript(ChatWidgetTranscriptRole.System, "session ready");
		state.appendTranscript(ChatWidgetTranscriptRole.Assistant, "How can I help?");
		state.applyInput(TerminalInputEvent.Text("draft"));

		final frame = ChatWidgetShellRenderer.render(state, TerminalSize.of(80, 12));
		assertStringEquals("Codex", frame.title, "frame title");
		assertStringEquals("Codex | model: gpt-live | status: idle", frame.lineAt(0), "header");
		assertStringEquals("--------", frame.lineAt(1), "top separator");
		assertStringEquals("system> session ready", frame.lineAt(2), "first transcript row");
		assertStringEquals("assistant> How can I help?", frame.lineAt(3), "assistant transcript row");
		assertStringEquals("--------", frame.lineAt(4), "bottom separator");
		assertStringEquals("status: idle | rows: 2 | rev: 3", frame.lineAt(5), "footer");
		assertStringEquals("input> draft", frame.lineAt(6), "composer line");
		assertIntEquals(7, frame.lineCount(), "frame line count");
		assertIntEquals(6, frame.cursorRow, "cursor row");
		assertIntEquals(12, frame.cursorColumn, "cursor column");
	}

	static function testTranscriptViewportKeepsLatestRows():Void {
		final state = ChatWidgetShellState.initial("gpt-live");
		state.appendTranscript(ChatWidgetTranscriptRole.System, "row 0");
		state.appendTranscript(ChatWidgetTranscriptRole.Assistant, "row 1");
		state.appendTranscript(ChatWidgetTranscriptRole.User, "row 2");
		state.appendTranscript(ChatWidgetTranscriptRole.Assistant, "row 3");
		state.appendTranscript(ChatWidgetTranscriptRole.User, "row 4");
		final frame = ChatWidgetShellRenderer.render(state, TerminalSize.of(80, 8));
		assertStringEquals("user> row 2", frame.lineAt(2), "oldest visible row");
		assertStringEquals("assistant> row 3", frame.lineAt(3), "middle visible row");
		assertStringEquals("user> row 4", frame.lineAt(4), "latest visible row");
		assertStringEquals("status: idle | rows: 5 | rev: 5", frame.lineAt(6), "truncated footer");
	}

	static function testHeadlessBackendDrawsShellFrame():Void {
		final backend = new HeadlessTerminalBackend([]);
		assertTrue(backend.setup(TerminalSetup.headless(TerminalSize.of(80, 12))).ok, "headless setup");
		final state = ChatWidgetShellState.initial("gpt-live");
		state.appendTranscript(ChatWidgetTranscriptRole.Assistant, "ready");
		state.applyInput(TerminalInputEvent.Text("ask"));

		final frame = ChatWidgetShellRenderer.render(state, TerminalSize.of(80, 12));
		final draw = backend.draw(frame);
		assertTrue(draw.ok, "headless shell draw");
		assertOperationKindEquals(TerminalOperationKind.DrawComplete, draw.kind, "headless draw kind");
		assertStringEquals("Codex | model: gpt-live | status: idle", backend.currentFrame().lineAt(0), "headless header");
		assertStringEquals("assistant> ready", backend.currentFrame().lineAt(2), "headless body");
		assertStringEquals("input> ask", backend.currentFrame().lineAt(5), "headless composer");
		assertIntEquals(1, backend.drawCount(), "headless draw count");
		backend.restore(TerminalRestoreReason.NormalExit);
	}

	static function testLiveBackendDrawsShellFrameAndRestores():Void {
		final backend = new LiveTerminalBackend();
		assertTrue(backend.setup(TerminalSetup.live(TerminalSize.of(80, 12))).ok, "live setup should be accepted or CI-skipped");
		assertStatusAccepted(backend.lastReport().status, "live setup status");
		final state = ChatWidgetShellState.initial("gpt-live");
		state.appendTranscript(ChatWidgetTranscriptRole.System, "live shell");
		state.applyInput(TerminalInputEvent.Text("draft"));

		final frame = ChatWidgetShellRenderer.render(state, TerminalSize.of(80, 12));
		final draw = backend.draw(frame);
		assertTrue(draw.ok, "live shell draw should be accepted or CI-skipped");
		assertOperationKindEquals(TerminalOperationKind.DrawComplete, draw.kind, "live draw kind");
		assertStatusAccepted(backend.lastReport().status, "live draw status");
		assertStringEquals("input> draft", backend.currentFrame().lineAt(5), "live current composer");
		final restore = backend.restore(TerminalRestoreReason.NormalExit);
		assertTrue(restore.restored, "live shell path should restore");
	}

	static function assertDrawOnly(effects:Array<ChatWidgetShellEffect>, label:String):Void {
		assertIntEquals(1, effects.length, label + " effect count");
		switch effects[0] {
			case ChatWidgetShellEffect.DrawRequested:
			case _:
				fail(label + ": expected draw request");
		}
	}

	static function assertPromptSubmit(expected:String, effects:Array<ChatWidgetShellEffect>, label:String):Void {
		assertIntEquals(2, effects.length, label + " effect count");
		switch effects[0] {
			case ChatWidgetShellEffect.PromptSubmitted(text):
				assertStringEquals(expected, text, label + " submitted text");
			case _:
				fail(label + ": expected prompt submit");
		}
		switch effects[1] {
			case ChatWidgetShellEffect.DrawRequested:
			case _:
				fail(label + ": expected draw request");
		}
	}

	static function assertStatusAccepted(status:LiveTerminalProbeStatus, label:String):Void {
		if (!status.okForCi())
			throw label + ": " + status.text();
	}

	static function assertOperationKindEquals(expected:TerminalOperationKind, actual:TerminalOperationKind, label:String):Void {
		assertStringEquals(operationKindText(expected), operationKindText(actual), label);
	}

	static function operationKindText(kind:TerminalOperationKind):String {
		return kind;
	}

	static function assertStatusKindEquals(expected:ChatWidgetStatusKind, actual:ChatWidgetStatusKind, label:String):Void {
		assertStringEquals(statusKindText(expected), statusKindText(actual), label);
	}

	static function statusKindText(kind:ChatWidgetStatusKind):String {
		return ChatWidgetShellState.statusKindText(kind);
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

	static function fail(message:String):Void {
		throw message;
	}
}
