#!/usr/bin/env python3
"""ste_check.py - mechanical checker for Simplified Technical English.

Rules are paraphrased from ASD-STE100 Issue 9, Part 1 (writing rules).
No dictionary is shipped. Heuristics may give false positives: the model
reviews each finding before it acts on it.

Usage: ste_check.py FILE [--mode procedural|descriptive|auto] [--allow w,w] [--json]
       ste_check.py --align EN_FILE PT_FILE
Output: LINE:COL RULE SEVERITY message, then a summary line.
Exit:   0 no errors, 1 errors (or misaligned), 2 usage or I/O error.
"""
import argparse
import json
import re
import sys

# Common imperative verbs; used only to guess "procedural" and "two instructions".
IMPERATIVES = set("""add adjust align apply attach bleed break build check clean click close connect
continue copy create cut delete disconnect do drain enter ensure examine fill find get give go hold
identify inspect install keep let lift load lock loosen lubricate make measure move open operate
pour press pull push put read record refer release remove repair replace report reset restart
review rotate run save see select send set show start stop take test tighten turn type unlock use
verify wait write""".split())
# Words that do not count as content words for the noun-cluster heuristic (rule 2.1).
FUNC = set("""the a an of to in for with and or is are was were be been on at by from if then that this
these those it its you we they not do does did can will must may should as but when until before
after into onto up down out off over under between through each all any no more most than only
also so there here which who what how where while your their our""".split())
# -ing words accepted without --allow: nouns and one preposition, kept short on purpose.
ING_OK = set("thing string ring spring bearing wiring setting warning housing during nothing something".split())
# Words that look like participles (-ed/-en) but are not.
NOT_PART = set("often seven token green screen speed indeed proceed exceed need bleed feed".split())
UNITS = set("""mm cm m km kg g mg l ml psi bar v a hz khz mhz ghz s ms min h n nm pa kpa mpa w kw
kb mb gb tb %""".split())
ABBR = set("etc e.g i.e vs dr dra sr sra prof fig cf no".split())
QUOTED = re.compile(r'"[^"]*"|“[^”]*”')  # may wrap lines; a paragraph holds no blank line
ARTICLES = set("the a an this that these those".split())
HEAD = re.compile(r"[A-Z][\w-]*(?:\s+[\w-]+){0,2}")  # label before a colon: 1-3 words
LABEL = re.compile(r"(Note|NOTE|Warning|WARNING|Caution|CAUTION)\s*:")
PASSIVE = re.compile(r"\b(?:am|is|are|was|were|be|been|being)\s+(?:\w+ly\s+)?"
                     r"([A-Za-z]{3,}(?:ed|en)|made|done|shown|given|held|kept|left|sent|built|"
                     r"found|lost|known|taken|written)\b", re.I)
HAVE = re.compile(r"\b(?:has|have|had)\s+(?:been|[a-z]{3,}(?:ed|en))\b", re.I)
CONTR = re.compile(r"\b[A-Za-z]+(?:n['’]t|['’](?:re|ve|ll|d|m))\b"
                   r"|\b(?:it|that|there|here|let|what|who|he|she)['’]s\b", re.I)


class Block:
    """A heading, a list item or a paragraph, with source line numbers."""
    def __init__(self, kind, lines):
        self.kind, self.lines = kind, lines

    @property
    def text(self):
        return "\n".join(s for _, s in self.lines)

    def loc(self, pos):
        for n, s in self.lines:
            if pos <= len(s):
                return n, pos + 1
            pos -= len(s) + 1
        n, s = self.lines[-1]
        return n, len(s) + 1


