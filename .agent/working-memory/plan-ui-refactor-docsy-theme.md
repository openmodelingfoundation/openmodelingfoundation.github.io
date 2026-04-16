# Plan: Docsy UI Refactor and Color System Refresh

**Date:** 2026-04-15  
**Site:** Open Modeling Foundation Hugo + Docsy gateway  
**Primary style files:**
- `assets/scss/_variables_project.scss`
- `assets/scss/_styles_project.scss`
- `assets/scss/_sidebar-tree-with-links.scss`

---

## Goal

Refactor the visual system so the site reads as a modern scientific/editorial platform with stronger brand consistency, improved accessibility, and clearer hierarchy across homepage, docs pages, and resource content.

## Non-goals

- No information architecture changes (menus/routes/content structure stay as-is).
- No JavaScript framework migration.
- No component rewrite outside existing Docsy/Hugo templates unless required for styling hooks.

---

## Proposed visual direction

**Theme concept:** Scientific Editorial

- Trust-first dark blue primary foundation
- Crisp teal for links and interactive affordances
- Warm amber accent reserved for key actions/highlights
- Light neutral surfaces for long-form readability
- Distinctive serif/sans pairing for stronger voice and scanability

### Candidate palette (recommended)

- `--omf-primary`: `#0F2742`
- `--omf-secondary`: `#0E7490`
- `--omf-accent`: `#F59E0B`
- `--omf-surface-1`: `#F7FAFC`
- `--omf-surface-2`: `#EAF1F6`
- `--omf-text`: `#1F2937`
- `--omf-text-muted`: `#4B5563`
- `--omf-border`: `#CBD5E1`

Map these to Bootstrap/Docsy Sass variables (`$primary`, `$secondary`, `$light`, `$dark`, `$link-color`, etc.) in `_variables_project.scss`.

---

## Work plan

### Phase 1: Foundations (variables + typography)

1. Replace ad-hoc colors with a coherent tokenized palette in `_variables_project.scss`.
2. Define heading/body font stacks with non-generic defaults.
3. Normalize link contrast and states (default/hover/focus/visited where applicable).
4. Keep navbar/footer colors aligned with the new tokens.

**Deliverable:** Stable theme primitives with no page-level regressions.

### Phase 2: Global components

1. Refine card visual language (radius, border, depth, hover).
2. Improve sidebar readability and active states.
3. Standardize focus-visible styles across nav, content links, buttons.
4. Harmonize spacing rhythm for headings, paragraphs, and section blocks.

**Deliverable:** Consistent interaction and hierarchy across standard Docsy layouts.

### Phase 3: Homepage and hero polish

1. Increase narrative hierarchy in hero section typography.
2. Improve section separation using controlled background contrast.
3. Tune icon block spacing and heading weights.
4. Introduce subtle motion only where it reinforces orientation.

**Deliverable:** Distinct, intentional landing experience without visual noise.

### Phase 4: Resource/doc page refinement

1. Ensure resource-heavy pages (including awesome list) inherit the new system cleanly.
2. Recheck long-form content readability (line length, heading rhythm, lists).
3. Tighten metadata/callout card styling for consistency.

**Deliverable:** High readability and cohesive branding in content-dense pages.

---

## Implementation details

### Files likely to edit

- `assets/scss/_variables_project.scss`
  - Color and typography tokens
  - Bootstrap variable overrides
- `assets/scss/_styles_project.scss`
  - Footer, cards, sidebar active indicators, docs content rhythm
  - Homepage block enhancements
  - Awesome list style alignment
- `content/en/_index.html` (optional/minimal)
  - Minor semantic wrappers or utility classes for layout hooks

### Guardrails

- Preserve existing URL structure and menu behavior.
- Preserve Docsy compatibility and upgradeability.
- Avoid introducing heavy custom JS.
- Keep animation subtle and accessible (reduced-motion friendly).

---

## Accessibility and quality criteria

1. Contrast:
   - Body text and interactive text must meet WCAG 2.2 AA.
2. Keyboard:
   - All interactive elements show visible focus indicators.
3. Readability:
   - Paragraph line length targets ~60-80 characters where practical.
4. Motion:
   - Respect `prefers-reduced-motion`.
5. Regression:
   - No broken layouts at mobile, tablet, and desktop breakpoints.

---

## Validation plan

Run in containerized environment:

1. `docker compose run --rm --no-deps --entrypoint sh hugo -c '.github/scripts/build-site.sh'`
2. Spot-check representative pages in `public/`:
   - home
   - one standards page
   - one working-group page
   - resources index
   - awesome-list page
3. HTML parse check for touched rendered pages using `xmllint --html --noout`.
4. Visual regression check by comparing before/after screenshots for key templates.

---

## Risks and mitigations

- **Risk:** New palette reduces contrast in existing components.
  - **Mitigation:** Run targeted contrast checks before finalizing tokens.

- **Risk:** Docsy defaults conflict with custom overrides.
  - **Mitigation:** Keep overrides scoped and rely on variable-level changes first.

- **Risk:** Typography choice increases layout shift/perf cost.
  - **Mitigation:** Use performant font loading strategy and fallback stacks.

---

## Suggested execution order

1. Palette + link/focus tokens
2. Sidebar + card system
3. Homepage polish
4. Resource and awesome-list final pass
5. Build, validate, and document changes

---

## Definition of done

- Unified color system implemented and documented.
- Sidebar, cards, and content typography visibly improved and consistent.
- Homepage visual hierarchy is stronger and more intentional.
- Awesome-list and other long-form pages match the new design language.
- Container build passes and HTML parse checks pass for touched pages.
