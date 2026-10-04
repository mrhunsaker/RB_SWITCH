# Documentation tools

Two small scripts keep the documentation copies in sync. Run them from the repository root after editing anything in `docs/`.

| Script | What it does |
|---|---|
| `python3 tools/sync_documents.py` | Rewrites `documents/` from `docs/` (drops the Jekyll `permalink:` line and turns `{{ '/page.html' \| relative_url }}` links into `page.md`). Add `--check` to see whether `documents/` is stale without writing anything. |
| `node tools/build_setup_docx.js` | Rebuilds `RB_Switch_Paraprofessional_Setup_Guide.docx` from `docs/setup.md`. Needs Node.js and the `docx` package (`npm install docx`). |

`docs/setup.md` is the single source for the printable guide. Text between `<!-- web-only -->` and `<!-- /web-only -->` appears on the website but not in the printed guide.

After rebuilding the Word file, open it and check the page breaks before printing.
