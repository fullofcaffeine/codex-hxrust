package codexhx.runtime.model.streamitem;

typedef ModelFreshSessionServiceTierRequestFields = {
	final requestId:String;
	final baseConfigServiceTier:ModelFreshSessionServiceTierValue;
	final configuredServiceTier:ModelFreshSessionServiceTierValue;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelFreshSessionServiceTierRequest {
	public final requestId:String;
	public final baseConfigServiceTier:ModelFreshSessionServiceTierValue;
	public final configuredServiceTier:ModelFreshSessionServiceTierValue;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelFreshSessionServiceTierRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.baseConfigServiceTier = fields.baseConfigServiceTier == null ? ModelFreshSessionServiceTierValue.None : fields.baseConfigServiceTier;
		this.configuredServiceTier = fields.configuredServiceTier == null ? ModelFreshSessionServiceTierValue.None : fields.configuredServiceTier;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
