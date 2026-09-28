# Code Style

This document describes the conventions used across RB Switch's firmware, documentation, and hardware source files. It reflects the style already used in the production sketch and published docs — match what's already there rather than introducing a new convention, unless you're proposing a repo-wide change (open an issue first; see `CONTRIBUTING.md`).

## Firmware (`.ino` / C++)

- **Naming:**
  - Constants use `UPPER_SNAKE_CASE` with `static constexpr`, typed explicitly (`uint8_t`, `uint32_t`), for example: `static constexpr uint8_t SW1_PIN = 10;`.
  - Functions and variables use `camelCase` (`updateSwitch`, `sendKey`, `lastChangeMs`).
  - Types (structs, classes) use `PascalCase` (`SwitchState`, `ServerCallbacks`).
- **Comments:**
  - Use a block comment at the top of the file describing purpose, hardware inputs, and what is deliberately *not* included — this project has a history of scope creep from earlier prototypes, and the header comment is where that boundary is stated (see the existing header for the pattern).
  - Use `// -----...-----` banner comments to separate logical sections (pin map, BLE state, debounce state, BLE setup, switch handling, Arduino setup/loop), matching the existing file.
  - Comment *why*, not just *what*, especially for magic numbers (for example, the existing comment explaining `DEBOUNCE_MS` and the HID Usage ID table above the key constants).
- **Formatting:**
  - Two-space indentation.
  - Braces on the same line as the statement (`if (...) {`), matching the existing file.
  - One statement per line; avoid combining multiple side effects into one line even when C++ allows it.
- **Structure:**
  - Keep `loop()` non-blocking. Avoid adding `delay()` calls inside `loop()` beyond the existing 1 ms yield; use the existing millis()-based debounce pattern (`SwitchState.lastChangeMs`) as the template for any new timed behavior.
  - Keep hardware constants (pins, keys, timing) declared together near the top of the file, not scattered through the logic.
  - Prefer extending the existing `SwitchState` pattern for new inputs over introducing a parallel, differently-shaped mechanism.
- **Scope discipline:** do not add functionality outside the three-mechanical-switch production scope (touch sensors, proximity sensors, NeoPixel/RGB control, mono-jack inputs) to the production sketch. Experimental variants belong in a separate, clearly-labeled directory (see how `firmware/BLE_ADAPTIVE_SWITCH_EXPANDED_SCAFFOLD/` is marked archived), not folded into `RB_SWITCH_firmware.ino`.
- See `docs/firmware-customization.md` for guidance on which specific parts of the file are safe to change.

## Documentation (Markdown)

- **Front matter:** every page in `docs/` starts with:
  ```yaml
  ---
  layout: default
  title: <Page Title>
  permalink: /<slug>.html
  ---
  ```
  The matching page in `documents/` omits the `permalink` line (see `CONTRIBUTING.md` for why the two directories differ).
- **Headings:** one `#` H1 matching the page title, then `##` for major sections, `###` for subsections. Don't skip levels.
- **Cross-links:**
  - In `docs/`, link to other pages with `[Label]({{ '/slug.html' | relative_url }})` (add `#anchor` inside the quoted string if linking to a section).
  - In `documents/`, link with plain `[Label](slug.md)`.
- **Tables** for any fixed mapping (pin/key tables, comparison tables, HID Usage ID references) rather than prose lists — this project documents several small fixed mappings, and tables scan faster for the classroom staff and technicians who are this project's primary documentation audience.
- **Numbered steps** for anything the reader performs in order (pairing, wizard steps); **bullet lists** for unordered facts or checklists (battery-safety checklist, "what's not included" lists).
- **Troubleshooting entries** are phrased as a short symptom heading (`## Button repeats unexpectedly`) followed by either numbered diagnostic steps or a bullet checklist — not narrative prose.
- **Bold** is used for UI labels the reader taps or clicks (`**Settings → Accessibility → Switch Access**`), and for the specific button/action being referenced (`**SW1**`, `**Select**`). Avoid bolding entire sentences.
- **Platform accuracy:** when documenting OS-level accessibility menu steps (Switch Access, Switch Control, or similar), verify against a current, dated source rather than memory before publishing — these menus change between OS releases, and stale steps are worse than no steps. Note menu-wording variance explicitly rather than presenting one OEM's wording as universal.
- **Keep `docs/` and `documents/` synchronized.** See `CONTRIBUTING.md`.

## Hardware sources

- **KiCad (`electrical/`):** keep reference designators consistent with the schematic when adding parts (next available number in the existing series, for example `R9` if `R8` is the highest resistor reference). Regenerate gerbers from the same KiCad project version noted in the PR rather than hand-editing Gerber files.
- **OpenSCAD (`mechanical/`):** name revision files with an explicit revision suffix (matching the existing `enclosure_mechanical_RevD2.scad` pattern) rather than overwriting a prior revision in place, so past revisions remain buildable for reference.
- **BOM (`bom/`):** keep reference designators and part values consistent with the schematic; update the BOM in the same pull request as any schematic change that adds, removes, or substitutes a part.

## Commit messages and pull requests

See the "Submitting a pull request" and "Commit messages" sections of `CONTRIBUTING.md`.
