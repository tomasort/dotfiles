---
name: algorithm-visualizer
description: >
  Turn any algorithm (or data-structure operation) into a debugger-style animated
  walkthrough video using HyperFrames. Split-screen: code always on screen with a
  moving line-highlight, a live variable watch, and a data-structure visualization
  (bars/pointers/matrix) that updates as the code steps. Renders to MP4, and to a
  small Anki-ready GIF. Use when the user asks to "visualize this algorithm",
  "make an animation of this code", "debug through this in a video", "show how
  this loop/recursion works", or wants to add such an animation to an Anki card.
---

# Algorithm Visualizer

Turn an algorithm into a debugger-style HyperFrames animation: code on the left
(always visible, current line highlighted), variables on-screen updating as the
code runs, and a visual of the data structure on the right changing step by step.
Works for array algorithms (two-pointer, sliding window, buy/sell, sort, search),
linked lists, matrices, and simple recursion — anything you can trace by hand.

## Outputs

- **MP4** — full-resolution walkthrough (the primary deliverable).
- **Anki GIF** — condensed, small (≤ ~200 KB), 360px, 10 fps, plays inline on a
  flashcard back. Optionally attached to the user's card.

## Workflow

1. **Identify the algorithm and a concrete example input.** Use the user's example,
   or pick a small one that exercises every branch. Confirm the input before
   building.
2. **Trace it by hand first.** Write out the exact sequence of lines executed and
   every variable change (this becomes the `STEPS` array). Never invent the trace
   while writing the animation.
3. **Scaffold a project** (once per algorithm):
   ```bash
   cd <workspace>
   npx hyperframes init <name> --non-interactive --example blank --resolution landscape
   ```
4. **Copy the reusable template** into `index.html`:
   ```
   cp <skill>/template.html index.html
   ```
   Then fill in the `CONFIG` and `STEPS` sections described below. Only edit the
   `CONFIG`, `STEPS`, and per-step data — the timeline builder and layout stay
   untouched.
5. **Run the gate**, fix findings, **preview/approve**, then **render**:
   ```bash
   npx hyperframes check
   npx hyperframes render --quality high --output out.mp4
   ```
6. **Render the Anki GIF** (from the MP4 — HyperFrames' own GIF output can be
   transparent):
   ```bash
   ffmpeg -y -v error -i out.mp4 \
     -vf "scale=360:-2:flags=lanczos,fps=10,split[a][b];[a]palettegen=max_colors=128[p];[b][p]paletteuse=dither=bayer" \
     out.gif
   ```
7. **Verify pixels** before showing the user (cheap and catches layout bugs):
   ```bash
   ffmpeg -y -v error -ss <t> -i out.mp4 -frames:v 1 /tmp/f.png
   python3 -c "from PIL import Image; im=Image.open('/tmp/f.png'); px=im.load(); \
     print([x for x in range(1920) if sum(1 for y in range(200,900,6) if all(c>220 for c in px[x,y]))>40])"
   ```
   This prints x-positions of vertical white lines — confirm the cursor/pointer is
   over its target, not drifting over the code panel.
8. **Anki (optional):** `storeMediaFile` the GIF, then `updateNoteFields` to append
   `<img src="out.gif" style="width:100%; max-width:480px; border-radius:8px">`
   to the card back.

## CONFIG (template — edit these)

```js
const CONFIG = {
  title: "Short title",
  subtitle: "one-line framing of the problem",
  values: [7, 1, 5, 3, 6, 4],      // data shown as bars; scale auto-computed
  dayLabels: ["day 0", "day 1", ...], // labels under bars, optional
  code: [                          // the traced function, one string per line
    "def maxProfit(prices):",
    "    local_min = prices[0]",
    "...",
  ],
  vars: ["i", "local_min", "local_max", "max_profit"], // variable boxes to show
  chartLabel: "prices = [...]",
};
```

## STEPS (template — the whole animation)

One entry per visible change. `at` = seconds (timeline length = last `at` + 2;
set the root `data-duration` to that).

```js
const STEPS = [
  { at: 3.0, line: 0, explain: "<b>1</b> define maxProfit(prices)",
    cursor: 0, bars: { 0: "#60a5fa" }, vars: { i: 0 },
    badges: {}, fade: [], done: [], dim: [] },
  { at: 4.5, line: 1, vars: { local_min: 7 } },
  // ...
];
```

