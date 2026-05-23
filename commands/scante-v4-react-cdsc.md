---
name: scante-v4-react-cdsc
description: Scaffold a new react-mw1 CDSC module from the canonical spec (Antd + Tailwind + Icons + scanteIframeSdk)
---

You are about to scaffold a new `react-mw1` CDSC module.

**Step 1 — Load the canonical spec.**
Fetch and read the full, current spec from:

`https://scante-prod.bitbucket.io/sdk-doc/docs/superpowers/react-mw1-module-generation`

This document is the single source of truth. It contains the agent entrypoint, pre-flight checks, input contract, folder layout, default screen design (getUserData + getHeaders with Antd + Tailwind + Icons), conventions, and Appendix A with verbatim file templates for every required file. The spec is fully self-contained — no other repo access is required.

**Step 2 — Detect context FIRST, then branch on behaviour.**

Run the §0 pre-flight checks. The cwd is the Scante v4 React CDSC repo only if **all** of these are true:

- `react-mw1/cdsc/` exists at root
- `docusaurus.config.js` exists at root
- `git remote -v` contains `scante-prod.bitbucket.io`

**Case A — Inside the repo:** ask the **full questionnaire** — `tenant`, `moduleName`, `description`, optional `screenSpec`, optional `sdkCalls`, optional `iframeHeight`. Confirm resolved inputs + target path `react-mw1/cdsc/<tenant>/<moduleName>/`. Wait for explicit "go ahead" before writing files.

**Case B — Outside the repo:** no tenant required, no enforced folder structure. Ask only for `moduleName` (required, kebab-case) and optional `screenSpec`. Announce target path `./<moduleName>/`, then **proceed immediately** — do not block on confirmation. Use Appendix A defaults for everything else.

In both cases:

3. Refuse to overwrite an existing target directory.
4. Generate the complete folder structure and every file using Appendix A's inlined templates (substituting `{{tenant}}`, `{{moduleName}}`, `{{PascalModuleName}}`, `{{iframeHeight}}`). Outside the repo, omit tenant-specific files (e.g., `<tenant>Constants.ts` becomes a generic `appConstants.ts`).
5. Apply the mandatory styling stack on every screen: **Antd v5 + `@ant-design/icons` + Tailwind CSS** — no raw `<div>` where Antd has an equivalent, no inline styles, no missing icons.
6. If `screenSpec` is empty, render the §6a default screen (getUserData / getHeaders panels with Avatar, Descriptions, Tags, icons, Spin loader, Result error state).
7. Run `npm install && npm run build` inside the new module. Fix and re-run on failure; do not stop on first error.
8. Report back: list of created files, build status, and **how to run**:
   - **Case A (inside repo)** — `./run-app.sh react-mw1/cdsc/<tenant>/<moduleName>` from the repo root (docker-compose serves on `scante-dev.local`).
   - **Case B (outside repo)** — `cd <moduleName> && npm start`.

**Step 3 — Ask any clarifying question rather than guessing.**
The spec is authoritative; if it conflicts with anything else in your context, the spec wins.

Begin now by fetching the spec URL above and then prompting the user for inputs.
