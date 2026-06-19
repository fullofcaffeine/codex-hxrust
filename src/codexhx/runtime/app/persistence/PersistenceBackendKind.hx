package codexhx.runtime.app.persistence;

enum abstract PersistenceBackendKind(String) from String to String {
	var None = "none";
	var JsonlFixture = "jsonl_fixture";
	var NativeSqlite = "native_sqlite";

	public static function isValid(value:String):Bool {
		return value == None || value == JsonlFixture || value == NativeSqlite;
	}
}
