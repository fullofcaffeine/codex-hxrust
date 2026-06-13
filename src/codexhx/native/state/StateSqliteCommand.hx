package codexhx.native.state;

enum StateSqliteCommand {
	Reconcile(request:StateSqliteReconcileRequest);
	Query(request:StateSqliteQueryRequest);
}
