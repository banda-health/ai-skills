# Extracting the Banda design system (one-time setup)

The skill ships with neutral placeholder values so it works end-to-end, but
demos are only useful as a visual contract once `assets/tokens.css` and
`assets/components.html` are distilled from the real Banda web UI. Until
then, every generated page carries a visible placeholder banner.

**How to run this:** open the Banda frontend repo in Claude Code and say
"Read .claude/skills/demo-page/references/EXTRACTION.md and follow it."
Extraction is direct because the source of truth is a custom web app —
no need to scrape computed styles unless step 1 comes up empty.

## 1. Locate the source of truth

In order of preference: a design-tokens/theme file, global CSS custom
properties, Tailwind config, or a styled-components/emotion theme object.
Useful greps: `:root`, `--color`, `tailwind.config`, `theme.extend`,
`createTheme`, `ThemeProvider`, `variables.scss`. If nothing structured
exists, open the running app and read computed styles off real screens —
then say so in the tokens header, because it means the product itself has
no token layer and drift is likely on their side too.

## 2. Fill tokens.css

Keep the token **names** unchanged — `base.css` depends on them. Map real
values onto them; preserve the product's units (rem vs px). Pull:

- Colors: page background, surface, borders (default + strong); text
  (primary, muted, faint, inverse); primary action (base, hover, soft,
  text-on-primary); success/warning/danger/info each with a soft variant;
  focus ring.
- Typography: family stacks, size scale, weights, base line-height. Demos
  make zero network requests, so if the product uses a webfont, keep the
  family name first in the stack and accept the system fallback (note it
  in the header).
- Spacing scale, radii, shadows, border width, sidebar width, topbar height.

If the product has roles these tokens don't cover, **add** tokens plus
matching `base.css` rules. Never hardcode values downstream — hardcoding
is the drift this skill exists to kill.

## 3. Replace the component markup

For each snippet in `assets/components.html` (buttons, inputs, table,
card, badges, tabs, alerts, modal, nav in `template.html`), find the real
component and lift its rendered markup near-verbatim. Two rules:

- Match **computed styles, not implementation**. If the product uses
  Tailwind or CSS-in-JS, translate what the browser actually renders into
  `base.css` rules — never ship utility-class soup or generated class
  hashes into the assets.
- Strip framework artifacts (React data-attributes, hydration markers)
  but keep the class names and structure a designer would recognize.

Also replace the sidebar nav in `template.html` with the product's real
labels and grouping, and adjust `base.css` values (paddings, radii,
hover states) to match the real rendering.

## 4. Verify against a golden screen

Pick one real product screen. Build a demo of it with this skill and put
the two side by side. If you can tell them apart at a glance, extract
whatever differs and repeat. Fix deltas in `tokens.css`/`base.css`, never
in the individual demo. Opening `assets/components.html` in a browser
previews the whole library at once.

## 5. Finish

1. In `assets/tokens.css`: delete the marker word from the STATUS line
   (this is what silences the placeholder banner) and fill in
   `Extracted from:` (repo@commit) and `Extraction date:`.
2. Open a pull request against this repo to publish the new values.
   This folder is the shared copy that implementers install, so a
   re-extraction only reaches them once it is merged here.
3. Optionally re-zip the folder and upload to claude.ai as a user skill
   so chat-generated demos comply too.

## Re-extraction

Repeat steps 2–5 whenever the product theme or core components change.
Every demo's footer records its generation date and token source, so
stale demos are identifiable at a glance.
