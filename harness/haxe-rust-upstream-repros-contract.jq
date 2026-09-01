def active_pressure_gap_ids($pressure):
  [
    $pressure.gaps[]
    | select(.status == "open_upstream" or .status == "local_workaround")
    | .id
  ]
  | sort;

def mapped_pressure_gap_ids:
  [.repros[].pressureGapId] | sort;

(active_pressure_gap_ids($p[0])) as $active
| (mapped_pressure_gap_ids) as $mapped
| $mapped == $active
  and ($active | unique | length) == ($active | length)
  and ($mapped | unique | length) == ($mapped | length)
  and all(.repros[];
    if .status == "expected_cargo_failure" then
      (.haxeRustFixturePath | startswith("test/repro/upstream_open_gaps/"))
      and .compileFile == "compile.hxml"
    elif .status == "fix_in_review" then
      (.haxeRustFixturePath | startswith("test/snapshot/"))
      and (.pullRequest | test("^https://github.com/[^/]+/[^/]+/pull/[0-9]+$"))
      and (.fixtureCommit | test("^[0-9a-f]{40}$"))
    else
      false
    end
  )
  and all(.repros[];
    . as $repro
    | $repro.entrypoint == "Main.hx"
    and ($repro.compileFile // "") != ""
    and ($repro.profileCompileFiles | type) == "array"
    and ($repro.profileCompileFiles | length) > 0
    and ($repro.profileCompileFiles | index($repro.compileFile)) != null
    and all($repro.profileCompileFiles[]; test("^compile(?:\\.[a-z0-9_-]+)?\\.hxml$"))
  )
  and all(.repros[]; (.expectedFailureSignature // "") != "")
  and all(.repros[]; (.upstreamableContract // "") != "")
  and (
    [
      .repros[] as $repro
      | any(
          $p[0].gaps[];
          .id == $repro.pressureGapId
          and (.status == "open_upstream" or .status == "local_workaround")
        )
    ]
    | all
  )
