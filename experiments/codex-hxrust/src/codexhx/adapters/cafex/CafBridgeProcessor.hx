package codexhx.adapters.cafex;

import codexhx.protocol.JsonScalar;
import codexhx.protocol.goals.ThreadGoal;
import codexhx.protocol.goals.ThreadGoalStatus;
import codexhx.protocol.json.CodexJson;
import codexhx.state.goals.ThreadGoalStore;
import haxe.json.Value;
import sys.FileSystem;
import sys.io.File;

class CafBridgeProcessor {
    static inline final effortRequestSchema = "cafetera.codex.effort-apply-request.v1";
    static inline final effortReceiptSchema = "cafetera.codex.effort-apply.v1";
    static inline final wakeRequestSchema = "caf-client-wake-request.v1";
    static inline final wakeReceiptSchema = "caf-client-wake-receipt.v1";
    static inline final modeRequestSchema = "cafetera.codex.mode-apply-request.v1";
    static inline final modeReceiptSchema = "cafetera.codex.mode-apply.v1";
    static inline final goalRequestSchema = "cafetera.codex.goal-apply-request.v1";
    static inline final goalReceiptSchema = "cafetera.codex.goal-apply.v1";
    static inline final queueReconcileRequestSchema = "cafetera.codex.queue-reconcile-request.v1";
    static inline final queueReconcileReceiptSchema = "cafetera.codex.queue-reconcile-receipt.v1";

    public static function processOnce(requestsDir:String, receiptsDir:String, writtenAt:String):CafBridgeProcessOutcome {
        if (requestsDir.length == 0) return CafBridgeProcessOutcome.success(0, 0);
        if (!FileSystem.exists(requestsDir)) return CafBridgeProcessOutcome.success(0, 0);
        if (!FileSystem.isDirectory(requestsDir)) {
            return CafBridgeProcessOutcome.failure("requests_path_not_directory", "Caf request path is not a directory");
        }

        try {
            ensureDirectory(receiptsDir);
        } catch (e:Dynamic) {
            return CafBridgeProcessOutcome.failure("receipt_directory_failed", "failed to create Caf receipt directory");
        }

        var processed = 0;
        var skipped = 0;
        final entries = FileSystem.readDirectory(requestsDir);
        entries.sort(compareStrings);

        for (entry in entries) {
            final requestPath = joinPath(requestsDir, entry);
            if (FileSystem.isDirectory(requestPath) || !StringTools.endsWith(entry, ".json")) {
                skipped = skipped + 1;
                continue;
            }

            final raw = try File.getContent(requestPath) catch (e:Dynamic) "";
            if (raw.length == 0) {
                skipped = skipped + 1;
                continue;
            }

            final parsed = try CodexJson.parse(raw) catch (e:Dynamic) null;
            if (parsed == null || !parsed.ok) {
                skipped = skipped + 1;
                continue;
            }

            final schema = readString(parsed.value, "schema");
            if (!schema.ok) {
                skipped = skipped + 1;
                continue;
            }

            final requestId = requestIdFor(parsed.value, entry);
            final receiptPath = joinPath(receiptsDir, requestId + ".json");
            if (FileSystem.exists(receiptPath)) {
                skipped = skipped + 1;
                continue;
            }

            final receipt = receiptFor(schema.value, requestId, parsed.value, writtenAt);
            if (!receipt.ok) {
                skipped = skipped + 1;
                continue;
            }

            try {
                File.saveContent(receiptPath, receipt.value);
            } catch (e:Dynamic) {
                return CafBridgeProcessOutcome.failure("receipt_write_failed", "failed to write Caf bridge receipt");
            }
            processed = processed + 1;
        }

        return CafBridgeProcessOutcome.success(processed, skipped);
    }

    public static function processOnceFromEnv(writtenAt:String):CafBridgeProcessOutcome {
        final requestsDir = firstEnv("CAF_CODEX_EFFORT_REQUESTS_DIR", "CAF_CODEX_WAKE_REQUESTS_DIR", "CAF_CODEX_GOAL_REQUESTS_DIR", "CAF_CODEX_QUEUE_RECONCILE_REQUESTS_DIR");
        final receiptsDir = firstEnv("CAF_CODEX_EFFORT_RECEIPTS_DIR", "CAF_CODEX_WAKE_RECEIPTS_DIR", "CAF_CODEX_GOAL_RECEIPTS_DIR", "CAF_CODEX_QUEUE_RECONCILE_RECEIPTS_DIR");
        return processOnce(requestsDir, receiptsDir, writtenAt);
    }

