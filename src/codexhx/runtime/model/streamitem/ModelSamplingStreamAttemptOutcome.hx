package codexhx.runtime.model.streamitem;

class ModelSamplingStreamAttemptOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final resultKind:ModelSamplingStreamAttemptResultKind;
	public final errorKind:ModelSamplingStreamErrorKind;
	public final retryable:Bool;
	public final retryScheduled:Bool;
	public final retryCountBefore:Int;
	public final retryCountAfter:Int;
	public final maxRetries:Int;
	public final unauthorizedRetryStatePrepared:Bool;
	public final contextWindowMarkedFull:Bool;
	public final usageLimitRateLimitsUpdated:Bool;
	public final terminal:Bool;
	public final streamOpened:Bool;
	public final dispatchAttemptIndex:Int;
	public final promptItemCount:Int;
	public final liveProviderRequestAttempted:Bool;
	public final providerStreamOpened:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(
		ok:Bool,
		code:String,
		requestId:String,
		resultKind:ModelSamplingStreamAttemptResultKind,
		errorKind:ModelSamplingStreamErrorKind,
		retryable:Bool,
		retryScheduled:Bool,
		retryCountBefore:Int,
		retryCountAfter:Int,
		maxRetries:Int,
		unauthorizedRetryStatePrepared:Bool,
		contextWindowMarkedFull:Bool,
		usageLimitRateLimitsUpdated:Bool,
		terminal:Bool,
		streamOpened:Bool,
		dispatchAttemptIndex:Int,
		promptItemCount:Int,
		liveProviderRequestAttempted:Bool,
		providerStreamOpened:Bool,
		liveNetworkAttempted:Bool,
		realFilesystemMutated:Bool,
		toolExecutedOutsideFixture:Bool,
		errorMessage:String
	) {
		this.ok = ok;
		this.code = code;
		this.requestId = requestId == null ? "" : requestId;
		this.resultKind = resultKind;
		this.errorKind = errorKind;
		this.retryable = retryable;
		this.retryScheduled = retryScheduled;
		this.retryCountBefore = retryCountBefore;
		this.retryCountAfter = retryCountAfter;
		this.maxRetries = maxRetries;
		this.unauthorizedRetryStatePrepared = unauthorizedRetryStatePrepared;
		this.contextWindowMarkedFull = contextWindowMarkedFull;
		this.usageLimitRateLimitsUpdated = usageLimitRateLimitsUpdated;
		this.terminal = terminal;
		this.streamOpened = streamOpened;
		this.dispatchAttemptIndex = dispatchAttemptIndex;
		this.promptItemCount = promptItemCount;
		this.liveProviderRequestAttempted = liveProviderRequestAttempted;
		this.providerStreamOpened = providerStreamOpened;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code
			+ ";ok=" + boolText(ok)
			+ ";request=" + requestId
			+ ";resultKind=" + resultKind
			+ ";errorKind=" + errorKind
			+ ";retryable=" + boolText(retryable)
			+ ";retryScheduled=" + boolText(retryScheduled)
			+ ";retryCountBefore=" + Std.string(retryCountBefore)
			+ ";retryCountAfter=" + Std.string(retryCountAfter)
			+ ";maxRetries=" + Std.string(maxRetries)
			+ ";unauthorizedRetryStatePrepared=" + boolText(unauthorizedRetryStatePrepared)
			+ ";contextWindowMarkedFull=" + boolText(contextWindowMarkedFull)
			+ ";usageLimitRateLimitsUpdated=" + boolText(usageLimitRateLimitsUpdated)
			+ ";terminal=" + boolText(terminal)
			+ ";streamOpened=" + boolText(streamOpened)
			+ ";dispatchAttemptIndex=" + Std.string(dispatchAttemptIndex)
			+ ";promptItemCount=" + Std.string(promptItemCount)
			+ ";liveProviderRequestAttempted=" + boolText(liveProviderRequestAttempted)
			+ ";providerStreamOpened=" + boolText(providerStreamOpened)
			+ ";liveNetworkAttempted=" + boolText(liveNetworkAttempted)
			+ ";realFilesystemMutated=" + boolText(realFilesystemMutated)
			+ ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture)
			+ ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
