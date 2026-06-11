package codexhx.adapters.cafex;

import codexhx.protocol.JsonScalar;
import sys.FileSystem;
import sys.io.File;

class CafActiveLaneWriter {
    static inline final activeLaneSchema = "cafetera.codex.active-lane.v1";

    public static function maybeWriteActiveLane(
        env:CafActiveLaneEnv,
        conversationId:String,
        nativeLiveStatus:CafNativeLiveStatus,
        nativeProcessId:Int,
        writtenAt:String
    ):CafReceiptWriteOutcome {
        if (env.activeLanePath.length == 0) return CafReceiptWriteOutcome.skipped("missing_active_lane_path");
        final runId = activeRunId(env);
        if (runId.reason.length > 0) return CafReceiptWriteOutcome.skipped(runId.reason);
        if (env.ownerPid.length == 0) return CafReceiptWriteOutcome.skipped("missing_owner_pid");

        final ownerPid = parsePositiveInt(env.ownerPid);
        if (!ownerPid.ok) return CafReceiptWriteOutcome.skipped("invalid_owner_pid");
        if (ownerPid.value != nativeProcessId) return CafReceiptWriteOutcome.skipped("owner_pid_mismatch");
        if (env.wakeRequestsDir.length == 0) return CafReceiptWriteOutcome.skipped("missing_wake_requests_dir");
        if (env.wakeReceiptsDir.length == 0) return CafReceiptWriteOutcome.skipped("missing_wake_receipts_dir");

        try {
            ensureDirectory(directoryOf(env.activeLanePath));
            File.saveContent(env.activeLanePath, activeLaneJson(env, runId.value, ownerPid.value, nativeProcessId, conversationId, nativeLiveStatus, writtenAt));
        } catch (e:Dynamic) {
            return CafReceiptWriteOutcome.failure("active_lane_write_failed", "failed to write Caf active-lane receipt");
        }
        return CafReceiptWriteOutcome.written(env.activeLanePath);
    }

    static function activeRunId(env:CafActiveLaneEnv):RunIdRead {
        if (env.runId.length > 0 && env.successorRunId.length > 0 && env.runId != env.successorRunId) {
            return RunIdRead.skipped("run_id_mismatch");
        }
        if (env.runId.length > 0) return RunIdRead.success(env.runId);
        if (env.successorRunId.length > 0) return RunIdRead.success(env.successorRunId);
        return RunIdRead.skipped("missing_run_id");
    }

    static function activeLaneJson(
        env:CafActiveLaneEnv,
        runId:String,
        ownerPid:Int,
        nativeProcessId:Int,
        conversationId:String,
        nativeLiveStatus:CafNativeLiveStatus,
        writtenAt:String
    ):String {
        var json = "{\n"
            + "  \"schema\": " + quote(activeLaneSchema) + ",\n"
            + "  \"source\": \"native-runtime\",\n"
            + "  \"clientId\": \"codex\",\n"
            + "  \"ownerClientId\": \"codex\",\n"
            + "  \"runId\": " + quote(runId) + ",\n"
            + "  \"pid\": " + Std.string(ownerPid) + ",\n"
            + "  \"pidSource\": \"CAF_CODEX_PID\",\n"
            + "  \"nativeProcessId\": " + Std.string(nativeProcessId) + ",\n"
            + "  \"ownerPidMatched\": true,\n"
            + "  \"runtimeRestartProtocol\": \"exec_successor_after_shutdown.v2\",\n"
            + "  \"runtimeRestartReceiptStatus\": \"successor_exec_after_shutdown_pending\",\n"
            + "  \"runtimeRestartPidSource\": \"CAF_CODEX_PID\",\n"
            + "  \"runtimeEffortControl\": \"next_turn_apply\",\n"
            + "  \"runtimeCollaborationModeControl\": \"next_turn_apply\",\n"
            + "  \"runtimeRequestSchemas\": " + stringArray(runtimeRequestSchemas()) + ",\n"
            + "  \"runtimeReceiptSchemas\": " + stringArray(runtimeReceiptSchemas()) + ",\n"
            + "  \"runtimeControlSchemas\": " + stringArray(runtimeControlSchemas()) + ",\n"
            + "  \"continuityGenerationId\": " + quote(env.continuityGenerationId) + ",\n"
            + "  \"wakeRequestsDir\": " + quote(env.wakeRequestsDir) + ",\n"
            + "  \"wakeReceiptsDir\": " + quote(env.wakeReceiptsDir) + ",\n"
            + "  \"pendingInputSnapshotPath\": " + quote(env.pendingInputSnapshotPath) + ",\n"
            + "  \"conversationId\": " + quote(conversationId);

        if (nativeLiveStatus != null) {
            json = json + ",\n  \"nativeLiveStatus\": " + nativeLiveStatus.json("  ");
        }

        return json + ",\n"
            + "  \"writtenAt\": " + quote(writtenAt) + "\n"
            + "}\n";
    }

