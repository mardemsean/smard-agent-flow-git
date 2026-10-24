#!/usr/bin/env python3
"""Validate a JSON file against a JSON Schema (draft 2020-12).

Usage: python3 -I validate.py <schema> <json>
Relative $ref values resolve against the schema file's directory; only bare *.json
basenames in that directory are accepted (no subpaths, no other extensions).
Exit 0 valid; 1 invalid (best-match error, JSON path on one line, on stderr);
2 unreadable input; 3 missing jsonschema dependency.
Note: -I ignores user site-packages, so jsonschema and referencing must be installed system-wide
(pip install jsonschema referencing --break-system-packages).
"""
import json
import os
import sys


def main(argv):
    if len(argv) != 3:
        print("usage: validate.py <schema> <json>", file=sys.stderr)
        return 2
    try:
        with open(argv[1], encoding="utf-8") as f:
            schema = json.load(f)
        with open(argv[2], encoding="utf-8") as f:
            data = json.load(f)
    except (OSError, ValueError) as e:
        print("unreadable: %s" % e, file=sys.stderr)
        return 2
    try:
        from jsonschema import Draft202012Validator
        from jsonschema.exceptions import best_match, SchemaError
        from referencing.exceptions import Unresolvable
        from referencing import Registry, Resource
        from referencing.jsonschema import DRAFT202012
    except ImportError:
        print("missing dependency: jsonschema and referencing", file=sys.stderr)
        return 3
    base = os.path.dirname(os.path.abspath(argv[1]))

    def retrieve(uri):
        # Relative $ref resolves against the schema file's directory; no escaping it.
        name = os.path.basename(uri)
        if name != uri or not name.endswith(".json"):
            raise ValueError("unresolvable $ref: %s" % uri)
        with open(os.path.join(base, name), encoding="utf-8") as f:
            return Resource.from_contents(json.load(f), default_specification=DRAFT202012)

    registry = Registry(retrieve=retrieve)
    try:
        Draft202012Validator.check_schema(schema)
        errors = list(Draft202012Validator(schema, registry=registry).iter_errors(data))
    except Unresolvable as e:
        print("unresolvable $ref: %s" % getattr(e, "ref", e), file=sys.stderr)
        return 2
    except SchemaError as e:
        print("invalid schema: %s" % e.message, file=sys.stderr)
        return 2
    if not errors:
        return 0
    e = best_match(errors)
    path = "$" + "".join("[%d]" % p if isinstance(p, int) else "." + p for p in e.absolute_path)
    print("%s: %s" % (path, e.message), file=sys.stderr)
    return 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
