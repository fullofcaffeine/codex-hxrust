package codexhx.runtime.asyncruntime;

class AsyncError {
	public final code:String;
	public final message:String;
	public final recoverable:Bool;

	public function new(code:String, message:String, recoverable:Bool) {
		this.code = code;
		this.message = message;
		this.recoverable = recoverable;
	}

	public function summary():String {
		return "code=" + code + ";recoverable=" + (recoverable ? "true" : "false") + ";message=" + message;
	}
}
