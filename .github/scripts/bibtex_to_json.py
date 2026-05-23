#!/usr/bin/env -S uv run
# /// script
# requires-python = ">=3.10"
# dependencies = [
#   "bibtexparser>=2.0.0b9",
# ]
# ///
"""Convert a BibTeX bibliography into Hugo-friendly JSON.

This script is intentionally small and deterministic:
- parse the input BibTeX file with bibtexparser
- normalize each entry into plain JSON data
- sort entries by year descending, then key ascending
- write the result to the requested output path

The output structure is a JSON array of objects with keys:
- key
- type
- sortYear
- fields
- fieldMap
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Iterable

import bibtexparser

_FIELD_CLEANUP_RE = re.compile(r"\\([&%_$#])")


@dataclass(frozen=True)
class NormalizedField:
    name: str
    value: str


@dataclass(frozen=True)
class NormalizedEntry:
    key: str
    entry_type: str
    sort_year: int
    fields: list[NormalizedField]
    field_map: dict[str, str]
    author_list: list[str]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Convert a BibTeX bibliography into Hugo data JSON."
    )
    parser.add_argument(
        "--input",
        required=True,
        type=Path,
        help="Path to the source .bib file.",
    )
    parser.add_argument(
        "--output",
        required=True,
        type=Path,
        help="Path to the JSON file to write.",
    )
    return parser.parse_args()


def normalize_author_name(name: str) -> str:
    """Convert 'Family, Given' BibTeX names to 'Given Family'."""
    name = name.strip()

    if "," not in name:
        return name

    parts = [part.strip() for part in name.split(",")]

    # BibTeX supports:
    #   Family, Given
    #   Family, Jr, Given
    if len(parts) == 2:
        family, given = parts
        return f"{given} {family}"

    if len(parts) >= 3:
        family, jr, given = parts[:3]
        return f"{given} {family}, {jr}"

    return name


def split_author_list(value: str) -> list[str]:
    """Split and normalize BibTeX author strings."""
    return [
        normalize_author_name(item)
        for item in re.split(r"\s+and\s+", value)
        if item.strip()
    ]


def normalize_bibtex_value(value: Any) -> str:
    """Convert a BibTeX field value to a display-friendly string."""
    text = str(value).strip()
    if not text:
        return ""

    # Remove one layer of balanced braces or quotes.
    if len(text) >= 2:
        if text.startswith("{") and text.endswith("}"):
            text = text[1:-1].strip()
        elif text.startswith('"') and text.endswith('"'):
            text = text[1:-1].strip()

    # BibTeX often uses braces for grouping and backslashes for symbol escapes.
    text = text.replace("{", "").replace("}", "")
    text = _FIELD_CLEANUP_RE.sub(r"\1", text)
    return text.strip()


def field_value(entry: Any, name: str) -> str:
    field = entry.fields_dict.get(name)
    if field is None:
        return ""
    return normalize_bibtex_value(field.value)


def infer_sort_year(entry: Any) -> int:
    year_text = field_value(entry, "year")
    match = re.search(r"\d{4}", year_text)
    return int(match.group(0)) if match else 0


def normalize_entry(entry: Any) -> NormalizedEntry:
    fields: list[NormalizedField] = []
    field_map: dict[str, str] = {}

    # Preserve BibTeX field order for the details view.
    for field in entry.fields:
        value = normalize_bibtex_value(field.value)
        fields.append(NormalizedField(name=str(field.key), value=value))
        field_map[str(field.key)] = value

    return NormalizedEntry(
        key=str(entry.key),
        entry_type=str(entry.entry_type).lower(),
        sort_year=infer_sort_year(entry),
        fields=fields,
        field_map=field_map,
        author_list=split_author_list(field_map.get("author", "")),
    )


def parse_bibtex(path: Path) -> list[NormalizedEntry]:
    bibtex_text = path.read_text(encoding="utf-8")
    library = bibtexparser.parse_string(bibtex_text)

    failed_blocks = getattr(library, "failed_blocks", [])
    if failed_blocks:
        print(
            f"warning: {len(failed_blocks)} BibTeX block(s) failed to parse",
            file=sys.stderr,
        )

    entries = [normalize_entry(entry) for entry in getattr(library, "entries", [])]
    entries.sort(key=lambda item: (-item.sort_year, item.key.lower()))
    return entries


def write_json(entries: Iterable[NormalizedEntry], path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    data = [
        {
            "key": entry.key,
            "type": entry.entry_type,
            "sortYear": entry.sort_year,
            "fields": [
                {"name": field.name, "value": field.value} for field in entry.fields
            ],
            "fieldMap": entry.field_map,
            **({"authorList": entry.author_list} if entry.author_list else {}),
        }
        for entry in entries
    ]
    path.write_text(
        json.dumps(data, indent=2, ensure_ascii=False) + "\n",
        encoding="utf-8",
    )


def main() -> int:
    args = parse_args()

    if not args.input.exists():
        print(f"error: input file not found: {args.input}", file=sys.stderr)
        return 2

    try:
        entries = parse_bibtex(args.input)
        write_json(entries, args.output)
    except Exception as exc:  # pragma: no cover - fail fast with context.
        print(f"error: failed to convert BibTeX to JSON: {exc}", file=sys.stderr)
        return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
