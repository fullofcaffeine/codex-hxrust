package codexhx.tools.sandbox;

class SandboxGateRequest {
    public final platform:String;
    public final sandboxMode:String;
    public final operation:String;
    public final path:String;
    public final bypassRequested:Bool;

    public function new(platform:String, sandboxMode:String, operation:String, path:String, bypassRequested:Bool) {
        this.platform = platform;
        this.sandboxMode = sandboxMode;
        this.operation = operation;
        this.path = path;
        this.bypassRequested = bypassRequested;
    }
}
