---
name: scante-v4-react-cdsc
description: Scaffold a new react-mw1 CDSC module from the canonical spec (Antd + Tailwind + Icons + scanteIframeSdk)
---

You are about to scaffold a new `react-mw1` CDSC module.

**Step 1 — Load the canonical spec.**
Fetch and read the full, current spec from:

`https://scante-prod.bitbucket.io/sdk-doc/docs/superpowers/react-mw1-module-generation`

This document is the single source of truth. It contains the agent entrypoint, pre-flight checks, input contract, folder layout, default screen design (getUserData + getHeaders with Antd + Tailwind + Icons), conventions, and Appendix A with verbatim file templates for every required file. The spec is fully self-contained — no other repo access is required.

**Step 2 — Follow the spec's "Agent entrypoint" section verbatim.**
That section instructs you to:

1. Run the §0 pre-flight detection (are we inside the scantestage.bitbucket.io repo, or standalone?) and pick the target path accordingly.
2. Ask the user for: `tenant`, `moduleName`, `description`, optional `screenSpec`, optional `sdkCalls`, optional `iframeHeight`.
3. Confirm the resolved inputs + target path with the user. Wait for explicit approval before writing files.
4. Refuse to overwrite an existing target directory without confirmation.
5. Generate the complete folder structure and every file using Appendix A's inlined templates (substituting `{{tenant}}`, `{{moduleName}}`, `{{PascalModuleName}}`, `{{iframeHeight}}`).
6. Apply the mandatory styling stack on every screen: **Antd v5 components + `@ant-design/icons` + Tailwind CSS utility classes** — no raw `<div>` where Antd has an equivalent, no inline styles, no missing icons.
7. If `screenSpec` is empty, render the §6a default screen (getUserData / getHeaders panels with Avatar, Descriptions, Tags, icons, Spin loader, Result error state).
8. Run `npm install && npm run build` inside the new module. Fix and re-run on failure; do not stop on first error.
9. Report back: list of created files, build status, and `npm start` instructions.

**Step 3 — Ask any clarifying question rather than guessing.**
The spec is authoritative; if it conflicts with anything else in your context, the spec wins.

Begin now by fetching the spec URL above and then prompting the user for inputs.
