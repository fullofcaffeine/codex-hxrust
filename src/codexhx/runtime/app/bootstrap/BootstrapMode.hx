package codexhx.runtime.app.bootstrap;

enum abstract BootstrapMode(String) from String to String {
    var InProcess = "in_process";
    var Remote = "remote";
}
