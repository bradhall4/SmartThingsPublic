#!/bin/bash
# SessionStart hook: install the Hallmark design skill so it's available
# every time a Claude Code session starts (each web session runs in a fresh,
# ephemeral container, so the skill has to be (re)installed on startup).
#
# Hallmark: https://www.usehallmark.com  (nutlope/hallmark)
set -euo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
cd "$PROJECT_DIR"

# Claude Code discovers project skills under .claude/skills/. The skills CLI
# symlinks installed skills into that directory, so make sure it exists first.
mkdir -p .claude/skills

# Idempotent: re-running simply reinstalls the latest Hallmark. Don't let a
# transient network/install failure block the whole session from starting.
if npx -y skills add nutlope/hallmark --yes; then
  echo "Hallmark skill installed."
else
  echo "WARNING: could not install Hallmark skill (offline or install error); continuing." >&2
fi
