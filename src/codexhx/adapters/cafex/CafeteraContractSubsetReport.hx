package codexhx.adapters.cafex;

import codexhx.protocol.JsonScalar;

class CafeteraContractSubsetReport {
    public static inline final schema = "codex-hxrust.cafetera-contract-subset-report.v1";
    public static inline final defaultGeneratedAt = "2026-06-10T00:00:06Z";

    public static function reportJson(?generatedAt:String):String {
        final contracts = coveredContracts();
        final gaps = knownGaps();
        final generated = generatedAt == null ? defaultGeneratedAt : generatedAt;

        var out = "{\n";
        out += "  \"schema\": " + quote(schema) + ",\n";
        out += "  \"generatedAt\": " + quote(generated) + ",\n";
        out += "  \"source\": \"cafetera-codex-module-contract-subset\",\n";
        out += "  \"scope\": \"fixture-backed hxrust subset only\",\n";
        out += "  \"productionReplacement\": false,\n";
        out += "  \"replacementClaim\": \"none\",\n";
        out += "  \"summary\": {\n";
        out += "    \"covered\": " + Std.string(contracts.length) + ",\n";
        out += "    \"passed\": " + Std.string(contracts.length) + ",\n";
        out += "    \"failed\": 0,\n";
        out += "    \"gaps\": " + Std.string(gaps.length) + "\n";
        out += "  },\n";
        out += "  \"contracts\": [\n";
        for (i in 0...contracts.length) {
            out += contractJson(contracts[i]);
            if (i < contracts.length - 1) out += ",";
            out += "\n";
        }
        out += "  ],\n";
        out += "  \"unsupportedFailures\": [\n";
        for (i in 0...gaps.length) {
            out += gapJson(gaps[i]);
            if (i < gaps.length - 1) out += ",";
            out += "\n";
        }
        out += "  ]\n";
        out += "}";
        return out;
    }

