#let template(
  language: "de",
  font: "New Computer Modern",
  font_size: 11pt,
  line_spacing: 1.5,
  margin: (
    left: 30mm,
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
    university: "",
  ),
  paper: (
    type: "",
    description: "",
    title: "",
    first_reviewer: "",
    second_reviewer: "",
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
    paper.description = "zur Vorbereitung der " + paper.type + " im Studiengang"
    paper.type = "Exposé"
  }

  set document(
    author: author.name,
    title: paper.type,
    description: paper.title,
    date: paper.date,
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

    text(
      paper.description + "\n" + strong(author.degree) + "\n" + author.university,
      hyphenate: false,
    )

    v(1fr)

    text(paper.title, hyphenate: false, weight: "bold", 15pt)

    v(2fr)

    let entries = ()
    entries.push(("Vorgelegt von:", author.name))
    if not paper.proposal {
      entries.push(("", author.street))
      entries.push(("", author.city))
    }
    entries.push(("\nMatrikelnummer:", "\n" + author.number))
    entries.push(("Zenturie:", author.centuria))
    entries.push(("\nGutachter:", "\n" + paper.first_reviewer))
    if not paper.proposal {
      entries.push(("Co-Gutachter:", paper.second_reviewer))
      entries.push(("Betrieblicher Betreuer:", paper.company_supervisor))
    }
    entries.push(("\nVorgelegt am:", "\n" + paper.date.display("[day].[month].[year]")))

    grid(
      columns: 2,
      row-gutter: 0.65em,
      column-gutter: 5em,
      ..for (term, desc) in entries {
        if not (desc == "" or desc == "\n") {
          (align(left, strong(term)), align(right, desc))
        }
      }
    )
  }

  if paper.confidential and not paper.proposal [
    = Sperrvermerk

    Diese #paper.type basiert auf internen und vertraulichen Daten des Unternehmens #paper.company.

    Diese Arbeit darf Dritten, mit Ausnahme der betreuenden Dozierenden und befugten Mitgliedern des Prüfungsausschusses, ohne ausdrückliche Zustimmung des Verfassenden nicht zugänglich gemacht werden.

    Eine Vervielfältigung und Veröffentlichung der #paper.type ohne ausdrückliche Genehmigung, auch in Auszügen, ist nicht erlaubt.
  ]

  {
    set page(margin: (bottom: margin.bottom + 5mm))
    body
  }

  if paper.oath and not paper.proposal [
    = Eidesstattliche Erklärung

    Mit meiner Unterschrift versichere ich, dass ich die hier vorliegende Arbeit selbstständig, ohne fremde Hilfe und nur mit den angegebenen Hilfsmitteln verfasst habe und meine Angaben zu den verwendeten Quellen der Wahrheit entsprechen und vollständig sind.

    Alle Quellen, aus denen ich wörtlich oder sinngemäß übernommen habe, habe ich als solche gekennzeichnet.

    Darüber hinaus versichere ich, dass ich sämtliche Teile der vorliegenden Arbeit, die unter Zuhilfenahme künstlicher Intelligenz (KI) generiert wurden, als solche gekennzeichnet habe und deren Entstehung in einer beigefügten Prozessdokumentation nachgewiesen habe.

    Ich habe zur Kenntnis genommen, dass zuwiderlaufendes Verhalten als Täuschungsversuch gewertet wird und zu den in der geltenden Prüfungsverfahrensordnung genannten Konsequenzen führen wird.

    #v(1fr)

    #grid(
      columns: 2,
      gutter: 1fr,
      align(center, stack(
        dir: ttb,
        spacing: 0.8em,
        line(length: 7cm, stroke: 0.5pt),
        "Ort und Datum",
      )),
      align(center, stack(
        dir: ttb,
        spacing: 0.8em,
        line(length: 7cm, stroke: 0.5pt),
        author.name,
      )),
    )
  ]
}
