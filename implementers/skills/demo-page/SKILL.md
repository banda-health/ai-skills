---
name: demo-page
description: Build self-contained HTML demo pages that match the Banda web UI exactly, assembled from pre-extracted design tokens and canonical component markup instead of invented styling. Use this whenever the user asks for a demo page, mockup, prototype, demo HTML, or to show what a feature or screen would look like — even if they don't say "demo" explicitly. Also use when producing a reference page to hand to implementers, or when the user mentions mockups not matching the product UI.
---

# Banda demo pages

This skill makes the visual layer of a demo a fixed cost. The palette, type, spacing, and component markup are already extracted from the real Banda web UI and live in `assets/`. Generation should only spend tokens on the feature-specific content. The output doubles as the reference implementers align to, so fidelity to the tokens matters more than creativity — a "better looking" demo that drifts from the product is a failed demo.

## Hard rules

1. **Never invent visual values.** Every color, font, size, spacing, radius, and shadow comes from a `var(--...)` defined in `assets/tokens.css`. If the exact value needed doesn't exist, use the closest token and leave a `<!-- TOKEN-GAP: wanted X, used Y -->` comment rather than hardcoding. Hardcoded values are how drift starts.
2. **Compose from the component library.** Copy markup patterns from `assets/components.html`. Write new markup only for feature-specific content, and build it out of existing patterns and tokens. If a demo genuinely needs a pattern the library lacks, build it token-only and mark it `<!-- NEW-COMPONENT: <name> — candidate for components.html -->` so it can be reviewed and added.
3. **One self-contained file, zero network requests.** All CSS inlined; no CDNs, no webfonts, no remote images. Inline SVG is fine. These files get shared over email and chat and must open identically anywhere, offline included.
4. **Fictional sample data only.** Banda is hospital management software. Sample content must be obviously fictional — never real or realistic-looking patient, staff, or financial records. Invented names, invented MRNs, round-ish numbers.
5. **Stay on-system.** If the user explicitly asks to deviate from the design system (a new color, different spacing), confirm once, apply it, and mark it with a `<!-- DEVIATION: ... -->` comment. A wanted deviation usually means `tokens.css` needs updating at the source — say so.
6. **Placeholder check.** If `assets/tokens.css` still contains the string `PLACEHOLDER-TOKENS`, the design system has not been extracted yet. Still build the demo — `build.sh` stamps a visible placeholder banner onto the page automatically — but tell the user the styling is placeholder and point them to `references/EXTRACTION.md`. In the no-shell path, include the banner yourself (see Assembly).

## Assembly

**Preferred — a shell is available (Claude Code, Cowork, code execution):**

Write only the content fragment — the markup that goes inside `<main>` — to a temp file, then assemble:

```bash
scripts/build.sh <fragment.html> <output.html> "Page title"
```

The script splices the fragment plus the verbatim CSS into `assets/template.html`. The CSS never passes through the model, which is the token saving this skill exists for. Do not re-type or "clean up" the CSS.

**Fallback — no shell:**

Read `assets/template.html`, `assets/tokens.css`, and `assets/base.css`, and substitute the markers verbatim — character-for-character, resist reformatting:

- `/* @@TOKENS@@ */` → full contents of `tokens.css`
- `/* @@BASE@@ */` → full contents of `base.css`
- `<!-- @@CONTENT@@ -->` → the content fragment
- `<!-- @@TITLE@@ -->` → the page title
- `<!-- @@META@@ -->` → `Generated <YYYY-MM-DD> by the demo-page skill · <the "Extracted from:" line from tokens.css>`
- `<!-- @@BANNER@@ -->` → if `tokens.css` contains `PLACEHOLDER-TOKENS`, replace with `<div class="demo-banner">Placeholder styling — Banda design tokens not yet extracted. Do not use this page as a visual reference.</div>`; otherwise delete the marker line

## Output location

- In a repo (Claude Code): `demos/YYYY-MM-DD-<feature>.html` at the repo root. Create `demos/` if it doesn't exist.
- In chat environments (claude.ai): create the file and present it to the user.

## What a good fragment looks like

Typically a `.page-header` (title, one-line context, primary action) followed by the feature content — cards, a table, a form, KPI tiles — all lifted from `assets/components.html`. Demos are static by default. Add minimal inline vanilla JS only when the demo's point requires interaction (switching tabs, opening a modal), and keep it under ~30 lines.

Copy inside the demo follows product-writing rules: buttons say exactly what they do ("Save changes", not "Submit"), errors say what went wrong and how to fix it, empty states invite the next action.

## Maintaining the library

The extraction guide lives at `references/EXTRACTION.md` — it covers locating the source of truth in the Banda frontend, which values to pull, and how to verify against a golden screen. Open `assets/components.html` in a browser to preview the whole library at once. When the product gains a component demos keep needing, lift its **real** markup into `assets/components.html` and any new values into `tokens.css`/`base.css`. The library should always be a distillation of the product, never a parallel design effort.
