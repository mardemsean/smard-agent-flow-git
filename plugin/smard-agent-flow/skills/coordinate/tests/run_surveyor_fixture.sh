#!/usr/bin/env bash
# Run from the repository root; prompts carry repo-relative paths, so dispatch from the repository root too.
#   bash skills/coordinate/tests/run_surveyor_fixture.sh prompts           print the three dispatch prompts for fixture-1
#   bash skills/coordinate/tests/run_surveyor_fixture.sh validate [dir]    validate captures (default skills/coordinate/tests/captures)
#   bash skills/coordinate/tests/run_surveyor_fixture.sh selftest          RED/GREEN check of the validator on the bad and sample fixtures
# Captures are saved by the dispatching session as <dir>/{handoffs,channel,tasks-and-docs}.json.
set -u
D=skills/coordinate
SCHEMA=$D/assets/surveyor-output.schema.json
V=$D/scripts/validate.py
PROMPT=$D/prompts/surveyor-dispatch.md
CONFIG=$D/assets/examples/coordination.fixture-1.json
FIX=$D/tests/fixtures/fixture-1
CUTOFF=2026-10-05T12:30:00Z
BUDGET=60
SCHEMAS=$D/assets
SCOPES="handoffs channel tasks-and-docs"

prompts() { # [fixture root] [scopes...]
  local fix=${1:-$FIX}; shift || true
  local scopes=${*:-$SCOPES}
  [ -f "$PROMPT" ] || { echo "FAIL prompts: $PROMPT missing"; return 1; }
  python3 -I - "$PROMPT" "$CONFIG" "$fix" "$CUTOFF" "$BUDGET" "$SCHEMAS" $scopes <<'PY'
import json, re, sys
tpl = open(sys.argv[1], encoding="utf-8").read()
cfg = json.load(open(sys.argv[2], encoding="utf-8"))
fix, cutoff, budget, schemas, scopes = sys.argv[3], sys.argv[4], sys.argv[5], sys.argv[6], sys.argv[7:]
cfg["project_root"] = fix + "/proj"
if cfg.get("channel"):
    cfg["channel"]["path"] = fix + "/channel"
rc = 0
for s in scopes:
    out = (tpl.replace("{scope}", s)
              .replace("{config_json}", json.dumps(cfg, indent=2))
              .replace("{cutoff_utc}", cutoff)
              .replace("{size_budget_kb}", budget)
              .replace("{schemas_dir}", schemas))
    left = sorted(set(re.findall(r"\{(?:scope|config_json|cutoff_utc|size_budget_kb|schemas_dir)\}", out)))
    if left:
        print("FAIL prompt %s: unsubstituted %s" % (s, left)); rc = 1
    print("===== DISPATCH PROMPT scope=%s (agent coordinate-surveyor) =====" % s)
    print(out)
    print("===== END scope=%s =====" % s)
sys.exit(rc)
PY
}

validate() { # dir
  local dir=${1:-$D/tests/captures} fails=0 s f rc err
  for s in $SCOPES; do
    f=$dir/$s.json
    if [ ! -f "$f" ]; then echo "SKIP $s: capture missing"; continue; fi
    err=$(python3 -I "$V" "$SCHEMA" "$f" 2>&1 >/dev/null); rc=$?
    if [ "$rc" -eq 0 ]; then echo "PASS $s: schema"; else echo "FAIL $s: schema rc=$rc $err"; fails=$((fails+1)); fi
    err=$(python3 -I - "$f" "$s" <<'PY'
import json, sys
try:
    d = json.load(open(sys.argv[1], encoding="utf-8"))
except Exception as e:
    print("unreadable: %s" % e); sys.exit(1)
bad = []
if d.get("scope") != sys.argv[2]:
    bad.append("scope is %r, expected %r" % (d.get("scope"), sys.argv[2]))
for i, x in enumerate(d.get("facts") or []):
    if isinstance(x, dict) and x.get("tag") == "verified-this-run" and not str(x.get("source", "")).strip():
        bad.append("facts[%d] verified-this-run with empty source" % i)
raw = open(sys.argv[1], encoding="utf-8").read()
for m in ("/home/", "/root/"):
    if m in raw:
        bad.append("machine path %s appears %d times" % (m, raw.count(m)))
print("; ".join(bad)); sys.exit(1 if bad else 0)
PY
); rc=$?
    if [ "$rc" -eq 0 ]; then echo "PASS $s: sourced verified facts, scope, no machine paths"; else echo "FAIL $s: $err"; fails=$((fails+1)); fi
  done
  [ "$fails" -eq 0 ]
}

selftest() {
  local fails=0
  if validate "$D/tests/fixtures/captures-bad" >/dev/null; then echo "FAIL selftest: bad capture accepted"; fails=$((fails+1)); else echo "PASS selftest: bad capture rejected"; fi
  if validate "$D/tests/fixtures/captures-sample"; then echo "PASS selftest: sample capture accepted"; else echo "FAIL selftest: sample capture rejected"; fails=$((fails+1)); fi
  # padded copy: one handoff over the 60 KB budget; the handoffs prompt must carry the budget and the size rule
  local tmp out h
  tmp=$(mktemp -d)
  cp -r "$FIX" "$tmp/fixture-1"
  h=$tmp/fixture-1/proj/HANDOFF.coordinator-2026-10-05.md
  python3 -I -c 'import sys; open(sys.argv[1], "a", encoding="utf-8").write("\n<!-- padding -->\n" + ("x" * 99 + "\n") * 700)' "$h"
  if [ "$(wc -c < "$h")" -gt $((BUDGET * 1024)) ]; then echo "PASS selftest: padded handoff exceeds ${BUDGET} KB"; else echo "FAIL selftest: padded handoff exceeds ${BUDGET} KB"; fails=$((fails+1)); fi
  out=$(prompts "$tmp/fixture-1" handoffs 2>&1)
  if [ $? -eq 0 ] && printf '%s' "$out" | grep -qF "Size budget: \`${BUDGET}\` KB per file" \
     && printf '%s' "$out" | grep -qF "a file over \`${BUDGET}\` KB is read only in its cold-start section" \
     && printf '%s' "$out" | grep -qF "\"project_root\": \"$tmp/fixture-1/proj\""; then
    echo "PASS selftest: padded-copy handoffs prompt carries the ${BUDGET} KB budget"
  else echo "FAIL selftest: padded-copy handoffs prompt carries the ${BUDGET} KB budget"; fails=$((fails+1)); fi
  rm -rf "$tmp"
  [ "$fails" -eq 0 ]
}

case "${1:-}" in
  prompts) shift; prompts "$@" ;;
  validate) validate "${2:-}" ;;
  selftest) selftest ;;
  *) echo "usage: $0 prompts|validate [dir]|selftest" >&2; exit 2 ;;
esac
