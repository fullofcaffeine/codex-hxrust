package codexhx.native.state;

import codexhx.runtime.app.persistence.ThreadPersistenceMetadata;

class StateSqliteReconcileRequest {
    public final metadata:ThreadPersistenceMetadata;
    public final mutationEnabled:Bool;

    public function new(metadata:ThreadPersistenceMetadata, mutationEnabled:Bool) {
        this.metadata = metadata;
        this.mutationEnabled = mutationEnabled;
    }
}
