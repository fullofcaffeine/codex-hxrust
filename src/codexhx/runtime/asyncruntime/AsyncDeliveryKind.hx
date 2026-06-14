package codexhx.runtime.asyncruntime;

enum abstract AsyncDeliveryKind(String) to String {
	var Lossless = "lossless";
	var BestEffort = "best_effort";
}
