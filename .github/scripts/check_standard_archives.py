#!/usr/bin/env python3
"""Verify that preserved standard editions still match their manifests."""

import argparse
import hashlib
import json
from pathlib import Path
import sys


def verify(root: Path) -> int:
    editions = {path for path in root.glob("**/versions/*") if path.is_dir()}
    if not editions:
        raise ValueError("No standard editions found")
    for edition in sorted(editions):
        manifest = json.loads((edition / "manifest.json").read_text())
        if manifest["schema_version"] != 1 or manifest["edition_id"] != edition.name:
            raise ValueError(f"{edition}: invalid manifest schema or edition identifier")
        listed = set()
        for entry in manifest["files"]:
            name = entry["path"]
            path = edition / name
            if (not path.resolve().is_relative_to(edition.resolve())
                    or name in listed or name == "manifest.json"):
                raise ValueError(f"{edition}: invalid or duplicate file {name!r}")
            listed.add(name)
            data = path.read_bytes()
            if len(data) != entry["bytes"] or hashlib.sha256(data).hexdigest() != entry["sha256"]:
                raise ValueError(f"{path}: archived bytes differ from the manifest")
        actual = {str(path.relative_to(edition)) for path in edition.rglob("*")
                  if path.is_file() and path != edition / "manifest.json"}
        if "index.md" not in listed or actual != listed:
            raise ValueError(f"{edition}: manifest does not cover every archived file")
        print(f"Verified {edition.name}: {len(listed)} files")
    return len(editions)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path,
                        default=Path(__file__).resolve().parents[2] / "content/en/standards")
    args = parser.parse_args()
    try:
        count = verify(args.root)
    except (OSError, ValueError, KeyError, TypeError) as error:
        print(f"Archive verification failed: {error}", file=sys.stderr)
        sys.exit(1)
    print(f"Verified {count} standard edition(s).")
