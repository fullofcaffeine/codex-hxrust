package codexhx.runtime.model.streamitem;

class ModelToolArgumentDiffConsumerState {
	public final kind:ModelToolArgumentDiffConsumerKind;
	public final callId:String;
	var lineBuffer:String;
	var mode:ModelPatchParserMode;
	var hunks:Array<ModelPatchFileChange>;
	var lineNumber:Int;
	var updateHunkLineNumber:Int;
	var error:ModelPatchParseError;
	var emittedCount:Int;
	var firstProgressSent:Bool;
	var pending:ModelToolArgumentDiffConsumerEvent;

	public function new(kind:ModelToolArgumentDiffConsumerKind, callId:String) {
		this.kind = kind;
		this.callId = callId;
		this.lineBuffer = "";
		this.mode = ModelPatchParserMode.NotStarted;
		this.hunks = [];
		this.lineNumber = 0;
		this.updateHunkLineNumber = 0;
		this.error = null;
		this.emittedCount = 0;
		this.firstProgressSent = false;
		this.pending = null;
	}

	public static function create(toolName:String, callId:String):ModelToolArgumentDiffConsumerState {
		return toolName == "apply_patch" ? new ModelToolArgumentDiffConsumerState(ModelToolArgumentDiffConsumerKind.ApplyPatch, callId) : null;
	}

	public function consume(delta:ModelStreamToolInputDelta):ModelToolArgumentDiffConsumerEvent {
		if (delta == null || delta.status != ModelStreamToolInputDeltaStatus.Accepted) return null;
		pushDelta(delta.delta);
		if (hasError()) return null;
		final changes = snapshotChanges(!firstProgressSent);
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
		finishParser();
		if (hasError()) return null;
		if (pending != null) {
			final event = new ModelToolArgumentDiffConsumerEvent(kind, callId, pending.changes, true, pending.index);
			pending = null;
			return event;
		}
		if (!firstProgressSent) return null;
		final changes = snapshotChanges(false);
		if (changes.length == 0) return null;
		return nextEvent(changes, true);
	}

	public function hasError():Bool {
		return error != null;
	}

	public function errorSummary():String {
		return error == null ? "" : error.summary();
	}

	function nextEvent(changes:Array<ModelPatchFileChange>, finished:Bool):ModelToolArgumentDiffConsumerEvent {
		emittedCount = emittedCount + 1;
		return new ModelToolArgumentDiffConsumerEvent(kind, callId, changes, finished, emittedCount);
	}

	function pushDelta(delta:String):Void {
		var i = 0;
		while (i < delta.length && !hasError()) {
			final ch = delta.charAt(i);
			if (ch == "\n") {
				var line = lineBuffer;
				lineBuffer = "";
				if (endsWith(line, "\r")) line = line.substr(0, line.length - 1);
				lineNumber = lineNumber + 1;
				processLine(line);
			} else {
				lineBuffer = lineBuffer + ch;
			}
			i = i + 1;
		}
	}

	function finishParser():Void {
		if (hasError()) return;
		if (lineBuffer.length > 0) {
			final line = lineBuffer;
			lineBuffer = "";
			lineNumber = lineNumber + 1;
			if (trim(line) == "*** End Patch") {
				ensureUpdateHunkIsNotEmpty(trim(line));
				if (!hasError()) mode = ModelPatchParserMode.EndedPatch;
			} else {
				processLine(line);
			}
		}
		if (!hasError() && mode != ModelPatchParserMode.EndedPatch) {
			failPatch("The last line of the patch must be '*** End Patch'");
		}
	}

