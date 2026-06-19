package codexhx.runtime.model.streamitem;

typedef ModelFreshSessionServiceTierOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final decisionKind:ModelFreshSessionServiceTierDecisionKind;
	final baseConfigServiceTier:ModelFreshSessionServiceTierValue;
	final configuredServiceTier:ModelFreshSessionServiceTierValue;
	final freshConfigServiceTier:ModelFreshSessionServiceTierValue;
	final serviceTierOverrodeBaseConfig:Bool;
	final serviceTierClearedFromBaseConfig:Bool;
	final baseConfigOtherwisePreserved:Bool;
	final eventOrderingPreserved:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelFreshSessionServiceTierOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final decisionKind:ModelFreshSessionServiceTierDecisionKind;
	public final baseConfigServiceTier:ModelFreshSessionServiceTierValue;
	public final configuredServiceTier:ModelFreshSessionServiceTierValue;
	public final freshConfigServiceTier:ModelFreshSessionServiceTierValue;
	public final serviceTierOverrodeBaseConfig:Bool;
	public final serviceTierClearedFromBaseConfig:Bool;
	public final baseConfigOtherwisePreserved:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelFreshSessionServiceTierOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.decisionKind = fields.decisionKind == null ? ModelFreshSessionServiceTierDecisionKind.ConfiguredServiceTierCleared : fields.decisionKind;
		this.baseConfigServiceTier = fields.baseConfigServiceTier == null ? ModelFreshSessionServiceTierValue.None : fields.baseConfigServiceTier;
		this.configuredServiceTier = fields.configuredServiceTier == null ? ModelFreshSessionServiceTierValue.None : fields.configuredServiceTier;
		this.freshConfigServiceTier = fields.freshConfigServiceTier == null ? ModelFreshSessionServiceTierValue.None : fields.freshConfigServiceTier;
		this.serviceTierOverrodeBaseConfig = fields.serviceTierOverrodeBaseConfig;
		this.serviceTierClearedFromBaseConfig = fields.serviceTierClearedFromBaseConfig;
		this.baseConfigOtherwisePreserved = fields.baseConfigOtherwisePreserved;
		this.eventOrderingPreserved = fields.eventOrderingPreserved;
		this.liveNetworkAttempted = fields.liveNetworkAttempted;
		this.realFilesystemMutated = fields.realFilesystemMutated;
		this.toolExecutedOutsideFixture = fields.toolExecutedOutsideFixture;
		this.errorMessage = fields.errorMessage == null ? "" : fields.errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";decisionKind=" + decisionKind + ";baseConfigServiceTier="
			+ noneIfEmpty(baseConfigServiceTier) + ";configuredServiceTier=" + noneIfEmpty(configuredServiceTier) + ";freshConfigServiceTier="
			+ noneIfEmpty(freshConfigServiceTier) + ";serviceTierOverrodeBaseConfig=" + boolText(serviceTierOverrodeBaseConfig)
			+ ";serviceTierClearedFromBaseConfig=" + boolText(serviceTierClearedFromBaseConfig) + ";baseConfigOtherwisePreserved="
			+ boolText(baseConfigOtherwisePreserved) + ";eventOrderingPreserved=" + boolText(eventOrderingPreserved) + ";liveNetworkAttempted="
			+ boolText(liveNetworkAttempted) + ";realFilesystemMutated=" + boolText(realFilesystemMutated) + ";toolExecutedOutsideFixture="
			+ boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
