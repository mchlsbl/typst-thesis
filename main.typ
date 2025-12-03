#import "/utils.typ": *
#import "/template.typ": template

#template(
  author: (
    name: "Max Mustermann",
    street: "Straße 1",
    city: "11111 Stadt",
    number: "00000",
    centuria: "XXX",
    degree: "Bachelor of Science (B. Sc.) in Software Engineering",
    university: "an der technischen Universität Musterstadt",
  ),
  paper: (
    type: "Bachelorarbeit",
    description: "zur Erlangung des akademischen Grades",
    title: "Interessanter Titel",
    first_reviewer: "Max Musterprüfer",
    second_reviewer: "Moritz Musterprüfer",
    company_supervisor: "Max Musterbetreuer",
    company: "Firma GmbH",
    proposal: false,
    confidential: true,
    oath: true,
    date: datetime.today(),
  ),
)[
  #frontmatter[
    #table_of_contents()
    #list_of("Abbildungsverzeichnis", figure.where(kind: image))
    #list_of("Tabellenverzeichnis", figure.where(kind: table))
    #list_of("Quelltextverzeichnis", figure.where(kind: raw))
    #list_of_acronyms(
      "Abkürzungsverzeichnis",
      (
        "SBOM": "Software Bill of Materials",
      ),
    )
  ]

  #mainmatter[
    #include "/content/thesis.typ"
  ]

  #backmatter[
    #bibliography(title: "Literaturverzeichnis", "/assets/literature.bib")
    #list_of("Anhangsverzeichnis", selector(heading).after(<appendix-start>).before(<appendix-end>))
  ]

  #appendix[
    #include "/content/appendix.typ"
  ]
]
