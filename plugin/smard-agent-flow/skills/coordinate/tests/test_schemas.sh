#!/usr/bin/env bash
# Run from the repository root: bash skills/coordinate/tests/test_schemas.sh
set -u
D=skills/coordinate
S=$D/assets/coordination.schema.json
V=$D/scripts/validate.py
E=$D/assets/examples
T=$(mktemp -d)
trap 'rm -rf "$T"' EXIT
FAILS=0
expect() { # name, expected_rc, schema, json
  python3 -I "$V" "$3" "$4" >/dev/null 2>&1
  rc=$?
  if [ "$rc" -eq "$2" ]; then echo "PASS $1"; else echo "FAIL $1 (rc=$rc, expected $2)"; FAILS=$((FAILS+1)); fi
}
for f in coordination.smard-drive-index coordination.fixture-1 coordination.no-channel; do
  expect "example $f validates" 0 "$S" "$E/$f.json"
done
python3 -I - "$E/coordination.smard-drive-index.json" "$T" <<'PY'
import json, sys
d = json.load(open(sys.argv[1])); t = sys.argv[2]
a = dict(d); a["handoff_skill"] = "other"
json.dump(a, open(t + "/bad-skill.json", "w"))
b = dict(d); del b["project_root"]
json.dump(b, open(t + "/no-root.json", "w"))
c = dict(d); c["extra"] = 1
json.dump(c, open(t + "/extra.json", "w"))
e = dict(d); e["recent_handoffs"] = 0
json.dump(e, open(t + "/zero.json", "w"))
f = json.loads(json.dumps(d)); f["channel"]["kind"] = "other"
json.dump(f, open(t + "/kind.json", "w"))
g = json.loads(json.dumps(d)); g["channel"]["extra"] = "x"
json.dump(g, open(t + "/chextra.json", "w"))
h = dict(d); h["deliverables_dir"] = 5
json.dump(h, open(t + "/deliv.json", "w"))
PY
expect "handoff_skill other fails" 1 "$S" "$T/bad-skill.json"
expect "missing project_root fails" 1 "$S" "$T/no-root.json"
expect "unknown top-level key fails" 1 "$S" "$T/extra.json"
expect "recent_handoffs 0 fails" 1 "$S" "$T/zero.json"
expect "unreadable file exits 2" 2 "$S" "$T/absent.json"
err=$(python3 -I "$V" "$S" "$T/absent.json" 2>&1 >/dev/null)
case "$err" in unreadable:*) echo "PASS unreadable stderr prefix";; *) echo "FAIL unreadable stderr prefix ($err)"; FAILS=$((FAILS+1));; esac
err=$(python3 -I "$V" "$S" "$T/bad-skill.json" 2>&1 >/dev/null)
case "$err" in '$.handoff_skill:'*) echo "PASS invalid prints path on stderr";; *) echo "FAIL invalid prints path on stderr ($err)"; FAILS=$((FAILS+1));; esac
expect "channel wrong kind fails" 1 "$S" "$T/kind.json"
expect "channel extra key fails" 1 "$S" "$T/chextra.json"
expect "deliverables_dir number fails" 1 "$S" "$T/deliv.json"
err=$(python3 -I "$V" "$S" "$T/kind.json" 2>&1 >/dev/null)
case "$err" in '$.channel.kind:'*) echo "PASS channel error path is specific";; *) echo "FAIL channel error path is specific ($err)"; FAILS=$((FAILS+1));; esac
# Task 2: situation and retake-plan schemas, shared tags schema, $ref resolution
SS=$D/assets/situation.schema.json
PS=$D/assets/retake-plan.schema.json
expect "situation sample validates" 0 "$SS" "$E/situation.smard-2026-10-24.json"
expect "retake-plan sample validates" 0 "$PS" "$E/retake-plan.smard-2026-10-24.json"
python3 -I - "$E/situation.smard-2026-10-24.json" "$E/retake-plan.smard-2026-10-24.json" "$D/assets/tags.schema.json" "$T" <<'PY'
import json, sys, shutil
sit = json.load(open(sys.argv[1])); plan = json.load(open(sys.argv[2])); t = sys.argv[4]
a = json.loads(json.dumps(sit)); a["lineage"][0]["tag"] = "confirmed"
json.dump(a, open(t + "/sit-bad-tag.json", "w"))
b = json.loads(json.dumps(plan)); del b["cost"]["statement"]
json.dump(b, open(t + "/plan-no-statement.json", "w"))
def mut(name, base, fn):
    x = json.loads(json.dumps(base)); fn(x); json.dump(x, open(t + "/" + name + ".json", "w"))
mut("plan-weight6", plan, lambda x: x["criteria"][0].__setitem__("weight", 6))
mut("plan-method", plan, lambda x: x["matrix"].__setitem__("method", "guess"))
mut("sit-vstatus", sit, lambda x: x["verify_block"].__setitem__("status", "ok"))
mut("sit-extra", sit, lambda x: x.__setitem__("extra", 1))
mut("sit-nochain", sit, lambda x: x.pop("chain"))
shutil.copy(sys.argv[3], t + "/tags.schema.json")
json.dump({"$schema": "https://json-schema.org/draft/2020-12/schema", "$id": "refprobe.schema.json",
           "type": "object", "required": ["tag"], "additionalProperties": False,
           "properties": {"tag": {"$ref": "tags.schema.json"}}}, open(t + "/refprobe.schema.json", "w"))
