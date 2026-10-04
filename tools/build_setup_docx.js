#!/usr/bin/env node
/*
 * Build RB_Switch_Paraprofessional_Setup_Guide.docx from docs/setup.md.
 *
 * Usage (from the repository root):  node tools/build_setup_docx.js
 * Needs Node.js and the "docx" package:  npm install docx
 *
 * Supported Markdown: front matter, # / ## / ### headings, paragraphs, bullet
 * and numbered lists, tables, > callouts, **bold**, *italic*, `code`, and
 * [links] (rendered as plain text). Text between <!-- web-only --> and
 * <!-- /web-only --> is left out of the printed guide.
 */
const fs = require("fs");
const path = require("path");
const {
  Document, Packer, Paragraph, TextRun, Table, TableRow, TableCell, WidthType,
  ShadingType, BorderStyle, AlignmentType, HeadingLevel, LevelFormat, Footer,
  Header, PageNumber, TabStopType,
} = require("docx");

const ROOT = path.resolve(__dirname, "..");
const SRC = path.join(ROOT, "docs", "setup.md");
const OUT = path.join(ROOT, "RB_Switch_Paraprofessional_Setup_Guide.docx");
const SITE = "https://mrhunsaker.github.io/RB_SWITCH/";
const FONT = "Arial";
const PAGE_W = 12240, MARGIN = 1080, CONTENT_W = PAGE_W - 2 * MARGIN; // US Letter, 0.75in margins

// ---------- inline markdown -> runs ----------
function inline(text, base = {}) {
  text = text
    .replace(/\{\{[^}]*\}\}/g, "")
    .replace(/\[([^\]]+)\]\([^)]*\)/g, "$1");
  const runs = [];
  const re = /(\*\*[^*]+\*\*|\*[^*]+\*|`[^`]+`)/g;
  let last = 0, m;
  while ((m = re.exec(text)) !== null) {
    if (m.index > last) runs.push(new TextRun({ text: text.slice(last, m.index), font: FONT, ...base }));
    const tok = m[0];
    if (tok.startsWith("**")) runs.push(new TextRun({ text: tok.slice(2, -2), bold: true, font: FONT, ...base }));
    else if (tok.startsWith("`")) runs.push(new TextRun({ text: tok.slice(1, -1), font: "Courier New", ...base }));
    else runs.push(new TextRun({ text: tok.slice(1, -1), italics: true, font: FONT, ...base }));
    last = m.index + tok.length;
  }
  if (last < text.length) runs.push(new TextRun({ text: text.slice(last), font: FONT, ...base }));
  return runs.length ? runs : [new TextRun({ text: "", font: FONT })];
}

// ---------- parse ----------
let src = fs.readFileSync(SRC, "utf8").replace(/\r\n/g, "\n");
src = src.replace(/^---\n[\s\S]*?\n---\n/, "");
src = src.replace(/<!-- web-only -->[\s\S]*?<!-- \/web-only -->\n?/g, "");
const lines = src.split("\n");

const numberingRefs = [];
function newNumbering() {
  const ref = "num" + numberingRefs.length;
  numberingRefs.push(ref);
  return ref;
}

const BORDER = { style: BorderStyle.SINGLE, size: 4, color: "999999" };
const BORDERS = { top: BORDER, bottom: BORDER, left: BORDER, right: BORDER };

function makeTable(rows) {
  const header = rows[0], body = rows.slice(1);
  const n = header.length;
  const weights = header.map((_, c) => Math.max(8, ...rows.map(r => (r[c] || "").length)));
  const capped = weights.map(w => Math.min(w, 46));
  const total = capped.reduce((a, b) => a + b, 0);
  let widths = capped.map(w => Math.floor(CONTENT_W * w / total));
  widths[n - 1] += CONTENT_W - widths.reduce((a, b) => a + b, 0);
  const cell = (txt, w, head) => new TableCell({
    width: { size: w, type: WidthType.DXA },
    borders: BORDERS,
    shading: head ? { fill: "DCE6F1", type: ShadingType.CLEAR, color: "auto" } : undefined,
    margins: { top: 60, bottom: 60, left: 100, right: 100 },
    children: [new Paragraph({ spacing: { after: 0 }, children: inline(txt, { size: 20, bold: head ? true : undefined }) })],
  });
  return new Table({
    width: { size: CONTENT_W, type: WidthType.DXA },
    columnWidths: widths,
    rows: [
      new TableRow({ tableHeader: true, cantSplit: true, children: header.map((h, c) => cell(h, widths[c], true)) }),
      ...body.map(r => new TableRow({ cantSplit: true, children: header.map((_, c) => cell(r[c] || "", widths[c], false)) })),
    ],
  });
}

