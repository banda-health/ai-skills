#!/usr/bin/env bash
# Assemble a Banda demo page.
#
#   scripts/build.sh <fragment.html> <output.html> "Page title"
#
# Splices the content fragment plus the VERBATIM contents of
# assets/tokens.css and assets/base.css into assets/template.html.
# The CSS never passes through the model — that is the token saving
# this skill exists for. If tokens.css still carries the placeholder
# marker, a visible warning banner is stamped onto the page.
set -euo pipefail

if [ "$#" -ne 3 ]; then
  echo "usage: $(basename "$0") <fragment.html> <output.html> \"Page title\"" >&2
  exit 1
fi

FRAGMENT=$1
OUTPUT=$2
TITLE=$3

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATE="$SKILL_DIR/assets/template.html"
TOKENS="$SKILL_DIR/assets/tokens.css"
BASE="$SKILL_DIR/assets/base.css"

for f in "$FRAGMENT" "$TEMPLATE" "$TOKENS" "$BASE"; do
  [ -f "$f" ] || { echo "error: missing file: $f" >&2; exit 1; }
done

BANNER=""
if grep -q "PLACEHOLDER-TOKENS" "$TOKENS"; then
  BANNER='<div class="demo-banner">Placeholder styling — Banda design tokens not yet extracted. Do not use this page as a visual reference.</div>'
fi

SOURCE_LINE="$(grep -m1 'Extracted from:' "$TOKENS" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//' || true)"
META="Generated $(date +%Y-%m-%d) by the demo-page skill · ${SOURCE_LINE:-token source unrecorded}"

OUT_DIR="$(dirname "$OUTPUT")"
[ "$OUT_DIR" = "" ] || mkdir -p "$OUT_DIR"

awk -v tokens="$TOKENS" -v base="$BASE" -v fragment="$FRAGMENT" \
    -v title="$TITLE" -v banner="$BANNER" -v meta="$META" '
function emit(file,   line) {
  while ((getline line < file) > 0) print line
  close(file)
}
# Literal (regex-safe) marker substitution.
function subst(marker, value,   i) {
  while (i = index($0, marker))
    $0 = substr($0, 1, i - 1) value substr($0, i + length(marker))
}
/@@TOKENS@@/  { emit(tokens);   next }
/@@BASE@@/    { emit(base);     next }
/@@CONTENT@@/ { emit(fragment); next }
/@@BANNER@@/  { if (banner != "") print banner; next }
{
  subst("<!-- @@TITLE@@ -->", title)
  subst("<!-- @@META@@ -->", meta)
  print
}
' "$TEMPLATE" > "$OUTPUT"

if grep -q "@@" "$OUTPUT"; then
  echo "warning: unreplaced @@ markers remain in $OUTPUT" >&2
fi

echo "built: $OUTPUT"
