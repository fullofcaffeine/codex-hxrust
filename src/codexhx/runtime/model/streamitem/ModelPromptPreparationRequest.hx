package codexhx.runtime.model.streamitem;

class ModelPromptPreparationRequest {
	public final requestId:String;
	public final hookRecordingOutcome:ModelPendingInputHookRecordingOutcome;
	public final historyItemCount:Int;
	public final imageItemCountBefore:Int;
	public final modelSupportsImages:Bool;
	public final windowId:String;
	public final metadataHeaderEnabled:Bool;
	public final nextSamplingRequestIndex:Int;
	public final secretProbe:String;

	public function new(
		requestId:String,
		hookRecordingOutcome:ModelPendingInputHookRecordingOutcome,
		historyItemCount:Int,
		imageItemCountBefore:Int,
		modelSupportsImages:Bool,
		windowId:String,
		metadataHeaderEnabled:Bool,
		nextSamplingRequestIndex:Int,
		secretProbe:String
	) {
		this.requestId = requestId == null ? "" : requestId;
		this.hookRecordingOutcome = hookRecordingOutcome;
		this.historyItemCount = historyItemCount < 0 ? 0 : historyItemCount;
		this.imageItemCountBefore = imageItemCountBefore < 0 ? 0 : imageItemCountBefore;
		this.modelSupportsImages = modelSupportsImages;
		this.windowId = windowId == null ? "" : windowId;
		this.metadataHeaderEnabled = metadataHeaderEnabled;
		this.nextSamplingRequestIndex = nextSamplingRequestIndex < 0 ? 0 : nextSamplingRequestIndex;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
