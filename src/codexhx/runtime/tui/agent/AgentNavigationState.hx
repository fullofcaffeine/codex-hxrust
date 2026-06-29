package codexhx.runtime.tui.agent;

import codexhx.protocol.ThreadId;

/**
	Tracks the thread order and display metadata used to switch between the main
	thread and side-agent threads in the TUI.
**/
class AgentNavigationState {
	final entries:Array<AgentNavigationEntry>;
	final order:Array<ThreadId>;

	public function new() {
		entries = [];
		order = [];
	}

	public function upsert(threadId:ThreadId, agentNickname:String, agentRole:String, isClosed:Bool):Void {
		final index = indexOf(threadId);
		if (index < 0) {
			order.push(threadId);
			entries.push(new AgentNavigationEntry({
				threadId: threadId,
				agentNickname: agentNickname,
				agentRole: agentRole,
				agentPath: "",
				isRunning: false,
				isClosed: isClosed
			}));
		} else {
			entries[index] = entries[index].withMetadata(agentNickname, agentRole, isClosed);
		}
	}

	public function recordActivity(threadId:ThreadId, agentPath:String, isRunning:Bool):Void {
		final index = indexOf(threadId);
		if (index < 0) {
			order.push(threadId);
			entries.push(new AgentNavigationEntry({
				threadId: threadId,
				agentNickname: "",
				agentRole: "",
				agentPath: agentPath,
				isRunning: isRunning,
				isClosed: false
			}));
		} else {
			entries[index] = entries[index].withActivity(agentPath, isRunning);
		}
	}

	public function setRunning(threadId:ThreadId, isRunning:Bool):Void {
		final index = indexOf(threadId);
		if (index >= 0)
			entries[index] = entries[index].withRunning(isRunning);
	}

	public function setAgentPath(threadId:ThreadId, agentPath:String):Void {
		final trimmed = StringTools.trim(agentPath);
		final index = indexOf(threadId);
		if (index >= 0 && trimmed != "")
			entries[index] = entries[index].withAgentPath(agentPath);
	}

	public function markClosed(threadId:ThreadId):Void {
		final index = indexOf(threadId);
		if (index >= 0) {
			entries[index] = entries[index].closed();
		} else {
			upsert(threadId, "", "", true);
		}
	}

	public function remove(threadId:ThreadId):Void {
		final index = indexOf(threadId);
		if (index >= 0)
			entries.splice(index, 1);
		var i = order.length - 1;
		while (i >= 0) {
			if (sameThread(order[i], threadId))
				order.splice(i, 1);
			i = i - 1;
		}
	}

	public function clear():Void {
		entries.splice(0, entries.length);
		order.splice(0, order.length);
	}

	public function orderedThreadIds():Array<ThreadId> {
		final out:Array<ThreadId> = [];
		for (threadId in order) {
			if (indexOf(threadId) >= 0)
				out.push(threadId);
		}
		return out;
	}

	public function adjacentThreadId(currentThreadId:ThreadId, direction:AgentNavigationDirection):Null<ThreadId> {
		final ids = orderedThreadIds();
		if (ids.length < 2 || currentThreadId == null)
			return null;
		var currentIndex = -1;
		for (i in 0...ids.length) {
			if (sameThread(ids[i], currentThreadId))
				currentIndex = i;
		}
		if (currentIndex < 0)
			return null;
		final nextIndex = switch direction {
			case Next:
				(currentIndex + 1) % ids.length;
			case Previous:
				currentIndex == 0 ? ids.length - 1 : currentIndex - 1;
		}
		return ids[nextIndex];
	}

	public function activeAgentLabel(currentThreadId:ThreadId, primaryThreadId:ThreadId):String {
		if (entries.length <= 1 || currentThreadId == null)
			return "";
		final isPrimary = sameThread(primaryThreadId, currentThreadId);
		final entry = entryFor(currentThreadId);
		if (entry == null)
			return formatAgentPickerItemName("", "", isPrimary);
		final trimmedPath = StringTools.trim(entry.agentPath);
		if (!isPrimary && trimmedPath != "")
			return "`" + entry.agentPath + "`";
		return formatAgentPickerItemName(entry.agentNickname, entry.agentRole, isPrimary);
	}

	public function hasNonPrimaryThread(primaryThreadId:ThreadId):Bool {
		for (entry in entries) {
			if (!sameThread(entry.threadId, primaryThreadId))
				return true;
		}
		return false;
	}

	public function entryFor(threadId:ThreadId):Null<AgentNavigationEntry> {
		final index = indexOf(threadId);
		return index < 0 ? null : entries[index];
	}

	public function entryCount():Int {
		return entries.length;
	}

	public static function pickerSubtitle():String {
		return "Select an agent to watch. Alt+Left previous, Alt+Right next.";
	}

	public static function formatAgentPickerItemName(agentNickname:String, agentRole:String, isPrimary:Bool):String {
		if (isPrimary)
			return "Main [default]";
		final nickname = StringTools.trim(agentNickname);
		final role = StringTools.trim(agentRole);
		if (nickname != "" && role != "")
			return nickname + " [" + role + "]";
		if (nickname != "")
			return nickname;
		if (role != "")
			return "[" + role + "]";
		return "Agent";
	}

	static function sameThread(left:ThreadId, right:ThreadId):Bool {
		return left != null && left.equals(right);
	}

	function indexOf(threadId:ThreadId):Int {
		for (i in 0...entries.length) {
			if (sameThread(entries[i].threadId, threadId))
				return i;
		}
		return -1;
	}
}