    static function receiptFor(schema:String, requestId:String, request:Value, writtenAt:String):StringRead {
        return switch schema {
            case effortRequestSchema:
                StringRead.success(effortReceipt(requestId, request, writtenAt));
            case wakeRequestSchema:
                StringRead.success(wakeReceipt(requestId, request, writtenAt));
            case modeRequestSchema:
                StringRead.success(modeUnsupportedReceipt(requestId, request, writtenAt));
            case goalRequestSchema:
                StringRead.success(goalReceipt(requestId, request, writtenAt));
            case queueReconcileRequestSchema:
                StringRead.success(queueReconcileReceipt(requestId, request, writtenAt));
            case _:
                StringRead.failure();
        }
    }

    static function effortReceipt(requestId:String, request:Value, writtenAt:String):String {
        final modelRead = firstNestedString(request, "model", "clientEffort", "targetModel");
        final effortRead = firstNestedString(request, "effort", "clientEffort", "appliedEffort");
        final targetModel = modelRead.ok ? modelRead.value : "";
        final targetEffort = effortRead.ok ? effortRead.value : "";
        final normalizedEffort = normalizeEffort(targetEffort);

        var status = "queued_next_turn";
        var applyPhase = "next_turn";
        var refusalReason = "";

        if (targetModel.length == 0) {
            status = "refused";
            applyPhase = "none";
            refusalReason = "missing_model";
        } else if (targetEffort.length == 0) {
            status = "refused";
            applyPhase = "none";
            refusalReason = "missing_effort";
        } else if (normalizedEffort.length == 0) {
            status = "refused";
            applyPhase = "none";
            refusalReason = "invalid_effort";
        }

        var json = "{\n"
            + "  \"schema\": " + quote(effortReceiptSchema) + ",\n"
            + "  \"requestId\": " + quote(requestId) + ",\n"
            + optionalStringLine(request, "taskId", "taskId", true)
            + optionalStringLine(request, "clientId", "clientId", true)
            + optionalStringLine(request, "runId", "runId", true)
            + optionalStringLine(request, "laneId", "laneId", true)
            + optionalNumberLine(request, "processId", "processId", true)
            + optionalStringLine(request, "continuityGenerationId", "continuityGenerationId", true)
            + "  \"targetModel\": " + quote(targetModel) + ",\n"
            + "  \"targetEffort\": " + quote(targetEffort) + ",\n"
            + optionalStringLine(request, "policyId", "policyId", true)
            + "  \"status\": " + quote(status) + ",\n"
            + "  \"applyPhase\": " + quote(applyPhase) + ",\n"
            + "  \"writtenAt\": " + quote(writtenAt);

        if (refusalReason.length == 0) {
            json = json + ",\n"
                + "  \"model\": " + quote(targetModel) + ",\n"
                + "  \"effort\": " + quote(normalizedEffort) + ",\n"
                + "  \"persisted\": false";
        } else {
            json = json + ",\n"
                + "  \"refusalReason\": " + quote(refusalReason);
        }

        return json + "\n}\n";
    }

    static function wakeReceipt(requestId:String, request:Value, writtenAt:String):String {
        return "{\n"
            + "  \"schema\": " + quote(wakeReceiptSchema) + ",\n"
            + "  \"requestId\": " + quote(requestId) + ",\n"
            + optionalStringLine(request, "runId", "runId", true)
            + optionalStringLine(request, "continuityGenerationId", "continuityGenerationId", true)
            + optionalStringLine(request, "ownerClientId", "ownerClientId", true)
            + optionalStringLine(request, "delegateClientId", "delegateClientId", true)
            + optionalStringLine(request, "waitId", "waitId", true)
            + "  \"status\": \"consumed\",\n"
            + "  \"writtenAt\": " + quote(writtenAt)
            + "\n}\n";
    }

