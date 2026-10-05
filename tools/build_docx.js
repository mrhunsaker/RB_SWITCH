#!/usr/bin/env node
/*
 * Build the printable Word guides from the Markdown in docs/.
 *
 *   node tools/build_docx.js              build every guide
 *   node tools/build_docx.js setup        only the paraprofessional setup guide
 *   node tools/build_docx.js evaluation   only the switch evaluation package
 *
 * Needs Node.js and the "docx" package:  npm install docx
 *
 * Supported Markdown: front matter, # / ## / ### / #### headings, paragraphs,
 * bullet and numbered lists, tables, > callouts (with optional bullet lists),
 * fenced code, **bold**, *italic*, `code`, and [links] (printed as plain text).
 * Lines made only of underscores become handwriting lines.
 *
 * Directives (HTML comments, invisible on the website):
 *   <!-- web-only --> ... <!-- /web-only -->   left out of the Word file
 *   <!-- pagebreak -->                         start a new page
 *   <!-- landscape -->  /  <!-- portrait -->   start a new page in that orientation
 *
 * A callout whose first bold word is Note, Important, Tip, Warning or Caution is
 * colored to match.
 */
const fs = require("fs");
const path = require("path");
const {
  Document, Packer, Paragraph, TextRun, Table, TableRow, TableCell, WidthType,
  ShadingType, BorderStyle, AlignmentType, HeadingLevel, LevelFormat, Footer,
  Header, PageNumber, TabStopType, PageOrientation, PageBreak, HeightRule,
} = require("docx");

const ROOT = path.resolve(__dirname, "..");
const SITE = "https://mrhunsaker.github.io/RB_SWITCH/";
const FONT = "Arial";

const GUIDES = {
  setup: {
    src: "docs/setup.md",
    out: "RB_Switch_Paraprofessional_Setup_Guide.docx",
    title: "RB Switch Quick Setup & Classroom Use Guide",
    description: "Generated from docs/setup.md by tools/build_docx.js",
    preTitle: "RB Switch",
    subtitle: "For paraprofessionals and K\u201312 staff",
    header: "RB Switch \u2013 Quick Setup & Classroom Use Guide",
    footer: "Generated from docs/setup.md",
    endNote: "Online instructions: " + SITE,
    margin: 1080,
  },
  evaluation: {
    src: "docs/evaluation-package.md",
    out: "RB_Switch_Evaluation_Package.docx",
    title: "Adaptive Switch Assistive Technology Evaluation Package",
    description: "Generated from docs/evaluation-package.md by tools/build_docx.js",
    header: "Adaptive Switch Assistive Technology Evaluation Package",
    footer: "Adaptive Switch AT Evaluation Package",
    margin: 900,
  },
};

const BORDER = { style: BorderStyle.SINGLE, size: 4, color: "999999" };
const BORDERS = { top: BORDER, bottom: BORDER, left: BORDER, right: BORDER };
const CALLOUTS = {
  note: { bar: "2E75B6", fill: "EAF1FB" },
  important: { bar: "C0504D", fill: "FDF2E9" },
  tip: { bar: "4E9A51", fill: "EEF7EE" },
  warning: { bar: "BF8F00", fill: "FFF8E1" },
  caution: { bar: "BF8F00", fill: "FFF8E1" },
  default: { bar: "C0504D", fill: "FDF2E9" },
};

