#!/usr/bin/env bash
# Run from the repository root; prompts carry repo-relative paths, so dispatch from the repository root too.
#   bash skills/coordinate/tests/run_reviewer_sample.sh prompts           print the reviewer dispatch prompt for the plan and situation samples
#   bash skills/coordinate/tests/run_reviewer_sample.sh validate [file]   validate a capture (default skills/coordinate/tests/captures/reviewer.json)
# validate also resolves every evidence pair <json-path>: "<quote>" (pairs joined by " / ") against the samples:
# a path beginning with situation. resolves in the situation sample, any other in the plan sample, and the quote
# must be a substring of the resolved value. A double quote inside a quote is written \" and unescaped before matching.
# The capture is saved by the dispatching session as skills/coordinate/tests/captures/reviewer.json.
set -u
D=skills/coordinate
SCHEMA=$D/assets/reviewer-output.schema.json
V=$D/scripts/validate.py
PROMPT=$D/prompts/reviewer-dispatch.md
PLAN=$D/assets/examples/retake-plan.smard-2026-10-24.json
SIT=$D/assets/examples/situation.smard-2026-10-24.json
SCHEMAS=$D/assets

prompts() {
  [ -f "$PROMPT" ] || { echo "FAIL prompts: $PROMPT missing"; return 1; }
  python3 -I - "$PROMPT" "$PLAN" "$SIT" "$SCHEMAS" <<'PY'
import re, sys
tpl = open(sys.argv[1], encoding="utf-8").read()
out = (tpl.replace("{plan_json_path}", sys.argv[2])
          .replace("{situation_json_path}", sys.argv[3])
          .replace("{schemas_dir}", sys.argv[4]))
left = sorted(set(re.findall(r"\{(?:plan_json_path|situation_json_path|schemas_dir)\}", out)))
print("===== DISPATCH PROMPT (agent coordinate-reviewer) =====")
print(out)
print("===== END =====")
if left:
    print("FAIL prompt: unsubstituted %s" % left); sys.exit(1)
PY
}

validate() { # file
  local f=${1:-$D/tests/captures/reviewer.json} fails=0 rc err
  if [ ! -f "$f" ]; then echo "SKIP reviewer: capture missing ($f)"; return 0; fi
  err=$(python3 -I "$V" "$SCHEMA" "$f" 2>&1 >/dev/null); rc=$?
  if [ "$rc" -eq 0 ]; then echo "PASS reviewer: schema"; else echo "FAIL reviewer: schema rc=$rc $err"; fails=$((fails+1)); fi
  err=$(python3 -I - "$f" "$PLAN" "$SIT" <<'PY'
import json, re, sys
try:
    d = json.load(open(sys.argv[1], encoding="utf-8"))
except Exception as e:
    print("unreadable: %s" % e); sys.exit(1)
bad = []
fs = d.get("findings") if isinstance(d.get("findings"), list) else []
classes = [x.get("class") for x in fs if isinstance(x, dict)]
v = d.get("verdict")
if v == "fail" and "reserved" not in classes:
    bad.append("verdict fail without any reserved finding")
if v == "pass" and fs:
    bad.append("verdict pass with %d findings" % len(fs))
if v == "pass-with-findings" and not fs:
    bad.append("verdict pass-with-findings with no findings")
if "reserved" in classes and v != "fail":
    bad.append("reserved finding present but verdict is %r" % v)
plan = json.load(open(sys.argv[2], encoding="utf-8"))
sit = json.load(open(sys.argv[3], encoding="utf-8"))
PATH = r"[A-Za-z_][A-Za-z0-9_]*(?:\.[A-Za-z_][A-Za-z0-9_]*|\[\d+\])*"
PAIR = re.compile(r'(' + PATH + r'): "(.*?)"(?= / ' + PATH + r': "|$)', re.S)
def resolve(path):
    root, rest = (sit, path[len("situation."):]) if path.startswith("situation.") else (plan, path)
    cur = root
    for name, idx in re.findall(r"([A-Za-z_][A-Za-z0-9_]*)|\[(\d+)\]", rest):
        if name:
            if not isinstance(cur, dict) or name not in cur: return None
            cur = cur[name]
        else:
            i = int(idx)
            if not isinstance(cur, list) or i >= len(cur): return None
            cur = cur[i]
    return cur
for i, x in enumerate(fs):
    ev = x.get("evidence", "") if isinstance(x, dict) else ""
    pos, pairs = 0, []
    for m in PAIR.finditer(ev):
        if m.start() != pos: break
        pairs.append((m.group(1), m.group(2))); pos = m.end() + (3 if ev[m.end():m.end()+3] == " / " else 0)
    if not pairs or pos != len(ev):
        bad.append("findings[%d].evidence does not follow <json-path>: \"<quote>\"" % i); continue
    for path, quote in pairs:
        quote = quote.replace('\\"', '"')
        v = resolve(path)
        if v is None:
            bad.append("findings[%d].evidence path %s does not resolve" % (i, path))
        elif quote not in (v if isinstance(v, str) else json.dumps(v, ensure_ascii=False)):
            bad.append("findings[%d].evidence quote not found at %s" % (i, path))
raw = open(sys.argv[1], encoding="utf-8").read()
for m in ("/home/", "/root/"):
    if m in raw:
        bad.append("machine path %s appears %d times" % (m, raw.count(m)))
print("; ".join(bad)); sys.exit(1 if bad else 0)
PY
); rc=$?
  if [ "$rc" -eq 0 ]; then echo "PASS reviewer: verdict consistent with findings, evidence resolves, no machine paths"; else echo "FAIL reviewer: $err"; fails=$((fails+1)); fi
  [ "$fails" -eq 0 ]
}

case "${1:-}" in
  prompts) prompts ;;
  validate) validate "${2:-}" ;;
  *) echo "usage: $0 prompts|validate [file]" >&2; exit 2 ;;
esac
