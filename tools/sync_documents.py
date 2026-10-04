#!/usr/bin/env python3
"""Rewrite documents/ from docs/.

docs/ is the GitHub Pages (Jekyll) source. documents/ is the same content in a
form that can be read directly:
  * the `permalink:` front-matter line is removed, and
  * {{ '/page.html#anchor' | relative_url }} links become page.md#anchor.

Usage (from the repository root):  python3 tools/sync_documents.py [--check]
With --check, nothing is written; the exit status is 1 if documents/ is stale.
"""
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
LINK = re.compile(r"\{\{\s*'/([A-Za-z0-9_-]+)\.html(#[A-Za-z0-9_-]+)?'\s*\|\s*relative_url\s*\}\}")


def convert(text: str) -> str:
    lines = [ln for ln in text.split("\n") if not ln.startswith("permalink:")]
    return LINK.sub(lambda m: f"{m.group(1)}.md{m.group(2) or ''}", "\n".join(lines))


def main() -> int:
    check = "--check" in sys.argv
    src, dst = ROOT / "docs", ROOT / "documents"
    stale = []
    for page in sorted(src.glob("*.md")):
        out = convert(page.read_text(encoding="utf-8"))
        target = dst / page.name
        if not target.exists() or target.read_text(encoding="utf-8") != out:
            stale.append(page.name)
            if not check:
                target.write_text(out, encoding="utf-8")
    for extra in sorted(dst.glob("*.md")):
        if not (src / extra.name).exists():
            print(f"warning: documents/{extra.name} has no source in docs/")
    if stale:
        print(("stale: " if check else "updated: ") + ", ".join(stale))
    else:
        print("documents/ is in sync with docs/")
    return 1 if (check and stale) else 0


if __name__ == "__main__":
    sys.exit(main())
