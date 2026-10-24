#!/usr/bin/env bash
# Run from the repository root: bash skills/coordinate/tests/test_render.sh
set -u
D=skills/coordinate
A=$D/assets
R=$D/scripts/render_page.py
E=$A/examples
T=$(mktemp -d)
trap 'rm -rf "$T"' EXIT
FAILS=0
ok()   { echo "PASS $1"; }
bad()  { echo "FAIL $1"; FAILS=$((FAILS+1)); }
rc_is() { # name, expected, actual
  if [ "$3" -eq "$2" ]; then ok "$1"; else bad "$1 (rc=$3, expected $2)"; fi
}
has() { # name, file, fixed string
  if grep -qF -- "$3" "$2"; then ok "$1"; else bad "$1"; fi
}
render_case() { # label template json sections...
  local label=$1 tpl=$2 js=$3; shift 3
  local out=$T/$label.html
  python3 -I "$R" "$tpl" "$js" "$out" >/dev/null 2>&1
  rc_is "$label renders (exit 0)" 0 $?
  [ -f "$out" ] || { bad "$label output exists"; return; }
  has "$label has <title>" "$out" "<title>"
  for id in "$@"; do has "$label has section id $id" "$out" "id:'$id'"; done
  if grep -qF '/*DATA*/' "$out"; then bad "$label has no /*DATA*/ left"; else ok "$label has no /*DATA*/ left"; fi
  python3 -I - "$out" "$T/$label.js" <<'PY'
import re, sys
html = open(sys.argv[1], encoding="utf-8").read()
blocks = [m.group(1) for m in re.finditer(r"<script(?![^>]*\bsrc=)[^>]*>(.*?)</script>", html, re.S)]
open(sys.argv[2], "w", encoding="utf-8").write(blocks[-1] if blocks else "")
PY
  if ! command -v node >/dev/null 2>&1; then echo "SKIP $label node --check (node absent)"
  elif node --check "$T/$label.js" 2>/dev/null; then ok "$label inline script passes node --check"; else bad "$label inline script passes node --check"; fi
  n=$(grep -o '<script[^>]*src=' "$out" | wc -l)
  [ "$n" -eq 2 ] && ok "$label loads exactly two external scripts" || bad "$label loads exactly two external scripts ($n)"
  if grep -o 'src="[^"]*"' "$out" | grep -vqE '^src="https://cdnjs\.cloudflare\.com/ajax/libs/react(-dom)?/18\.3\.1/'; then bad "$label scripts only from cdnjs react 18.3.1"; else ok "$label scripts only from cdnjs react 18.3.1"; fi
}
render_case situation "$A/situation-report.template.html" "$E/situation.smard-2026-10-24.json" \
  sucessao sessoes estado cadeia tarefas verificacao pendencias
render_case plan "$A/retake-plan.template.html" "$E/retake-plan.smard-2026-10-24.json" \
  diagnostico opcoes plano dia0 papeis done custo riscos
# verify_block variants: "no block" shows the warning box; "rerun" with empty rows shows the no-rows text
python3 -I - "$E/situation.smard-2026-10-24.json" "$T" <<'PY'
import json, sys
d = json.load(open(sys.argv[1])); t = sys.argv[2]
d["verify_block"] = {"status": "no block", "rows": []}
json.dump(d, open(t + "/vb-noblock.json", "w"))
d["verify_block"] = {"status": "rerun", "rows": []}
json.dump(d, open(t + "/vb-norows.json", "w"))
PY
for v in noblock norows; do
  python3 -I "$R" "$A/situation-report.template.html" "$T/vb-$v.json" "$T/vb-$v.html" >/dev/null 2>&1
  rc_is "verify_block $v renders (exit 0)" 0 $?
done
if ! command -v node >/dev/null 2>&1; then echo "SKIP verify_block page text (node absent)"
else
  for v in noblock norows; do
    python3 -I - "$T/vb-$v.html" "$T/vb-$v.js" <<'PY'
import re, sys
html = open(sys.argv[1], encoding="utf-8").read()
blocks = [m.group(1) for m in re.finditer(r"<script(?![^>]*\bsrc=)[^>]*>(.*?)</script>", html, re.S)]
open(sys.argv[2], "w", encoding="utf-8").write(blocks[-1] if blocks else "")
PY
    # evaluate the page script with a minimal React stub and collect every rendered text node
    cat > "$T/vb-run.js" <<'JS'
const fs = require('fs');
const [, , f, v] = process.argv;
const src = fs.readFileSync(f, 'utf8');
const texts = [];
const walk = (n) => { if (n == null || n === false) return; if (Array.isArray(n)) return n.forEach(walk);
  if (typeof n === 'string' || typeof n === 'number') { texts.push(String(n)); return; }
  if (typeof n.t === 'function') return walk(n.t(Object.assign({}, n.p, {children: n.c})));
  walk(n.c); };
const React = {createElement: (t, p, ...c) => ({t, p: p || {}, c: c.length === 1 ? c[0] : c}), Fragment: 'frag',
  useState: (x) => [typeof x === 'function' ? x() : x, () => {}], useEffect: () => {}, useMemo: (fn) => fn(), useRef: (x) => ({current: x})};