| key       | meaning                                                                 |
| --------- | ----------------------------------------------------------------------- |
| `at`      | timestamp in seconds                                                    |
| `line`    | 0-based index into `CONFIG.code`; highlight bar moves here              |
| `explain` | HTML for the commentary line under the chart                            |
| `cursor`  | bar index the pointer jumps to (optional)                               |
| `bars`    | `{ barIndex: cssColor }` recolors those bars                            |
| `vars`    | `{ varName: value }` updates the watch panel                            |
| `badges`  | `{ badgeId: true }` shows a badge. **Badge ids are `<kind><barIndex>`** — the digit is the BAR index the badge sits over (e.g. `buy1` = BUY over bar 1, `sell2` = SELL over bar 2), *not* a trade counter. Two badges over the same bar collide. |
| `fade`    | ids of price labels to fade out (when a badge replaces a label)         |
| `done`    | bar indices to dim (processing finished)                                |

**Every badge must replace a label at the same position, and that label's id must
go in that step's `fade`** — otherwise `check` reports `content_overlap`.

## Visual vocabulary (reuse, don't reinvent)

- **Bars** = array values. Color semantics: default `#334155`, scanning `#60a5fa`,
  buy/valley/success `#22c55e` (badge `BUY`, class `badge buy`), rising/probing
  `#f59e0b`, sell/peak/found `#ef4444` (badge `SELL`), done `#475569` at 0.35 opacity.
- **Two pointers / sliding window**: render extra vertical cursors (`#cursor`-style
  divs, each with an explicit `left`) and move them with `x` tweens; label them
  `L`/`R`/`slow`/`fast`.
- **Recursion / stack**: add a stack panel on the left (below the code) showing
  frames; pop/push via `tl.call` updating its innerHTML.
- **Swap / compare highlights**: just recolor the two bars and show a `compare`
  status in `explain` — no extra mechanics needed.
- **Counter/profit totals**: add a `varBox` and update it in `vars` like any other
  variable.

## Rules (learned the hard way — all break silently)

1. **Every absolutely-positioned cursor/pointer needs an explicit `left` in CSS.**
   Without it the element anchors at the static left edge and its `x` tween drifts
   it across the code panel (a "ghost white line") instead of over the data.
   Bars also need explicit `left` + `height` set inline.
2. **Fonts:** only `Inter` and `JetBrains Mono` (auto-resolved by the renderer).
   Never reference system fonts (`SFMono-Regular`, etc.) — lint fails with
   `font_family_without_font_face`.
3. **Contrast:** code/body text `#e2e8f0`, line numbers `#a8b3c4`, comments/panel
   labels `#94a3b8` on `#0f172a` panels pass WCAG. Dimmer grays (`#64748b`) fail.
4. **Badge/label overlap:** a badge shown where a price label already sits must
   fade that label out (`fade: ["pl1"]`) or `check` fails.
5. **Determinism:** one paused GSAP timeline registered on
   `window.__timelines["main"]`; never `Date.now`/`Math.random`/`repeat:-1`; update
   text via `tl.call`. Bars grow with `scaleY` from `transform-origin: bottom`.
6. **Clip:** the scene needs `class="clip"`, `data-start="0"`, `data-duration`,
   `data-track-index`; root needs `data-composition-id`, `data-start="0"`,
   `data-width`, `data-height`, `data-duration` ≥ timeline end.
7. **GIF:** render MP4 → ffmpeg convert. HyperFrames `--format gif` output carries
   an alpha channel and the background renders transparent in Anki.

## Template location

`<skill base>/template.html` — copy into the project's `index.html` and edit the
`CONFIG` and `STEPS` blocks. The `references/` folder holds worked examples
(`examples/buy-sell.html` from this skill's own validation, plus patterns).

### Adapting to a different algorithm (two-pointer example)

The template's builder handles: multiple bar states, badges, cursors over any bar,
variable boxes, and line highlighting. To express a *two-pointer* algorithm (e.g.
container with most water) you don't need new machinery — reuse the cursor + badge
system:

1. `CONFIG.values` = the array being scanned; `CONFIG.code` = the two-pointer
   function.
2. In `STEPS`, use `cursor` to park the active pointer on its bar and `bars` to
   recolor it; add a second cursor by giving a later step a different `cursor`
   index (the builder auto-creates one per distinct index and only one shows at a
   time).
3. Track `l`, `r`, `best` in `vars`; describe each comparison in `explain`.

For anything the template doesn't express directly (recursion stack, matrix cells,
linked-list nodes), add a small panel and update it via `tl.call` — keep the layout
contract (sized boxes, explicit `left`, `class="clip"` scene) and the determinism
rules and it will pass `check`.

## References

- HyperFrames composition contract: read `/hyperframes-core` (data-attributes,
  determinism-rules) and `/hyperframes-cli` (init/check/render) before editing the
  template — the template already obeys them.
- Anki card handling: `/anki-cards` for `storeMediaFile`/`updateNoteFields`.
