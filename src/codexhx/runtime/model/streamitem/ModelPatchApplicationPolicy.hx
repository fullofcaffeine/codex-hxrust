package codexhx.runtime.model.streamitem;

class ModelPatchApplicationPolicy {
	public static function apply(request:ModelPatchApplicationRequest):ModelPatchApplicationOutcome {
		if (request == null) return failure("", ModelPatchApplyStatus.Failed, "", "", [], "missing patch application request");
		if (request.verificationOutcome == null || !request.verificationOutcome.ok || request.verificationOutcome.endEvent == null) {
			return failure(request.requestId, ModelPatchApplyStatus.Failed, "", "", request.beforeFiles, "patch application requires a verified patch outcome");
		}

		final endEvent = request.verificationOutcome.endEvent;
		final before = copyFiles(request.beforeFiles);
		if (endEvent.status != ModelPatchApplyStatus.Completed) {
			return success(request.requestId, endEvent.status, endEvent.stdout, endEvent.stderr, before, copyFiles(before));
		}

		final after = copyFiles(before);
		for (change in endEvent.changes) {
			final error = applyChange(after, change);
			if (error.length > 0) return failure(request.requestId, ModelPatchApplyStatus.Failed, endEvent.stdout, error, before, error);
		}
		return success(request.requestId, ModelPatchApplyStatus.Completed, endEvent.stdout, endEvent.stderr, before, after);
	}

	static function applyChange(files:Array<ModelPatchVirtualFile>, change:ModelPatchFileChange):String {
		if (change.kind == ModelPatchFileChangeKind.Add) {
			putFile(files, change.path, change.content);
			return "";
		}
		if (change.kind == ModelPatchFileChangeKind.Delete) {
			if (!removeFile(files, change.path)) return "delete source missing from virtual workspace: " + change.path;
			return "";
		}
		if (change.kind == ModelPatchFileChangeKind.Update) {
			final current = fileContent(files, change.path);
			final updated = applyUpdateChunks(current, change);
			if (updated == null) return "update chunk did not match virtual workspace: " + change.path;
			if (change.movePath.length > 0) {
				removeFile(files, change.path);
				putFile(files, change.movePath, updated);
			} else {
				putFile(files, change.path, updated);
			}
			return "";
		}
		return "unsupported patch change kind: " + change.kind;
	}

	static function applyUpdateChunks(content:String, change:ModelPatchFileChange):String {
		var current = content == null ? "" : content;
		for (chunk in change.chunks) {
			final oldBlock = linesBlock(chunk.oldLines);
			final newBlock = linesBlock(chunk.newLines);
			if (oldBlock.length == 0) {
				current = current + newBlock;
			} else {
				final index = current.indexOf(oldBlock);
				if (index < 0) return null;
				current = current.substr(0, index) + newBlock + current.substr(index + oldBlock.length);
			}
			if (chunk.isEndOfFile) current = trimTrailingBlankLines(current);
		}
		return current;
	}

	static function linesBlock(lines:Array<String>):String {
		if (lines == null || lines.length == 0) return "";
		return lines.join("\n") + "\n";
	}

	static function trimTrailingBlankLines(value:String):String {
		var out = value;
		while (out.length >= 2 && out.substr(out.length - 2) == "\n\n") out = out.substr(0, out.length - 1);
		return out;
	}

	static function copyFiles(files:Array<ModelPatchVirtualFile>):Array<ModelPatchVirtualFile> {
		final out:Array<ModelPatchVirtualFile> = [];
		if (files == null) return out;
		for (file in files) out.push(new ModelPatchVirtualFile(file.path, file.content));
		return out;
	}

	static function fileContent(files:Array<ModelPatchVirtualFile>, path:String):String {
		for (file in files) if (file.path == path) return file.content;
		return "";
	}

	static function putFile(files:Array<ModelPatchVirtualFile>, path:String, content:String):Void {
		var i = 0;
		while (i < files.length) {
			if (files[i].path == path) {
				files[i] = new ModelPatchVirtualFile(path, content);
				return;
			}
			i = i + 1;
		}
		files.push(new ModelPatchVirtualFile(path, content));
	}

	static function removeFile(files:Array<ModelPatchVirtualFile>, path:String):Bool {
		var i = 0;
		while (i < files.length) {
			if (files[i].path == path) {
				files.splice(i, 1);
				return true;
			}
			i = i + 1;
		}
		return false;
	}

	static function success(
		requestId:String,
		status:ModelPatchApplyStatus,
		stdout:String,
		stderr:String,
		beforeFiles:Array<ModelPatchVirtualFile>,
		afterFiles:Array<ModelPatchVirtualFile>
	):ModelPatchApplicationOutcome {
		return new ModelPatchApplicationOutcome(
			true,
			"patch_application_result_modeled",
			requestId,
			status,
			stdout,
			stderr,
			beforeFiles,
			afterFiles,
			false,
			false,
			false,
			""
		);
	}

	static function failure(
		requestId:String,
		status:ModelPatchApplyStatus,
		stdout:String,
		stderr:String,
		beforeFiles:Array<ModelPatchVirtualFile>,
		errorMessage:String
	):ModelPatchApplicationOutcome {
		return new ModelPatchApplicationOutcome(
			false,
			"patch_application_failed",
			requestId,
			status,
			stdout,
			stderr,
			copyFiles(beforeFiles),
			copyFiles(beforeFiles),
			false,
			false,
			false,
			errorMessage
		);
	}
}
