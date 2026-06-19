package codexhx.runtime.model.streamitem;

class ModelPatchApplicationOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final status:ModelPatchApplyStatus;
	public final stdout:String;
	public final stderr:String;
	public final beforeFiles:Array<ModelPatchVirtualFile>;
	public final afterFiles:Array<ModelPatchVirtualFile>;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(ok:Bool, code:String, requestId:String, status:ModelPatchApplyStatus, stdout:String, stderr:String,
			beforeFiles:Array<ModelPatchVirtualFile>, afterFiles:Array<ModelPatchVirtualFile>, liveNetworkAttempted:Bool, realFilesystemMutated:Bool,
			toolExecutedOutsideFixture:Bool, errorMessage:String) {
		this.ok = ok;
		this.code = code;
		this.requestId = requestId == null ? "" : requestId;
		this.status = status;
		this.stdout = stdout == null ? "" : stdout;
		this.stderr = stderr == null ? "" : stderr;
		this.beforeFiles = beforeFiles == null ? [] : beforeFiles;
		this.afterFiles = afterFiles == null ? [] : afterFiles;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";status=" + status + ";stdout=" + stdout + ";stderr=" + stderr
			+ ";before=[" + fileSummaries(beforeFiles) + "]" + ";after=[" + fileSummaries(afterFiles) + "]" + ";liveNetworkAttempted="
			+ boolText(liveNetworkAttempted) + ";realFilesystemMutated=" + boolText(realFilesystemMutated) + ";toolExecutedOutsideFixture="
			+ boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function fileSummaries(files:Array<ModelPatchVirtualFile>):String {
		final parts:Array<String> = [];
		for (file in files)
			parts.push("path=" + file.path + ";content=" + file.content);
		return parts.join("||");
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
