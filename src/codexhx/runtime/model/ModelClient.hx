package codexhx.runtime.model;

interface ModelClient {
	public function startStream(request:ModelStreamRequest):ModelStreamStartOutcome;
	public function cancelStream(handle:ModelStreamHandle):ModelStreamCancelOutcome;
}
