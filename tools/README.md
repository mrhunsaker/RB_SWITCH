# Documentation tools

Two small scripts keep the documentation copies in sync. Run them from the repository root after editing anything in `docs/`.

| Script | What it does |
|---|---|
| `python3 tools/sync_documents.py` | Rewrites `documents/` from `docs/` (drops the Jekyll `permalink:` line and turns `{{ '/page.html' \| relative_url }}` links into `page.md`). Add `--check` to see whether `documents/` is stale without writing anything. |
| `node tools/build_docx.js [setup\|evaluation]` | Rebuilds the printable Word documents from `docs/`. With no argument it builds both. Needs Node.js and the `docx` package (`npm install docx`). |

## Word documents

| Output | Source |
|---|---|
| `RB_Switch_Paraprofessional_Setup_Guide.docx` | `docs/setup.md` |
| `RB_Switch_Evaluation_Package.docx` | `docs/evaluation-package.md` |

The Markdown page is the single source for each Word file. Do not edit the `.docx` by hand; your changes would be lost the next time it is rebuilt.

Comments in the Markdown control the Word output. They are invisible on the website and on GitHub.

| Comment | Effect in the Word file |
|---|---|
| `<!-- web-only -->` ... `<!-- /web-only -->` | Text between the markers is left out |
| `<!-- pagebreak -->` | Starts a new page |
| `<!-- landscape -->` / `<!-- portrait -->` | Starts a new page in that orientation (the evaluation package uses landscape for its data sheets) |

Other behavior: a blockquote that starts with **Note**, **Important**, **Tip** or **Warning** becomes a colored callout. A line made only of underscores becomes a handwriting line. Table rows that are mostly empty get extra height so they can be filled in by hand.

After rebuilding a Word file, open it and check the page breaks before printing.
