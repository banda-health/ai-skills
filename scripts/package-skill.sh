#!/usr/bin/env bash
# Package one skill as a .zip for upload to claude.ai.
#
#   scripts/package-skill.sh <path/to/skill> [outdir]
#
# Claude Code users do not need this — they install the plugin from the
# marketplace (see README.md). This is for people who work in claude.ai and
# upload a skill by hand.
set -euo pipefail

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  echo "usage: $(basename "$0") <path/to/skill> [outdir]" >&2
  exit 1
fi

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_DIR="$(cd "$1" && pwd)"
SKILL_NAME="$(basename "$SKILL_DIR")"
OUTDIR="${2:-$REPO_ROOT/dist}"

[ -f "$SKILL_DIR/SKILL.md" ] || { echo "error: no SKILL.md at $SKILL_DIR" >&2; exit 1; }
command -v zip >/dev/null || { echo "error: zip is not installed" >&2; exit 1; }

# A skill that ships design assets stamps its own version. Use it when present,
# so the archive name matches what the skill's output claims.
TOKENS="$SKILL_DIR/assets/tokens.css"
VERSION=""
DATE=""
if [ -f "$TOKENS" ]; then
  if grep -q 'PLACEHOLDER-TOKENS' "$TOKENS"; then
    echo "error: $TOKENS still carries PLACEHOLDER-TOKENS — do not ship this" >&2
    exit 1
  fi
  VERSION="$(grep -m1 'Assets version:' "$TOKENS" \
    | sed 's/.*Assets version:[[:space:]]*//; s/[[:space:]]*$//' || true)"
  DATE="$(grep -m1 'Extraction date:' "$TOKENS" \
    | sed 's/.*Extraction date:[[:space:]]*//; s/[[:space:]]*$//' || true)"
fi
VERSION="${VERSION:-$(date +%Y-%m-%d)}"

mkdir -p "$OUTDIR"
ZIP="$OUTDIR/$SKILL_NAME-$VERSION.zip"
rm -f "$ZIP"

# Zip from the parent so the archive holds <skill>/SKILL.md, not SKILL.md.
( cd "$(dirname "$SKILL_DIR")" && zip -rq "$ZIP" "$SKILL_NAME" -x '*.DS_Store' '*/.git/*' )

echo "packaged: $ZIP"
[ -n "$DATE" ] && echo "  design assets $VERSION, extracted $DATE"
echo "  upload this in claude.ai under Settings → Capabilities → Skills"
