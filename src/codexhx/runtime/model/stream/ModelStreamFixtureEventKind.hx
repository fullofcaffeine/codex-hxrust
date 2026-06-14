package codexhx.runtime.model.stream;

enum abstract ModelStreamFixtureEventKind(String) to String {
	public var Created = "created";
	public var OutputItemDone = "output_item_done";
	public var Completed = "completed";
	public var ProviderError = "provider_error";
	public var StreamClosed = "stream_closed";
	public var ConsumerDropped = "consumer_dropped";
}
