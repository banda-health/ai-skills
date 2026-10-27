---
name: demo-page
description: Build self-contained HTML demo pages that match the Banda web UI exactly, assembled from pre-extracted design tokens and canonical component markup instead of invented styling. Use this whenever the user asks for a demo page, mockup, prototype, demo HTML, or to show what a feature or screen would look like — even if they don't say "demo" explicitly. Also use when producing a reference page to hand to implementers, or when the user mentions mockups not matching the product UI.
---

# Banda demo pages

This skill makes the visual layer of a demo a fixed cost. The palette, type, spacing, and component markup are already extracted from the real Banda web UI and live in `assets/`. Generation should only spend tokens on the feature-specific content. The output doubles as the reference implementers align to, so fidelity to the tokens matters more than creativity — a "better looking" demo that drifts from the product is a failed demo.

## Hard rules

1. **Never invent visual values.** Every color, font, size, spacing, radius, and shadow comes from a `var(--...)` defined in `assets/tokens.css`. If the exact value needed doesn't exist, use the closest token and leave a `<!-- TOKEN-GAP: wanted X, used Y -->` comment rather than hardcoding. Hardcoded values are how drift starts.

2. **Compose from the library — and read the product before inventing.** Copy markup patterns from `assets/components.html`. Write new markup only for feature-specific content, built out of existing patterns and tokens.

   When a demo needs a pattern the library lacks, **never reconstruct it from tokens on a guess.** Check the coverage map at the top of `assets/components.html` first — the library is a slice of the product, not all of it. What you do next depends on whether the frontend repo is on this machine.

   **With the frontend repo** (default `~/work/greenlight-client`) — read the real component:

   ```bash
   grep -rn 'bh-' src/scss/module/              # the product's own component classes
   grep -rn 'className="table' src/components/  # real markup for a given screen
   ```

   Lift the real values into `tokens.css`/`base.css` and the real markup into `assets/components.html`, then use it. Fix drift at the source, never in one demo. Only when the product genuinely has no such component, build it token-only and mark it `<!-- NEW-COMPONENT: <name> — candidate for components.html -->`.

   **Without the frontend repo** (most implementers) — you cannot check, so do not guess:

   - Build the closest thing you can **out of components the library already has**. A plainer demo that is correct beats a richer one that is invented.
   - Mark the region `<!-- UNVERIFIED: <component> is not in the library and could not be checked against the product -->`.
   - Say so in your summary, name the component, and tell the user to ask the design-system owner to extract it. Point them at `references/EXTRACTION.md`.
   - Do not silently promote your own markup into `components.html`. That file is only edited against the real product.

   Inventing a plausible substitute is the main way this skill produces a wrong demo, and it fails quietly: the page looks coherent and matches nothing. Without the repo nobody downstream can catch it, which is exactly why the rule is stricter there, not looser.

3. **One self-contained file, zero network requests.** All CSS inlined; no CDNs, no webfonts, no remote images. Inline SVG is fine. These files get shared over email and chat and must open identically anywhere, offline included.

4. **Fictional sample records only.** Banda is hospital management software. Sample *records* must be obviously fictional — never real or realistic-looking patient, staff, or financial data. Invented names, invented MRNs, round-ish numbers. This covers records, not reference data: real ICD/LOINC codes, real MoH form names and real clinical terminology are fine, and usually make the demo more useful to implementers.

5. **Stay on-system.** If the user explicitly asks to deviate from the design system (a new color, different spacing), confirm once, apply it, and mark it with a `<!-- DEVIATION: ... -->` comment. A wanted deviation usually means `tokens.css` needs updating at the source — say so.

6. **Placeholder check.** If `assets/tokens.css` still contains the string `PLACEHOLDER-TOKENS`, the design system has not been extracted yet. Still build the demo — `build.sh` stamps a visible placeholder banner onto the page automatically — but tell the user the styling is placeholder and point them to `references/EXTRACTION.md`. In the no-shell path, include the banner yourself (see Assembly).

