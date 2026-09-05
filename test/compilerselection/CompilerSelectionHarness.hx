/**
	Provides a small generated-Rust entry point for the compiler-selection gate.

	The gate compiles this module through a distinct `HAXE_RUST_ROOT` and checks
	Haxe's verbose parse log. Product behavior is intentionally outside its scope.
**/
class CompilerSelectionHarness {
	static function main():Void {
		trace("compiler-selection-ready");
	}
}
