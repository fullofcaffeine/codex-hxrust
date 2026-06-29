import codexhx.protocol.ThreadId;
import codexhx.runtime.tui.agent.AgentNavigationDirection;
import codexhx.runtime.tui.agent.AgentNavigationEntry;
import codexhx.runtime.tui.agent.AgentNavigationState;

class TuiAgentNavigationHarness {
	static function main():Void {
		testOrderingAndMetadata();
		testAdjacency();
		testActiveLabelsAndPickerFormatting();
		testClosedThreadRemoval();
		Sys.println("tui-agent-navigation ok");
	}

	static function testOrderingAndMetadata():Void {
		final state = new AgentNavigationState();
		final primary = thread("00000000-0000-0000-0000-000000000001");
		final child = thread("00000000-0000-0000-0000-000000000002");
		final grandchild = thread("00000000-0000-0000-0000-000000000003");

		state.upsert(primary, "", "", false);
		state.upsert(child, "Robie", "explorer", false);
		state.recordActivity(grandchild, "agents/robie/notes.md", true);
		state.upsert(child, "Robie", "reviewer", false);

		assertThreadOrder([primary, child, grandchild], state.orderedThreadIds(), "first-seen order survives metadata updates");
		assertEntry(state.entryFor(child), "Robie", "reviewer", "", false, false, "child metadata update");
		assertEntry(state.entryFor(grandchild), "", "", "agents/robie/notes.md", true, false, "activity backfill entry");
		assertIntEquals(3, state.entryCount(), "entry count");
	}

	static function testAdjacency():Void {
		final state = threeThreadState();
		final primary = thread("00000000-0000-0000-0000-000000000011");
		final child = thread("00000000-0000-0000-0000-000000000012");
		final grandchild = thread("00000000-0000-0000-0000-000000000013");
		final missing = thread("00000000-0000-0000-0000-000000000099");

		assertThreadEquals(child, state.adjacentThreadId(primary, AgentNavigationDirection.Next), "next from primary");
		assertThreadEquals(primary, state.adjacentThreadId(child, AgentNavigationDirection.Previous), "previous from child");
		assertThreadEquals(primary, state.adjacentThreadId(grandchild, AgentNavigationDirection.Next), "next wraps");
		assertThreadEquals(grandchild, state.adjacentThreadId(primary, AgentNavigationDirection.Previous), "previous wraps");
		assertNullThread(state.adjacentThreadId(missing, AgentNavigationDirection.Next), "missing current has no adjacent");

		final single = new AgentNavigationState();
		single.upsert(primary, "", "", false);
		assertNullThread(single.adjacentThreadId(primary, AgentNavigationDirection.Next), "single entry has no adjacent");
	}

	static function testActiveLabelsAndPickerFormatting():Void {
		final state = threeThreadState();
		final primary = thread("00000000-0000-0000-0000-000000000011");
		final child = thread("00000000-0000-0000-0000-000000000012");
		final grandchild = thread("00000000-0000-0000-0000-000000000013");
		final missing = thread("00000000-0000-0000-0000-000000000088");

		assertStringEquals("Main [default]", state.activeAgentLabel(primary, primary), "primary label");
		assertStringEquals("Robie [explorer]", state.activeAgentLabel(child, primary), "metadata label");
		assertStringEquals("`agents/robie/side.md`", state.activeAgentLabel(grandchild, primary), "path label");
		assertStringEquals("Agent", state.activeAgentLabel(missing, primary), "missing entry fallback label");
		assertTrue(state.hasNonPrimaryThread(primary), "non-primary present");
		assertStringEquals("Select an agent to watch. Alt+Left previous, Alt+Right next.", AgentNavigationState.pickerSubtitle(), "picker subtitle");
		assertStringEquals("Main [default]", AgentNavigationState.formatAgentPickerItemName("", "", true), "primary picker row");
		assertStringEquals("Robie [reviewer]", AgentNavigationState.formatAgentPickerItemName(" Robie ", " reviewer ", false), "nickname role row");
		assertStringEquals("Robie", AgentNavigationState.formatAgentPickerItemName(" Robie ", "", false), "nickname row");
		assertStringEquals("[reviewer]", AgentNavigationState.formatAgentPickerItemName("", " reviewer ", false), "role row");
		assertStringEquals("Agent", AgentNavigationState.formatAgentPickerItemName("", "", false), "fallback row");

		final single = new AgentNavigationState();
		single.upsert(primary, "", "", false);
		assertStringEquals("", single.activeAgentLabel(primary, primary), "single thread hides label");
		assertFalse(single.hasNonPrimaryThread(primary), "single primary has no non-primary");
	}