    static function coveredContracts():Array<CafeteraContractSubsetContract> {
        return [
            new CafeteraContractSubsetContract(
                "hxcx-5.1-caf-session-turn-receipts",
                "HXCX-5.1",
                "pass",
                "fixture_pass",
                "Caf session and turn receipt writer",
                "harness/check-caf-receipts.sh",
                [
                    "fixtures/cafex/caf-session-receipt-resume.v1.json",
                    "fixtures/cafex/caf-turn-receipt-startup.v1.json"
                ],
                "Validates env-owned receipt paths, successor/predecessor metadata, deterministic pretty JSON, no-op behavior, overwrite behavior, and unsupported source rejection."
            ),
            new CafeteraContractSubsetContract(
                "hxcx-5.2-caf-effort-wake-bridge",
                "HXCX-5.2",
                "pass",
                "fixture_pass",
                "Caf effort, wake, and invalid mode directory bridge",
                "harness/check-caf-bridge.sh",
                [
                    "fixtures/cafex/caf-effort-request.v1.json",
                    "fixtures/cafex/caf-effort-receipt.v1.json",
                    "fixtures/cafex/caf-wake-request.v1.json",
                    "fixtures/cafex/caf-wake-receipt.v1.json",
                    "fixtures/cafex/caf-mode-unsupported-request.v1.json",
                    "fixtures/cafex/caf-mode-unsupported-receipt.v1.json"
                ],
                "Validates request scanning, accepted effort aliases, consumed wake receipts, invalid mode refusal, malformed effort refusal, unknown schema skips, and idempotent duplicate scans."
            ),
            new CafeteraContractSubsetContract(
                "hxcx-5.3-caf-goal-tool-flow",
                "HXCX-5.3",
                "pass",
                "fixture_pass",
                "Minimal Caf goal DTO, state, and tool flow",
                "harness/check-goals.sh",
                [
                    "fixtures/hxrust/thread-goal-active.v1.json",
                    "fixtures/hxrust/thread-goal-transition.v1.jsonl",
                    "fixtures/hxrust/goal-tool-output.v1.jsonl"
                ],
                "Validates app/server goal JSON, in-memory lifecycle transitions, token usage accounting, model-facing goal tools, and explicit unsupported tool/status behavior."
            ),
            new CafeteraContractSubsetContract(
                "hxcx-8.1-caf-goal-apply-bridge",
                "HXCX-8.1",
                "pass",
                "fixture_pass",
                "Caf goal-apply request and receipt bridge",
                "harness/check-caf-bridge.sh",
                [
                    "fixtures/cafex/caf-goal-apply-request.v1.json",
                    "fixtures/cafex/caf-goal-apply-receipt.v1.json",
                    "fixtures/cafex/caf-goal-clear-request.v1.json",
                    "fixtures/cafex/caf-goal-clear-receipt.v1.json",
                    "fixtures/cafex/caf-goal-invalid-request.v1.json",
                    "fixtures/cafex/caf-goal-invalid-receipt.v1.json"
                ],
                "Validates Caf/Ralph goal-apply request parsing, Brew completion authority guards, ThreadGoalStore application, clear-boundary receipts, invalid request refusal, and idempotent duplicate scans."
            ),
            new CafeteraContractSubsetContract(
                "hxcx-8.3-caf-queue-reconcile-bridge",
                "HXCX-8.3",
                "pass",
                "fixture_pass",
                "Caf queue-reconcile request and receipt bridge rails",
                "harness/check-caf-bridge.sh",
                [
                    "fixtures/cafex/caf-queue-reconcile-request.v1.json",
                    "fixtures/cafex/caf-queue-reconcile-receipt.v1.json"
                ],
                "Validates queue-reconcile request scanning, deterministic receipt writing, Brew delivery-decision field preservation, and explicit no-claim runtime queue mutation metadata."
            ),
            new CafeteraContractSubsetContract(
                "hxcx-8.4-caf-mode-apply-bridge-rails",
                "HXCX-8.4",
                "pass",
                "fixture_pass",
                "Caf mode-apply request and next-turn receipt bridge rails",
                "harness/check-caf-bridge.sh",
                [
                    "fixtures/cafex/caf-mode-plan-request.v1.json",
                    "fixtures/cafex/caf-mode-plan-receipt.v1.json",
                    "fixtures/cafex/caf-mode-default-request.v1.json",
                    "fixtures/cafex/caf-mode-default-receipt.v1.json",
                    "fixtures/cafex/caf-mode-unsupported-request.v1.json",
                    "fixtures/cafex/caf-mode-unsupported-receipt.v1.json"
                ],
                "Validates plan/default mode request scanning, accepted mode aliases, deterministic next-turn receipts, plan-checkpoint boundary field preservation, and explicit no-claim current-turn mutation metadata."
            ),
            new CafeteraContractSubsetContract(
                "hxcx-8.2-caf-active-lane-capability",
                "HXCX-8.2",
                "pass",
                "fixture_pass",
                "Caf active-lane capability and native live-status DTO writer",
                "harness/check-caf-active-lane.sh",
                [
                    "fixtures/cafex/caf-active-lane.v1.json",
                    "fixtures/cafex/caf-active-lane-no-native-status.v1.json"
                ],
                "Validates deterministic active-lane capability advertisement, runtime request/receipt/control schema lists, optional native live-status DTO, run-id selection, wake directories, and fail-closed owner/native PID proof."
            ),
            new CafeteraContractSubsetContract(
                "hxcx-5.4-caf-continuity-metadata",
                "HXCX-5.4",
                "pass",
                "fixture_pass",
                "Wake/restart successor and predecessor continuity metadata",
                "harness/check-caf-continuity.sh",
                [
                    "fixtures/cafex/caf-continuity-metadata-resume.v1.json",
                    "fixtures/cafex/caf-continuity-metadata-fresh.v1.json",
                    "fixtures/cafex/caf-continuity-session-receipt.v1.json",
                    "fixtures/cafex/caf-continuity-turn-receipt-fresh.v1.json"
                ],
                "Validates explicit successor/predecessor parsing, resume/fresh continuity derivation, receipt writes from parsed metadata, and invalid metadata rejection."
            )
        ];
    }

