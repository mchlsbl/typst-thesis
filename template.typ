#import "@preview/acrostiche:0.7.0": *

#let template(
  language: "de",
  font: "New Computer Modern",
  font_size: 12pt,
  line_spacing: 1.5,
  margin: (
    left: 20mm,
    right: 20mm,
    top: 20mm,
    bottom: 20mm,
  ),
  author: (
    name: "",
    street: "",
    city: "",
    number: "",
    centuria: "",
    degree: "",
  ),
  paper: (
    type: "",
    description: "",
    title: "",
    first_supervisor: "",
    second_supervisor: "",
    company_supervisor: "",
    company: "",
    proposal: false,
    confidential: false,
    oath: false,
    date: datetime.today(),
  ),
  body,
) = {
  if paper.proposal {
    paper.type = "Exposé"
    paper.description = "zur Vorbereitung der Bachelorarbeit im Studiengang"
  }

  set document(
    author: author.name,
    title: paper.type,
    description: paper.title,
    date: datetime.today(),
  )

  set text(
    lang: language,
    font: font,
    size: font_size,
  )

  set par(
    justify: true,
    spacing: 1.2em * line_spacing,
    leading: 0.65em * line_spacing,
  )

  set page(margin: margin)

  show figure: set block(spacing: 3em)
  set figure(gap: 2em)

  show table.cell.where(y: 0): strong
  set table(
    align: horizon,
    stroke: (x, y) => (
      top: if y > 0 { 0.5pt },
      left: if x > 0 { 0.5pt },
    ),
  )

  show outline.entry.where(
    level: 1,
  ): it => {
    show repeat: none
    strong(it)
  }

  show heading: set block(spacing: 1.5em)

  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    it
  }

  {
    set page(margin: 30mm)
    set par(justify: false)
    set align(center)

    image("assets/logo.png", width: 55%)

    v(2fr)

    text(paper.type, weight: "bold", 15pt)

    v(1fr)

    text(paper.description + "\n" + author.degree, hyphenate: false)

    v(1fr)

    text(paper.title, hyphenate: false, weight: "bold", 15pt)

    v(2fr)

    let entries = ()
    entries.push(("Autor:", author.name))
    if not paper.proposal {
      entries.push(("", author.street))
      entries.push(("", author.city))
    }
    entries.push(("\nMatrikelnummer:", "\n" + author.number))
    entries.push(("Zenturie:", author.centuria))
    entries.push(("\nVorgelegt am:", "\n" + paper.date.display("[day].[month].[year]")))
    entries.push(("\nGutachter:", "\n" + paper.first_supervisor))
    if not paper.proposal {
      entries.push(("Zweitgutachter:", paper.second_supervisor))
      entries.push(("\nBetrieblicher Betreuer:", "\n" + paper.company_supervisor))
    }

    grid(
      columns: 2,
      row-gutter: 0.7em,
      column-gutter: 7em,
      ..for (term, desc) in entries {
        if not (desc == "" or desc == "\n") {
          (align(left, strong(term)), align(right, desc))
        }
      }
    )
  }

  if paper.confidential and not paper.proposal [
    = Sperrvermerk

    Die nachfolgende Arbeit enthält vertrauliche Daten der #paper.company.

    Veröffentlichungen oder Vervielfältigungen der Arbeit - auch auszugsweise - sind ohne ausdrückliche Genehmigung der #paper.company nicht gestattet.

    Die Arbeit ist nur den Korrektoren sowie den Mitgliedern des Prüfungsausschusses zugänglich zu machen.
  ]

  body

  if paper.oath and not paper.proposal [
    = Eigenständigkeitserklärung

    Mit meiner Unterschrift versichere ich, dass ich die hier vorliegende Arbeit selbstständig, ohne fremde Hilfe und nur mit den angegebenen Hilfsmitteln verfasst habe und meine Angaben zu den verwendeten Quellen der Wahrheit entsprechen und vollständig sind. Alle Quellen, aus denen ich wörtlich oder sinngemäß übernommen habe, habe ich als solche gekennzeichnet.

    Darüber hinaus versichere ich, dass ich sämtliche Teile der vorliegenden Arbeit, die unter Zuhilfenahme künstlicher Intelligenz (KI) generiert wurden, als solche gekennzeichnet habe und deren Entstehung in einer beigefügten Prozessdokumentation nachgewiesen habe.

    Ich habe zur Kenntnis genommen, dass zuwiderlaufendes Verhalten als Täuschungsversuch gewertet wird und zu den in der geltenden Prüfungsverfahrensordnung genannten Konsequenzen führen wird.

    #v(1fr)

    #grid(
      columns: 2,
      column-gutter: 1fr,
      align(center, stack(
        dir: ttb,
        spacing: 0.8em,
        author.city.split().at(1) + ", der " + paper.date.display("[day].[month].[year]"),
        line(length: 7cm, stroke: 0.5pt),
        "Ort und Datum",
      )),
      align(center, stack(
        dir: ttb,
        spacing: 0.8em,
        "",
        line(length: 7cm, stroke: 0.5pt),
        author.name,
      )),
    )
  ]
}

#let list_of(title, target) = context {
  if query(target).len() != 0 {
    pagebreak(weak: true)
    if title != auto {
      show heading: none
      heading(numbering: none)[#title]
    }
    outline(
      title: title,
      target: target,
    )
  }
}

#let list_of_acronyms(title, acronyms) = {
  init-acronyms(acronyms)
  if acronyms.len() != 0 {
    pagebreak(weak: true)
    print-index(
      title: title,
      row-gutter: 0.65em * 1.5,
      column-ratio: 0.15,
      outlined: true,
      used-only: true,
      delimiter: none,
    )
  }
}

#let frontmatter(body) = {
  set page(numbering: "I")
  counter(page).update(1)
  [#[] <frontmatter-start>]
  body
  [#[] <frontmatter-end>]
}

#let mainmatter(body) = {
  set page(numbering: "1")
  set heading(numbering: "1.1 ")
  counter(page).update(1)
  body
}

#let backmatter(body) = context {
  set page(numbering: "I")
  counter(page).update(counter(page).at(<frontmatter-end>).first() + 1)
  body
}

#let appendix(body) = {
  set page(numbering: "I")
  set heading(numbering: "A.1 ")
  counter(heading).update(0)
  [#[] <appendix-start>]
  body
  [#[] <appendix-end>]
}
