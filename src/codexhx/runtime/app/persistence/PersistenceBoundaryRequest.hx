package codexhx.runtime.app.persistence;

class PersistenceBoundaryRequest {
	public final backend:PersistenceBackendKind;
	public final metadata:ThreadPersistenceMetadata;
	public final stateDbRequested:Bool;
	public final logDbRequested:Bool;
	public final reconcileRolloutRequested:Bool;
	public final persistThreadRequested:Bool;

	public function new(backend:PersistenceBackendKind, metadata:ThreadPersistenceMetadata, stateDbRequested:Bool, logDbRequested:Bool,
			reconcileRolloutRequested:Bool, persistThreadRequested:Bool) {
		this.backend = backend;
		this.metadata = metadata;
		this.stateDbRequested = stateDbRequested;
		this.logDbRequested = logDbRequested;
		this.reconcileRolloutRequested = reconcileRolloutRequested;
		this.persistThreadRequested = persistThreadRequested;
	}

	public function evaluate():PersistenceBoundaryOutcome {
		if (!PersistenceBackendKind.isValid(backend)) {
			return PersistenceBoundaryOutcome.failure("invalid_backend", "persistence backend is not supported");
		}

		final metadataOutcome = metadata.validate();
		if (!metadataOutcome.ok)
			return metadataOutcome;

		final nativeFeatures = requestedNativeFeatures();
		if (backend == PersistenceBackendKind.NativeSqlite) {
			if (nativeFeatures.length == 0)
				nativeFeatures.push(PersistentFeatureKind.StateDbHandle);
			return PersistenceBoundaryOutcome.success("native_boundary_required",
				"native SQLite/log persistence must be implemented as a generic metal Rust boundary", nativeFeatures, metadata.summary());
		}

		if (nativeFeatures.length > 0) {
			return PersistenceBoundaryOutcome.failure("native_boundary_missing", "portable fixture metadata cannot claim native SQLite/log persistence");
		}

		if (backend == PersistenceBackendKind.None && metadata.historyItemCount > 0) {
			return PersistenceBoundaryOutcome.failure("backend_disabled_with_history", "history metadata requires a fixture or native backend");
		}

		return PersistenceBoundaryOutcome.success("portable_metadata_only", "portable Haxe may validate rollout metadata, not production persistence effects",
			nativeFeatures, metadata.summary());
	}

	function requestedNativeFeatures():Array<String> {
		final features:Array<String> = [];
		if (stateDbRequested)
			features.push(PersistentFeatureKind.StateDbHandle);
		if (logDbRequested)
			features.push(PersistentFeatureKind.LogDbLayer);
		if (reconcileRolloutRequested)
			features.push(PersistentFeatureKind.ReconcileRollout);
		if (persistThreadRequested)
			features.push(PersistentFeatureKind.PersistThread);
		return features;
	}
}
