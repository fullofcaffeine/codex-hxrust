package codexhx.runtime.model.streamitem;

enum abstract ModelSamplingResultIntegrationStatusKind(String) to String {
	final Ok = "ok";
	final Cancelled = "cancelled";
	final Error = "error";
}
