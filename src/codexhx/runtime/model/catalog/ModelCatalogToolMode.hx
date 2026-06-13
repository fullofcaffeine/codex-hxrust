package codexhx.runtime.model.catalog;

enum abstract ModelCatalogToolMode(String) to String {
	public var None = "none";
	public var Direct = "direct";
	public var CodeMode = "code_mode";
	public var CodeModeOnly = "code_mode_only";
}
