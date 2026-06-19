package codexhx.runtime.model.streamitem;

class ModelSamplingErrorTerminalRequest {
	public final requestId:String;
	public final errorKind:ModelSamplingErrorTerminalKind;
	public final previousLastAgentMessage:String;
	public final historyImagesReplaceable:Bool;
	public final errorMessage:String;
	public final codexErrorInfo:String;
	public final terminalStopHookOutcome:ModelTerminalStopHookOutcome;
	public final secretProbe:String;

	public function new(requestId:String, errorKind:ModelSamplingErrorTerminalKind, previousLastAgentMessage:String, historyImagesReplaceable:Bool,
			errorMessage:String, codexErrorInfo:String, terminalStopHookOutcome:ModelTerminalStopHookOutcome, secretProbe:String) {
		this.requestId = requestId == null ? "" : requestId;
		this.errorKind = errorKind == null ? ModelSamplingErrorTerminalKind.GenericCodexError : errorKind;
		this.previousLastAgentMessage = previousLastAgentMessage == null ? "" : previousLastAgentMessage;
		this.historyImagesReplaceable = historyImagesReplaceable;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
		this.codexErrorInfo = codexErrorInfo == null ? "" : codexErrorInfo;
		this.terminalStopHookOutcome = terminalStopHookOutcome;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
