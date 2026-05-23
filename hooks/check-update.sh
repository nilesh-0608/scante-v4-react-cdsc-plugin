#!/usr/bin/env bash
# scante-v4-react-cdsc — SessionStart update check
# Compares the locally installed plugin.json version with the latest on GitHub.
# Prints a one-line notification to stdout (Claude Code surfaces it as context).
# Caches the result for 6 hours to avoid hammering GitHub.
# Fails silently on any error — never blocks the session.

set -u

REPO="nilesh-0608/scante-v4-react-cdsc-plugin"
RAW_URL="https://raw.githubusercontent.com/${REPO}/main/.claude-plugin/plugin.json"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/scante-v4-react-cdsc"
CACHE_FILE="${CACHE_DIR}/update-check.json"
CACHE_TTL_SECONDS=21600   # 6 hours

LOCAL_MANIFEST="${CLAUDE_PLUGIN_ROOT:-}/.claude-plugin/plugin.json"
[ -f "$LOCAL_MANIFEST" ] || exit 0

# Read local version (no jq dependency — grep + sed)
LOCAL_VERSION=$(grep -m1 '"version"' "$LOCAL_MANIFEST" | sed -E 's/.*"version"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/')
[ -n "$LOCAL_VERSION" ] || exit 0

# Honor cache
mkdir -p "$CACHE_DIR" 2>/dev/null || exit 0
if [ -f "$CACHE_FILE" ]; then
  CACHE_AGE=$(( $(date +%s) - $(stat -c %Y "$CACHE_FILE" 2>/dev/null || stat -f %m "$CACHE_FILE" 2>/dev/null || echo 0) ))
  if [ "$CACHE_AGE" -lt "$CACHE_TTL_SECONDS" ]; then
    REMOTE_VERSION=$(grep -m1 '"version"' "$CACHE_FILE" | sed -E 's/.*"version"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/')
  fi
fi

# Fetch if cache miss/expired
if [ -z "${REMOTE_VERSION:-}" ]; then
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL --max-time 4 "$RAW_URL" -o "$CACHE_FILE" 2>/dev/null || exit 0
  elif command -v wget >/dev/null 2>&1; then
    wget -q --timeout=4 -O "$CACHE_FILE" "$RAW_URL" 2>/dev/null || exit 0
  else
    exit 0
  fi
  REMOTE_VERSION=$(grep -m1 '"version"' "$CACHE_FILE" | sed -E 's/.*"version"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/')
fi

[ -n "$REMOTE_VERSION" ] || exit 0
[ "$LOCAL_VERSION" = "$REMOTE_VERSION" ] && exit 0

# Simple semver compare via sort -V — only notify if remote is strictly newer
NEWEST=$(printf '%s\n%s\n' "$LOCAL_VERSION" "$REMOTE_VERSION" | sort -V | tail -1)
[ "$NEWEST" = "$REMOTE_VERSION" ] || exit 0

cat <<EOF
[scante-v4-react-cdsc] 🔔 Update available: ${LOCAL_VERSION} → ${REMOTE_VERSION}
  Update with one of:
    /plugin marketplace update nilesh-0608/scante-v4-react-cdsc-plugin
    /plugin uninstall scante-v4-react-cdsc && /plugin install scante-v4-react-cdsc@scante-v4-react-cdsc
  Release: https://github.com/${REPO}/releases
EOF
