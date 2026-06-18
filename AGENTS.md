# AGENTS

This repository powers the Open Modeling Foundation science gateway, implemented with Hugo and Docsy, and published on GitHub Pages.

This document is the canonical source of truth for agent behavior in this repository.

For a contributor-facing overview, see the Agent Harness section in [README.md](README.md#agent-harness).

## Scope and precedence

- This file defines the shared operating contract for all AI agents.
- If guidance in `.github/copilot-instructions.md` or `CLAUDE.md` differs, follow this file.
- `README.md` provides contributor-facing context; this file remains authoritative for agent behavior.
- Agent-specific files should provide adapter notes only and link back here.

## Agent harness

Agent-generated artifacts must be written under `.agent/`.

- Working memory: `.agent/working-memory/`
- Checkpoints: `.agent/checkpoints/`
- Handoffs: `.agent/handoffs/`

## Standard workflow

1. Read this file before starting substantial work.
2. Record in-progress context in `.agent/working-memory/session.md`.
3. For long tasks, save progress snapshots in `.agent/checkpoints/`.
4. Before pausing or transferring work, create a handoff in `.agent/handoffs/`.
5. When a user requests a cleanup pass, review and update this file (`AGENTS.md`) as part of that pass, even if the update is only a brief synchronization note.

## Command execution environment

- Run project commands in containers only; do not assume local `go`, `hugo`, `node`, or `npm` are installed on the host.
- Use Docker Compose with the `hugo` service for build/test/update tasks (for example: `docker compose run --rm --no-deps --entrypoint sh hugo -c '<command>'`).
- Prefer the shared Hugo production build entrypoint `.github/scripts/build-site.sh` for render operations used by CI and local production-style checks.
- Use `make render` for the local production-style render path and `make serve` for local hot-reload preview.
- Use `make publications-json` to regenerate `data/publications.json` from `assets/bibliographies/publications.bib` when bibliography data changes.
- Use `make render-site-isolated` when another local Hugo container/session is running or host lock/permission conflicts are present; this runs in a one-off isolated container workspace and reuses the host cache directory `.hugo_cache` for module/cache reuse.
- If a command cannot run in the current container setup, document the limitation and propose a container-based alternative.

## Artifact guidance

- Keep notes concise, factual, and actionable.
- Include file paths, decisions, and validation outcomes.
- Do not store secrets, tokens, or private credentials.
- Use UTC timestamps in checkpoints and handoffs when possible.

## Static asset paths

- Prefer base-path-safe asset references (`relURL`, relative paths, or equivalent template-aware indirection) over hardcoded root-relative paths like `/images/...` or `/fonts/...` for deployable site assets.
- **Hugo module mounts and the `static` component**: whenever any mount in `hugo.yaml` targets the `static` component (even a partial path like `static/bibliographies`), Hugo drops the implicit `static/ → static/` default mount. Always include an explicit `- source: "static" / target: "static"` entry when defining custom mounts, or `public/` will silently omit everything under `static/` (fonts, images, CNAME, etc.).
- Font `@font-face` declarations belong in a Hugo partial (e.g. `layouts/partials/hooks/head-end.html`) rather than in SCSS, because Hugo template functions such as `relURL` are not available inside the `toCSS` pipeline.

## Important dependency versions

- Hugo (Docker build arg): `0.163.3` (`Dockerfile`)
- UV (Docker build arg): `0.11.16` (`Dockerfile`)
- BibTeX parser floor: `>=2.0.0b9` (PEP 723 inline metadata in `.github/scripts/bibtex_to_json.py` — single source of truth)
- Docsy module: `v0.15.0` (`go.mod` and `Dockerfile`)
- Go toolchain declaration: `1.18` (`go.mod`)
- npm package manifest version: `1.0.0` (`package.json`)
- Frontend/build packages in `package.json` use semver ranges (`^`), including:
	- `bootstrap` `^5.3.3`
	- `@popperjs/core` `^2.11.8`
	- `autoprefixer` `^10.2.5`
	- `postcss` `^8.5.3`
	- `postcss-cli` `^11.0.0`

## Suggested naming

- Checkpoints: `checkpoint-YYYYMMDD-HHMM.md`
- Handoffs: `handoff-YYYYMMDD-HHMM.md`

## Templates

- Checkpoint template: `.agent/checkpoints/checkpoint-template.md`
- Handoff template: `.agent/handoffs/handoff-template.md`
