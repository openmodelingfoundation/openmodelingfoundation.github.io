# Open Modeling Foundation Standards and Governance Repository

This repository is for establishing and disseminating standards related to accessibility, interoperability, documentation, and reuse of computational models. Please see our [mission and charter](https://openmodelingfoundation.org/governance/charter/) for more details.

## How to Contribute

You can contribute to this site by following the directions at https://openmodelingfoundation.org/contribute/ - the process of proposing and accepting changes to OMF standards will be finalized once we have established our [governance structure](https://openmodelingfoundation.org/governance/).

## Agent Harness

This repository includes an agent collaboration harness for AI-assisted work.

- Canonical policy: `AGENTS.md` is the source of truth for agent behavior.
- Agent notes: `.github/copilot-instructions.md` and `CLAUDE.md` are adapter files that defer to `AGENTS.md`.
- Agent artifacts: `.agent/` stores generated working context and transfer records.
	- `.agent/working-memory/` for in-progress notes
	- `.agent/checkpoints/` for progress snapshots
	- `.agent/handoffs/` for transfer summaries

Agents should read `AGENTS.md` first and use the templates under `.agent/checkpoints/` and `.agent/handoffs/` when creating artifacts.

## Deployment

The site is deployed to GitHub Pages via the workflow at `.github/workflows/gh-pages.yml`. Pushes to the `develop` branch trigger an automated build-and-deploy.

### How it works

1. The `build` job checks out `develop`, configures the Pages base URL, then builds the site inside the same Docker Compose `hugo` service used for local development (`docker compose build hugo` + `docker compose run hugo ...`). The Hugo invocation itself is centralized in `.github/scripts/build-site.sh`, which is shared across local production-style rendering and CI workflows.
2. The `deploy` job receives that artifact and publishes it directly to GitHub Pages via GitHub's OIDC-based Pages API (`actions/deploy-pages`).

**No "built" branch is used.** The old approach pushed compiled HTML to a `main` branch using `peaceiris/actions-gh-pages`. That is no longer the case — the deployment artifact goes straight to GitHub's Pages infrastructure. The `main` branch (if it still exists in the remote) is a leftover and is no longer updated.

### Repository Pages setting

The repository's Pages source must be set to **GitHub Actions** (not "Deploy from a branch"). In repository Settings → Pages → Build and deployment, select **Source: GitHub Actions**. Using "Branch: main" will not work with the current workflow.

## About

This GitHub pages site is generated with [hugo](https://gohugo.io) using the [docsy](https://www.docsy.dev) theme and can be built locally by following these instructions:

### Setup

To create a local setup of this site you can install `Docker` and `docker-compose` or `hugo` and `npm` on your local operating system.

Clone this repository via `git clone --recurse-submodules -j8 https://github.com/openmodelingfoundation/openmodelingfoundation.github.io.git`

#### Docker and docker-compose installed
If you have Docker and docker-compose installed, you can use the Makefile in the repository to automatically serve a local copy of the site to test out any changes:

Build and start a docker container with a hot-reloading `hugo server` that you can visit in your browser at `http://localhost:1313` via

```
% make serve
```

Run the local production-style render path (equivalent to the CI shared build entrypoint):

```
% make render
```

Open a hugo shell in the docker container

```
% make shell
```

The shared build script used by CI workflows and `make render` is:

```
.github/scripts/build-site.sh
```

#### Install hugo and npm locally

If you don't have docker installed and don't mind installing things in your operating system, you can do the following:

- Install the extended version of hugo from the [releases page](https://github.com/gohugoio/hugo/releases).
- Install npm via your operating system's package manager or from the [npm site](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm).
- Use hugo commands and npm to build/render the site.

```bash
% npm install
% hugo serve     # dev server without drafts
# OR
% hugo serve -D  # dev server with drafts
```
