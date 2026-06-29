package codexhx.runtime.tui.smoke;

typedef TuiSmokeLoadedThreadsPlanFields = {
	final primaryThreadId:String;
	final allowModelCall:Bool;
	final allowAppServerRequest:Bool;
	final allowFilesystemMutation:Bool;
	final threads:Array<TuiSmokeLoadedThread>;
	final expected:Array<TuiSmokeLoadedSubagentThread>;
	final expectedInvalidSkipped:Int;
	final expectedUnrelatedSkipped:Int;
	final expectedNonSpawnSkipped:Int;
	final failureCode:String;
	final noModelCall:Bool;
	final noAppServerRequest:Bool;
	final noFilesystemMutation:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeLoadedThreadsPlan {
	public final primaryThreadId:String;
	public final allowModelCall:Bool;
	public final allowAppServerRequest:Bool;
	public final allowFilesystemMutation:Bool;
	public final threads:Array<TuiSmokeLoadedThread>;
	public final expected:Array<TuiSmokeLoadedSubagentThread>;
	public final expectedInvalidSkipped:Int;
	public final expectedUnrelatedSkipped:Int;
	public final expectedNonSpawnSkipped:Int;
	public final failureCode:String;
	public final noModelCall:Bool;
	public final noAppServerRequest:Bool;
	public final noFilesystemMutation:Bool;
	public final unsupportedRejected:Bool;

	public function enabled():Bool {
		return !allowModelCall && !allowAppServerRequest && !allowFilesystemMutation && primaryThreadId != "" && threads != null;
	}

	public function discovered():Array<TuiSmokeLoadedSubagentThread> {
		return discover(primaryThreadId, threads);
	}

	public static function discover(primaryThreadId:String, threads:Array<TuiSmokeLoadedThread>):Array<TuiSmokeLoadedSubagentThread> {
		final included:Array<String> = [];
		final pending:Array<String> = [primaryThreadId];
		while (pending.length > 0) {
			final parentThreadId = pending.pop();
			for (thread in threads) {
				if (!thread.validThreadId || contains(included, thread.threadId))
					continue;
				if (thread.source != TuiSmokeLoadedThreadSourceKind.ThreadSpawn)
					continue;
				if (thread.parentThreadId != parentThreadId)
					continue;
				included.push(thread.threadId);
				pending.push(thread.threadId);
			}
		}

		final out:Array<TuiSmokeLoadedSubagentThread> = [];
		for (threadId in included) {
			final thread = getThread(threads, threadId);
			if (thread != null) {
				out.push(new TuiSmokeLoadedSubagentThread({
					threadId: thread.threadId,
					agentNickname: thread.agentNickname,
					agentRole: thread.agentRole,
					agentPath: thread.agentPath
				}));
			}
		}
		out.sort(compareLoadedSubagents);
		return out;
	}

	public function invalidSkipped():Int {
		var count = 0;
		for (thread in threads) {
			if (!thread.validThreadId)
				count = count + 1;
		}
		return count;
	}

	public function nonSpawnSkipped():Int {
		var count = 0;
		for (thread in threads) {
			if (thread.validThreadId && thread.threadId != primaryThreadId && thread.source != TuiSmokeLoadedThreadSourceKind.ThreadSpawn)
				count = count + 1;
		}
		return count;
	}

	public function unrelatedSkipped(discovered:Array<TuiSmokeLoadedSubagentThread>):Int {
		var count = 0;
		for (thread in threads) {
			if (!thread.validThreadId || thread.threadId == primaryThreadId || thread.source != TuiSmokeLoadedThreadSourceKind.ThreadSpawn)
				continue;
			if (!containsLoaded(discovered, thread.threadId))
				count = count + 1;
		}
		return count;
	}

	public function expectedMatches(actual:Array<TuiSmokeLoadedSubagentThread>):Bool {
		if (actual.length != expected.length)
			return false;
		for (i in 0...actual.length) {
			if (actual[i].summary() != expected[i].summary())
				return false;
		}
		return true;
	}

	public function summary(threads:Array<TuiSmokeLoadedSubagentThread>):String {
		final parts:Array<String> = [];
		for (thread in threads) {
			parts.push(thread.summary());
		}
		return parts.join("|");
	}

	static function getThread(threads:Array<TuiSmokeLoadedThread>, threadId:String):Null<TuiSmokeLoadedThread> {
		for (thread in threads) {
			if (thread.threadId == threadId)
				return thread;
		}
		return null;
	}

	static function contains(values:Array<String>, value:String):Bool {
		for (candidate in values) {
			if (candidate == value)
				return true;
		}
		return false;
	}

	static function containsLoaded(values:Array<TuiSmokeLoadedSubagentThread>, threadId:String):Bool {
		for (candidate in values) {
			if (candidate.threadId == threadId)
				return true;
		}
		return false;
	}

	static function compareLoadedSubagents(left:TuiSmokeLoadedSubagentThread, right:TuiSmokeLoadedSubagentThread):Int {
		if (left.threadId < right.threadId)
			return -1;
		if (left.threadId > right.threadId)
			return 1;
		return 0;
	}
}
