package codexhx.tools.sandbox;

class SandboxPermissionGate {
    public static function decide(request:SandboxGateRequest):SandboxGateDecision {
        if (request.bypassRequested) {
            return SandboxGateDecision.deny(request, "sandbox_bypass_denied", "sandbox bypass is not available through this gate");
        }
        if (!supportedPlatform(request.platform)) {
            return SandboxGateDecision.deny(request, "unsupported_sandbox_platform", "sandbox platform is unsupported and fails closed");
        }
        if (!validMode(request.sandboxMode)) {
            return SandboxGateDecision.deny(request, "invalid_sandbox_mode", "unsupported sandbox mode");
        }
        if (!validOperation(request.operation)) {
            return SandboxGateDecision.deny(request, "invalid_sandbox_operation", "unsupported sandbox operation");
        }
        if (!safePath(request.path)) {
            return SandboxGateDecision.deny(request, "unsafe_sandbox_path", "sandbox paths must be relative normalized paths");
        }

        if (request.sandboxMode == "danger-full-access") {
            return SandboxGateDecision.deny(request, "danger_full_access_denied", "danger-full-access is not allowed by the sandbox gate");
        }
        if (request.sandboxMode == "external-sandbox") {
            return SandboxGateDecision.deny(request, "external_sandbox_unverified", "external sandbox enforcement is not verified by this gate");
        }

        if (request.operation == "read") {
            return SandboxGateDecision.allow(request);
        }
        if (request.operation == "workspace-write") {
            if (request.sandboxMode == "workspace-write") {
                return SandboxGateDecision.allow(request);
            }
            return SandboxGateDecision.deny(request, "write_denied", "workspace writes require workspace-write sandbox mode");
        }
        if (request.operation == "exec") {
            return SandboxGateDecision.deny(request, "exec_requires_process_approval", "process execution must pass the process exec approval wrapper");
        }
        if (request.operation == "network") {
            return SandboxGateDecision.deny(request, "network_denied", "network access is denied by the sandbox gate");
        }

        return SandboxGateDecision.deny(request, "invalid_sandbox_operation", "unsupported sandbox operation");
    }

    static function supportedPlatform(platform:String):Bool {
        return platform == "fixture-posix";
    }

    static function validMode(mode:String):Bool {
        return mode == "read-only"
            || mode == "workspace-write"
            || mode == "external-sandbox"
            || mode == "danger-full-access";
    }

    static function validOperation(operation:String):Bool {
        return operation == "read"
            || operation == "workspace-write"
            || operation == "exec"
            || operation == "network";
    }

    static function safePath(path:String):Bool {
        if (StringTools.trim(path) == "") return false;
        if (StringTools.startsWith(path, "/")) return false;
        if (path.indexOf("\\") >= 0) return false;
        final parts = path.split("/");
        for (part in parts) {
            if (part == "" || part == "." || part == "..") return false;
        }
        return true;
    }
}
