package codexhx.runtime.model.streamitem;

class ModelPatchApprovalKey {
	public final environmentId:String;
	public final path:String;

	public function new(environmentId:String, path:String) {
		this.environmentId = environmentId == null ? "" : environmentId;
		this.path = path == null ? "" : path;
	}

	public function summary():String {
		return "environment=" + environmentId + ";path=" + path;
	}
}
