# Working Memory

## Active tasks

- Task: Plan for dynamically embedding awesome-modeling-practices README into a Hugo page
- Current status: Plan written (see .agent/working-memory/plan-awesome-list.md)
- Open questions: None at this stage; ready to implement on request
- Next actions: Implement plan steps on user approval

## Deployment context (updated 2026-03-28)

- Workflow: `.github/workflows/gh-pages.yml`
- Trigger: push to `develop` branch
- Build: containerized via Docker Compose (`docker compose build hugo` + `docker compose run hugo hugo build --gc --minify`), mirroring local deployment toolchain and image
- Deploy method: `actions/upload-pages-artifact` + `actions/deploy-pages` (OIDC, no branch write)
- **No `main` branch is used for deployment.** The old `peaceiris/actions-gh-pages` approach that pushed to `main` has been replaced. The `main` branch is obsolete.
- Required repo setting: Settings → Pages → Source must be **GitHub Actions** (not "Deploy from a branch").

## CI troubleshooting (updated 2026-03-29)

- Hugo module/cache paths inside the container must resolve to absolute directories for the current CI image/version.
- For Docker Compose workflows, use separate variables for host and container cache paths:
	- host path for GitHub Actions cache: `./.hugo_cache`
	- container path for Hugo `--cacheDir`: `/src/.hugo_cache`
- Running the container as `--user "$(id -u):$(id -g)"` avoids root-owned workspace files, but it also means default cache locations like `/cache/modules` may be unwritable.

## Shared build entrypoint planning (updated 2026-03-29)

- Plan created: `.agent/working-memory/plan-shared-build-entrypoint.md`
- Objective: route local production render, htmltest render, and GitHub Pages build through one repository-owned build script.
- Preferred shape: keep workflow orchestration in YAML, move only the canonical Hugo build logic into a shared container-executed shell script.

## Checkpoint and docs sync (updated 2026-03-29)

- Checkpoint added: `.agent/checkpoints/checkpoint-20260329-0824.md`.
- Contributor docs synced: `README.md` now documents shared build entrypoint and `make render`.
- Agent docs synced: `AGENTS.md` now references `.github/scripts/build-site.sh` and local production-style render guidance.
- Repo hygiene: `.gitignore` now ignores generated `/.hugo_cache/` and `/dist/` build outputs.
