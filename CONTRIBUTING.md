# Contributing to RB Switch

Thanks for your interest in improving RB Switch. This project spans firmware, PCB/mechanical design, and documentation used directly by classroom staff, so contributions in any of those areas are welcome — code is not a prerequisite.

By participating, you agree to follow the [Code of Conduct](CODE_OF_CONDUCT.md). Please review [SECURITY.md](SECURITY.md) before reporting anything that could affect device or data safety rather than opening a public issue.

## Ways to contribute

- **Documentation** — corrections, clarifications, or new platform-specific guidance in `docs/` and `documents/`.
- **Firmware** — changes to `firmware/RB_SWITCH_firmware/RB_SWITCH_firmware.ino`.
- **Hardware** — schematic, PCB, or enclosure changes in `electrical/`, `bom/`, and `mechanical/`.
- **Issue triage and testing** — trying documented steps on a real device (especially a specific Android OEM skin or iOS/iPadOS version) and reporting where the menu wording or behavior has drifted from what's documented.

## Before you start

1. Search open and closed issues and pull requests for related work.
2. For anything larger than a small fix (a new documentation page, a firmware behavior change, a hardware revision), open an issue first to confirm the approach before investing time in the change.
3. Confirm which part of the project you're touching is actually **production**. The archived scaffold under `firmware/BLE_ADAPTIVE_SWITCH_EXPANDED_SCAFFOLD/` is retained for historical reference only — it is not the current firmware, and changes to it will not be accepted as functional updates to the RB Switch. See that directory's `README.md` and the repository root `README.md` for the current production scope.

## Project structure

| Path | Contents |
|---|---|
| `firmware/RB_SWITCH_firmware/` | Production Arduino sketch |
| `firmware/BLE_ADAPTIVE_SWITCH_EXPANDED_SCAFFOLD/` | Archived, non-production firmware — historical reference only |
| `electrical/` | KiCad schematic, PCB, and gerbers |
| `mechanical/` | OpenSCAD enclosure source |
| `bom/` | Bill of materials |
| `docs/` | GitHub Pages documentation source (Jekyll, built by `.github/workflows/static.yml`) |
| `documents/` | Packaging-friendly copy of the same documentation, for inclusion in offline exports or printed packets |
| `RB_Switch_Paraprofessional_Setup_Guide.docx` | Printable classroom quick-reference, generated from `docs/setup.md` by `tools/build_docx.js` |
| `RB_Switch_Evaluation_Package.docx` | Printable switch evaluation package, generated from `docs/evaluation-package.md` by `tools/build_docx.js` |
| `tools/` | Scripts that keep `documents/` and the printable guide in sync with `docs/` |

**`docs/` and `documents/` must stay synchronized.** If you change one, make the equivalent change in the other (run `python3 tools/sync_documents.py` to do this automatically). The only intended differences are:

- `docs/*.md` includes Jekyll front matter (`permalink: ...`) and uses `{{ '/page.html' | relative_url }}` links, because it is built and published by GitHub Pages.
- `documents/*.md` omits the `permalink` line and uses plain `page.md` relative links, because it is meant to be read directly (for example, packaged into an offline handout) without a Jekyll build step.

If a documentation change affects what's in `RB_Switch_Paraprofessional_Setup_Guide.docx` (setup steps, button mapping, troubleshooting), rebuild the `.docx` with `node tools/build_docx.js` (needs Node.js and `npm install docx`), or note in your pull request that it still needs to be updated. The same applies to `docs/evaluation-package.md` and `RB_Switch_Evaluation_Package.docx`.

## Making a firmware change

1. Read [`docs/firmware-customization.md`](docs/firmware-customization.md) first — it documents which parts of the sketch are safe to change and which require care.
2. Change one thing at a time and re-verify/re-upload/re-test between changes.
3. Test with the Serial Monitor at 115200 baud, then test on at least one real host device (a plain text field is enough for a basic check; see `docs/setup.md`).
4. If the change affects the documented button mapping, debounce timing, or device name, update every file listed under "Keeping documentation in sync" in `docs/firmware-customization.md`.
5. Follow [`CODE_STYLE.md`](CODE_STYLE.md) for naming and formatting.

## Making a hardware change

1. Open an issue describing the change and its motivation before starting schematic or PCB work — hardware revisions are expensive to redo.
2. Keep the BOM (`bom/BT_Switch_Mechanical_BOM.xlsx`), schematic, and PCB consistent with each other and with `docs/hardware.md`.
3. Note the revision (for example, RevD3) in your pull request description, and update any documentation that references the current revision.

## Making a documentation change

1. Match the existing structure: numbered setup steps, tables for pin/key mappings, and short troubleshooting entries phrased as a symptom followed by steps.
2. Update both `docs/` and `documents/` (see above).
3. If you're adding a new page, add it to the navigation list in `docs/index.md` **and** `documents/index.md`, and add a corresponding permalink front-matter entry if it's a Jekyll (`docs/`) page.
4. Prefer verifying a claimed OS behavior (menu wording, feature availability, wizard steps) against current, dated sources rather than memory — accessibility settings menus change between OS releases.

## Submitting a pull request

1. Fork the repository and create a branch from `main`.
2. Make your change, following the guidance above for the relevant area(s).
3. Fill out the pull request template completely, including which platforms/devices you tested against, if applicable.
4. Add an entry to [`CHANGES.md`](CHANGES.md) under **Unreleased**.
5. Expect review focused on: does this match the production hardware/firmware scope, is the documentation synchronized, and has it been tested on a real device rather than only in simulation or by inspection.

## Commit messages

Use a short, imperative summary line (for example, `Fix Android Switch Access wizard step order`), with additional detail in the body if needed. Reference the related issue number if one exists.

## Questions

If you're unsure whether something is in scope, open an issue and ask before submitting a large change.