const ReactDOM = {createRoot: () => ({render: walk})};
const el = {setAttribute() {}, getAttribute() { return null; }, addEventListener() {}, classList: {add() {}, remove() {}, toggle() {}}};
const document = {getElementById: () => el, documentElement: el, querySelector: () => el, title: ''};
const window = {matchMedia: () => ({matches: false, addEventListener() {}}), addEventListener() {}};
const localStorage = {getItem() { return null; }, setItem() {}};
new Function('React', 'ReactDOM', 'document', 'window', 'localStorage', src)(React, ReactDOM, document, window, localStorage);
const all = texts.join('\n');
const W = 'The latest handoff carries no verify block', N = 'The verify block was rerun but lists no rows.';
const [want, notWant] = v === 'noblock' ? [W, N] : [N, W];
process.exit(all.includes(want) && !all.includes(notWant) ? 0 : 1);
JS
    if node "$T/vb-run.js" "$T/vb-$v.js" "$v"; then ok "verify_block $v page shows the expected text"; else bad "verify_block $v page shows the expected text"; fi
  done
fi
# examples carry no machine path, session id or task id
if grep -lP '/home/|/root/|[A-Z]:\\\\|cse_(?!EXAMPLE|autor\b)|session_0|trig_0' "$E"/*.json >/dev/null; then bad "examples have no path, session id or task id"; else ok "examples have no path, session id or task id"; fi
# templates carry no absolute path, hostname or session id
for t in situation-report retake-plan; do
  if grep -nE 'cse_|session_0|[A-Z]:\\\\?|/home/|/Users/' "$A/$t.template.html" >/dev/null; then bad "$t template has no path or session id"; else ok "$t template has no path or session id"; fi
done
# the injected JSON cannot break out of the script
python3 -I - "$E/situation.smard-2026-10-24.json" "$T/evil.json" <<'PY'
import json, sys
d = json.load(open(sys.argv[1])); d["project"] = "x</script><b>y"
json.dump(d, open(sys.argv[2], "w"))
PY
python3 -I "$R" "$A/situation-report.template.html" "$T/evil.json" "$T/evil.html" >/dev/null 2>&1
rc_is "script-breaking data renders" 0 $?
if grep -qF '</script><b>' "$T/evil.html"; then bad "</script in data is escaped"; else ok "</script in data is escaped"; fi
# invalid data -> 1, with a path line
python3 -I - "$E/situation.smard-2026-10-24.json" "$T/bad.json" <<'PY'
import json, sys
d = json.load(open(sys.argv[1])); d["lineage"][0]["tag"] = "confirmed"
json.dump(d, open(sys.argv[2], "w"))
PY
err=$(python3 -I "$R" "$A/situation-report.template.html" "$T/bad.json" "$T/bad.html" 2>&1 >/dev/null); rc=$?
rc_is "invalid data exits 1" 1 $rc
case "$err" in '$.lineage[0].tag:'*) ok "invalid data prints path line";; *) bad "invalid data prints path line ($err)";; esac
[ ! -e "$T/bad.html" ] && ok "invalid data writes no output" || bad "invalid data writes no output"
# explicit --schema overrides the basename choice
python3 -I "$R" "$A/situation-report.template.html" "$E/retake-plan.smard-2026-10-24.json" "$T/x.html" --schema "$A/retake-plan.schema.json" >/dev/null 2>&1
rc_is "--schema override accepted" 0 $?
# short scores array -> 1 with the specific message
python3 -I - "$E/retake-plan.smard-2026-10-24.json" "$T/short.json" <<'PY'
import json, sys
d = json.load(open(sys.argv[1])); d["options"][0]["scores"].pop()
json.dump(d, open(sys.argv[2], "w"))
PY
err=$(python3 -I "$R" "$A/retake-plan.template.html" "$T/short.json" "$T/short.html" 2>&1 >/dev/null); rc=$?
rc_is "short scores exits 1" 1 $rc
case "$err" in 'scores length must equal criteria length for option A'*) ok "short scores message";; *) bad "short scores message ($err)";; esac
# unknown template prefix without --schema -> 3
cp "$A/retake-plan.template.html" "$T/other.template.html"
python3 -I "$R" "$T/other.template.html" "$E/retake-plan.smard-2026-10-24.json" "$T/o.html" >/dev/null 2>&1
rc_is "unknown template prefix exits 3" 3 $?
# template without placeholder -> 2
printf '<title>t</title><script>var DATA = 1;</script>' > "$T/situation-nodata.template.html"
python3 -I "$R" "$T/situation-nodata.template.html" "$E/situation.smard-2026-10-24.json" "$T/n.html" >/dev/null 2>&1
rc_is "template without placeholder exits 2" 2 $?
# unreadable input -> 3
python3 -I "$R" "$A/situation-report.template.html" "$T/absent.json" "$T/a.html" >/dev/null 2>&1
rc_is "unreadable json exits 3" 3 $?
python3 -I "$R" "$T/absent.template.html" "$E/situation.smard-2026-10-24.json" "$T/a.html" >/dev/null 2>&1
rc_is "unreadable template exits 3" 3 $?
[ "$FAILS" -eq 0 ] && echo "ALL PASS" || echo "$FAILS FAILED"
[ "$FAILS" -eq 0 ]
