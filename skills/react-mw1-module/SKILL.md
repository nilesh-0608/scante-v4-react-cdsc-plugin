---
name: react-mw1-module
description: Use when the user asks to create, scaffold, generate, or bootstrap a new react-mw1 CDSC module, a new scanteIframeSdk module, a new tenant module under react-mw1/cdsc/, or mentions phrases like "new react-mw1 module", "scaffold a CDSC module", "create scante iframe module", or "/new-react-mw1-module". Produces a complete React 18 + TypeScript + CRA project wired to window.scanteIframeSdk with mandatory Antd v5 + @ant-design/icons + Tailwind styling.
version: 1.0.0
---

# react-mw1 Module Scaffolding Skill

When activated, do the following:

## 1. Fetch the canonical spec

The single source of truth is published at:

**`https://scante-prod.bitbucket.io/sdk-doc/docs/superpowers/react-mw1-module-generation`**

Use WebFetch to retrieve it. The spec contains:

- An **Agent entrypoint** section (read this first)
- §0 pre-flight repo detection
- §4 input contract
- §6 folder layout
- §6a default screen design (Antd + Tailwind + Icons, renders `getUserData()` + `getHeaders()`)
- §8 mandatory conventions
- **Appendix A**: verbatim inlined contents of every required file (`package.json`, `tsconfig.json`, `tailwind.config.js`, `postcss.config.js`, `public/index.html`, `public/manifest.json`, `src/index.tsx`, `src/index.css`, `src/App.tsx`, `src/App.css`, `src/react-app-env.d.ts`, `src/reportWebVitals.ts`, `src/setupTests.ts`, `src/context/scanteIframeSdkContext.tsx`)

The spec is **self-contained** — the user does not need to be inside any specific repo.

## 2. Execute the spec's Agent entrypoint verbatim

Summary of what you must do (the spec is authoritative — defer to it on any conflict):

1. **Detect context** — is the cwd the scantestage.bitbucket.io repo (has `react-mw1/cdsc/` + `docusaurus.config.js`)?
   - Inside: target path is `react-mw1/cdsc/<tenant>/<moduleName>/`
   - Outside: target path is `./<moduleName>/` (standalone), still generates the full folder/files from Appendix A
2. **Ask the user** (one grouped message) for:
   - `tenant` (required) — e.g. `gfs`, `power-telematics`, `reladyne`, `rtl`, `thermal`, `default`, or new
   - `moduleName` (required, kebab-case)
   - `description` (required, 1–2 sentences)
   - `screenSpec` (optional — blank uses §6a default)
   - `sdkCalls` (optional — default `init`, `setIframeHeight`, `getUserData`, `getHeaders`)
   - `iframeHeight` (optional — default `1000`)
3. **Confirm** resolved inputs + target path. Wait for "go ahead" before writing anything.
4. **Refuse on collision** — stop if the target dir already exists; ask the user.
5. **Generate every file** from Appendix A, substituting placeholders `{{tenant}}`, `{{moduleName}}`, `{{PascalModuleName}}`, `{{iframeHeight}}`.
6. **Mandatory styling on every screen** (the spec is hard-blocking on this):
   - **Antd v5** components for everything (no raw `<div>` where Antd has an equivalent)
   - **`@ant-design/icons`** on every meaningful affordance (Outlined variants preferred)
   - **Tailwind CSS** utility classes for layout / spacing / color / responsive — no inline `style={{}}`, no per-component CSS files
7. **Default screen (when no `screenSpec`)** — render the §6a layout:
   - Header strip: `Avatar` + `<UserOutlined />` + `Typography.Title` with moduleName + `Tag` with tenant + reload `Button` with `<ReloadOutlined />`
   - Two `Card`s in a Tailwind grid (`grid grid-cols-1 lg:grid-cols-2 gap-4 p-6`):
     - `getUserData()` card → Antd `Descriptions` (bordered, small) for scalar fields + copyable raw JSON
     - `getHeaders()` card → Antd `Tag` per header (icon-prefixed where applicable) + copyable raw JSON
   - Centered `Spin` (size large, `tip="Loading SDK data..."`) while loading
   - Antd `Result` (status="error") on error with retry button
8. **Build + verify**: `cd` into the new module, run `npm install && npm run build`. On failure, fix and re-run; do not stop on first error.
9. **Report**: list created files (paths relative to cwd), confirm build succeeded, give the user `cd <module> && npm start` instructions.

## 3. Hard rules

- Never `import` `scanteIframeSdk`; it's runtime-injected on `window`.
- Imports use the `src/` absolute prefix.
- React 18, TypeScript strict, CRA (`react-scripts` 5.0.1). Do not switch to Vite/Next. Do not eject.
- Dates: `dayjs`.
- Ask the user when ambiguous; do not silently guess.

## 4. If the user invokes the slash command

The `/new-react-mw1-module` slash command (also shipped with this plugin) loads the same instructions. This skill is the autonomous-trigger entrypoint; the slash command is the explicit-trigger entrypoint. Both delegate to the published spec URL.