def parse_blocks(raw):
    """Split into blocks. Fenced code vanishes, inline code becomes one 'X', markers become spaces."""
    blocks, cur, fence = [], None, None
    for i, line in enumerate(raw, 1):
        s = line.rstrip("\r\n")
        m = re.match(r"\s*(```|~~~)", s)
        if fence:
            if m and m.group(1) == fence:
                fence = None
            cur = None
            continue
        if m:
            fence, cur = m.group(1), None
            continue
        s = re.sub(r"`[^`\n]*`", lambda x: " " * (len(x.group()) - 1) + "X", s)
        s = re.sub(r"^\s*>\s?", lambda x: " " * len(x.group()), s)
        if not s.strip() or re.fullmatch(r"\s*([-*_])(\s*\1){2,}\s*", s):
            cur = None
            continue
        h = re.match(r"\s{0,3}#{1,6}\s+", s)
        li = re.match(r"\s*(?:[-*+]|\d+[.)])\s+", s)
        if h:
            blocks.append(Block("header", [(i, " " * h.end() + s[h.end():])]))
            cur = None
        elif li:
            cur = Block("list", [(i, " " * li.end() + s[li.end():])])
            blocks.append(cur)
        else:
            if cur is None:
                cur = Block("para", [])
                blocks.append(cur)
            cur.lines.append((i, s))
    return blocks


def split_sentences(text):
    """Return [(offset, sentence)]. Terminators . ! ? ; skips abbreviations and decimals."""
    out, start = [], 0
    # A terminator inside a quoted string does not end the sentence (rule 8.6): blank it for the scan.
    scan = QUOTED.sub(lambda m: re.sub(r"[.!?]+(?=\s)", lambda t: "_" * len(t.group()), m.group()), text)

    def add(a, b):
        seg = text[a:b]
        if re.search(r"\w", seg):
            out.append((a + len(seg) - len(seg.lstrip()), seg.strip()))

    for m in re.finditer(r"[.!?]+[)\"'”’»\]]*(?=\s|$)", scan):
        if m.group() == ".":
            w = re.search(r"[\w.]+$", scan[start:m.start()])
            w = w.group().lower() if w else ""
            if w in ABBR and not (w == "etc" and text[m.end():].lstrip()[:1].isupper()):
                continue
        add(start, m.end())
        start = m.end()
    add(start, len(text))
    return out


def count_words(s):
    """Rules 8.5-8.7: quoted text and (parenthesized text) count as one word; number+unit is one."""
    s = re.sub(r'"[^"]*"|“[^”]*”', "Q", s)
    s = re.sub(r"\([^()]*\)", "P", s)
    toks = [t for t in s.split() if re.search(r"\w", t)]
    n = i = 0
    while i < len(toks):
        n += 1
        if (re.fullmatch(r"\d[\d.,]*", toks[i].strip(".,;:")) and i + 1 < len(toks)
                and toks[i + 1].strip(".,;:").lower() in UNITS):
            i += 1
        i += 1
    return n


def mask_quotes(s):
    """Quoted strings are one word and exempt from word-level checks; keep offsets."""
    return QUOTED.sub(lambda m: "Q" + " " * (len(m.group()) - 1), s)


def is_path(t):
    """A token with '/' is a path when, minus edge punctuation, it looks like a file or URL."""
    t = re.sub(r"^[(\[\"'“`]+|[.,;:!?)\]\"'”`]+$", "", t)
    return bool(re.match(r"(https?://|www\.|[./~]|[A-Za-z]:\\)", t) or re.search(r"\.\w+", t)
                or t.count("/") > 1)


def is_imperative(s):
    s = LABEL.sub("", s, count=1).strip()
    s = re.sub(r"(?:first|second|third|next|then|finally|now|last)\b,?\s+", "", s, count=1, flags=re.I)
    c = re.match(r"(?:if|when|before|after|while|until)\b[^,]*,\s*(.*)", s, re.I | re.S)
    if c:
        s = c.group(1)
    w = re.match(r"[A-Za-z]+", s)
    return bool(w) and w.group().lower() in IMPERATIVES