	function processLine(line:String):Void {
		final trimmed = trim(line);
		if (mode == ModelPatchParserMode.NotStarted) {
			if (trimmed == "*** Begin Patch") {
				mode = ModelPatchParserMode.StartedPatch;
				return;
			}
			failPatch("The first line of the patch must be '*** Begin Patch'");
		} else if (mode == ModelPatchParserMode.StartedPatch) {
			if (startsWith(line, "*** Environment ID: ")) return;
			if (handleHunkHeadersAndEndPatch(trimmed)) return;
			failHunk("'" + trimmed + "' is not a valid hunk header. Valid hunk headers: '*** Add File: {path}', '*** Delete File: {path}', '*** Update File: {path}'", lineNumber);
		} else if (mode == ModelPatchParserMode.AddFile) {
			if (handleHunkHeadersAndEndPatch(trimmed)) return;
			if (startsWith(line, "+")) {
				final add = lastChange();
				if (add != null) add.appendContent(line.substr(1) + "\n");
				return;
			}
			failHunk("'" + trimmed + "' is not a valid hunk header. Valid hunk headers: '*** Add File: {path}', '*** Delete File: {path}', '*** Update File: {path}'", lineNumber);
		} else if (mode == ModelPatchParserMode.DeleteFile) {
			if (handleHunkHeadersAndEndPatch(trimmed)) return;
			failHunk("'" + trimmed + "' is not a valid hunk header. Valid hunk headers: '*** Add File: {path}', '*** Delete File: {path}', '*** Update File: {path}'", lineNumber);
		} else if (mode == ModelPatchParserMode.UpdateFile) {
			processUpdateLine(line, trimEnd(line));
		}
	}

	function processUpdateLine(line:String, updateLine:String):Void {
		if (handleHunkHeadersAndEndPatch(updateLine)) return;
		final update = lastChange();
		if (update == null) {
			failHunk("Unexpected line found in update hunk: '" + line + "'. Every line should start with ' ' (context line), '+' (added line), or '-' (removed line)", lineNumber);
			return;
		}
		if (update.chunks.length == 0 && update.movePath.length == 0 && startsWith(updateLine, "*** Move to: ")) {
			update.setMovePath(updateLine.substr("*** Move to: ".length));
			return;
		}
		if ((updateLine == "@@" || startsWith(updateLine, "@@ ")) && lastChunkIsEmpty(update)) {
			failHunk("Unexpected line found in update hunk: '" + line + "'. Every line should start with ' ' (context line), '+' (added line), or '-' (removed line)", lineNumber);
			return;
		}
		if (updateLine == "@@") {
			update.addChunk(new ModelPatchUpdateChunk(""));
			return;
		}
		if (startsWith(updateLine, "@@ ")) {
			update.addChunk(new ModelPatchUpdateChunk(updateLine.substr("@@ ".length)));
			return;
		}
		if (updateLine == "*** End of File") {
			if (lastChunkIsEmpty(update)) {
				failHunk("Update hunk does not contain any lines", lineNumber);
				return;
			}
			final eofChunk = lastChunk(update);
			if (eofChunk != null) eofChunk.isEndOfFile = true;
			return;
		}
		if (line == "") {
			ensureChunk(update).appendContext("");
			return;
		}
		if (startsWith(line, " ")) {
			ensureChunk(update).appendContext(line.substr(1));
			return;
		}
		if (startsWith(line, "+")) {
			ensureChunk(update).appendAdded(line.substr(1));
			return;
		}
		if (startsWith(line, "-")) {
			ensureChunk(update).appendRemoved(line.substr(1));
			return;
		}
		if (lastChunkHasLines(update)) {
			failHunk("Expected update hunk to start with a @@ context marker, got: '" + line + "'", lineNumber);
			return;
		}
		failHunk("Unexpected line found in update hunk: '" + line + "'. Every line should start with ' ' (context line), '+' (added line), or '-' (removed line)", lineNumber);
	}

