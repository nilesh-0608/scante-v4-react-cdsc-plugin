---
name: scante-v4-react-cdsc
description: Use when the user asks to create, scaffold, generate, or bootstrap a new react-mw1 CDSC module, a new scanteIframeSdk module, a new tenant module under react-mw1/cdsc/, or mentions phrases like "new react-mw1 module", "scaffold a CDSC module", "create scante iframe module", or "/scante-v4-react-cdsc". Produces a complete React 18 + TypeScript + CRA project wired to window.scanteIframeSdk with mandatory Antd v5 + @ant-design/icons + Tailwind styling.
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

1. **Detect context FIRST — before asking anything.** Check whether the current working directory is the Scante v4 React CDSC repo. It is if **all** of these are true:
   - `react-mw1/cdsc/` directory exists at the cwd root
   - `docusaurus.config.js` exists at the cwd root
   - `git remote -v` contains `scante-prod.bitbucket.io`

2. **Branch on the detection result:**

   **Case A — Inside the repo (all checks pass): ASK the full questionnaire.**
   Tenant matters here because the module lives under `react-mw1/cdsc/<tenant>/<moduleName>/`. Ask the user (one grouped message) for:
   - `tenant` (required) — e.g. `gfs`, `power-telematics`, `reladyne`, `rtl`, `thermal`, `default`, or new
   - `moduleName` (required, kebab-case)
   - `description` (required, 1–2 sentences)
   - `screenSpec` (optional — blank uses §6a default)
   - `sdkCalls` (optional — default `init`, `setIframeHeight`, `getUserData`, `getHeaders`)
   - `iframeHeight` (optional — default `1000`)
   Then **confirm** resolved inputs + target path `react-mw1/cdsc/<tenant>/<moduleName>/` and wait for explicit "go ahead" before writing anything.

   **Case B — Outside the repo (any check fails): proceed with minimal prompts and just scaffold.**
   There is no tenant or enforced folder structure here. Ask only the bare minimum (`moduleName` — required, kebab-case; `screenSpec` — optional) and **immediately proceed** to scaffold at `./<moduleName>/` in the current cwd using Appendix A templates with sensible defaults. Don't block on confirmation — just announce the target path and start generating. If `moduleName` is also missing, ask only for that.
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
9. **Report + how to run**:
   - List created files (paths relative to cwd) and confirm build succeeded.
   - **Inside the repo (Case A)** — instruct the user to run the module via the repo's helper script from the repo root:
     ```bash
     ./run-app.sh react-mw1/cdsc/<tenant>/<moduleName>
     ```
     This spins up the React dev container via `docker compose up`. **Tell the user to open** `https://scante-dev.local` (or `http://scante-dev.local`) in the browser once the container is ready. Prerequisite: `/etc/hosts` must contain `127.0.0.1 scante-dev.local` (the repo already includes the local SSL cert under `certbot/` / `nginx/`). Do **not** instruct `npm start` in this case.
   - **Outside the repo (Case B)** — instruct the user to run locally with:
     ```bash
     cd <moduleName> && npm start
     ```
     Then open `http://localhost:3000`.

## 2a. Docker / compose files — DO NOT touch

The repo's Docker setup is fully generic and **requires zero changes per new module**:

- `Dockerfile` (repo root) — copies `package*.json` from `${PROJECT_PATH}`, runs `npm install`, exposes port 3000. Generic.
- `docker-compose.yml` (repo root) — uses `${PROJECT_PATH}` env var for build context AND volume mount (`${PROJECT_PATH}:/app`).
- `docker-compose-html.yml` — same idea, for HTML/Alpine modules.
- `run-app.sh` — accepts the module path as `$1`, sets `PROJECT_PATH=$(realpath "$1")`, then runs `docker compose up` (React) or `docker compose -f docker-compose-html.yml up` (HTML), auto-detected by presence of `package.json`.

**Default behavior:** do **not** edit `Dockerfile`, `docker-compose*.yml`, `run-app.sh`, or `nginx/*` when scaffolding. The new module's own `package.json` (generated from Appendix A) is all the docker stack needs. If a generated module's `npm install` fails inside the container, the fix almost always belongs in the module's `package.json`, not the docker files.

**Exception — agent MAY ask the user for permission to edit a docker file** when there is a genuine reason that cannot be solved at the module level. Examples:

- The new module needs a different exposed port (not 3000) — would require a `ports:` change in `docker-compose.yml`.
- The new module needs an additional service (e.g. Redis, a worker) — would require a new service block.
- The new module needs an env var injected at container start.
- The new module changes the Node version requirement beyond the base image.
- An nginx route/proxy entry is needed for the new module.

In those cases: **ask the user explicitly**, describe the exact file + diff you intend to make, and only proceed after they say yes. Never silently modify infra files.

## 3. Hard rules

- Never `import` `scanteIframeSdk`; it's runtime-injected on `window`.
- Imports use the `src/` absolute prefix.
- React 18, TypeScript strict, CRA (`react-scripts` 5.0.1). Do not switch to Vite/Next. Do not eject.
- Dates: `dayjs`.
- Ask the user when ambiguous; do not silently guess.

## 4. If the user invokes the slash command

The `/scante-v4-react-cdsc` slash command (also shipped with this plugin) loads the same instructions. This skill is the autonomous-trigger entrypoint; the slash command is the explicit-trigger entrypoint. Both delegate to the published spec URL.
