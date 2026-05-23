# scante-v4-react-cdsc — Claude Code Plugin

Scaffold a new **react-mw1 CDSC** module with a single command. Generates a complete React 18 + TypeScript + CRA project wired to `window.scanteIframeSdk`, styled with **Ant Design v5** + **`@ant-design/icons`** + **Tailwind CSS**.

The plugin delegates to the canonical, self-contained spec hosted at:

**<https://scante-prod.bitbucket.io/sdk-doc/docs/superpowers/react-mw1-module-generation>**

The spec inlines every required file (Appendix A), so the plugin works whether or not you're inside the `scantestage.bitbucket.io` repo.

## Install

From inside Claude Code:

```
/plugin marketplace add nilesh-0608/scante-v4-react-cdsc-plugin
/plugin install scante-v4-react-cdsc@scante-v4-react-cdsc
```


## Use

**Explicit (slash command):**

```
/scante-v4-react-cdsc
```

Claude will:

1. Detect whether your cwd is the `scantestage.bitbucket.io` repo (picks `react-mw1/cdsc/<tenant>/<moduleName>/`) or somewhere else (picks `./<moduleName>/`).
2. Ask for: `tenant`, `moduleName`, `description`, optional `screenSpec`, optional `sdkCalls`, optional `iframeHeight`.
3. Confirm with you before writing.
4. Generate every file from the spec's Appendix A templates.
5. Run `npm install && npm run build` and report results.

**Autonomous:** the bundled skill also activates when you say things like "create a new react-mw1 module" or "scaffold a CDSC module" — no slash command required.

## What the generated module looks like

- React 18, TypeScript strict, CRA (`react-scripts` 5.0.1)
- Antd v5 components for every UI primitive
- `@ant-design/icons` on every meaningful affordance
- Tailwind utility classes for layout / spacing / responsive
- A working default screen that renders `await scanteIframeSdk.getUserData()` + `await scanteIframeSdk.getHeaders()` in styled Antd cards (you replace this with your real UI)
- `scanteIframeSdkContext` provider + `use<PascalModuleName>` hook scaffolding

## Updating

There are two kinds of updates:

### 1. Spec updates (most updates)

The canonical spec lives at
<https://scante-prod.bitbucket.io/sdk-doc/docs/superpowers/react-mw1-module-generation>
and is fetched fresh every time the plugin runs. Any change there applies to new scaffolds **immediately** — no plugin reinstall needed.

### 2. Plugin updates (command / skill / marketplace changes)

When this plugin's `command`, `skill`, or `marketplace.json` itself changes, you have two options to pull the new version into Claude Code:

**Option A — Enable auto-update (recommended):**
```
/plugin marketplace update nilesh-0608/scante-v4-react-cdsc-plugin
```
Or turn on automatic marketplace refresh in your Claude Code settings so the plugin pulls latest on each new session.

**Option B — Remove and re-add:**
```
/plugin uninstall scante-v4-react-cdsc
/plugin marketplace remove scante-v4-react-cdsc
/plugin marketplace add nilesh-0608/scante-v4-react-cdsc-plugin
/plugin install scante-v4-react-cdsc@scante-v4-react-cdsc
```

This forces a clean reinstall from the latest commit on `main`.

Plugin maintainers: bump `plugin.json` `version` whenever you change command / skill behavior so users on Option A see a clear version bump.

## License

UNLICENSED — internal Scante use.