def analyse(blocks, mode, allow):
    F, nsent = [], 0
    for bi, b in enumerate(blocks):
        if b.kind == "header":
            continue
        text = b.text
        nxt = blocks[bi + 1] if bi + 1 < len(blocks) else None
        sents = split_sentences(text)
        nsent += len(sents)

        def add(pos, rule, sev, msg, b=b):
            F.append(b.loc(pos) + (rule, sev, msg))

        if b.kind == "para" and len(sents) > 6:
            add(sents[6][0], "6.6", "error", "paragraph has %d sentences (maximum 6)" % len(sents))
        for m in LABEL.finditer(text):
            if text[:m.start()].strip():
                add(m.start(), "SAFETY", "error", "%s must start its own paragraph" % m.group(1))
        if b.kind == "list":
            a = re.search(r"[A-Za-z]", text)
            if a and not a.group().isupper():
                add(a.start(), "4.3a", "error", "list item must start with a capital letter")
            end = text.rstrip()
            if end.endswith(","):
                add(len(end) - 1, "4.3b", "error", "list item must not end with a comma")
            if not (nxt and nxt.kind == "list") and not re.search(r"[.!?]$", end):
                add(len(end) - 1, "4.3b", "error", "last list item must end with a period")

        for k, (pos, s) in enumerate(sents):
            lm = LABEL.match(s)
            label = lm.group(1).lower() if lm else None
            body = " " * lm.end() + s[lm.end():] if lm else s
            imp = is_imperative(body)
            if label == "note":
                kind = "note"
            elif label or mode == "procedural":
                kind = "proc"
            elif mode == "descriptive":
                kind = "desc"
            else:
                kind = "proc" if (b.kind == "list" or imp) else "desc"

            def hit(off, rule, sev, msg, pos=pos):
                add(pos + off, rule, sev, msg)

            raw = body
            body = mask_quotes(body)
            n = max([count_words(raw)] + [count_words(g) for g in re.findall(r"\(([^()]*)\)", raw)])
            rule, limit = {"note": ("5.5a", 25), "desc": ("6.3", 25), "proc": ("5.1", 20)}[kind]
            if n > limit:
                hit(0, rule, "error", "sentence has %d words (maximum %d)" % (n, limit))
            if kind == "note" and imp:
                hit(0, "5.5", "error", "a note gives information only, not a command")
            if kind == "proc":
                parts = re.split(r",\s*(?:and\s+|then\s+)?|\s+(?:and|then)\s+", body)
                if sum(1 for p in parts if re.match(r"\s*([A-Za-z]+)", p)
                       and re.match(r"\s*([A-Za-z]+)", p).group(1).lower() in IMPERATIVES) > 1:
                    hit(0, "5.2", "error", "more than one instruction in one sentence")
                for m in re.finditer(r"\(([^()]*)\)", body):
                    if not re.fullmatch(r"[A-Za-z0-9.\-]{1,8}", m.group(1)):
                        hit(m.start(), "PAREN", "error", "parentheses in a procedural sentence")
            for m in PASSIVE.finditer(body):
                if m.group(1).lower() not in NOT_PART:
                    hit(m.start(), "3.6", "error" if kind == "proc" else "info",
                        "passive voice: '%s'" % m.group())
            for m in HAVE.finditer(body):
                hit(m.start(), "3.2a", "error", "perfect tense: '%s'" % m.group())
            for m in CONTR.finditer(body):
                hit(m.start(), "4.2a", "error", "contraction: '%s'" % m.group())
            for m in re.finditer(r"[A-Za-z]+ing\b", body):
                w, lw = m.group(), m.group().lower()
                if len(w) <= 4 or lw in ING_OK or lw in allow:
                    continue
                if body[max(m.start() - 1, 0):m.start()] == "-" or body[m.end():m.end() + 1] == "-":
                    continue
                if w[0].isupper() and body[:m.start()].strip():
                    continue
                hit(m.start(), "3.5", "error", "-ing form '%s' (use --allow for technical names)" % w)
            for m in re.finditer(r"\S+", body):
                t = m.group()
                if re.search(r"[A-Za-z]/[A-Za-z]", t) and not is_path(t):
                    hit(m.start() + t.index("/"), "SLASH", "error", "slash between words: '%s'" % t)
            for m in re.finditer(";", body):
                hit(m.start(), "8.1", "error", "semicolon: use two sentences")
            for m in re.finditer(":", body):
                after = body[m.end():m.end() + 1]
                if after and not after.isspace():
                    continue
                lead_in = k == len(sents) - 1 and body.rstrip().endswith(":") and nxt and nxt.kind == "list"
                head = body[:m.start()].strip()
                if after and (re.match(r"\s+[QX](?!\w)", body[m.end():]) or (HEAD.fullmatch(head) and "," not in body[m.end():]
                        and head.split()[0].lower() not in FUNC | IMPERATIVES
                        and not any(w.lower() in ARTICLES for w in head.split()))):
                    continue
                if not lead_in:
                    hit(m.start(), "COLON", "error", "colon only before a list")
                elif re.search(r"\bdo not\b", body, re.I):
                    hit(m.start(), "4.3d", "error", "put DO NOT inside each list item, not in the lead-in")
            for m in re.finditer(r"\b(two|three|four|five|six|seven|eight|nine)\b", body, re.I):
                hit(m.start(), "NUM", "info", "write '%s' as a digit" % m.group())
            for m in re.finditer(r"\bmake sure\s+(?!that\b)", body, re.I):
                hit(m.start(), "GR-1", "error", "keep 'that' after 'make sure'")
            for m in re.finditer(r"\b(he|she|him|his)\b", body, re.I):
                hit(m.start(), "GR-3", "error", "use a noun or 'you', not '%s'" % m.group())
            for m in re.finditer(r"(?<![\w.])(?:e\.g|i\.e|etc)\b\.?", body, re.I):
                hit(m.start(), "GR-6", "error", "Latin abbreviation '%s'" % m.group())
            run, first = 0, 0
            for m in re.finditer(r"\S+", body + " ."):
                w = re.sub(r"^\W+|\W+$", "", m.group()).lower()
                if w and w not in FUNC:
                    if run == 0:
                        first = m.start()
                    run += 1
                if not w or w in FUNC or re.search(r"[,;:.!?)]$", m.group()):
                    if run >= 4:
                        hit(first, "2.1", "info", "noun cluster of %d words" % run)
                    run = 0
    return sorted(set(F)), nsent


