#!/usr/bin/env bash
# Tests for scripts/ste_check.py. Run: bash tests/test_ste_check.sh
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHK="$HERE/../scripts/ste_check.py"; FX="$HERE/fixtures"; PY="${PYTHON:-python3}"
FAILS=0
# t NAME WANT_EXIT PATTERN ARGS...   (PATTERN "-" means no pattern check)
t() {
  local name="$1" want="$2" pat="$3" out code; shift 3
  out="$("$PY" "$CHK" "$@" 2>&1)"; code=$?
  if [ "$code" -ne "$want" ]; then
    echo "FAIL $name (exit $code, want $want)"; echo "$out" | head -3 | sed 's/^/     /'; FAILS=$((FAILS+1)); return
  fi
  if [ "$pat" != "-" ] && ! grep -Eq -- "$pat" <<<"$out"; then
    echo "FAIL $name (no match for: $pat)"; echo "$out" | head -3 | sed 's/^/     /'; FAILS=$((FAILS+1)); return
  fi
  echo "PASS $name"
}
t pass-clean        0 'errors=0 info=0 sentences=' "$FX/pass.ste.md"
t exempt-code       0 'errors=0 info=0'            "$FX/exempt.code.md"
t len-procedural    1 ' 5\.1 error'                "$FX/fail.length-proc.md"
t len-descriptive   1 ' 6\.3 error'                "$FX/fail.length-desc.md"
t paragraph-7       1 ' 6\.6 error'  "$FX/fail.paragraph.md"
t paragraph-count   1 'sentences=7'                "$FX/fail.paragraph.md"
t two-instructions  1 ' 5\.2 error'                "$FX/fail.two-instr.md"
t ing-form          1 ' 3\.5 error'                "$FX/fail.ing.md"
t ing-allow         0 'errors=0'                   "$FX/fail.ing.md" --allow cooling,foo
t passive-proc      1 ' 3\.6 error'                "$FX/fail.passive.md"
t contraction       1 ' 4\.2a error'               "$FX/fail.contraction.md"
t slash             1 ' SLASH error'               "$FX/fail.slash.md"
t semicolon         1 ' 8\.1 error'                "$FX/fail.semicolon.md"
t colon             1 ' COLON error'               "$FX/fail.colon.md"
t paren-proc        1 ' PAREN error'               "$FX/fail.paren.md"
t label-own-par     1 ' SAFETY error'              "$FX/fail.label.md"
t note-command      1 ' 5\.5 error'                "$FX/fail.note-command.md"
t latin-abbrev      1 ' GR-6 error'                "$FX/fail.latin.md"
t list-layout       1 ' 4\.3a error'               "$FX/fail.list.md"
t list-last-period  1 ' 4\.3b error'               "$FX/fail.list.md"
t have-participle   1 ' 3\.2a error'               "$FX/fail.have.md"
t make-sure-that    1 ' GR-1 error'                "$FX/fail.makesure.md"
t pronoun-he        1 ' GR-3 error'                "$FX/fail.pronoun.md"
t path-punct        0 'errors=0'                   "$FX/exempt.pathpunct.md"
t slash-still-flag  1 ' SLASH error'               "$FX/fail.slash.md"
t labels-ok         0 'errors=0'                   "$FX/pass.labels.md"
t colon-still-flag  1 ' COLON error'               "$FX/fail.colon.md"
t quote-one-word    0 'errors=0'                   "$FX/pass.quote-length.md"
t quoted-exempt     0 'errors=0'                   "$FX/exempt.quoted.md"
t auto-ordinal-proc 1 ' 5\.1 error'                "$FX/auto.ordinal.md" --mode auto
t colon-quote-ok    0 'errors=0'                   "$FX/pass.colon-quote.md"
t colon-verb-label  1 ' COLON error'               "$FX/fail.colon-verb-label.md"
t colon-inline-list 1 ' COLON error'               "$FX/fail.colon-list.md"
t colon-verb-label2 1 ' COLON error'               "$FX/fail.colon-verb-label2.md"
t colon-note-subject 0 'errors=0'                  "$FX/pass.note-subject.md"
t quote-multiline   0 'errors=0'                   "$FX/pass.quote-multiline.md"
t slash-words       1 ' SLASH error'               "$FX/fail.slash-words.md"
t info-numword      0 ' NUM info'                  "$FX/info.numword.md"
t info-cluster      0 ' 2\.1 info'                 "$FX/info.cluster.md"
t info-passive-desc 0 ' 3\.6 info'                 "$FX/info.passive-desc.md"
t mode-descriptive  0 'errors=0'                   "$FX/fail.length-proc.md" --mode descriptive
t mode-procedural   1 ' 5\.1 error'                "$FX/fail.length-desc.md" --mode procedural
t json-output       1 '"rule": "5\.1"'             "$FX/fail.length-proc.md" --json
t align-ok          0 'aligned'                    --align "$FX/align.en.md" "$FX/align.pt.md"
t align-bad-par     1 'paragraphs: en=5 pt=6'      --align "$FX/align.en.md" "$FX/misalign.pt.md"
t align-bad-sent    1 'paragraph 2: sentences en=2 pt=1' --align "$FX/align.en.md" "$FX/misalign.pt.md"
t usage-none        2 'usage:'
t usage-bad-mode    2 'usage:'                     "$FX/pass.ste.md" --mode nonsense
t usage-align-one   2 'usage:'                     --align "$FX/align.en.md"
t io-missing        2 'ste_check: cannot read'     "$FX/does-not-exist.md"
if [ "$FAILS" -eq 0 ]; then echo "ALL PASS"; exit 0; else echo "$FAILS FAILED"; exit 1; fi
