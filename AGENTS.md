# AGENTS

Repository-specific constraints for AI agents working on the Open Modeling Foundation Hugo + Docsy site (GitHub Pages).

Contributor documentation: `README.md`.

## Precedence

If instructions conflict: `AGENTS.md` → adapter files (`CLAUDE.md`, `.github/copilot-instructions.md`) → `README.md`.

## Invariants

- Run all project commands inside the Docker Compose `hugo` service via `make` targets. Do not use host-installed tooling. If a command cannot run in the container, explain why and propose a container-based alternative.
- Edit authoritative sources, then regenerate. `data/publications.json` is generated from `assets/bibliographies/publications.bib` via `.github/scripts/bibtex_to_json.py`.
- `public/` is build output. Never edit it directly.
- Never commit deploy credentials, API tokens, or analytics keys. Deployment secrets live in GitHub Actions repository secrets.

## Commands

Prefer `make` targets. Use Docker Compose directly only when debugging the build system.

| Need | Use |
| --- | --- |
| Preview site locally | `make serve` |
| Production-style render | `make render` |
| Render while another Hugo container is running | `make render-site-isolated` |
| Regenerate publications JSON from BibTeX | `make publications-json` |
| CI-equivalent production build | `.github/scripts/build-site.sh` |

## Deployment

Pushes to `develop` trigger the GitHub Pages workflow (`.github/workflows/gh-pages.yml`). The repository Pages source must be set to **GitHub Actions**, not a branch.

## Hugo gotchas

### Module mounts

When modifying `hugo.yaml` mounts, always include an explicit `static -> static` mount. Hugo drops the implicit default `static/` → `public/` copy when any mount is defined, silently removing static assets from the build.

### Font declarations

Place `@font-face` rules in a Hugo template partial (`layouts/partials/hooks/head-end.html`), not in SCSS. Hugo template functions like `relURL` are unavailable in the SCSS `toCSS` pipeline.

### Asset paths

Use Hugo URL helpers (`relURL`, `absURL`) in templates. Do not hardcode root-relative paths — the site may deploy under different base paths.

## Validation

- Bibliography changes: run `make publications-json` and confirm entry counts match the `.bib` source. Malformed BibTeX entries are silently dropped, not errored.
- Rendering or template changes: run `make render` and check `public/` directly for expected output. A successful exit code does not guarantee content is present (see module mounts gotcha above).