def align(en_path, pt_path):
    def counts(path):
        with open(path, encoding="utf-8") as f:
            bl = parse_blocks(f.readlines())
        return [(b.lines[0][0], 1 if b.kind == "header" else len(split_sentences(b.text))) for b in bl]
    a, p = counts(en_path), counts(pt_path)
    bad = []
    if len(a) != len(p):
        bad.append("paragraphs: en=%d pt=%d" % (len(a), len(p)))
    for i, (x, y) in enumerate(zip(a, p), 1):
        if x[1] != y[1]:
            bad.append("paragraph %d: sentences en=%d pt=%d (en line %d, pt line %d)" % (i, x[1], y[1], x[0], y[0]))
    print("\n".join(bad) if bad else "aligned paragraphs=%d" % len(a))
    return 1 if bad else 0


def main(argv=None):
    ap = argparse.ArgumentParser(prog="ste_check.py", description="Mechanical STE checker (ASD-STE100 Issue 9, Part 1).")
    ap.add_argument("files", nargs="+", metavar="FILE")
    ap.add_argument("--mode", choices=["procedural", "descriptive", "auto"], default="auto")
    ap.add_argument("--allow", default="", help="comma-separated -ing words to accept")
    ap.add_argument("--json", action="store_true")
    ap.add_argument("--align", action="store_true", help="compare EN_FILE and PT_FILE structure")
    args = ap.parse_args(argv)
    if len(args.files) != (2 if args.align else 1):
        ap.error("--align needs EN_FILE PT_FILE" if args.align else "exactly one FILE is required")
    try:
        if args.align:
            return align(*args.files)
        with open(args.files[0], encoding="utf-8") as f:
            raw = f.readlines()
    except (OSError, UnicodeDecodeError) as e:
        print("ste_check: cannot read: %s" % e, file=sys.stderr)
        return 2
    allow = {w.strip().lower() for w in args.allow.split(",") if w.strip()}
    found, nsent = analyse(parse_blocks(raw), args.mode, allow)
    errors = sum(1 for f in found if f[3] == "error")
    info = len(found) - errors
    if args.json:
        print(json.dumps({"findings": [dict(zip(("line", "col", "rule", "severity", "message"), f)) for f in found],
                          "summary": {"errors": errors, "info": info, "sentences": nsent}}, indent=1))
    else:
        for l, c, r, s, m in found:
            print("%d:%d %s %s %s" % (l, c, r, s, m))
        print("errors=%d info=%d sentences=%d" % (errors, info, nsent))
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
