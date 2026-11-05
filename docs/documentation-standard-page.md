# Documentation standard page and editions

The current review landing page is `/standards/documentation/`. It introduces the proposal, links to the original review documents, and explains feedback and adoption steps without reproducing the standard. Version history is `/standards/documentation/versions/`, with a leaf bundle for each preserved edition, including the 2020 workshop outputs. The former working-group drafts URLs are unlisted forwarding pages, not a separate collection.

```text
content/en/standards/documentation/
  _index.md                     Proposal introduction, downloads, and review process
  versions/
    _index.md                   Edition index
    workshop-2020/
      index.md                  Final workshop output and source attribution
      manifest.json             Provenance, size, SHA-256 checksum
    draft-1/
      index.md                  Frozen web transcription and review context
      definition.docx
      definition.pdf
      supplement.docx
      supplement.pdf
      source-draft.txt           Original supplied Markdown bytes
      manifest.json             Provenance, sizes, SHA-256 checksums
```

## Current page and edition selection

The current page's `edition_page` points to the edition supplying its downloads. The `standard-file` shortcode resolves those files through Hugo page resources, so links respect the site's base URL. Archived pages resolve their own bundle resources. The header links to version history; each archived edition links back to the current page.

The current introduction and review context remain editable. Its `standard_revision`, `standard_stage`, `review_deadline`, `rfc_url`, and `discussion_url` describe the current proposal. Change `edition_page` only when the introduction and selected downloads have been reconciled with the new edition. Keep the full requirements, tables, glossary, and references in the original review documents rather than transcribing them on the landing page. Never silently replace an older edition's files.

Edition frontmatter records `edition_id`, `archived`, `standard_status`, `snapshot_date`, `date` (for history ordering), and `current_page`. Review releases also record `announcement_date`; the workshop entry records `finalized_date` and `source_commit` instead. The history lists dated releases newest first, followed by the workshop material. An archive label does not imply adoption. An adopted edition must carry its actual approval status and identifiers; do not infer them from its filename or Discussion number.

## 2020 workshop outputs provenance

The 2020 workshop outputs collect the initial workshop material in the documentation version history. The original page content was finalized by Cheryl Porter (chporter) on October 6, 2020, in commit `9da8932066e7fcfffeac229d26a404c99a3bee35`, with A Lee credited as co-author. At that revision its path was `content/en/standards/documentation/_index.md`.

That commit records the workshop’s final output, with minor formatting changes applied afterward. Its November 4, 2026 capture date is distinct from the content finalization date. The workshop date itself remains unknown. Old drafts URLs remain unlisted forwarding pages for existing links.

## Draft 1 provenance

Draft 1 is a review snapshot captured on November 3, 2026, following the November 2 announcement in [Discussion #2](https://github.com/openmodelingfoundation/rfcs/discussions/2). The four Word/PDF originals were retrieved from the direct QuestionPro destinations behind the announcement's tracking links. Their bytes at the earlier announcement date are not verified.

The web transcription comes from the user-supplied `OMF Standard Template draft 1.md`, with the structural table presented as sections. The original supplied Markdown is retained as `source-draft.txt` and offered with a `.md` download filename. The Word definition's extracted text was inspected, but cross-format equivalence has not been certified. Original documents, their placeholders, and the transcription are retained separately.

The manifest records source URLs, capture dates, sizes, and SHA-256 hashes for every edition file except itself, including `index.md`. RFC number, DOI, and source commit are explicitly unknown. Do not use Discussion #2 as an RFC number. These are local preserved copies, not a DOI deposit.

The preserved review context requests feedback by November 30, 2026, offers email and meeting options, and requires reading both the definition and supplement. Executive Committee review precedes a Members Council vote planned for 2027; no date is specified for the Executive Committee review.

## Adding another edition

1. Create a new leaf bundle under `versions/`, using an explicit identifier such as `draft-2`; use an approved version number only after adoption is confirmed.
2. Freeze the reviewed text in `index.md` with `type: docs`, `layout: standard`, the edition metadata above, and no `edition_page` reference to another bundle.
3. Retain the exact release files and their provenance. Record the announcement date separately from the retrieval/capture date. Unknown identifiers remain unknown.
4. Create a schema-version-1 manifest listing each file's relative path, byte size, and SHA-256 digest. Calculate hashes in the Hugo container. The manifest must cover the edition text and every download; do not include its own hash.
5. Run `make standards-check`, then `make render-site-isolated`. Inspect the history, edition page, original-file downloads, provenance link, and return link at desktop and mobile widths.
6. Update the current page's text and edition pointer intentionally. The old bundle stays unchanged. Announce or update GitHub Discussion links only when requested and after the new webpage is published.

Both public-review releases and adopted releases can use this structure; ordinary working edits need not become editions. The working group's RFC page links to the current documentation proposal and its review discussion.

The layout uses neutral archive labels and displays each edition’s `standard_status`. Scientific requirements and Base/Full summaries belong in edition Markdown, not shared templates. Existing archived source bytes must remain unchanged.

## Integrity and presentation

`make standards-check` verifies all version bundles against their manifests. The production build script and isolated render also run this check, so missing files, unrecorded additions, and changed bytes block publication. This detects accidental changes; it does not replace review of a change that deliberately rewrites both a file and its manifest. Correct a published edition by issuing a new edition, not by refreshing the old hashes.

Original downloads and edition source text are the preserved artifacts. Hugo can regenerate their HTML with updated templates, typography, and navigation. If exact historical appearance is required, retain an additional self-contained HTML export or publication PDF for that edition. `public/` remains disposable build output.

The page extends the established OMF palette and type system; `assets/scss/_standard.scss` contains the scoped reading layout. Version history uses existing Docsy typography. No new global design system is introduced.

## Draft 1 implementation validation

Validation recorded on November 3, 2026:

- `make standards-check` and `make render-site-isolated` passed.
- Browser checks passed for the current page at 1440, 390, and 320 pixels, and for the archived edition and history at 1440 and 320 pixels.
- The five served downloads matched their manifest checksums. On disposable copies, the integrity checker rejected changed files, missing files, and unrecorded additions.
- Pages using `layout: standard` hide the shared right sidebar below the XL breakpoint because their content includes a mobile table of contents and feedback actions. Other documentation pages retain the shared sidebar, including its navigation and contribution links, at all widths.

These checks establish file integrity and the tested presentation; they do not certify equivalence between the supplied document formats or adoption of the proposal.

## Repeatable checks

Run `make standards-test` for corruption cases and `make site-check` for rendered navigation, subpath links, duplicate IDs, and download checksums. Both execute in the Hugo Compose service. Isolated builds use the production build script in a disposable workspace without host dependencies or server locks.

`make html-check` runs the same pinned htmltest binary as CI in the Hugo service.
Internal links block CI; `make html-check-external` remains advisory there.
Build and checker logs are retained in `tmp/checks/` even when checks fail;
failed builds also retain any generated HTML. These reports are ignored by Git.
`make check-tests` verifies the regression checker's failure diagnostics.
