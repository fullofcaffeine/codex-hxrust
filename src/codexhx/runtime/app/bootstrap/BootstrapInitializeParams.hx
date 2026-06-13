package codexhx.runtime.app.bootstrap;

class BootstrapInitializeParams {
    public final clientInfo:BootstrapClientInfo;
    public final hasCapabilities:Bool;
    public final capabilities:BootstrapCapabilities;

    public function new(clientInfo:BootstrapClientInfo, hasCapabilities:Bool, capabilities:BootstrapCapabilities) {
        this.clientInfo = clientInfo;
        this.hasCapabilities = hasCapabilities;
        this.capabilities = capabilities;
    }

    public function validate():BootstrapValidationOutcome {
        final client = clientInfo.validate();
        if (!client.ok) return client;
        if (hasCapabilities) {
            final caps = capabilities.validate();
            if (!caps.ok) return caps;
        }
        return BootstrapValidationOutcome.success("initialize-params");
    }

    public function toJson():String {
        final capabilitiesJson = hasCapabilities ? capabilities.toJson() : "null";
        return "{\"capabilities\":" + capabilitiesJson + ",\"clientInfo\":" + clientInfo.toJson() + "}";
    }

    public function requestJson(requestId:String):String {
        return "{\"id\":" + quote(requestId) + ",\"method\":\"initialize\",\"params\":" + toJson() + "}";
    }

    static function quote(value:String):String {
        return codexhx.protocol.JsonScalar.quote(value);
    }
}
