package codexhx.runtime.model.streamitem;

class ModelSamplingStreamAttemptRequest {
	public final requestId:String;
	public final dispatchOutcome:ModelSamplingDispatchOutcome;
	public final errorKind:ModelSamplingStreamErrorKind;
	public final currentRetryCount:Int;
	public final unauthorizedRecoveryAvailable:Bool;
	public final rateLimitUpdated:Bool;
	public final secretProbe:String;

	public function new(
		requestId:String,
		dispatchOutcome:ModelSamplingDispatchOutcome,
		errorKind:ModelSamplingStreamErrorKind,
		currentRetryCount:Int,
		unauthorizedRecoveryAvailable:Bool,
		rateLimitUpdated:Bool,
		secretProbe:String
	) {
		this.requestId = requestId == null ? "" : requestId;
		this.dispatchOutcome = dispatchOutcome;
		this.errorKind = errorKind;
		this.currentRetryCount = currentRetryCount < 0 ? 0 : currentRetryCount;
		this.unauthorizedRecoveryAvailable = unauthorizedRecoveryAvailable;
		this.rateLimitUpdated = rateLimitUpdated;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