    static function modeUnsupportedReceipt(requestId:String, request:Value, writtenAt:String):String {
        return "{\n"
            + "  \"schema\": " + quote(modeReceiptSchema) + ",\n"
            + "  \"requestId\": " + quote(requestId) + ",\n"
            + optionalStringLine(request, "taskId", "taskId", true)
            + optionalStringLine(request, "clientId", "clientId", true)
            + optionalStringLine(request, "runId", "runId", true)
            + optionalStringLine(request, "laneId", "laneId", true)
            + optionalNumberLine(request, "processId", "processId", true)
            + optionalStringLine(request, "continuityGenerationId", "continuityGenerationId", true)
            + optionalStringLine(request, "mode", "targetMode", true)
            + "  \"status\": \"refused\",\n"
            + "  \"applyPhase\": \"none\",\n"
            + "  \"writtenAt\": " + quote(writtenAt) + ",\n"
            + "  \"refusalReason\": \"unsupported_mode_apply\"\n"
            + "}\n";
    }

    static function goalReceipt(requestId:String, request:Value, writtenAt:String):String {
        final actionRead = readString(request, "action");
        final action = actionRead.ok && actionRead.value.length > 0 ? actionRead.value : "set_objective";
        final requestedStatus = firstNestedString(request, "requestedNativeGoalStatus", "goalRequest", "requestedNativeGoalStatus");
        final effectiveStatus = firstNestedString(request, "effectiveNativeGoalStatus", "goalRequest", "effectiveNativeGoalStatus");
        final normalizedStatus = normalizeGoalStatus(effectiveStatus.ok ? effectiveStatus.value : (requestedStatus.ok ? requestedStatus.value : "active"));
        final threadId = firstNestedString(request, "threadId", "goalRequest", "threadId");
        final objective = firstNestedString(request, "objective", "goalObjective", "objective");
        final nativeClosesBrew = readBool(request, "nativeGoalCompletionClosesBrew");
        final brewAuthority = readBool(request, "brewCompletionAuthority");

        var status = "applied";
        var applyPhase = action == "clear" ? "immediate" : "next_turn";
        var refusalReason = "";
        var goal:ThreadGoal = null;
        var cleared = false;

        if (threadId.value.length == 0) {
            status = "refused";
            applyPhase = "none";
            refusalReason = "missing_thread_id";
        } else if (!nativeClosesBrew.ok || nativeClosesBrew.value) {
            status = "refused";
            applyPhase = "none";
            refusalReason = "invalid_native_goal_completion_authority";
        } else if (!brewAuthority.ok || !brewAuthority.value) {
            status = "refused";
            applyPhase = "none";
            refusalReason = "missing_brew_completion_authority";
        } else if (action == "clear") {
            final store = new ThreadGoalStore(threadId.value);
            final operation = store.clear();
            cleared = operation.cleared;
        } else if (action == "set_objective") {
            if (objective.value.length == 0) {
                status = "refused";
                applyPhase = "none";
                refusalReason = "missing_objective";
            } else if (normalizedStatus.length == 0) {
                status = "refused";
                applyPhase = "none";
                refusalReason = "invalid_native_goal_status";
            } else {
                final store = new ThreadGoalStore(threadId.value);
                final operation = store.setObjective(objective.value, normalizedStatus, 0);
                if (operation.ok) {
                    goal = operation.goal;
                } else {
                    status = "refused";
                    applyPhase = "none";
                    refusalReason = operation.errorCode;
                }
            }
        } else {
            status = "refused";
            applyPhase = "none";
            refusalReason = "unsupported_goal_action";
        }

        var json = "{\n"
            + "  \"schema\": " + quote(goalReceiptSchema) + ",\n"
            + "  \"requestId\": " + quote(requestId) + ",\n"
            + optionalStringLine(request, "deliveryKey", "deliveryKey", true)
            + optionalStringLine(request, "taskId", "taskId", true)
            + optionalStringLine(request, "closedTaskId", "closedTaskId", true)
            + optionalStringLine(request, "clientId", "clientId", true)
            + optionalStringLine(request, "runId", "runId", true)
            + optionalStringLine(request, "laneId", "laneId", true)
            + optionalNumberLine(request, "processId", "processId", true)
            + optionalStringLine(request, "continuityGenerationId", "continuityGenerationId", true)
            + "  \"action\": " + quote(action) + ",\n"
            + optionalReadStringLine(requestedStatus, "requestedNativeGoalStatus", true)
            + optionalReadStringLine(effectiveStatus, "effectiveNativeGoalStatus", true)
            + optionalStringLine(request, "targetClosureRef", "targetClosureRef", true)
            + optionalStringLine(request, "targetClosureDigest", "targetClosureDigest", true)
            + optionalStringLine(request, "boundaryKind", "boundaryKind", true)
            + optionalStringLine(request, "nextLegalActionAfterBoundary", "nextLegalActionAfterBoundary", true)
            + "  \"nativeGoalCompletionClosesBrew\": false,\n"
            + "  \"brewCompletionAuthority\": true,\n"
            + "  \"status\": " + quote(status) + ",\n"
            + "  \"applyPhase\": " + quote(applyPhase) + ",\n"
            + "  \"writtenAt\": " + quote(writtenAt);

        if (status == "applied") {
            if (goal != null) {
                json = json + ",\n"
                    + "  \"threadId\": " + quote(goal.threadId) + ",\n"
                    + "  \"nativeGoal\": " + goal.appJson();
            } else {
                json = json + ",\n"
                    + "  \"threadId\": " + quote(threadId.value) + ",\n"
                    + "  \"cleared\": " + (cleared ? "true" : "false");
            }
        } else {
            json = json + ",\n"
                + "  \"refusalReason\": " + quote(refusalReason);
        }

        return json + "\n}\n";
    }

