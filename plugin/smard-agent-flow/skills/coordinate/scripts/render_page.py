#!/usr/bin/env python3
"""Render a coordinate page: inject validated JSON into an HTML + React template.

Usage: python3 -I render_page.py <template> <json> <out.html> [--schema <schema.json>]
Without --schema the schema is chosen by the template basename prefix:
  situation-   -> ../assets/situation.schema.json
  retake-plan- -> ../assets/retake-plan.schema.json
(a "." after the name, as in retake-plan.template.html, is accepted in place of "-")
The template must contain the placeholder /*DATA*/ exactly once (inside `const DATA = /*DATA*/;`).
Exit 0 ok; 1 data invalid, including option scores whose length differs from criteria (validate.py's path line on stderr, no output written);
2 template placeholder missing (or repeated); 3 unreadable input, unknown schema or missing dependency.
"""
import json
import os
import subprocess
import sys

PLACEHOLDER = "/*DATA*/"
HERE = os.path.dirname(os.path.abspath(__file__))
ASSETS = os.path.join(os.path.dirname(HERE), "assets")
PREFIXES = (("situation", "situation.schema.json"), ("retake-plan", "retake-plan.schema.json"))


def main(argv):
    args = argv[1:]
    schema = None
    if "--schema" in args:
        i = args.index("--schema")
        if i + 1 >= len(args):
            print("usage: render_page.py <template> <json> <out.html> [--schema <schema.json>]", file=sys.stderr)
            return 3
        schema = args[i + 1]
        del args[i:i + 2]
    if len(args) != 3:
        print("usage: render_page.py <template> <json> <out.html> [--schema <schema.json>]", file=sys.stderr)
        return 3
    template, data_path, out = args
    if schema is None:
        base = os.path.basename(template)
        for prefix, name in PREFIXES:
            if base.startswith(prefix) and base[len(prefix):len(prefix) + 1] in ("-", "."):
                schema = os.path.join(ASSETS, name)
                break
        else:
            print("unreadable: no schema for template %r (use --schema)" % base, file=sys.stderr)
            return 3
    try:
        with open(template, encoding="utf-8") as f:
            html = f.read()
        with open(data_path, encoding="utf-8") as f:
            data = json.load(f)
    except (OSError, ValueError) as e:
        print("unreadable: %s" % e, file=sys.stderr)
        return 3
    if html.count(PLACEHOLDER) != 1:
        print("template placeholder %s must occur exactly once (found %d)" % (PLACEHOLDER, html.count(PLACEHOLDER)), file=sys.stderr)
        return 2
    r = subprocess.run([sys.executable, "-I", os.path.join(HERE, "validate.py"), schema, data_path],
                       capture_output=True, text=True)
    if r.returncode == 1:
        sys.stderr.write(r.stderr)
        return 1
    if r.returncode != 0:
        sys.stderr.write(r.stderr)
        return 3
    if isinstance(data, dict) and isinstance(data.get("options"), list) and isinstance(data.get("criteria"), list):
        for o in data["options"]:
            if isinstance(o, dict) and len(o.get("scores", [])) != len(data["criteria"]):
                print("scores length must equal criteria length for option %s" % o.get("id"), file=sys.stderr)
                return 1
    payload = json.dumps(data, ensure_ascii=False)
    payload = payload.replace("</script", "<\\/script").replace("<!--", "<\\!--")
    try:
        with open(out, "w", encoding="utf-8") as f:
            f.write(html.replace(PLACEHOLDER, payload, 1))
    except OSError as e:
        print("unreadable: %s" % e, file=sys.stderr)
        return 3
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
