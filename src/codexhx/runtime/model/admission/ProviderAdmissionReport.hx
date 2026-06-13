package codexhx.runtime.model.admission;

class ProviderAdmissionReport {
	public final schema:String;
	public final outcomes:Array<ProviderAdmissionOutcome>;

	public function new(outcomes:Array<ProviderAdmissionOutcome>) {
		this.schema = "codex-hxrust.provider-admission-report.v1";
		this.outcomes = outcomes;
	}

	public function successCount():Int {
		var count = 0;
		for (outcome in outcomes) if (outcome.ok) count = count + 1;
		return count;
	}

	public function errorCount():Int {
		var count = 0;
		for (outcome in outcomes) if (!outcome.ok) count = count + 1;
		return count;
	}

	public function credentialAcceptedCount():Int {
		var count = 0;
		for (outcome in outcomes) if (outcome.credentialAccepted) count = count + 1;
		return count;
	}

	public function liveNetworkDeniedCount():Int {
		var count = 0;
		for (outcome in outcomes) if (outcome.code == "live_network_disabled") count = count + 1;
		return count;
	}

	public function redactedCredentialCount():Int {
		var count = 0;
		for (outcome in outcomes) if (outcome.credentialBucket == "present" || outcome.credentialBucket == "configured") count = count + 1;
		return count;
	}

	public function summary():String {
		final parts:Array<String> = [];
		for (outcome in outcomes) parts.push(outcome.summary());
		return "schema=" + schema
			+ ";cases=" + Std.string(outcomes.length)
			+ ";success=" + Std.string(successCount())
			+ ";errors=" + Std.string(errorCount())
			+ ";credentialsAccepted=" + Std.string(credentialAcceptedCount())
			+ ";redactedCredentials=" + Std.string(redactedCredentialCount())
			+ ";liveNetworkDenied=" + Std.string(liveNetworkDeniedCount())
			+ ";outcomes=[" + parts.join("##") + "]";
	}
}
