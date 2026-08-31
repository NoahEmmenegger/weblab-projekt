#let hslu-orange = rgb("f26b21")
#let ink = rgb("171717")
#let muted = rgb("626262")
#let paper-grey = rgb("f3f3f1")
#let rule-grey = rgb("d6d6d2")

#let placeholder(body) = block(
  width: 100%,
  inset: 7pt,
  radius: 2pt,
  fill: paper-grey,
  stroke: (left: 2pt + hslu-orange),
  [#text(size: 8.5pt, weight: "bold", fill: hslu-orange)[ZU ERGÄNZEN]\
   #text(size: 9pt, fill: muted)[#body]],
)

#let decision(id, title, status: "Vorgeschlagen", body) = block(
  width: 100%,
  inset: 10pt,
  radius: 2pt,
  stroke: 0.6pt + rule-grey,
  [#grid(
    columns: (1fr, auto),
    gutter: 8pt,
    [#text(weight: "bold")[#id · #title]],
    [#box(inset: (x: 6pt, y: 2pt), fill: hslu-orange, radius: 1pt)[#text(size: 7.5pt, weight: "bold", fill: white)[#status]]],
  )
  #v(5pt)
  #body],
)

#let hslu-document(meta, body) = {
  set document(title: meta.title, author: meta.author)
  set page(
    paper: "a4",
    margin: (top: 23mm, bottom: 21mm, left: 25mm, right: 21mm),
    header: context {
      if counter(page).get().first() > 1 {
        grid(
          columns: (1fr, auto),
          align: (left, right),
          text(size: 7.5pt, weight: "bold", fill: ink)[HSLU · INFORMATIK],
          text(size: 7.5pt, fill: muted)[#meta.module · #meta.status],
        )
        v(4pt)
        line(length: 100%, stroke: 0.5pt + rule-grey)
      }
    },
    footer: context {
      if counter(page).get().first() > 1 {
        line(length: 100%, stroke: 0.5pt + rule-grey)
        v(4pt)
        grid(
          columns: (1fr, auto),
          text(size: 7.5pt, fill: muted)[#meta.title · Version #meta.version],
          text(size: 7.5pt, fill: muted)[Seite #counter(page).display("1")],
        )
      }
    },
  )
  set text(font: "Arial", size: 10pt, fill: ink, lang: "de")
  set par(justify: true, leading: 0.72em)
  set heading(numbering: "1.1")
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    v(4pt)
    text(size: 8pt, weight: "bold", fill: hslu-orange)[ARC42]
    v(3pt)
    text(size: 22pt, weight: "bold", fill: ink)[#it.body]
    v(5pt)
    line(length: 100%, stroke: 1.4pt + hslu-orange)
    v(11pt)
  }
  show heading.where(level: 2): it => {
    v(7pt)
    text(size: 14pt, weight: "bold", fill: ink)[#it.body]
    v(4pt)
  }
  show heading.where(level: 3): it => {
    v(7pt)
    text(size: 11pt, weight: "bold", fill: hslu-orange)[#it.body]
    v(2pt)
  }
  show link: set text(fill: hslu-orange)
  show table.cell: set text(size: 8.5pt)

  // Titelseite
  rect(width: 100%, height: 8pt, fill: hslu-orange)
  v(22mm)
  text(size: 10pt, weight: "bold", fill: muted)[#meta.institution]
  v(8mm)
  text(size: 30pt, weight: "bold", fill: ink)[#meta.title]
  v(3mm)
  text(size: 16pt, fill: muted)[#meta.subtitle]
  v(16mm)
  line(length: 34mm, stroke: 2pt + hslu-orange)
  v(1fr)
  grid(
    columns: (32mm, 1fr),
    row-gutter: 5pt,
    text(size: 8pt, weight: "bold", fill: muted)[AUTOR], [#meta.author],
    text(size: 8pt, weight: "bold", fill: muted)[MODUL], [#meta.module],
    text(size: 8pt, weight: "bold", fill: muted)[SEMESTER], [#meta.semester],
    text(size: 8pt, weight: "bold", fill: muted)[VERSION], [#meta.version · #meta.status],
    text(size: 8pt, weight: "bold", fill: muted)[DATUM], [#meta.date],
  )
  v(14mm)
  grid(
    columns: (auto, 1fr),
    gutter: 8pt,
    box(inset: (x: 8pt, y: 4pt), fill: ink)[#text(size: 9pt, weight: "bold", fill: white)[HSLU]],
    align(horizon)[#text(size: 8pt, fill: muted)[Hochschule Luzern]],
  )
  pagebreak()

  text(size: 22pt, weight: "bold", fill: ink)[Dokumentinformation]
  v(5pt)
  line(length: 100%, stroke: 1.4pt + hslu-orange)
  v(11pt)
  table(
    columns: (38mm, 1fr),
    inset: 7pt,
    stroke: 0.5pt + rule-grey,
    fill: (_, row) => if calc.odd(row) { white } else { paper-grey },
    [*Dokument*], [#meta.subtitle],
    [*Status*], [#meta.status],
    [*Version*], [#meta.version],
    [*Repository*], [#link(meta.repository)[#meta.repository]],
  )
  v(12pt)
  text(size: 14pt, weight: "bold", fill: ink)[Änderungshistorie]
  v(5pt)
  table(
    columns: (22mm, 22mm, 28mm, 1fr),
    inset: 6pt,
    stroke: 0.5pt + rule-grey,
    table.header([*Datum*], [*Version*], [*Autor*], [*Änderung*]),
    [#meta.date], [0.1.0], [#meta.author], [Initiale Dokumentationsstruktur],
  )
  pagebreak()

  text(size: 22pt, weight: "bold", fill: ink)[Inhaltsverzeichnis]
  v(5pt)
  line(length: 100%, stroke: 1.4pt + hslu-orange)
  v(11pt)
  {
    set text(size: 8pt)
    set par(leading: 0.35em)
    outline(title: none, indent: auto, depth: 2)
  }
  pagebreak()

  body
}
