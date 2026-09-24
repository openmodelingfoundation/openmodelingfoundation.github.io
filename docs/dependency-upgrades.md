# Dependency upgrade runbook

Use this procedure for a coordinated Hugo, Docsy, and JavaScript upgrade. For a smaller update, perform the relevant steps in the same order. Run build and dependency commands through the Make targets: they execute inside the Docker Compose `hugo` service. Do not run a host-installed Hugo, Go, npm, or Python against this checkout.

## Where versions come from

| Dependency | Authoritative source | Generated or installed result |
| --- | --- | --- |
| Hugo | `.env` (`HUGO_VERSION`) for Compose; Dockerfile `ARG HUGO_VERSION` for its standalone default | Docker base image |
| Docsy | `go.mod`, imported as `github.com/google/docsy/theme` in `hugo.yaml` | `go.sum`; Hugo module cache |
| Site JavaScript and CSS tools | Root `package.json` | Root `package-lock.json`; `/tmp/node_modules` in the image |
| JavaScript requested by Hugo modules | Module manifests, consolidated by `hugo mod npm pack` | `packages/hugoautogen/{package.json,hugo_packagemeta.json}` and root `package-lock.json` |
| Container tools | Dockerfile base image and `UV_VERSION`; Alpine `apk add` packages | Docker image |
| BibTeX parser | Inline dependency metadata in `.github/scripts/bibtex_to_json.py` | Resolved by `uv run` (there is no committed Python lockfile) |
| Self-hosted fonts | `.github/scripts/fonts.env` | Files and licenses under `static/fonts/` |
| GitHub Actions and other CI tools | Pinned `uses:` commits in `.github/workflows/` | GitHub-hosted jobs |

The root package currently pins Bootstrap and Font Awesome directly. Those declarations take precedence over matching module dependencies, so `packages/hugoautogen/package.json` can legitimately have empty dependency objects. **Keep the workspace and its metadata:** Hugo regenerates them and uses the metadata to detect changes in module dependencies. Do not hand-edit either generated file. [Hugo explains the workspace and precedence rules](https://gohugo.io/hugo-modules/nodejs-dependencies/).

## Before editing

1. Start from a clean branch or record any existing local changes. Read the [Docsy update guide](https://www.docsy.dev/docs/update/) and every release note between the installed and target Docsy versions. Check Hugo, Node, and Dart Sass requirements, changed templates, icons, and other migration actions.
2. Check whether `make serve` or another Hugo container is running. Use `make render-site-isolated` for validation if it is; `make render` deletes shared build state.
3. Run `make build` **before changing package manifests**. This produces a usable image from the current, synchronized lockfile. The dependency targets below deliberately use this existing image and do not rebuild it. A fresh image build can fail at `npm ci` until the new lockfile exists.
4. Record a baseline with `make render` (or `make render-site-isolated`), including page and static-file counts and a few representative pages.

## Update Hugo and Docsy

1. If upgrading Hugo, set `HUGO_VERSION` in `.env` and the Dockerfile default `ARG HUGO_VERSION` to the same tag. Run `make build` **now, before editing `package.json`**. Check that the target Hugo image is available and meets Docsy's requirements. This gives subsequent Make targets the new Hugo executable.
2. Update Docsy's Hugo module with `make deps-docsy DOCSY_VERSION=vX.Y.Z`. Use the exact target version rather than an unrestricted `-u`. This updates `go.mod` and `go.sum`. Set `DOCSY_VERSION` in `.env` to the same version; it is a tracking value, not the Go module pin. Check that `hugo.yaml` still imports `github.com/google/docsy/theme` and apply any release-specific config or override migrations.
3. Review changes to `layouts/`, `assets/scss/`, shortcodes, icons, and the Sass toolchain against the Docsy release notes. In particular, a successful render does not prove that an overridden selector or icon still works.

For a Docsy-only upgrade, use the image built in **Before editing**. If the target Docsy requires a newer Hugo, upgrade Hugo first.

## Update JavaScript dependencies

1. Change direct package versions in root `package.json`, including PostCSS, Bootstrap, Font Awesome, and `sass-embedded` when their compatibility requirements call for it. Distinguish the direct pins from transitive entries in `package-lock.json`; do not edit the lockfile by hand. Confirm that the Dockerfile's `sass` executable link still points to the required Dart Sass implementation after changing Sass packages.
2. Run `make deps-pack` after changing Docsy **or** root `package.json`. This refreshes Hugo's generated npm workspace and checksum. Inspect `packages/hugoautogen/package.json`: module requirements may be empty because root versions override them, but a later Docsy release may add packages.
3. Run `make deps-lock` to resolve the full workspace and write `package-lock.json`. Review the resulting dependency and integrity changes. This target updates the lockfile without running package install scripts; the final image build still performs `npm ci`.
4. Run `make build`. Its `npm ci` checks that the manifest and lockfile agree and installs the dependencies used for site rendering. If this fails, fix the manifest or lockfile in the existing image with `make deps-pack` and `make deps-lock`, then rebuild. Do not weaken `npm ci` to `npm install` in the Dockerfile.

For a JavaScript-only update, start with the existing image, then do this section. For a lockfile-only refresh, leave direct package versions unchanged and run `make deps-lock` followed by `make build`.

## Other dependency updates

- **Container and Python tools:** Review the Dockerfile's Python, uv, and Alpine packages separately. Update their source pins or package declarations, then run `make build`. The BibTeX parser is specified by a version range in the script header and has no committed lock; record its resolved version during a Python update and consider an exact pin if reproducibility matters for the change.
- **Self-hosted fonts:** Update exact versions in `.github/scripts/fonts.env`, then run `make deps-fonts`. This invokes `.github/scripts/download-fonts.sh` in the Hugo service, adding its Bash, curl, and OpenSSL prerequisites to that temporary container. The target writes font assets as your user; do not run the script on the host. Review changed binary files and `static/fonts/README.md`.
- **GitHub Actions:** Update each workflow's action commit SHA and accompanying version comment together. Review the action's release notes and run the affected workflow. Workflow actions and the separate `yarn install` path in `count-votes.yml` are not installed by the Hugo image or represented in `package-lock.json`.

## Validate and finish

1. Run `make render`, or `make render-site-isolated` if a Hugo server is running. Inspect `public/` directly: check pages, the compiled CSS and JavaScript, `/webfonts/`, self-hosted fonts, and copied static assets. Hugo can exit successfully while a mount omission leaves assets missing.
2. Open the home page, a standards page, and a page using a custom shortcode. Check navigation, search, icons, breadcrumbs, responsive layout, and browser console/network errors. Repeat release-specific Docsy checks. For a Pages base-path change, also test the actual deployment base URL.
3. If bibliography tooling changed, run `make publications-json` and compare the number of generated records with the BibTeX source; malformed entries can be silently dropped. `data/publications.json` and `public/` are generated outputs and must not be committed.
4. Check `git diff --check`, `git diff --cached --check`, `git status --short`, and the diff for unexpected generated files or secrets. Commit the authoritative manifests, generated lockfiles/workspace metadata, documentation or template migrations, and any deliberately regenerated font assets. CI's Pages and htmltest workflows provide the final container-build checks.

If an npm or Hugo module update unexpectedly changes many transitive packages, inspect why before committing. Keep exact versions for dependencies whose major release affects the theme's assets, and use the release notes rather than assuming a clean build means the appearance is unchanged.
