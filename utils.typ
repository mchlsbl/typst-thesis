#import "@preview/acrostiche:0.7.0": *

#let listing(source, lang) = {
  set par(justify: false, leading: 0.65em)
  show raw: set align(left)
  block(
    fill: gray.lighten(80%),
    radius: 3pt,
    pad(
      8pt,
      block(
        raw(read(source), lang: lang),
        width: 100%,
      ),
    ),
  )
}

#let table_of_contents() = {
  pagebreak(weak: true)
  {
    set page(footer: none)
    show outline.entry.where(
      level: 1,
    ): it => {
      show repeat: none
      strong(it)
    }
    outline(target: selector(heading).after(<frontmatter-start>).before(<appendix-start>))
  }
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

#let list_of_acronyms(title, acronyms) = context {
  if acronyms.len() != 0 {
    pagebreak(weak: true)
    init-acronyms(acronyms)
    print-index(
      title: title,
      row-gutter: par.leading,
      column-ratio: 0.2,
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
