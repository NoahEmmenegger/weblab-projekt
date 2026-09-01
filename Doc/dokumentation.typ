#import "template/basic-thesis.typ": *

#show: basic-thesis.with(
  logo: image("assets/images/hslu-logo.svg", width: 30%),
  title: "Titel der Arbeit",
  students: (
    "Student 1",
    "Student 2",
  ),
  year: "2026",
  institution: "HSLU",
  study-program: "BSc Informatik",
  supervisor: "Supervisor Name",
  expert: "Expert Name",
  client: "Client/Company Name",
  public: false,
  secret: true,
  language: "de",
  thesis-type: "Wirtschaftsprojekt",
  bibliography: include "outlines/bibliography.typ",
  abbreviations: include "outlines/abbreviations.typ",
  figure-outline: include "outlines/figure-outline.typ",
  table-outline: include "outlines/table-outline.typ",
  code-outline: include "outlines/code-outline.typ",
  abstract: include "chapters/00_abstract.typ",
  gratitude: include "chapters/00_expression-of-gratitude.typ",
)

// TODO: Remove example chapter before final submission
#include "chapters/99_example.typ"

#include "chapters/01_problem-fragestellung-vision.typ"
#include "chapters/02_stand-der-technik.typ"
#include "chapters/03_ideen-und-konzepte.typ"
#include "chapters/04_methoden.typ"
#include "chapters/05_realisierung.typ"
#include "chapters/06_validation-und-evaluation.typ"
#include "chapters/07_ausblick.typ"
#include "chapters/08_anhang.typ"
