# Working Memory

## Active task

- awesome-modeling-practices embed plan is ready: `.agent/working-memory/plan-awesome-list.md`.
- Next step on request: implement the planned integration.

## Notes by date (newest first)

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