    static function runtimeRequestSchemas():Array<String> {
        return [
            "cafetera.codex.goal-apply-request.v1",
            "cafetera.codex.effort-apply-request.v1",
            "cafetera.codex.mode-apply-request.v1",
            "cafetera.codex.restart-apply-request.v1",
            "cafetera.codex.queue-reconcile-request.v1",
            "cafetera.codex.live-status-refresh-request.v1",
            "caf-client-wake-request.v1"
        ];
    }

    static function runtimeReceiptSchemas():Array<String> {
        return [
            "cafetera.codex.goal-apply.v1",
            "cafetera.codex.effort-apply.v1",
            "cafetera.codex.mode-apply.v1",
            "cafetera.codex.restart-apply.v1",
            "cafetera.codex.queue-reconcile-receipt.v1",
            "cafetera.codex.live-status-refresh.v1",
            "caf-client-wake-receipt.v1",
            "cafetera.codex.native-current-turn-plan-proof.v1"
        ];
    }

    static function runtimeControlSchemas():Array<String> {
        return [
            "cafetera.agent.control-action.v1",
            "cafetera.agent.control-receipt.v1",
            "cafetera.ralph.control-decision.v1"
        ];
    }

    static function stringArray(values:Array<String>):String {
        final out = new Array<String>();
        for (value in values) out.push(quote(value));
        return "[" + out.join(", ") + "]";
    }

    static function parsePositiveInt(value:String):IntRead {
        if (value.length == 0) return IntRead.failure();
        var out = 0;
        var i = 0;
        while (i < value.length) {
            final digit = digitValue(value.charAt(i));
            if (digit < 0) return IntRead.failure();
            out = out * 10 + digit;
            i = i + 1;
        }
        if (out <= 0) return IntRead.failure();
        return IntRead.success(out);
    }

    static function digitValue(value:String):Int {
        return switch value {
            case "0": 0;
            case "1": 1;
            case "2": 2;
            case "3": 3;
            case "4": 4;
            case "5": 5;
            case "6": 6;
            case "7": 7;
            case "8": 8;
            case "9": 9;
            case _: -1;
        }
    }

    static function directoryOf(path:String):String {
        final normalized = StringTools.replace(path, "\\", "/");
        final parts = normalized.split("/");
        if (parts.length <= 1) return "";
        final limit = parts.length - 1;
        var directory = StringTools.startsWith(normalized, "/") ? "/" : "";
        var i = 0;
        while (i < limit) {
            final part = parts[i];
            if (part.length > 0) {
                if (directory == "/") {
                    directory = "/" + part;
                } else if (directory.length == 0) {
                    directory = part;
                } else {
                    directory = directory + "/" + part;
                }
            }
            i = i + 1;
        }
        return directory;
    }

    static function ensureDirectory(path:String):Void {
        if (path.length == 0 || FileSystem.exists(path)) return;
        final normalized = StringTools.replace(path, "\\", "/");
        final parts = normalized.split("/");
        var current = StringTools.startsWith(normalized, "/") ? "/" : "";
        for (part in parts) {
            if (part.length == 0) continue;
            if (current == "/") {
                current = "/" + part;
            } else if (current.length == 0) {
                current = part;
            } else {
                current = current + "/" + part;
            }
            if (!FileSystem.exists(current)) {
                FileSystem.createDirectory(current);
            }
        }
    }

    static function quote(value:String):String {
        return JsonScalar.quote(value);
    }
}

class RunIdRead {
    public final value:String;
    public final reason:String;

    function new(value:String, reason:String) {
        this.value = value;
        this.reason = reason;
    }

    public static function success(value:String):RunIdRead {
        return new RunIdRead(value, "");
    }

    public static function skipped(reason:String):RunIdRead {
        return new RunIdRead("", reason);
    }
}

class IntRead {
    public final ok:Bool;
    public final value:Int;

    function new(ok:Bool, value:Int) {
        this.ok = ok;
        this.value = value;
    }

    public static function success(value:Int):IntRead {
        return new IntRead(true, value);
    }

    public static function failure():IntRead {
        return new IntRead(false, 0);
    }
}
