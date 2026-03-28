# AGENTS

This repository powers the Open Modeling Foundation science gateway, implemented with Hugo and Docsy, and published on GitHub Pages.

This document is the canonical source of truth for agent behavior in this repository.

For a contributor-facing overview, see the Agent Harness section in [README.md](README.md#agent-harness).

## Scope and precedence

- This file defines the shared operating contract for all AI agents.
- If guidance in `.github/copilot-instructions.md` or `CLAUDE.md` differs, follow this file.
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

## Command execution environment

- Run project commands in containers only; do not assume local `go`, `hugo`, `node`, or `npm` are installed on the host.
- Use Docker Compose with the `hugo` service for build/test/update tasks (for example: `docker compose run --rm hugo <command>`).
- If a command cannot run in the current container setup, document the limitation and propose a container-based alternative.

## Artifact guidance

- Keep notes concise, factual, and actionable.
- Include file paths, decisions, and validation outcomes.
- Do not store secrets, tokens, or private credentials.
- Use UTC timestamps in checkpoints and handoffs when possible.

## Important dependency versions

- Hugo (Docker build arg): `0.159.1` (`Dockerfile`)
- Docsy module: `v0.14.3` (`go.mod` and `Dockerfile`)
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