    static function queueReconcileReceipt(requestId:String, request:Value, writtenAt:String):String {
        return "{\n"
            + "  \"schema\": " + quote(queueReconcileReceiptSchema) + ",\n"
            + "  \"requestId\": " + quote(requestId) + ",\n"
            + optionalStringLine(request, "taskId", "taskId", true)
            + optionalStringLine(request, "clientId", "clientId", true)
            + optionalStringLine(request, "source", "source", true)
            + optionalStringLine(request, "runId", "runId", true)
            + optionalStringLine(request, "laneId", "laneId", true)
            + optionalNumberLine(request, "processId", "processId", true)
            + optionalStringLine(request, "continuityGenerationId", "continuityGenerationId", true)
            + "  \"status\": \"queued_next_turn\",\n"
            + "  \"applyPhase\": \"next_turn\",\n"
            + optionalStringLine(request, "deliveryDecision", "deliveryDecision", true)
            + optionalStringLine(request, "deliveryDecisionReason", "deliveryDecisionReason", true)
            + optionalStringLine(request, "checkpointGeneration", "checkpointGeneration", true)
            + optionalStringLine(request, "checkpointBasisDigest", "checkpointBasisDigest", true)
            + optionalStringLine(request, "observedGeneration", "observedGeneration", true)
            + optionalStringLine(request, "observedBasisDigest", "observedBasisDigest", true)
            + "  \"countsAvailable\": false,\n"
            + "  \"droppedCount\": 0,\n"
            + "  \"keptCount\": 0,\n"
            + "  \"deferredCount\": 0,\n"
            + "  \"sourceQueueIds\": [],\n"
            + "  \"runtimeQueueMutation\": \"not_claimed_by_hxrust_fixture\",\n"
            + "  \"writtenAt\": " + quote(writtenAt)
            + "\n}\n";
    }

    static function normalizeEffort(value:String):String {
        final trimmed = StringTools.trim(value);
        return switch trimmed {
            case "medium": "medium";
            case "high": "high";
            case "xhigh" | "x-high" | "extra_high" | "extra-high" | "extra high" | "extended": "xhigh";
            case _: "";
        }
    }

    static function normalizeGoalStatus(value:String):String {
        final trimmed = StringTools.trim(value);
        return switch trimmed {
            case "active": ThreadGoalStatus.Active;
            case "paused": ThreadGoalStatus.Paused;
            case "blocked": ThreadGoalStatus.Blocked;
            case "usageLimited" | "usage_limited" | "usage-limited": ThreadGoalStatus.UsageLimited;
            case "budgetLimited" | "budget_limited" | "budget-limited": ThreadGoalStatus.BudgetLimited;
            case "complete" | "completed": ThreadGoalStatus.Complete;
            case _: "";
        }
    }

    static function firstNestedString(object:Value, field:String, nestedObject:String, nestedField:String):StringRead {
        final direct = readString(object, field);
        if (direct.ok) return direct;

        return switch object {
            case JObject(keys, values):
                final i = fieldIndex(keys, nestedObject);
                if (i < 0) return StringRead.failure();
                readString(values[i], nestedField);
            case _:
                StringRead.failure();
        }
    }

    static function optionalStringLine(object:Value, sourceName:String, targetName:String, comma:Bool):String {
        final value = readString(object, sourceName);
        if (!value.ok) return "";
        return "  " + quote(targetName) + ": " + quote(value.value) + (comma ? ",\n" : "\n");
    }

