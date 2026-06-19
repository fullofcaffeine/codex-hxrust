package codexhx.runtime.app.bootstrap;

class BootstrapReport {
	public final mode:BootstrapMode;
	public final initializeRequestJson:String;
	public final initializedNotificationJson:String;
	public final initializeResponseJson:String;
	public final startupMetadataJson:String;
	public final serverVersion:String;
	public final summary:String;

	public function new(mode:BootstrapMode, initializeRequestJson:String, initializedNotificationJson:String, initializeResponseJson:String,
			startupMetadataJson:String, serverVersion:String, summary:String) {
		this.mode = mode;
		this.initializeRequestJson = initializeRequestJson;
		this.initializedNotificationJson = initializedNotificationJson;
		this.initializeResponseJson = initializeResponseJson;
		this.startupMetadataJson = startupMetadataJson;
		this.serverVersion = serverVersion;
		this.summary = summary;
	}
}
