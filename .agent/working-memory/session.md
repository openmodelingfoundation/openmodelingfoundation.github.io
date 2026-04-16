# Working Memory

## Active task

- awesome-modeling-practices embed plan is ready: `.agent/working-memory/plan-awesome-list.md`.
- navigation/resources refactor issue plan is ready: `.agent/working-memory/plan-navigation-resources-refactor.md`.
- UI refactor plan artifact is ready: `.agent/working-memory/plan-ui-refactor-docsy-theme.md`.
- Next step on request: complete visual QA pass for key pages and tune any contrast/spacing edge cases.

## Notes by date (newest first)

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
