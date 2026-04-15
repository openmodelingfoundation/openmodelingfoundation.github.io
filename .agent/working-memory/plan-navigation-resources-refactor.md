# Promote Working Groups to Top-Level Navigation and Add a Resources Index

## Summary

Move Working Groups out of About and make it a top-level section. Add a new top-level Resources page that acts as an index of OMF outputs. Keep `/standards/` as the canonical home for standards content; `/resources/` should link to it rather than duplicating it.

## Proposed changes

- Move `content/en/about/working-groups/` to `content/en/working-groups/`.
- Add Hugo aliases for every moved Working Groups page so existing `/about/working-groups/...` URLs keep working.
- Create `content/en/resources/_index.md` plus minimal child pages for publications, best practices, and repositories.
- Add a featured Standards link on `/resources/` that points to `/standards/`.
- Make the top nav order explicit: About, Governance, Working Groups, Standards, Resources, Contribute.
- Update internal links that still point to `/about/working-groups/`.

## Constraints

- Navigation is currently driven by section front matter `menu.main`, not a centralized `menus.main` block in `hugo.yaml`.
- Avoid a duplicate top-level menu definition unless existing section `menu.main` entries are removed.
- Keep this as a content/front matter refactor; do not rewrite templates unless the move exposes a real theme limitation.
- Validate with the containerized build path: `make render`.

## Acceptance criteria

- Working Groups appears in the top-level nav and is no longer nested under About.
- Resources appears in the top-level nav.
- `/working-groups/` is canonical.
- Old Working Groups URLs under `/about/working-groups/...` resolve via aliases.
- `/resources/` exists as an outputs index.
- `/resources/` includes a Standards block linking to `/standards/`.
- `/resources/` includes links for publications, best practices, and repositories, including `openmodelingfoundation/awesome-modeling-practices`.
- The site builds successfully with `make render`.

## Implementation notes

- Add aliases to every moved Working Groups page, not just the section landing page.
- Known internal links to update include `content/en/_index.html` and `content/en/about/history-events-and-activities.md`.
- Do not add a `standards-documents` subsection under Resources.