# Vendor Policy

This directory is intentionally empty during G0/G1.

Do not copy upstream Codex, Cafex, or haxe.rust here yet. Use pinned external checkouts recorded in `reference/`.

Potential future uses:

- a git submodule mount for haxe.rust if CI/reproducibility needs it
- a narrow vendored helper crate or generated fixture snapshot approved by a specific bead
- upstream audit receipts documenting why a dependency pin changed

Whole-source vendor copies should be a last resort.
