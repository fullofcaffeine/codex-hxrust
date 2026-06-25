package codexhx.runtime.tui.smoke;

class TuiSmokeAgentNavigationState {
	final entries:Array<TuiSmokeAgentNavigationEntry>;
	final order:Array<String>;

	public function new() {
		entries = [];
		order = [];
	}

	public function upsert(threadId:String, agentNickname:String, agentRole:String, isClosed:Bool):Void {
		final index = indexOf(threadId);
		if (index < 0) {
			order.push(threadId);
			entries.push(new TuiSmokeAgentNavigationEntry({
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

	public function recordActivity(threadId:String, agentPath:String, isRunning:Bool):Void {
		final index = indexOf(threadId);
		if (index < 0) {
			order.push(threadId);
			entries.push(new TuiSmokeAgentNavigationEntry({
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

	public function setRunning(threadId:String, isRunning:Bool):Void {
		final index = indexOf(threadId);
		if (index >= 0)
			entries[index] = entries[index].withRunning(isRunning);
	}

	public function setAgentPath(threadId:String, agentPath:String):Void {
		final trimmed = StringTools.trim(agentPath);
		final index = indexOf(threadId);
		if (index >= 0 && trimmed != "")
			entries[index] = entries[index].withAgentPath(agentPath);
	}

	public function markClosed(threadId:String):Void {
		final index = indexOf(threadId);
		if (index >= 0) {
			entries[index] = entries[index].closed();
		} else {
			upsert(threadId, "", "", true);
		}
	}

	public function remove(threadId:String):Void {
		final index = indexOf(threadId);
		if (index >= 0)
			entries.splice(index, 1);
		var i = order.length - 1;
		while (i >= 0) {
			if (order[i] == threadId)
				order.splice(i, 1);
			i = i - 1;
		}
	}

	public function clear():Void {
		entries.splice(0, entries.length);
		order.splice(0, order.length);
	}

	public function orderedThreadIds():Array<String> {
		final out:Array<String> = [];
		for (threadId in order) {
			if (indexOf(threadId) >= 0)
				out.push(threadId);
		}
		return out;
	}

	public function adjacentThreadId(currentThreadId:String, direction:TuiSmokeAgentNavigationDirectionKind):String {
		final ids = orderedThreadIds();
		if (ids.length < 2 || currentThreadId == "")
			return "";
		var currentIndex = -1;
		for (i in 0...ids.length) {
			if (ids[i] == currentThreadId)
				currentIndex = i;
		}
		if (currentIndex < 0)
			return "";
		final nextIndex = switch direction {
			case TuiSmokeAgentNavigationDirectionKind.Next:
				(currentIndex + 1) % ids.length;
			case TuiSmokeAgentNavigationDirectionKind.Previous:
				currentIndex == 0 ? ids.length - 1 : currentIndex - 1;
			case _:
				-1;
		}
		return nextIndex < 0 ? "" : ids[nextIndex];
	}

	public function activeAgentLabel(currentThreadId:String, primaryThreadId:String):String {
		if (entries.length <= 1 || currentThreadId == "")
			return "";
		final isPrimary = primaryThreadId == currentThreadId;
		final entry = get(currentThreadId);
		if (entry == null)
			return formatAgentPickerItemName("", "", isPrimary);
		final trimmedPath = StringTools.trim(entry.agentPath);
		if (!isPrimary && trimmedPath != "")
			return "`" + entry.agentPath + "`";
		return formatAgentPickerItemName(entry.agentNickname, entry.agentRole, isPrimary);
	}

	public function hasNonPrimaryThread(primaryThreadId:String):Bool {
		for (entry in entries) {
			if (entry.threadId != primaryThreadId)
				return true;
		}
		return false;
	}

	public static function pickerSubtitle():String {
		return "Select an agent to watch. Alt+Left previous, Alt+Right next.";
	}

	function get(threadId:String):Null<TuiSmokeAgentNavigationEntry> {
		final index = indexOf(threadId);
		return index < 0 ? null : entries[index];
	}

	function indexOf(threadId:String):Int {
		for (i in 0...entries.length) {
			if (entries[i].threadId == threadId)
				return i;
		}
		return -1;
	}

	static function formatAgentPickerItemName(agentNickname:String, agentRole:String, isPrimary:Bool):String {
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
}