7. **Verify before handing it over.** Run `scripts/verify.sh <output.html>` and report what it says. It catches hardcoded values, broken JS, network references and unreplaced markers. Do not call a demo done without it.

## Assembly

**Preferred — a shell is available (Claude Code, Cowork, code execution):**

Write only the content fragment — the markup that goes inside `<main>` — to a temp file, then assemble:

```bash
scripts/build.sh <fragment.html> <output.html> "Page title" [demo.css]
scripts/verify.sh <output.html>
```

The script splices the fragment plus the verbatim CSS into `assets/template.html`. The CSS never passes through the model, which is the token saving this skill exists for. Do not re-type or "clean up" the CSS.

**Demo-specific CSS belongs in the optional fourth argument**, not in a `<style>` block inside the fragment. If you do inline a `<style>` block anyway, remember its contents are CSS: write markers as `/* NEW-COMPONENT: ... */`. An HTML comment inside `<style>` is parsed as a stray rule and silently swallows whatever follows it.

**Fallback — no shell:**

Read `assets/template.html`, `assets/tokens.css`, and `assets/base.css`, and substitute the markers verbatim — character-for-character, resist reformatting:

- `/* @@TOKENS@@ */` → full contents of `tokens.css`
- `/* @@BASE@@ */` → full contents of `base.css`
- `/* @@DEMOCSS@@ */` → demo-specific CSS, or delete the marker line
- `<!-- @@CONTENT@@ -->` → the content fragment
- `<!-- @@TITLE@@ -->` → the page title
- `<!-- @@META@@ -->` → `Generated <YYYY-MM-DD> by the demo-page skill · <the "Extracted from:" line from tokens.css>`
- `<!-- @@BANNER@@ -->` → if `tokens.css` contains `PLACEHOLDER-TOKENS`, replace with `<div class="demo-banner">Placeholder styling — Banda design tokens not yet extracted. Do not use this page as a visual reference.</div>`; otherwise delete the marker line

## Output location

- In a repo (Claude Code): `demos/YYYY-MM-DD-<feature>.html` at the repo root. Create `demos/` if it doesn't exist.
- Outside a repo: `demos/YYYY-MM-DD-<feature>.html` under the working directory. Tell the user the full path.
- In chat environments (claude.ai): create the file and present it to the user.

## What a good fragment looks like

Typically a `.page-header` (title, one-line context, primary action) followed by the feature content — cards, a table, a form, KPI tiles — all lifted from `assets/components.html`. Demos are static by default. Add minimal inline vanilla JS only when the demo's point requires interaction (switching tabs, opening a modal), and keep it under ~30 lines.

**Exception — interaction-led demos.** When the behaviour *is* the deliverable (conditional fields, a multi-step flow, live totals), keep the logic in full. A static version would delete the thing being demonstrated. Convert existing logic rather than rewriting it, keep the markup it emits on-system, and say in your summary that the demo exceeds the static default and why.

Copy inside the demo follows product-writing rules: buttons say exactly what they do ("Save changes", not "Submit"), errors say what went wrong and how to fix it, empty states invite the next action.

## Maintaining the library

The extraction guide lives at `references/EXTRACTION.md` — it covers locating the source of truth in the Banda frontend, which values to pull, and how to verify against a golden screen. Open `assets/components.html` in a browser to preview the whole library at once; its coverage map records what is extracted and what is known to be missing. **Update that map whenever you add a component or discover a gap** — it is what stops the next demo from inventing a substitute.

When the product gains a component demos keep needing, lift its **real** markup into `assets/components.html` and any new values into `tokens.css`/`base.css`. The library should always be a distillation of the product, never a parallel design effort.

`build.sh` warns when the commit recorded in `tokens.css` no longer matches the frontend repo's HEAD. Treat that warning as a prompt to re-run extraction for the components the demo touches.
