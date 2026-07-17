# AGENTS

This repository powers the Open Modeling Foundation science gateway, built with Hugo and Docsy and published via GitHub Pages.

This file intentionally documents repository-specific decisions and constraints that are not obvious from the codebase itself.

Contributor documentation lives in `README.md`. Agent harness documentation lives under `.agent/`.

## Scope and precedence

If instructions conflict, follow this order:

1. `AGENTS.md`
2. Agent-specific adapter files (`CLAUDE.md`, `.github/copilot-instructions.md`, etc.)
3. `README.md`

Adapter files provide agent-specific configuration only and should not override repository conventions defined here.

## Operating principles

- Make the smallest correct change.
- Preserve existing architecture and conventions unless the task explicitly requires otherwise.
- Prefer extending existing patterns over introducing new abstractions.
- If requirements are ambiguous, choose the simplest correct solution and state any assumptions.
- Do not introduce new dependencies without clear justification.

## Agent workflow

For substantial tasks:

- Record working context under `.agent/working-memory/`.
- Save checkpoints for long-running work.
- Create a handoff before pausing or transferring work.
- When performing a documentation or cleanup pass, update this file if repository-specific guidance has changed.

See `.agent/README.md` for workflow details, templates, and naming conventions.

## Project invariants

These constraints should never be violated.

- All project commands should execute inside the project's container environment.
- Edit the authoritative source, then regenerate generated artifacts.
- `data/publications.json` is generated from `assets/bibliographies/publications.bib`.
- `public/` is build output and should never be edited directly.
- Documentation under `.agent/` is operational state, not project documentation.
- Never commit deploy credentials, API tokens, or analytics keys. GitHub Pages deployment secrets live in GitHub Actions repository secrets, not in tracked files.

## Common decisions

Prefer repository `make` targets whenever one exists. Invoke Docker Compose or project tools directly only when no suitable `make` target exists or when debugging the build system.

| Need                                            | Use                              |
| ------------------------------------------------ | --------------------------------- |
| Preview site locally                              | `make serve`                      |
| Production-style render                           | `make render`                     |
| Render while another Hugo container is running    | `make render-site-isolated`       |
| Bibliography changed                              | `make publications-json`          |
| CI-equivalent production build                    | `.github/scripts/build-site.sh`   |

If a command cannot run in the current container environment, explain why and propose a container-based alternative rather than switching to host-installed tooling.

## Repository gotchas

### Hugo module mounts

When modifying `hugo.yaml` mounts:

- Always include an explicit `static -> static` mount.
- Do not define only partial `static` mounts.

Why: Hugo disables the implicit default mount. The build succeeds, but assets silently disappear from `public/`. Check `public/` for the expected files directly.

### Font declarations

When adding or modifying `@font-face` declarations:

- Place them in a Hugo template partial such as `layouts/partials/hooks/head-end.html`.
- Do not define `@font-face` rules in SCSS processed through Hugo's `toCSS` pipeline.

Why: Hugo template functions such as `relURL` are unavailable inside the SCSS pipeline. Defining `@font-face` in a template partial ensures asset URLs are generated correctly for all deployment base paths.

### Asset paths

When referencing site assets:

- Prefer Hugo URL helpers such as `relURL`.
- Do not hardcode root-relative paths.

Why: The site may be deployed under different base paths. Template-aware URLs remain portable.

## Validation expectations

- Validate changes before considering work complete.
- Prefer the smallest validation that demonstrates correctness.
- For bibliography changes, regenerate `data/publications.json` and confirm entry counts match the `.bib` source — malformed BibTeX entries are dropped silently rather than raising an error.
- For rendering or template changes, perform a production-style render and check `public/` directly for expected output. A successful `make render` exit code does not guarantee content is present (see static mounts gotcha above) — Hugo's failure modes here are silent, not loud.