    static function knownGaps():Array<CafeteraContractSubsetGap> {
        return [
            new CafeteraContractSubsetGap(
                "full-cafetera-codex-module-suite",
                "gap",
                "unsupported_full_cafetera_cli",
                "The full Cafetera Codex module contract runner is not yet pointed at a production hxrust binary.",
                "Keep this report limited to the selected fixture-backed subset until the runtime adapter is executable from Cafetera."
            ),
            new CafeteraContractSubsetGap(
                "live-native-tui-event-loop",
                "gap",
                "unsupported_live_tui_runtime",
                "The subset checks receipts and bridge files but does not replace the native Codex TUI event loop.",
                "Wire app events and terminal/runtime behavior in later Cafex adapter milestones."
            ),
            new CafeteraContractSubsetGap(
                "native-restart-cutover",
                "gap",
                "unsupported_native_restart_cutover",
                "Continuity metadata is parsed and written, but no fork/exec or process handoff is performed by hxrust.",
                "Treat restart proof as metadata-level compatibility only."
            ),
            new CafeteraContractSubsetGap(
                "caf-mode-apply-runtime",
                "gap",
                "unsupported_mode_apply_runtime",
                "Mode-apply bridge rails emit next-turn receipts for supported modes, but live TUI/runtime collaboration-mode mutation is not implemented.",
                "Implement a generic runtime mode state surface before claiming current-turn or native TUI mode replacement."
            ),
            new CafeteraContractSubsetGap(
                "credentialed-live-model-runtime",
                "gap",
                "unsupported_live_model_runtime",
                "The contract subset uses credential-free fixtures and mock stream handling, not a live networked model provider.",
                "Keep secrets and model credentials outside fixture gates."
            )
        ];
    }

    static function contractJson(contract:CafeteraContractSubsetContract):String {
        var out = "    {\n";
        out += "      \"id\": " + quote(contract.id) + ",\n";
        out += "      \"bead\": " + quote(contract.bead) + ",\n";
        out += "      \"status\": " + quote(contract.status) + ",\n";
        out += "      \"classification\": " + quote(contract.classification) + ",\n";
        out += "      \"contract\": " + quote(contract.contract) + ",\n";
        out += "      \"harness\": " + quote(contract.harness) + ",\n";
        out += "      \"sourceFixtures\": " + stringArray(contract.sourceFixtures) + ",\n";
        out += "      \"notes\": " + quote(contract.notes) + "\n";
        out += "    }";
        return out;
    }

    static function gapJson(gap:CafeteraContractSubsetGap):String {
        var out = "    {\n";
        out += "      \"id\": " + quote(gap.id) + ",\n";
        out += "      \"status\": " + quote(gap.status) + ",\n";
        out += "      \"classification\": " + quote(gap.classification) + ",\n";
        out += "      \"reason\": " + quote(gap.reason) + ",\n";
        out += "      \"next\": " + quote(gap.next) + "\n";
        out += "    }";
        return out;
    }

    static function stringArray(values:Array<String>):String {
        var out = "[";
        for (i in 0...values.length) {
            if (i > 0) out += ", ";
            out += quote(values[i]);
        }
        return out + "]";
    }

    static function quote(value:String):String {
        return JsonScalar.quote(value);
    }
}

class CafeteraContractSubsetContract {
    public final id:String;
    public final bead:String;
    public final status:String;
    public final classification:String;
    public final contract:String;
    public final harness:String;
    public final sourceFixtures:Array<String>;
    public final notes:String;

    public function new(id:String, bead:String, status:String, classification:String, contract:String, harness:String, sourceFixtures:Array<String>, notes:String) {
        this.id = id;
        this.bead = bead;
        this.status = status;
        this.classification = classification;
        this.contract = contract;
        this.harness = harness;
        this.sourceFixtures = sourceFixtures;
        this.notes = notes;
    }
}

class CafeteraContractSubsetGap {
    public final id:String;
    public final status:String;
    public final classification:String;
    public final reason:String;
    public final next:String;

    public function new(id:String, status:String, classification:String, reason:String, next:String) {
        this.id = id;
        this.status = status;
        this.classification = classification;
        this.reason = reason;
        this.next = next;
    }
}
