#!/usr/bin/env bash
# Check a built Banda demo page against the skill's hard rules.
#
#   scripts/verify.sh <page.html>
#
# FAIL  breaks a hard rule — fix before handing the page over.
# WARN  worth a look, and worth mentioning to the user.
# Exit status is 1 if anything FAILed.
set -uo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $(basename "$0") <page.html>" >&2
  exit 2
fi
[ -f "$1" ] || { echo "error: no such file: $1" >&2; exit 2; }

PAGE="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FRONTEND="${BANDA_FRONTEND:-$HOME/work/greenlight-client}"

NODE_BIN="$(command -v node || true)"

python3 - "$PAGE" "$FRONTEND" "$NODE_BIN" <<'PY'
import os, re, subprocess, sys, tempfile

page, frontend, node_bin = sys.argv[1], sys.argv[2], sys.argv[3]
src = open(page, encoding='utf-8', errors='replace').read()
fails, warns, notes = [], [], []

def line_of(idx):
    return src.count('\n', 0, idx) + 1

# --- 1. Unreplaced template markers ---------------------------------------
if '@@' in src:
    bad = {m.group(0) for m in re.finditer(r'@@\w+@@', src)}
    fails.append(f"unreplaced template markers: {', '.join(sorted(bad)) or '@@'}")

# --- 2. Network requests ---------------------------------------------------
# data: URIs are fine; an xmlns inside one is not a request.
net = []
for m in re.finditer(r'(?:src|href)\s*=\s*["\'](https?:)?//', src):
    net.append(line_of(m.start()))
for m in re.finditer(r'url\(\s*["\']?(?:https?:)?//', src):
    net.append(line_of(m.start()))
if re.search(r'<link\b(?![^>]*rel=["\']?(icon|shortcut))', src, re.I):
    net.append(line_of(re.search(r'<link\b', src, re.I).start()))
if net:
    fails.append(f"external resource reference at line(s) {', '.join(map(str, sorted(set(net))))}")

# --- 3. HTML comments inside <style> (silently eats the next rule) ---------
for m in re.finditer(r'<style[^>]*>(.*?)</style>', src, re.S | re.I):
    if '<!--' in m.group(1):
        fails.append(f"HTML comment inside <style> at line {line_of(m.start(1))} — use /* ... */")

# --- 4. Unbalanced braces in any <style> ----------------------------------
for m in re.finditer(r'<style[^>]*>(.*?)</style>', src, re.S | re.I):
    css = m.group(1)
    if css.count('{') != css.count('}'):
        fails.append(f"unbalanced CSS braces in <style> at line {line_of(m.start(1))} "
                     f"({css.count('{')} open, {css.count('}')} close)")

# --- 5. Hardcoded colors below <head> -------------------------------------
# tokens.css and base.css legitimately carry literals; the demo's own markup
# must not. Scope to style="..." attributes and any <style> in the body.
head_end = src.lower().find('</head>')
body = src[head_end:] if head_end != -1 else src
offset = head_end if head_end != -1 else 0
HEX = re.compile(r'#(?:[0-9a-fA-F]{3,4}|[0-9a-fA-F]{6}|[0-9a-fA-F]{8})\b')
RGB = re.compile(r'\brgba?\(')
hits = []
for m in re.finditer(r'style\s*=\s*"([^"]*)"', body):
    if HEX.search(m.group(1)) or RGB.search(m.group(1)):
        hits.append(line_of(offset + m.start()))
for m in re.finditer(r'<style[^>]*>(.*?)</style>', body, re.S | re.I):
    for mm in list(HEX.finditer(m.group(1))) + list(RGB.finditer(m.group(1))):
        hits.append(line_of(offset + m.start(1) + mm.start()))
if hits:
    fails.append(f"hardcoded color below <head> at line(s) {', '.join(map(str, sorted(set(hits))))} "
                 f"— use a var(--...) token")

# --- 6. Raw lengths below <head> (informational) --------------------------
raw = set()
for m in re.finditer(r'style\s*=\s*"([^"]*)"', body):
    for mm in re.finditer(r'(?<![\w-])\d*\.?\d+(px|rem|em)\b', m.group(1)):
        raw.add(line_of(offset + m.start()))
