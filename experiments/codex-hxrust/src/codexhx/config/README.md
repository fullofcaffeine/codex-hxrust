# Config

Upstream Codex config/profile DTO subsets live here.

Current slice:

- `ConfigProfile`: upstream-first runtime profile projection
- `ConfigProfileParser`: JSON fixture parser with fail-closed required fields
- `ConfigProfileParseOutcome`: generator-friendly parse result wrapper

Native host-specific config reads should be wrapped through explicit interfaces rather than hidden globals.