json.dump({"tag": "inference"}, open(t + "/ref-ok.json", "w"))
json.dump({"tag": "confirmed"}, open(t + "/ref-bad.json", "w"))
PY
expect "criteria weight 6 fails" 1 "$PS" "$T/plan-weight6.json"
expect "matrix.method guess fails" 1 "$PS" "$T/plan-method.json"
expect "verify_block.status ok fails" 1 "$SS" "$T/sit-vstatus.json"
expect "situation extra top-level key fails" 1 "$SS" "$T/sit-extra.json"
expect "situation without chain fails" 1 "$SS" "$T/sit-nochain.json"
expect "situation tag 'confirmed' fails" 1 "$SS" "$T/sit-bad-tag.json"
expect "plan without cost.statement fails" 1 "$PS" "$T/plan-no-statement.json"
expect "\$ref schema accepts valid tag" 0 "$T/refprobe.schema.json" "$T/ref-ok.json"
expect "\$ref schema rejects invalid tag" 1 "$T/refprobe.schema.json" "$T/ref-bad.json"
# Task 5: reviewer output schema and the reviewer sample runner
RS=$D/assets/reviewer-output.schema.json
RR=$D/tests/run_reviewer_sample.sh
CS=$D/tests/fixtures/captures-sample
CB=$D/tests/fixtures/captures-bad
expect "reviewer sample validates" 0 "$RS" "$CS/reviewer.json"
expect "reviewer class 'style' fails" 1 "$RS" "$CB/reviewer-style.json"
expect "reviewer nine findings fail" 1 "$RS" "$CB/reviewer-nine.json"
expect "reviewer fail without reserved passes the schema" 0 "$RS" "$CB/reviewer-fail-no-reserved.json"
out=$(bash "$RR" validate "$CB/reviewer-fail-no-reserved.json" 2>&1); rc=$?
case "$rc:$out" in [1-9]*FAIL*) echo "PASS runner FAILs verdict fail without reserved";; *) echo "FAIL runner FAILs verdict fail without reserved (rc=$rc)"; FAILS=$((FAILS+1));; esac
out=$(bash "$RR" validate "$CS/reviewer.json" 2>&1); rc=$?
if [ "$rc" -eq 0 ] && ! printf '%s' "$out" | grep -q FAIL; then echo "PASS runner accepts reviewer sample"; else echo "FAIL runner accepts reviewer sample (rc=$rc) $out"; FAILS=$((FAILS+1)); fi
out=$(bash "$RR" validate "$T/absent-reviewer.json" 2>&1); rc=$?
case "$rc:$out" in 0:SKIP*) echo "PASS runner SKIPs an absent capture";; *) echo "FAIL runner SKIPs an absent capture (rc=$rc)"; FAILS=$((FAILS+1));; esac
for c in reviewer-bad-quote reviewer-bad-path; do
  out=$(bash "$RR" validate "$CB/$c.json" 2>&1); rc=$?
  case "$rc:$out" in [1-9]*FAIL*evidence*) echo "PASS runner FAILs unresolved evidence ($c)";; *) echo "FAIL runner FAILs unresolved evidence ($c) (rc=$rc)"; FAILS=$((FAILS+1));; esac
done
out=$(bash "$RR" prompts 2>&1); rc=$?
if [ "$rc" -eq 0 ] && printf '%s' "$out" | grep -qF "$E/retake-plan.smard-2026-10-24.json" \
   && printf '%s' "$out" | grep -qF "$E/situation.smard-2026-10-24.json" \
   && ! printf '%s' "$out" | grep -qE '\{(plan_json_path|situation_json_path|schemas_dir)\}|/home/|/root/'; then
  echo "PASS runner prints the substituted reviewer prompt with repo-relative paths"
else echo "FAIL runner prints the substituted reviewer prompt with repo-relative paths (rc=$rc)"; FAILS=$((FAILS+1)); fi
# Task 6: SKILL.md frontmatter (YAML parses; name; description starts "Use when"; exact argument-hint),
# length <= 12000, no /home/, /root/, drive path or cse_ in SKILL.md and the handshake reference
out=$(python3 -I - "$D/SKILL.md" <<'PY2' 2>&1
import sys
try:
    import yaml
except ImportError:
    print("no-yaml"); sys.exit(3)
try:
    t = open(sys.argv[1], encoding="utf-8").read()
except OSError as e:
    print("unreadable: %s" % e); sys.exit(2)
parts = t.split("---", 2)
if not t.startswith("---") or len(parts) < 3:
    print("no frontmatter"); sys.exit(1)
fm = yaml.safe_load(parts[1])
bad = []
if not isinstance(fm, dict): bad.append("frontmatter not a mapping")
else:
    if fm.get("name") != "coordinate": bad.append("name=%r" % fm.get("name"))
    if not str(fm.get("description", "")).startswith("Use when"): bad.append("description does not start with 'Use when'")
    if fm.get("argument-hint") != "[survey | plan | elect | all]": bad.append("argument-hint=%r" % fm.get("argument-hint"))
if len(t) > 12000: bad.append("SKILL.md has %d characters (> 12000)" % len(t))
import os, re
ref = os.path.join(os.path.dirname(sys.argv[1]), "assets", "handshake-v1.reference.md")
for name, txt in (("SKILL.md", t), ("handshake-v1.reference.md", open(ref, encoding="utf-8").read())):
    for pat in (r"/home/", r"/root/", r"[A-Z]:\\", r"cse_(?!autor\b)"):  # the field name cse_autor is documented; session ids are not
        if re.search(pat, txt): bad.append("%s contains %s" % (name, pat))
if bad: print("; ".join(bad)); sys.exit(1)
PY2
); rc=$?
if [ "$rc" -eq 0 ]; then echo "PASS SKILL.md frontmatter"; else echo "FAIL SKILL.md frontmatter ($out)"; FAILS=$((FAILS+1)); fi
[ "$FAILS" -eq 0 ] && echo "ALL PASS" || echo "$FAILS FAILED"
[ "$FAILS" -eq 0 ]
