package codexhx.runtime.model.streamitem;

enum abstract ModelParsedKeyKind(String) to String {
	final Function = "function";
	final Named = "named";
	final Character = "character";
	final Invalid = "invalid";
}