function callout(textLines) {
  const paras = textLines.map((t, i) => new Paragraph({
    spacing: { after: 60 },
    children: inline(t, { size: 21 }),
  }));
  return new Table({
    width: { size: CONTENT_W, type: WidthType.DXA },
    columnWidths: [CONTENT_W],
    rows: [new TableRow({ cantSplit: true, children: [new TableCell({
      width: { size: CONTENT_W, type: WidthType.DXA },
      borders: { top: BORDER, bottom: BORDER, right: BORDER, left: { style: BorderStyle.SINGLE, size: 24, color: "C0504D" } },
      shading: { fill: "FDF2E9", type: ShadingType.CLEAR, color: "auto" },
      margins: { top: 100, bottom: 80, left: 160, right: 140 },
      children: paras,
    })] })],
  });
}

const children = [];
// title block
children.push(new Paragraph({ alignment: AlignmentType.LEFT, spacing: { after: 60 }, children: [new TextRun({ text: "RB Switch", bold: true, size: 56, font: FONT, color: "1F3864" })] }));
let titleDone = false;

let i = 0;
while (i < lines.length) {
  const ln = lines[i];
  if (!ln.trim()) { i++; continue; }
  let m;
  if ((m = ln.match(/^# (.*)$/))) {
    children.push(new Paragraph({ spacing: { after: 40 }, children: [new TextRun({ text: m[1], size: 32, font: FONT, color: "404040" })] }));
    children.push(new Paragraph({ spacing: { after: 200 }, children: [new TextRun({ text: "For paraprofessionals and K\u201312 staff", italics: true, size: 22, font: FONT, color: "595959" })] }));
    titleDone = true; i++; continue;
  }
  if ((m = ln.match(/^## (.*)$/))) { children.push(new Paragraph({ heading: HeadingLevel.HEADING_1, keepNext: true, children: [new TextRun({ text: m[1], font: FONT })] })); i++; continue; }
  if ((m = ln.match(/^### (.*)$/))) { children.push(new Paragraph({ heading: HeadingLevel.HEADING_2, keepNext: true, children: [new TextRun({ text: m[1], font: FONT })] })); i++; continue; }
  if (ln.startsWith("```")) {
    const code = []; i++;
    while (i < lines.length && !lines[i].startsWith("```")) { code.push(lines[i]); i++; }
    i++;
    code.forEach(c => children.push(new Paragraph({ spacing: { after: 0 }, children: [new TextRun({ text: c, font: "Courier New", size: 20 })] })));
    continue;
  }
  if (ln.startsWith(">")) {
    const block = [];
    while (i < lines.length && lines[i].startsWith(">")) { block.push(lines[i].replace(/^>\s?/, "")); i++; }
    children.push(callout(block));
    children.push(new Paragraph({ spacing: { after: 120 }, children: [] }));
    continue;
  }
  if (ln.startsWith("|")) {
    const rows = [];
    while (i < lines.length && lines[i].startsWith("|")) {
      const cells = lines[i].replace(/^\||\|$/g, "").split("|").map(s => s.trim());
      if (!cells.every(c => /^:?-{2,}:?$/.test(c))) rows.push(cells);
      i++;
    }
    children.push(makeTable(rows));
    children.push(new Paragraph({ spacing: { after: 120 }, children: [] }));
    continue;
  }
  if (/^- /.test(ln)) {
    while (i < lines.length && /^- /.test(lines[i])) {
      children.push(new Paragraph({ numbering: { reference: "bullets", level: 0 }, spacing: { after: 60 }, children: inline(lines[i].slice(2), { size: 22 }) }));
      i++;
    }
    children.push(new Paragraph({ spacing: { after: 60 }, children: [] }));
    continue;
  }
  if (/^\d+\. /.test(ln)) {
    const ref = newNumbering();
    while (i < lines.length && /^\d+\. /.test(lines[i])) {
      children.push(new Paragraph({ numbering: { reference: ref, level: 0 }, spacing: { after: 60 }, children: inline(lines[i].replace(/^\d+\. /, ""), { size: 22 }) }));
      i++;
    }
    children.push(new Paragraph({ spacing: { after: 60 }, children: [] }));
    continue;
  }
  // paragraph (merge consecutive text lines)
  const para = [ln];
  i++;
  while (i < lines.length && lines[i].trim() && !/^(#|\||>|- |\d+\. |```)/.test(lines[i])) { para.push(lines[i]); i++; }
  children.push(new Paragraph({ spacing: { after: 120 }, children: inline(para.join(" "), { size: 22 }) }));
}

children.push(new Paragraph({ spacing: { before: 240 }, children: [new TextRun({ text: "Online instructions: " + SITE, size: 20, font: FONT, color: "595959" })] }));

const numbering = {
  config: [
    { reference: "bullets", levels: [{ level: 0, format: LevelFormat.BULLET, text: "\u2022", alignment: AlignmentType.LEFT, style: { paragraph: { indent: { left: 540, hanging: 270 } } } }] },
    ...numberingRefs.map(ref => ({ reference: ref, levels: [{ level: 0, format: LevelFormat.DECIMAL, text: "%1.", alignment: AlignmentType.LEFT, style: { paragraph: { indent: { left: 540, hanging: 360 } } } }] })),
  ],
};

const doc = new Document({
  creator: "RB Switch project",
  title: "RB Switch Quick Setup & Classroom Use Guide",
  description: "Generated from docs/setup.md by tools/build_setup_docx.js",
  styles: {
    default: { document: { run: { font: FONT, size: 22 } } },
    paragraphStyles: [
      { id: "Heading1", name: "Heading 1", basedOn: "Normal", next: "Normal", quickFormat: true,
        run: { size: 28, bold: true, font: FONT, color: "1F3864" }, paragraph: { spacing: { before: 280, after: 120 }, outlineLevel: 0 } },
      { id: "Heading2", name: "Heading 2", basedOn: "Normal", next: "Normal", quickFormat: true,
        run: { size: 24, bold: true, font: FONT, color: "2E5496" }, paragraph: { spacing: { before: 200, after: 80 }, outlineLevel: 1 } },
    ],
  },
  numbering,
  sections: [{
    properties: { page: { size: { width: PAGE_W, height: 15840 }, margin: { top: MARGIN, bottom: MARGIN, left: MARGIN, right: MARGIN } } },
    headers: { default: new Header({ children: [new Paragraph({ alignment: AlignmentType.RIGHT, children: [new TextRun({ text: "RB Switch \u2013 Quick Setup & Classroom Use Guide", size: 18, color: "7F7F7F", font: FONT })] })] }) },
    footers: { default: new Footer({ children: [new Paragraph({
      tabStops: [{ type: TabStopType.RIGHT, position: CONTENT_W }],
      children: [
        new TextRun({ text: "Generated from docs/setup.md", size: 16, color: "7F7F7F", font: FONT }),
        new TextRun({ text: "\tPage ", size: 18, color: "7F7F7F", font: FONT }),
        new TextRun({ children: [PageNumber.CURRENT], size: 18, color: "7F7F7F", font: FONT }),
        new TextRun({ text: " of ", size: 18, color: "7F7F7F", font: FONT }),
        new TextRun({ children: [PageNumber.TOTAL_PAGES], size: 18, color: "7F7F7F", font: FONT }),
      ] })] }) },
    children,
  }],
});

Packer.toBuffer(doc).then(buf => { fs.writeFileSync(OUT, buf); console.log("wrote " + path.relative(process.cwd(), OUT)); });
