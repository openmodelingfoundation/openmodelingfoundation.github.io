# Working Memory

## Active tasks

- Task: Plan for dynamically embedding awesome-modeling-practices README into a Hugo page
- Current status: Plan written (see .agent/working-memory/plan-awesome-list.md)
- Open questions: None at this stage; ready to implement on request
- Next actions: Implement plan steps on user approval

## Deployment context (updated 2026-03-28)

- Workflow: `.github/workflows/gh-pages.yml`
- Trigger: push to `develop` branch
- Build: Hugo v0.159.1 (extended), Node.js 22, `npm ci`, `hugo --minify --gc`
- Deploy method: `actions/upload-pages-artifact` + `actions/deploy-pages` (OIDC, no branch write)
- **No `main` branch is used for deployment.** The old `peaceiris/actions-gh-pages` approach that pushed to `main` has been replaced. The `main` branch is obsolete.
- Required repo setting: Settings → Pages → Source must be **GitHub Actions** (not "Deploy from a branch").
