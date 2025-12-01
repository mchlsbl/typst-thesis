#import "/template.typ": *

#template(
  author: (
    name: "Max Mustermann",
    street: "Straße 1",
    city: "11111 Stadt",
    number: "00000",
    centuria: "XXX",
    degree: "Bachelor of Science (B. Sc.) in Software Engineering",
  ),
  paper: (
    type: "Bachelorarbeit",
    description: "zur Erlangung des akademischen Grades",
    title: "Interessanter Titel",
    first_supervisor: "Max Musterprüfer",
    second_supervisor: "",
    company_supervisor: "Max Musterbetreuer",
    company: "Firma GmbH",
    proposal: false,
    confidential: true,
    oath: true,
    date: datetime.today(),
  ),
)[
  #frontmatter[
    #list_of(auto, selector(heading).after(<frontmatter-start>).before(<appendix-start>))
    #list_of("Abbildungsverzeichnis", figure.where(kind: image))
    #list_of("Tabellenverzeichnis", figure.where(kind: table))
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
    #bibliography("/assets/literature.bib", title: "Literaturverzeichnis")
    #list_of("Anhangsverzeichnis", selector(heading).after(<appendix-start>).before(<appendix-end>))
  ]

  #appendix[
    #include "/content/appendix.typ"
  ]
]
