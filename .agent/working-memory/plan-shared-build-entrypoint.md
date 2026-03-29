# Shared Build Entrypoint Plan

## Goal

Create one repository-owned build entrypoint that all site render paths use:

- local production-style build
- htmltest render
- GitHub Pages build

The entrypoint should centralize the Hugo invocation, container environment, cache configuration, and output-path handling so future fixes are made once.

## Current state

- Local development uses `make serve`, which starts the container default `hugo server` command.
- Local shell access uses `make shell`, which opens an interactive shell in the same container.
- `run-htmltest.yml` duplicates a Docker Compose + `hugo build` command.
- `gh-pages.yml` duplicates a similar Docker Compose + `hugo build` command with Pages-specific `BASE_URL` handling.
- Shared infrastructure already exists at the container/image level via `docker-compose.yml` and `Dockerfile`, but the build command itself is duplicated.

## Target design

Introduce a single script entrypoint under the repository, for example:

- `.github/scripts/build-site.sh`

Responsibilities:

- enforce strict shell behavior
- normalize environment variables and defaults
- configure git safe-directory behavior inside the container
- require absolute Hugo cache path inside the container
- accept output directory as an argument or env var
- accept optional base URL override
- run a single canonical `hugo build` command

Example interface:

- `OUTPUT_DIR=/src/public BASE_URL=https://example.test/ .github/scripts/build-site.sh`
- `OUTPUT_DIR=/src/dist .github/scripts/build-site.sh`

## Implementation phases

### Phase 1: Create canonical build script

- Add a shell script to the repo and make it the only place that calls `hugo build` for CI-style production renders.
- Set defaults for:
  - `HUGO_ENV=production`
  - `HUGO_CACHEDIR=/src/.hugo_cache`
  - `OUTPUT_DIR=/src/public`
- Build the Hugo command incrementally so optional flags like `--baseURL` are only added when present.
- Keep the script container-oriented; assume execution happens inside the `hugo` service with `/src` mounted.

Success criteria:

- No workflow contains a long inline `hugo build` command anymore.
- The script can render successfully for both default and overridden output directories.

### Phase 2: Route GitHub Pages through the script

- Replace the inline Hugo command in `gh-pages.yml` with a call to the shared script.
- Keep Pages-only concerns in the workflow:
  - `actions/configure-pages`
  - cache restore/save
  - artifact upload
  - deploy action
- Pass only the parameters the shared script needs:
  - `BASE_URL`
  - `HUGO_CACHEDIR`
  - optional explicit `OUTPUT_DIR=/src/public`

Success criteria:

- `gh-pages.yml` still owns deployment orchestration.
- The actual site build command lives only in the shared script.

### Phase 3: Route htmltest through the script

- Replace the inline Hugo command in `run-htmltest.yml` with a call to the shared script.
- Decide whether htmltest should build to `/src/public` for exact parity or continue using `/src/dist`.
- Preferred direction: build to `/src/public` and point htmltest at that output if feasible, because it reduces environment drift.
- If htmltest must keep `/src/dist`, use the shared script with `OUTPUT_DIR=/src/dist`.

Success criteria:

- htmltest and gh-pages differ only in workflow-specific orchestration, not in core site build logic.

### Phase 4: Add a local production-build entrypoint

- Add a Make target such as `make render` or `make build-site` that runs the same shared script inside the `hugo` service.
- Keep `make serve` as the fast feedback path for local content work.
- Document that `make render` is the local equivalent of CI production rendering.

Example target behavior:

- `docker compose build --pull hugo`
- `docker compose run --rm --no-deps --entrypoint sh hugo -c '.github/scripts/build-site.sh'`

Success criteria:

- There is a documented local command that exercises the same production build path as CI.
- Contributors no longer need to reconstruct the CI build command manually.

### Phase 5: Document the contract

- Update `README.md` to distinguish:
  - local live preview via `make serve`
  - local production-equivalent render via `make render`
  - CI consumers of the shared build entrypoint
- Document the required environment variables and defaults.
- Note that the deploy job publishes artifacts only; it does not build the site.

Success criteria:

- Repository docs match actual workflow behavior.
- The shared-entrypoint contract is easy to extend for future checks.

## Design constraints

- Keep project commands container-based, consistent with `AGENTS.md`.
- Do not move GitHub Pages deployment logic into the shared script.
- Keep host-path concerns in workflows and Make targets; keep container-path concerns in the script.
- Preserve the current absolute container cache directory requirement.
- Avoid introducing host-level dependencies on local `hugo`, `go`, `node`, or `npm`.

## Recommended normalization choices

- Canonical container cache dir: `/src/.hugo_cache`
- Canonical default output dir: `/src/public`
- Canonical local production command: `make render`
- Canonical live-preview command: `make serve`
- Canonical script location: `.github/scripts/build-site.sh`

## Open decisions

- Whether htmltest should consume `/src/public` instead of `/src/dist` for exact deploy parity.
- Whether the local render target should run as the host UID/GID to avoid root-owned artifacts.
- Whether git safe-directory setup should remain inline in the container command or be fully absorbed by the script.

## Suggested implementation order

1. Add the shared script.
2. Switch `gh-pages.yml` to use it.
3. Switch `run-htmltest.yml` to use it.
4. Add `make render`.
5. Update `README.md`.

## Validation plan

1. Run the shared script locally in the `hugo` container with default settings.
2. Run it locally with `OUTPUT_DIR=/src/dist`.
3. Confirm `gh-pages.yml` still builds and uploads the Pages artifact.
4. Confirm `run-htmltest.yml` renders and htmltest reads the intended output directory.
5. Compare generated `public` output between the local render path and the Pages workflow path for parity.