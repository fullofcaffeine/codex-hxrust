package codexhx.protocol.app;

class AppProtocolMessage {
	public final fixtureId:String;
	public final kind:String;
	public final method:String;
	public final canonicalJson:String;
	public final summary:String;
	public final schemaFingerprint:String;

	public function new(fixtureId:String, kind:String, method:String, canonicalJson:String, summary:String, schemaFingerprint:String) {
		this.fixtureId = fixtureId;
		this.kind = kind;
		this.method = method;
		this.canonicalJson = canonicalJson;
		this.summary = summary;
		this.schemaFingerprint = schemaFingerprint;
	}

	public static function empty():AppProtocolMessage {
		return new AppProtocolMessage("", "", "", "", "", "");
	}
}