	function handleHunkHeadersAndEndPatch(line:String):Bool {
		if (line == "*** End Patch") {
			ensureUpdateHunkIsNotEmpty(line);
			if (!hasError()) mode = ModelPatchParserMode.EndedPatch;
			return true;
		}
		if (startsWith(line, "*** Add File: ")) {
			ensureUpdateHunkIsNotEmpty(line);
			if (hasError()) return true;
			hunks.push(ModelPatchFileChange.add(line.substr("*** Add File: ".length)));
			mode = ModelPatchParserMode.AddFile;
			return true;
		}
		if (startsWith(line, "*** Delete File: ")) {
			ensureUpdateHunkIsNotEmpty(line);
			if (hasError()) return true;
			hunks.push(ModelPatchFileChange.deleteFile(line.substr("*** Delete File: ".length)));
			mode = ModelPatchParserMode.DeleteFile;
			return true;
		}
		if (startsWith(line, "*** Update File: ")) {
			ensureUpdateHunkIsNotEmpty(line);
			if (hasError()) return true;
			hunks.push(ModelPatchFileChange.update(line.substr("*** Update File: ".length)));
			mode = ModelPatchParserMode.UpdateFile;
			updateHunkLineNumber = lineNumber;
			return true;
		}
		return false;
	}

	function ensureUpdateHunkIsNotEmpty(line:String):Void {
		final update = lastChange();
		if (mode != ModelPatchParserMode.UpdateFile || update == null || update.kind != ModelPatchFileChangeKind.Update) return;
		if (update.chunks.length == 0) {
			failHunk("Update file hunk for path '" + update.path + "' is empty", updateHunkLineNumber);
			return;
		}
		if (lastChunkIsEmpty(update)) {
			if (line == "*** End Patch") {
				failHunk("Update hunk does not contain any lines", lineNumber);
			} else {
				failHunk("Unexpected line found in update hunk: '" + line + "'. Every line should start with ' ' (context line), '+' (added line), or '-' (removed line)", lineNumber);
			}
		}
	}

	function snapshotChanges(firstProgress:Bool):Array<ModelPatchFileChange> {
		final out:Array<ModelPatchFileChange> = [];
		for (hunk in hunks) out.push(firstProgress && hunk.kind == ModelPatchFileChangeKind.Add ? hunk.withoutAddContent() : hunk.copy());
		return out;
	}

	function ensureChunk(change:ModelPatchFileChange):ModelPatchUpdateChunk {
		if (change.chunks.length == 0) change.addChunk(new ModelPatchUpdateChunk(""));
		return lastChunk(change);
	}

	function lastChange():ModelPatchFileChange {
		return hunks.length == 0 ? null : hunks[hunks.length - 1];
	}

	function lastChunk(change:ModelPatchFileChange):ModelPatchUpdateChunk {
		return change == null || change.chunks.length == 0 ? null : change.chunks[change.chunks.length - 1];
	}

	function lastChunkIsEmpty(change:ModelPatchFileChange):Bool {
		final chunk = lastChunk(change);
		return chunk != null && chunk.isEmpty();
	}

	function lastChunkHasLines(change:ModelPatchFileChange):Bool {
		final chunk = lastChunk(change);
		return chunk != null && !chunk.isEmpty();
	}

	function failPatch(message:String):Void {
		if (error == null) error = new ModelPatchParseError(ModelPatchParseErrorKind.InvalidPatch, message, lineNumber);
	}

	function failHunk(message:String, line:Int):Void {
		if (error == null) error = new ModelPatchParseError(ModelPatchParseErrorKind.InvalidHunk, message, line);
	}

	static function startsWith(value:String, prefix:String):Bool {
		return value != null && value.indexOf(prefix) == 0;
	}

	static function endsWith(value:String, suffix:String):Bool {
		return value != null && value.length >= suffix.length && value.substr(value.length - suffix.length) == suffix;
	}

	static function trim(value:String):String {
		return StringTools.trim(value);
	}

	static function trimEnd(value:String):String {
		var end = value.length;
		while (end > 0) {
			final ch = value.charAt(end - 1);
			if (ch != " " && ch != "\t" && ch != "\r") break;
			end = end - 1;
		}
		return value.substr(0, end);
	}
}
