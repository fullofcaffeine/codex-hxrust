package codexhx.runtime.diagnostics;

typedef DiagnosticFieldFields = {
	final name:String;
	final value:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class DiagnosticField {
	public final name:String;
	public final value:String;

	public function render():String {
		return name + "=" + value;
	}
}