    static function optionalNumberLine(object:Value, sourceName:String, targetName:String, comma:Bool):String {
        final value = readNumber(object, sourceName);
        if (!value.ok) return "";
        return "  " + quote(targetName) + ": " + number(value.value) + (comma ? ",\n" : "\n");
    }

    static function optionalReadStringLine(value:StringRead, targetName:String, comma:Bool):String {
        if (!value.ok) return "";
        return "  " + quote(targetName) + ": " + quote(value.value) + (comma ? ",\n" : "\n");
    }

    static function readString(object:Value, name:String):StringRead {
        return switch object {
            case JObject(keys, values):
                final i = fieldIndex(keys, name);
                if (i < 0) return StringRead.failure();
                switch values[i] {
                    case JString(value): StringRead.success(value);
                    case _: StringRead.failure();
                }
            case _:
                StringRead.failure();
        }
    }

    static function readNumber(object:Value, name:String):NumberRead {
        return switch object {
            case JObject(keys, values):
                final i = fieldIndex(keys, name);
                if (i < 0) return NumberRead.failure();
                switch values[i] {
                    case JNumber(value): NumberRead.success(value);
                    case _: NumberRead.failure();
                }
            case _:
                NumberRead.failure();
        }
    }

    static function readBool(object:Value, name:String):BoolRead {
        return switch object {
            case JObject(keys, values):
                final i = fieldIndex(keys, name);
                if (i < 0) return BoolRead.failure();
                switch values[i] {
                    case JBool(value): BoolRead.success(value);
                    case _: BoolRead.failure();
                }
            case _:
                BoolRead.failure();
        }
    }

    static function requestIdFor(object:Value, entry:String):String {
        final requestId = readString(object, "requestId");
        if (requestId.ok && requestId.value.length > 0) return requestId.value;
        if (StringTools.endsWith(entry, ".json")) return entry.substr(0, entry.length - 5);
        return entry;
    }

    static function firstEnv(first:String, second:String, ?third:String, ?fourth:String):String {
        final firstValue = Sys.getEnv(first);
        if (firstValue != null && firstValue.length > 0) return firstValue;
        final secondValue = Sys.getEnv(second);
        if (secondValue != null && secondValue.length > 0) return secondValue;
        if (third != null) {
            final thirdValue = Sys.getEnv(third);
            if (thirdValue != null && thirdValue.length > 0) return thirdValue;
        }
        if (fourth != null) {
            final fourthValue = Sys.getEnv(fourth);
            if (fourthValue != null && fourthValue.length > 0) return fourthValue;
        }
        return "";
    }

    static function joinPath(base:String, entry:String):String {
        if (base.length == 0) return entry;
        if (StringTools.endsWith(base, "/")) return base + entry;
        return base + "/" + entry;
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

    static function compareStrings(a:String, b:String):Int {
        if (a < b) return -1;
        if (a > b) return 1;
        return 0;
    }

    static function fieldIndex(keys:Array<String>, name:String):Int {
        var i = 0;
        while (i < keys.length) {
            if (keys[i] == name) return i;
            i = i + 1;
        }
        return -1;
    }

    static function quote(value:String):String {
        return JsonScalar.quote(value);
    }

    static function number(value:Float):String {
        final intValue = Std.int(value);
        if (value == intValue) return Std.string(intValue);
        return Std.string(value);
    }
}

class StringRead {
    public final ok:Bool;
    public final value:String;

    function new(ok:Bool, value:String) {
        this.ok = ok;
        this.value = value;
    }

    public static function success(value:String):StringRead {
        return new StringRead(true, value);
    }

    public static function failure():StringRead {
        return new StringRead(false, "");
    }
}

class NumberRead {
    public final ok:Bool;
    public final value:Float;

    function new(ok:Bool, value:Float) {
        this.ok = ok;
        this.value = value;
    }

    public static function success(value:Float):NumberRead {
        return new NumberRead(true, value);
    }

    public static function failure():NumberRead {
        return new NumberRead(false, 0);
    }
}

class BoolRead {
    public final ok:Bool;
    public final value:Bool;

    function new(ok:Bool, value:Bool) {
        this.ok = ok;
        this.value = value;
    }

    public static function success(value:Bool):BoolRead {
        return new BoolRead(true, value);
    }

    public static function failure():BoolRead {
        return new BoolRead(false, false);
    }
}
