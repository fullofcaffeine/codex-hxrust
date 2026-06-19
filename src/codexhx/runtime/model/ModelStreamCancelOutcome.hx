package codexhx.runtime.model;

class ModelStreamCancelOutcome {
	public final ok:Bool;
	public final streamId:String;
	public final errorCode:String;
	public final errorMessage:String;

	function new(ok:Bool, streamId:String, errorCode:String, errorMessage:String) {
		this.ok = ok;
		this.streamId = streamId;
		this.errorCode = errorCode;
		this.errorMessage = errorMessage;
	}

	public static function success(streamId:String):ModelStreamCancelOutcome {
		return new ModelStreamCancelOutcome(true, streamId, "", "");
	}

	public static function failure(streamId:String, code:String, message:String):ModelStreamCancelOutcome {
		return new ModelStreamCancelOutcome(false, streamId, code, message);
	}
}
