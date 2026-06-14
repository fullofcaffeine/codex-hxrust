package codexhx.runtime.model.streamitem;

class ModelToolArgumentDiffConsumerState {
	public final kind:ModelToolArgumentDiffConsumerKind;
	public final callId:String;
	var input:String;
	var emittedCount:Int;
	var firstProgressSent:Bool;
	var pending:ModelToolArgumentDiffConsumerEvent;

	public function new(kind:ModelToolArgumentDiffConsumerKind, callId:String) {
		this.kind = kind;
		this.callId = callId;
		this.input = "";
		this.emittedCount = 0;
		this.firstProgressSent = false;
		this.pending = null;
	}

	public static function create(toolName:String, callId:String):ModelToolArgumentDiffConsumerState {
		return toolName == "apply_patch" ? new ModelToolArgumentDiffConsumerState(ModelToolArgumentDiffConsumerKind.ApplyPatch, callId) : null;
	}

	public function consume(delta:ModelStreamToolInputDelta):ModelToolArgumentDiffConsumerEvent {
		if (delta == null || delta.status != ModelStreamToolInputDeltaStatus.Accepted) return null;
		input = input + delta.delta;
		final changes = parseApplyPatchChanges(firstProgressSent);
		if (changes.length == 0) return null;
		final event = nextEvent(changes, false);
		if (!firstProgressSent) {
			firstProgressSent = true;
			pending = null;
			return event;
		}
		pending = event;
		return null;
	}

	public function finish():ModelToolArgumentDiffConsumerEvent {
		if (pending != null) {
			final event = new ModelToolArgumentDiffConsumerEvent(kind, callId, pending.changes, true, pending.index);
			pending = null;
			return event;
		}
		if (!firstProgressSent) return null;
		final changes = parseApplyPatchChanges(true);
		if (changes.length == 0) return null;
		return nextEvent(changes, true);
	}

	function nextEvent(changes:Array<ModelPatchFileChange>, finished:Bool):ModelToolArgumentDiffConsumerEvent {
		emittedCount = emittedCount + 1;
		return new ModelToolArgumentDiffConsumerEvent(kind, callId, changes, finished, emittedCount);
	}

	function parseApplyPatchChanges(includeContent:Bool):Array<ModelPatchFileChange> {
		final out:Array<ModelPatchFileChange> = [];
		final lines = input.split("\n");
		var i = 0;
		while (i < lines.length) {
			final line = lines[i];
			if (startsWith(line, "*** Add File: ")) {
				final path = line.substr("*** Add File: ".length);
				final content = includeContent ? collectAddedContent(lines, i + 1) : "";
				out.push(new ModelPatchFileChange(path, ModelPatchFileChangeKind.Add, content, "", ""));
			} else if (startsWith(line, "*** Delete File: ")) {
				final path = line.substr("*** Delete File: ".length);
				out.push(new ModelPatchFileChange(path, ModelPatchFileChangeKind.Delete, "", "", ""));
			} else if (startsWith(line, "*** Update File: ")) {
				final path = line.substr("*** Update File: ".length);
				out.push(new ModelPatchFileChange(path, ModelPatchFileChangeKind.Update, "", collectUnifiedDiff(lines, i + 1), movePathAfter(lines, i + 1)));
			}
			i = i + 1;
		}
		return out;
	}

	function collectAddedContent(lines:Array<String>, start:Int):String {
		var out = "";
		var i = start;
		while (i < lines.length) {
			final line = lines[i];
			if (startsWith(line, "*** ")) break;
			if (startsWith(line, "+")) out = out + line.substr(1) + "\n";
			i = i + 1;
		}
		return out;
	}

	function collectUnifiedDiff(lines:Array<String>, start:Int):String {
		var out = "";
		var i = start;
		while (i < lines.length) {
			final line = lines[i];
			if (startsWith(line, "*** ")) break;
			if (startsWith(line, "@@") || startsWith(line, "+") || startsWith(line, "-")) out = out + line + "\n";
			i = i + 1;
		}
		return out;
	}

	function movePathAfter(lines:Array<String>, start:Int):String {
		var i = start;
		while (i < lines.length) {
			final line = lines[i];
			if (startsWith(line, "*** Move to: ")) return line.substr("*** Move to: ".length);
			if (startsWith(line, "*** ") && !startsWith(line, "*** Move to: ")) return "";
			i = i + 1;
		}
		return "";
	}

	static function startsWith(value:String, prefix:String):Bool {
		return value != null && value.indexOf(prefix) == 0;
	}
}