for m in re.finditer(r'<style[^>]*>(.*?)</style>', body, re.S | re.I):
    for mm in re.finditer(r'(?<![\w-])\d*\.?\d+(px|rem|em)\b', m.group(1)):
        raw.add(line_of(offset + m.start(1) + mm.start()))
if raw:
    n = len(raw)
    notes.append(f"{n} raw length value(s) below <head> (line(s) "
                 f"{', '.join(map(str, sorted(raw)[:8]))}{' …' if n > 8 else ''}). "
                 f"Each needs a token or a TOKEN-GAP comment.")

# --- 7. Placeholder banner -------------------------------------------------
if 'demo-banner' in src and 'tokens not yet extracted' in src:
    warns.append("page carries the PLACEHOLDER styling banner — tell the user it is not a visual reference")

# --- 8. JS syntax ----------------------------------------------------------
scripts = [m.group(1) for m in re.finditer(r'<script(?![^>]*\bsrc=)[^>]*>(.*?)</script>', src, re.S | re.I)]
if not scripts:
    notes.append("no inline script (static demo)")
elif not node_bin:
    notes.append(f"{len(scripts)} inline script block(s), not syntax-checked (node not found)")
else:
    broken = 0
    for i, js in enumerate(scripts, 1):
        with tempfile.NamedTemporaryFile('w', suffix='.js', delete=False, encoding='utf-8') as fh:
            fh.write(js); tmp = fh.name
        r = subprocess.run([node_bin, '--check', tmp], capture_output=True, text=True)
        os.unlink(tmp)
        if r.returncode != 0:
            broken += 1
            first = (r.stderr.strip().splitlines() or ['syntax error'])
            fails.append(f"script block {i} has a syntax error: {first[0][:160]}")
    if not broken:
        notes.append(f"{len(scripts)} inline script block(s) pass node --check")

# --- 9. Token staleness ----------------------------------------------------
# Without the frontend repo (most implementers), age is the only signal there
# is — so surface it unconditionally rather than silently skipping.
mv = re.search(r'Banda design assets (\S+)(?: · extracted (\d{4}-\d{2}-\d{2}))?', src)
if mv:
    version, date = mv.group(1), mv.group(2)
    if date:
        import datetime
        age = (datetime.date.today() - datetime.date.fromisoformat(date)).days
        line = f"built from design assets {version}, extracted {date} ({age} days ago)"
        (warns if age > 90 else notes).append(
            line + (" — ask the design-system owner whether a newer version exists" if age > 90 else ""))
    else:
        warns.append(f"design assets {version} carry no extraction date")
else:
    warns.append("page does not record a design-assets version — rebuild with a current build.sh")

m = re.search(r'Extracted from:\s*(\S+)@([0-9a-f]{7,})', src)
if m and os.path.isdir(os.path.join(frontend, '.git')):
    token_commit = m.group(2)
    try:
        head = subprocess.run(
            ['git', '-C', frontend, 'rev-parse', f'--short={len(token_commit)}', 'HEAD'],
            capture_output=True, text=True, check=True).stdout.strip()
        if head and head != token_commit:
            behind = subprocess.run(
                ['git', '-C', frontend, 'rev-list', '--count', f'{token_commit}..HEAD'],
                capture_output=True, text=True).stdout.strip() or '?'
            warns.append(f"tokens extracted at {token_commit}; {os.path.basename(frontend)} HEAD is "
                         f"{head} ({behind} commits ahead) — re-check the components this demo uses")
    except subprocess.CalledProcessError:
        pass

# --- 10. Unverified regions (built without the frontend repo) -------------
unver = re.findall(r'<!--\s*UNVERIFIED:\s*(.*?)\s*-->', src)
if unver:
    warns.append(f"{len(unver)} unverified region(s) — not checked against the product: "
                 + '; '.join(u[:70] for u in unver[:4]))

# --- report ----------------------------------------------------------------
print(f"verify: {os.path.basename(page)}")
for f in fails: print(f"  FAIL  {f}")
for w in warns: print(f"  WARN  {w}")
for n in notes: print(f"  note  {n}")
if not fails and not warns:
    print("  OK    no failures, no warnings")
sys.exit(1 if fails else 0)
PY