	static function testClosedThreadRemoval():Void {
		final state = threeThreadState();
		final primary = thread("00000000-0000-0000-0000-000000000011");
		final child = thread("00000000-0000-0000-0000-000000000012");
		final grandchild = thread("00000000-0000-0000-0000-000000000013");
		final lateClosed = thread("00000000-0000-0000-0000-000000000014");

		state.setRunning(child, true);
		state.markClosed(child);
		assertEntry(state.entryFor(child), "Robie", "explorer", "", false, true, "closed child");
		state.remove(child);
		assertThreadOrder([primary, grandchild], state.orderedThreadIds(), "closed child removed from order");
		assertNullEntry(state.entryFor(child), "closed child removed from entries");
		assertThreadEquals(grandchild, state.adjacentThreadId(primary, AgentNavigationDirection.Next), "adjacent after removal");

		state.markClosed(lateClosed);
		assertEntry(state.entryFor(lateClosed), "", "", "", false, true, "mark closed creates tombstone entry");
		assertThreadOrder([primary, grandchild, lateClosed], state.orderedThreadIds(), "late closed entry ordered");
		state.clear();
		assertIntEquals(0, state.entryCount(), "clear entries");
		assertIntEquals(0, state.orderedThreadIds().length, "clear order");
	}

	static function threeThreadState():AgentNavigationState {
		final state = new AgentNavigationState();
		state.upsert(thread("00000000-0000-0000-0000-000000000011"), "", "", false);
		state.upsert(thread("00000000-0000-0000-0000-000000000012"), "Robie", "explorer", false);
		state.recordActivity(thread("00000000-0000-0000-0000-000000000013"), "agents/robie/side.md", true);
		return state;
	}

	static function thread(value:String):ThreadId {
		return ThreadId.unsafeAssumeValid(value);
	}

	static function assertEntry(entry:Null<AgentNavigationEntry>, nickname:String, role:String, path:String, isRunning:Bool, isClosed:Bool, label:String):Void {
		if (entry == null)
			throw label + ": missing entry";
		assertStringEquals(nickname, entry.agentNickname, label + " nickname");
		assertStringEquals(role, entry.agentRole, label + " role");
		assertStringEquals(path, entry.agentPath, label + " path");
		assertBoolEquals(isRunning, entry.isRunning, label + " running");
		assertBoolEquals(isClosed, entry.isClosed, label + " closed");
	}

	static function assertNullEntry(entry:Null<AgentNavigationEntry>, label:String):Void {
		if (entry != null)
			throw label + ": expected no entry";
	}

	static function assertThreadOrder(expected:Array<ThreadId>, actual:Array<ThreadId>, label:String):Void {
		assertIntEquals(expected.length, actual.length, label + " length");
		for (i in 0...expected.length)
			assertThreadEquals(expected[i], actual[i], label + " item " + i);
	}

	static function assertThreadEquals(expected:ThreadId, actual:Null<ThreadId>, label:String):Void {
		if (actual == null || !expected.equals(actual))
			throw label + ": expected " + expected.toString() + " but got " + threadText(actual);
	}

	static function assertNullThread(actual:Null<ThreadId>, label:String):Void {
		if (actual != null)
			throw label + ": expected null but got " + actual.toString();
	}

	static function threadText(value:Null<ThreadId>):String {
		return value == null ? "<null>" : value.toString();
	}

	static function assertStringEquals(expected:String, actual:String, label:String):Void {
		if (expected != actual)
			throw label + ": expected " + expected + " but got " + actual;
	}

	static function assertIntEquals(expected:Int, actual:Int, label:String):Void {
		if (expected != actual)
			throw label + ": expected " + expected + " but got " + actual;
	}

	static function assertBoolEquals(expected:Bool, actual:Bool, label:String):Void {
		if (expected != actual)
			throw label + ": expected " + expected + " but got " + actual;
	}

	static function assertTrue(value:Bool, label:String):Void {
		if (!value)
			throw label;
	}

	static function assertFalse(value:Bool, label:String):Void {
		if (value)
			throw label;
	}
}
