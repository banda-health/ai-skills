#!/usr/bin/env bash
# Assemble a Banda demo page.
#
#   scripts/build.sh <fragment.html> <output.html> "Page title" [demo.css]
#
# Splices the content fragment, optional demo-specific CSS, and the VERBATIM
# contents of assets/tokens.css and assets/base.css into assets/template.html.
# The CSS never passes through the model — that is the token saving this skill
# exists for. If tokens.css still carries the placeholder marker, a visible
# warning banner is stamped onto the page. If the commit recorded in tokens.css
# no longer matches the frontend repo's HEAD, a staleness warning is printed.
set -euo pipefail

if [ "$#" -lt 3 ] || [ "$#" -gt 4 ]; then
  echo "usage: $(basename "$0") <fragment.html> <output.html> \"Page title\" [demo.css]" >&2
  exit 1
fi

FRAGMENT=$1
OUTPUT=$2
TITLE=$3
DEMOCSS=${4:-}

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATE="$SKILL_DIR/assets/template.html"
TOKENS="$SKILL_DIR/assets/tokens.css"
BASE="$SKILL_DIR/assets/base.css"
FONTS="$SKILL_DIR/assets/fonts.css"

for f in "$FRAGMENT" "$TEMPLATE" "$TOKENS" "$BASE"; do
  [ -f "$f" ] || { echo "error: missing file: $f" >&2; exit 1; }
done

# The product's embedded type. Optional: without it a page still builds, but it
# renders in a system font, which is visibly not the product.
if [ ! -f "$FONTS" ]; then
  echo "warning: no assets/fonts.css — this page gets fallback type." >&2
  echo "         Run scripts/extract-fonts.sh to embed the product's font." >&2
  FONTS=""
fi
if [ -n "$DEMOCSS" ] && [ ! -f "$DEMOCSS" ]; then
  echo "error: missing file: $DEMOCSS" >&2
  exit 1
fi

# An HTML comment inside a <style> block is parsed as a stray rule and eats the
# declaration that follows it. Catch it here rather than in the rendered page.
if [ -n "$DEMOCSS" ] && grep -q '<!--' "$DEMOCSS"; then
  echo "error: $DEMOCSS contains an HTML comment; CSS comments must use /* ... */" >&2
  exit 1
fi

BANNER=""
if grep -q "PLACEHOLDER-TOKENS" "$TOKENS"; then
  BANNER='<div class="demo-banner">Placeholder styling — Banda design tokens not yet extracted. Do not use this page as a visual reference.</div>'
fi

SOURCE_LINE="$(grep -m1 'Extracted from:' "$TOKENS" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//' || true)"
ASSET_VERSION="$(grep -m1 'Assets version:' "$TOKENS" | sed 's/.*Assets version:[[:space:]]*//; s/[[:space:]]*$//' || true)"
EXTRACT_DATE="$(grep -m1 'Extraction date:' "$TOKENS" | sed 's/.*Extraction date:[[:space:]]*//; s/[[:space:]]*$//' || true)"
# Implementers without the frontend repo judge staleness by this line alone.
STAMP="Banda design assets ${ASSET_VERSION:-unversioned}"
[ -n "$EXTRACT_DATE" ] && STAMP="$STAMP · extracted $EXTRACT_DATE"
META="Generated $(date +%Y-%m-%d) by the demo-page skill · $STAMP · ${SOURCE_LINE:-token source unrecorded}"

# --- Staleness: do the tokens still describe the product? ------------------
# Override the repo location with BANDA_FRONTEND if it lives elsewhere.
FRONTEND="${BANDA_FRONTEND:-$HOME/work/greenlight-client}"
TOKEN_COMMIT="$(printf '%s' "$SOURCE_LINE" | sed -n 's/.*@\([0-9a-f]\{7,\}\).*/\1/p')"
if [ -n "$TOKEN_COMMIT" ] && [ -d "$FRONTEND/.git" ]; then
  HEAD_COMMIT="$(git -C "$FRONTEND" rev-parse --short=${#TOKEN_COMMIT} HEAD 2>/dev/null || true)"
  if [ -n "$HEAD_COMMIT" ] && [ "$HEAD_COMMIT" != "$TOKEN_COMMIT" ]; then
    BEHIND="$(git -C "$FRONTEND" rev-list --count "$TOKEN_COMMIT..HEAD" 2>/dev/null || echo '?')"
    echo "warning: tokens were extracted at $TOKEN_COMMIT; $(basename "$FRONTEND") HEAD is $HEAD_COMMIT ($BEHIND commits ahead)." >&2
    echo "         Re-check the components this demo uses against the product before trusting it." >&2
  fi
fi

OUT_DIR="$(dirname "$OUTPUT")"
[ "$OUT_DIR" = "" ] || mkdir -p "$OUT_DIR"

awk -v tokens="$TOKENS" -v base="$BASE" -v fragment="$FRAGMENT" -v democss="$DEMOCSS" \
    -v fonts="$FONTS" -v title="$TITLE" -v banner="$BANNER" -v meta="$META" '
function emit(file,   line) {
  while ((getline line < file) > 0) print line
  close(file)
}
# Literal (regex-safe) marker substitution.
function subst(marker, value,   i) {
  while (i = index($0, marker))
    $0 = substr($0, 1, i - 1) value substr($0, i + length(marker))
}
/@@FONTS@@/   { if (fonts != "") emit(fonts); next }
/@@TOKENS@@/  { emit(tokens);   next }
/@@BASE@@/    { emit(base);     next }
/@@DEMOCSS@@/ { if (democss != "") emit(democss); next }
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
echo "next:  $SKILL_DIR/scripts/verify.sh $OUTPUT"
