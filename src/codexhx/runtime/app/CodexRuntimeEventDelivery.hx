package codexhx.runtime.app;

enum abstract CodexRuntimeEventDelivery(String) from String to String {
    var Lossless = "lossless";
    var BestEffort = "bestEffort";
    var Control = "control";
}
