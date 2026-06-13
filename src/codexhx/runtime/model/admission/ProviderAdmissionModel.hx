package codexhx.runtime.model.admission;

class ProviderAdmissionModel {
	public final modelId:String;
	public final providerId:String;
	public final contextWindow:Int;

	public function new(modelId:String, providerId:String, contextWindow:Int) {
		this.modelId = modelId;
		this.providerId = providerId;
		this.contextWindow = contextWindow;
	}

	public function valid():Bool {
		return StringTools.trim(modelId).length > 0
			&& StringTools.trim(providerId).length > 0
			&& contextWindow >= 0;
	}

	public function summary():String {
		return "model=" + modelId + ";modelProvider=" + providerId + ";contextWindow=" + Std.string(contextWindow);
	}
}
