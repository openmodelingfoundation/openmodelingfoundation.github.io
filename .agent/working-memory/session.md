# Working Memory

## Active task

- Static asset 404s on deployed site (fonts, logos) are fixed.
- Root cause: Hugo drops the `static/ → static/` default mount whenever any custom mount targets the `static` component. `hugo.yaml` had `assets/bibliographies → static/bibliographies` with no explicit `static → static` entry, silently excluding all of `static/` from `public/`.
- Fix: added `- source: "static" / target: "static"` to `hugo.yaml` module mounts. Build validated: 64 static files, `public/fonts/`, `public/images/`, `public/CNAME` all present.
- Next step: push to `develop` to trigger CI deployment and confirm live site.


## Notes by date (newest first)

### 2026-05-23 (cleanup + formatting/lint pass)

- Cleanup pass:
	- Scanned repository for common stale artifacts (`*.bak`, `*.orig`, `*.rej`, `*.tmp`, `*.swp`, `*~`, `.DS_Store`, `Thumbs.db`).
	- No stale artifacts were found.
- Formatting/linting pass:
	- Publications template was kept in formatted state (`layouts/partials/publications-list.html`).
	- Regenerated bibliography data with `.github/scripts/bibtex_to_json.py` to ensure `data/publications.json` is current.
	- Executed `.github/scripts/build-site.sh` in the Hugo container as a production-style lint gate.
- Validation status:
	- Build completed successfully after setting writable cache/output env vars and clearing a stale lock file.
	- Residual non-blocking Hugo deprecation warnings persist (`.Language.LanguageDirection`, `.Site.AllPages`, `.Site.Data`).

### 2026-05-22 (cleanup + docs sync)

- Cleanup pass:
	- Scanned repository for common stale artifacts (`*.bak`, `*.orig`, `*.tmp`, `*.swp`, `*~`, `.DS_Store`, `Thumbs.db`).
	- No unnecessary temporary/backup files found.
- Agent docs sync:
	- Updated working-memory active task and status after single-return refactor in `layouts/partials/render-remote-readme.html`.
	- Updated latest checkpoint scope to reflect current state.
- Validation status:
	- Template diagnostics remain clean for:
		- `layouts/partials/render-remote-readme.html`
		- `layouts/docs/awesome-list.html`
	- Isolated containerized build re-validation passed:
		- Command: `docker run --rm --entrypoint sh -v "$PWD":/workspace:ro -w /tmp openmodelingfoundation/omf:latest -lc 'cp -a /workspace /tmp/src && git config --global --add safe.directory /tmp/src && cd /tmp/src && hugo build --gc --minify --cacheDir /tmp/.hugo_cache -d /tmp/public --noBuildLock'`
		- Result: success (exit 0), total ~23s.
		- Residual warnings: Hugo deprecations (`.Language.LanguageDirection`, `.Site.AllPages`) from theme/template code.

### 2026-05-22 (sync pass)

- Rendering consistency refinements completed:
	- Awesome fallback markup deduplicated in `layouts/docs/awesome-list.html`.
	- Fallback section title aligned to `Papers` for content consistency.
	- Empty metadata link rows removed when DOI/URL are absent.
- Bibliography output quality updates:
	- Publications sorted by year descending in `layouts/partials/publications-list.html`.
	- Curly brace artifacts removed from rendered BibTeX values and common escaped symbols normalized.
- Validation:
	- Containerized production build path (`.github/scripts/build-site.sh`) passed after each update.

### 2026-05-22

- Synced publications architecture:
	- Canonical bibliography source: `assets/bibliographies/publications.bib`.
	- Removed stale `data/publications.json` path and old `layouts/resources/publications.html` override.
	- `layouts/docs/publications.html` is now the canonical publications template.
- Static BibTeX exposure now uses Hugo module mount:
	- `hugo.yaml` mount: `assets/bibliographies` -> `static/bibliographies`.
	- Publications page links BibTeX via static URL (`bibliographies/publications.bib`).
- Awesome list integration updates:
	- Publications block renders under `Papers`.
	- Compact publication card UI with expandable full metadata.
	- Fallback path retains publications visibility when remote README retrieval fails.
- Validation:
	- Containerized production build path (`.github/scripts/build-site.sh`) passed after each major step.

### 2026-04-15

- Resumed UI theme refactor handoff and implemented Phase 1 + Phase 2 baseline in SCSS:
	- `assets/scss/_variables_project.scss`: tokenized Scientific Editorial palette, typography stacks, Bootstrap variable remap, focus ring tuning, reduced-motion handling.
	- `assets/scss/_styles_project.scss`: global readability/focus updates, navbar/section backgrounds, footer restyle, card and sidebar interaction polish, awesome-list alignment.
	- `assets/scss/_sidebar-tree-with-links.scss`: page-meta link contrast, hover/focus states, and typography weight adjustments.
- Validation run completed with containerized workflow: `make render` succeeded on 2026-04-15 22:45 UTC.
- Build warning observed (pre-existing): Hugo deprecation for `.Site.AllPages` in theme/template code, unrelated to this SCSS refactor.

### 2026-03-31

- `Makefile` maintenance completed: fixed `make shell`, refactored shared Docker Compose flags, removed global `.NOTPARALLEL`, and simplified `clean` with a merged `find`.
- Validation: `make -n` checks passed for `build`, `serve`, `render`, `shell`, `stop`, and `clean`.

### 2026-03-29

- CI/cache troubleshooting: keep host cache at `./.hugo_cache` and container cache at `/src/.hugo_cache`; `--user "$(id -u):$(id -g)"` avoids root-owned files.
- Shared build entrypoint plan: `.agent/working-memory/plan-shared-build-entrypoint.md`.
- Checkpoint: `.agent/checkpoints/checkpoint-20260329-0824.md`.

### 2026-03-28

- Deployment workflow: `.github/workflows/gh-pages.yml` on `develop`.
- Build/deploy path: Docker Compose `hugo` service + `.github/scripts/build-site.sh`, then `actions/upload-pages-artifact` and `actions/deploy-pages`.
- Pages source requirement: GitHub Actions (not branch deployment); no `main` branch publishing.