function build(name) {
  const cfg = GUIDES[name];
  const PW = 12240, PH = 15840, M = cfg.margin;
  let contentW = PW - 2 * M;
  const numberingRefs = [];

  // ---------- inline markdown -> runs ----------
  function inline(text, base = {}) {
    text = text.replace(/\{\{[^}]*\}\}/g, "").replace(/\[([^\]]+)\]\([^)]*\)/g, "$1");
    const runs = [];
    const re = /(\*\*[^*]+\*\*|\*[^*\s][^*]*\*|`[^`]+`)/g;
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

  // ---------- tables ----------
  function makeTable(rows) {
    const header = rows[0], body = rows.slice(1), n = header.length;
    const size = n >= 13 ? 14 : n >= 9 ? 17 : n >= 7 ? 18 : 20;
    const charW = size * 5.4;                     // rough dxa per character
    const longestWord = c => Math.min(20, Math.max(...[header[c], ...body.map(r => r[c] || "")]
      .map(t => { const x = t.replace(/[*`]/g, ""); return x.length <= 12 ? x.length : x.split(/\s+/).reduce((a, w) => Math.max(a, w.length), 0); })));
    const minW = header.map((_, c) => Math.ceil((longestWord(c) + 1) * charW * (c === 0 || true ? 1.05 : 1)) + 190);
    const weights = header.map((h, c) => {
      if (/^(entry|response)$/i.test(h) && body.every(r => !(r[c] || "").trim())) return 34;
      let w = Math.max(h.length, ...body.map(r => Math.min((r[c] || "").length, 40)), 6);
      if (/notes|observation/i.test(h)) w = Math.max(w, 22);
      return n >= 13 ? Math.max(4, Math.min(w, 8)) : Math.min(w, 46);
    });
    const total = weights.reduce((a, b) => a + b, 0);
    let widths = weights.map(w => Math.floor(contentW * w / total));
    // enforce minimum widths, taking the shortfall from the widest columns
    for (let pass = 0; pass < 6; pass++) {
      let short = 0, flexIdx = [];
      widths.forEach((w, c) => { if (w < minW[c]) { short += minW[c] - w; widths[c] = minW[c]; } else flexIdx.push(c); });
      if (!short) break;
      const flexTotal = flexIdx.reduce((a, c) => a + Math.max(widths[c] - minW[c], 0), 0) || 1;
      flexIdx.forEach(c => { widths[c] -= Math.floor(short * Math.max(widths[c] - minW[c], 0) / flexTotal); });
    }
    widths[n - 1] += contentW - widths.reduce((a, b) => a + b, 0);
    const cell = (txt, w, head, rowHeightish) => new TableCell({
      width: { size: w, type: WidthType.DXA },
      borders: BORDERS,
      shading: head ? { fill: "DCE6F1", type: ShadingType.CLEAR, color: "auto" } : undefined,
      margins: { top: 50, bottom: 50, left: n >= 13 ? 40 : 90, right: n >= 13 ? 40 : 90 },
      children: [new Paragraph({ spacing: { after: 0 }, alignment: n >= 13 && !head ? AlignmentType.CENTER : AlignmentType.LEFT,
        children: inline(txt, { size, bold: head ? true : undefined }) })],
    });
    const blankish = r => r.some(c => !(c || "").trim());
    const fillIn = body.filter(blankish).length >= Math.ceil(body.length / 2);
    return new Table({
      width: { size: contentW, type: WidthType.DXA },
      columnWidths: widths,
      rows: [
        new TableRow({ tableHeader: true, cantSplit: true, children: header.map((h, c) => cell(h, widths[c], true)) }),
        ...body.map(r => new TableRow({
          cantSplit: true,
          height: fillIn ? { value: n >= 13 ? 440 : body.length > 14 ? 360 : body.length >= 10 ? 400 : 440, rule: HeightRule.ATLEAST } : undefined,
          children: header.map((_, c) => cell(r[c] || "", widths[c], false)),
        })),
      ],
    });
  }

  // ---------- callouts ----------
  function callout(lines) {
    const first = lines.find(l => l.trim()) || "";
    const lab = (first.match(/^\*\*(Note|Important|Tip|Warning|Caution)\b/i) || [])[1];
    const style = CALLOUTS[(lab || "default").toLowerCase()];
    const paras = [];
    for (const t of lines) {
      if (!t.trim()) continue;
      if (/^- /.test(t)) paras.push(new Paragraph({ numbering: { reference: "bullets", level: 0 }, spacing: { after: 40 }, children: inline(t.slice(2), { size: 21 }) }));
      else paras.push(new Paragraph({ spacing: { after: 60 }, children: inline(t, { size: 21 }) }));
    }
    return new Table({
      width: { size: contentW, type: WidthType.DXA },
      columnWidths: [contentW],
      rows: [new TableRow({ cantSplit: true, children: [new TableCell({
        width: { size: contentW, type: WidthType.DXA },
        borders: { top: BORDER, bottom: BORDER, right: BORDER, left: { style: BorderStyle.SINGLE, size: 24, color: style.bar } },
        shading: { fill: style.fill, type: ShadingType.CLEAR, color: "auto" },
        margins: { top: 100, bottom: 80, left: 160, right: 140 },
        children: paras,
      })] })],
    });
  }

  // ---------- parse ----------
  let src = fs.readFileSync(path.join(ROOT, cfg.src), "utf8").replace(/\r\n/g, "\n");
  src = src.replace(/^---\n[\s\S]*?\n---\n/, "");
  src = src.replace(/<!-- web-only -->[\s\S]*?<!-- \/web-only -->\n?/g, "");
  const lines = src.split("\n");

  // sections (orientation changes start a new Word section)
  const sections = [];
  let cur = { landscape: false, children: [] };
  let lastWasBreak = false;
  const push = el => { cur.children.push(el); lastWasBreak = false; };
  const spacer = (after = 120) => push(new Paragraph({ spacing: { after }, children: [] }));
  const pageBreak = () => {
    if (lastWasBreak || cur.children.length === 0) return;
    cur.children.push(new Paragraph({ children: [new PageBreak()] })); lastWasBreak = true;
  };
  const setOrientation = landscape => {
    if (cur.landscape === landscape) { pageBreak(); return; }
    if (lastWasBreak) cur.children.pop();
    sections.push(cur);
    cur = { landscape, children: [] };
    contentW = (landscape ? PH : PW) - 2 * M;
    lastWasBreak = true;
  };

  if (cfg.preTitle) push(new Paragraph({ spacing: { after: 60 }, children: [new TextRun({ text: cfg.preTitle, bold: true, size: 56, font: FONT, color: "1F3864" })] }));

  let i = 0;
  while (i < lines.length) {
    const ln = lines[i];
    if (!ln.trim()) { i++; continue; }
    let m;
    if (/^<!--\s*pagebreak\s*-->/.test(ln)) { pageBreak(); i++; continue; }
    if (/^<!--\s*landscape\s*-->/.test(ln)) { setOrientation(true); i++; continue; }
    if (/^<!--\s*portrait\s*-->/.test(ln)) { setOrientation(false); i++; continue; }
    if (/^<!--/.test(ln)) { i++; continue; }
    if ((m = ln.match(/^# (.*)$/))) {
      if (cfg.preTitle) {
        push(new Paragraph({ spacing: { after: 40 }, children: [new TextRun({ text: m[1], size: 32, font: FONT, color: "404040" })] }));
        push(new Paragraph({ spacing: { after: 200 }, children: [new TextRun({ text: cfg.subtitle, italics: true, size: 22, font: FONT, color: "595959" })] }));
      } else {
        push(new Paragraph({ spacing: { after: 80 }, children: [new TextRun({ text: m[1], bold: true, size: 44, font: FONT, color: "1F3864" })] }));
      }
      i++; continue;
    }
    if ((m = ln.match(/^## (.*)$/))) { push(new Paragraph({ heading: HeadingLevel.HEADING_1, keepNext: true, children: [new TextRun({ text: m[1], font: FONT })] })); i++; continue; }
    if ((m = ln.match(/^### (.*)$/))) { push(new Paragraph({ heading: HeadingLevel.HEADING_2, keepNext: true, children: [new TextRun({ text: m[1], font: FONT })] })); i++; continue; }
    if ((m = ln.match(/^#### (.*)$/))) { push(new Paragraph({ heading: HeadingLevel.HEADING_3, keepNext: true, children: [new TextRun({ text: m[1], font: FONT })] })); i++; continue; }
    if (/^---+\s*$/.test(ln)) {
      push(new Paragraph({ spacing: { before: 120, after: 120 }, border: { bottom: { style: BorderStyle.SINGLE, size: 6, color: "999999", space: 1 } }, children: [] }));
      i++; continue;
    }
    if (ln.startsWith("```")) {
      const code = []; i++;
      while (i < lines.length && !lines[i].startsWith("```")) { code.push(lines[i]); i++; }
      i++;
      code.forEach(c => push(new Paragraph({ spacing: { after: 0 }, children: [new TextRun({ text: c, font: "Courier New", size: 20 })] })));
      spacer(120); continue;
    }
    if (ln.startsWith(">")) {
      const block = [];
      while (i < lines.length && lines[i].startsWith(">")) { block.push(lines[i].replace(/^>\s?/, "")); i++; }
      push(callout(block)); spacer(120); continue;
    }
    if (ln.startsWith("|")) {
      const rows = [];
      while (i < lines.length && lines[i].startsWith("|")) {
        const cells = lines[i].replace(/^\||\|\s*$/g, "").split("|").map(s => s.trim());
        if (!cells.every(c => /^:?-{2,}:?$/.test(c))) rows.push(cells);
        i++;
      }
      push(makeTable(rows)); spacer(120); continue;
    }
    if (/^- /.test(ln)) {
      while (i < lines.length && /^- /.test(lines[i])) {
        push(new Paragraph({ numbering: { reference: "bullets", level: 0 }, spacing: { after: 60 }, children: inline(lines[i].slice(2), { size: 22 }) }));
        i++;
      }
      spacer(60); continue;
    }
    if (/^\d+\. /.test(ln)) {
      const ref = "num" + numberingRefs.length; numberingRefs.push(ref);
      while (i < lines.length && /^\d+\. /.test(lines[i])) {
        push(new Paragraph({ numbering: { reference: ref, level: 0 }, spacing: { after: 60 }, children: inline(lines[i].replace(/^\d+\. /, ""), { size: 22 }) }));
        i++;
      }
      spacer(60); continue;
    }
    if (/^_{8,}\s*$/.test(ln)) {   // handwriting line
      push(new Paragraph({ spacing: { before: 200, after: 0 }, border: { bottom: { style: BorderStyle.SINGLE, size: 6, color: "808080", space: 1 } }, children: [] }));
      i++; continue;
    }
    const para = [ln]; i++;
    while (i < lines.length && lines[i].trim() && !/^(#|\||>|- |\d+\. |```|<!--|---)/.test(lines[i])) { para.push(lines[i]); i++; }
    push(new Paragraph({ spacing: { after: 120 }, children: inline(para.join(" "), { size: 22 }) }));
  }
  if (cfg.endNote) push(new Paragraph({ spacing: { before: 240 }, children: [new TextRun({ text: cfg.endNote, size: 20, font: FONT, color: "595959" })] }));
  sections.push(cur);

  // ---------- document ----------
  const numbering = {
    config: [
      { reference: "bullets", levels: [{ level: 0, format: LevelFormat.BULLET, text: "\u2022", alignment: AlignmentType.LEFT, style: { paragraph: { indent: { left: 540, hanging: 270 } } } }] },
      ...numberingRefs.map(ref => ({ reference: ref, levels: [{ level: 0, format: LevelFormat.DECIMAL, text: "%1.", alignment: AlignmentType.LEFT, style: { paragraph: { indent: { left: 540, hanging: 360 } } } }] })),
    ],
  };
  const mkSection = s => {
    const w = (s.landscape ? PH : PW) - 2 * M;
    return {
      properties: { page: {
        size: { width: PW, height: PH, orientation: s.landscape ? PageOrientation.LANDSCAPE : PageOrientation.PORTRAIT },
        margin: { top: M, bottom: M, left: M, right: M },
      } },
      headers: { default: new Header({ children: [new Paragraph({ alignment: AlignmentType.RIGHT, children: [new TextRun({ text: cfg.header, size: 18, color: "7F7F7F", font: FONT })] })] }) },
      footers: { default: new Footer({ children: [new Paragraph({
        tabStops: [{ type: TabStopType.RIGHT, position: w }],
        children: [
          new TextRun({ text: cfg.footer, size: 16, color: "7F7F7F", font: FONT }),
          new TextRun({ text: "\tPage ", size: 18, color: "7F7F7F", font: FONT }),
          new TextRun({ children: [PageNumber.CURRENT], size: 18, color: "7F7F7F", font: FONT }),
          new TextRun({ text: " of ", size: 18, color: "7F7F7F", font: FONT }),
          new TextRun({ children: [PageNumber.TOTAL_PAGES], size: 18, color: "7F7F7F", font: FONT }),
        ] })] }) },
      children: s.children,
    };
  };
  const doc = new Document({
    creator: "RB Switch project", title: cfg.title, description: cfg.description,
    styles: {
      default: { document: { run: { font: FONT, size: 22 } } },
      paragraphStyles: [
        { id: "Heading1", name: "Heading 1", basedOn: "Normal", next: "Normal", quickFormat: true, run: { size: 28, bold: true, font: FONT, color: "1F3864" }, paragraph: { spacing: { before: 280, after: 120 }, outlineLevel: 0 } },
        { id: "Heading2", name: "Heading 2", basedOn: "Normal", next: "Normal", quickFormat: true, run: { size: 24, bold: true, font: FONT, color: "2E5496" }, paragraph: { spacing: { before: 200, after: 80 }, outlineLevel: 1 } },
        { id: "Heading3", name: "Heading 3", basedOn: "Normal", next: "Normal", quickFormat: true, run: { size: 22, bold: true, font: FONT, color: "404040" }, paragraph: { spacing: { before: 160, after: 60 }, outlineLevel: 2 } },
      ],
    },
    numbering,
    sections: sections.map(mkSection),
  });
  const out = path.join(ROOT, cfg.out);
  return Packer.toBuffer(doc).then(buf => { fs.writeFileSync(out, buf); console.log("wrote " + path.relative(process.cwd(), out)); });
}

const want = process.argv[2];
const names = want ? [want] : Object.keys(GUIDES);
for (const n of names) if (!GUIDES[n]) { console.error("unknown guide: " + n + " (use: " + Object.keys(GUIDES).join(", ") + ")"); process.exit(1); }
(async () => { for (const n of names) await build(n); })();
