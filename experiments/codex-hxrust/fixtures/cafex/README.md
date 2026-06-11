# Cafex Fixtures

Selected Cafex/Cafetera adapter fixtures live here for M5.

Keep these fixtures adapter-scoped. They should not change upstream-shaped core behavior.

Current fixtures:

- `caf-session-receipt-resume.v1.json` covers a resumed `caf-client-session.v1` receipt with predecessor session proof.
- `caf-turn-receipt-startup.v1.json` covers a fresh startup `caf-client-turn.v1` receipt without predecessor session proof.
- `caf-effort-request.v1.json` and `caf-effort-receipt.v1.json` cover a successful `cafetera.codex.effort-apply-request.v1` -> `cafetera.codex.effort-apply.v1` bridge pass.
- `caf-effort-invalid-request.v1.json` and `caf-effort-invalid-receipt.v1.json` cover fail-closed invalid effort handling.
- `caf-wake-request.v1.json` and `caf-wake-receipt.v1.json` cover the same-process wake request/consumed receipt subset.
- `caf-mode-unsupported-request.v1.json` and `caf-mode-unsupported-receipt.v1.json` cover explicit unsupported mode refusal.
- `caf-continuity-metadata-resume.v1.json` and `caf-continuity-metadata-fresh.v1.json` cover explicit successor/predecessor metadata parsing.
- `caf-continuity-session-receipt.v1.json` and `caf-continuity-turn-receipt-fresh.v1.json` cover receipts written from parsed continuity metadata.
- `cafetera-contract-subset-report.v1.json` records the HXCX-5.5 selected Cafetera contract subset pass/fail/gap classification and explicitly avoids any production replacement claim.
