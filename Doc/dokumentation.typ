#import "template/basic-thesis.typ": *

#show: basic-thesis.with(
  logo: image("assets/images/hslu-logo.svg", width: 30%),
  title: "Projekttitel",
  students: (
    "Noah Emmenegger",
  ),
  year: "2026",
  institution: "HSLU",
  study-program: "BSc Informatik",
  supervisor: "Dozent/in",
  expert: "",
  client: "Web Programming Lab",
  show-declaration: false,
  language: "de",
  thesis-type: "Web Programming Lab Projekt",
  bibliography: include "outlines/bibliography.typ",
  abbreviations: include "outlines/abbreviations.typ",
  figure-outline: include "outlines/figure-outline.typ",
  table-outline: include "outlines/table-outline.typ",
  code-outline: include "outlines/code-outline.typ",
  abstract: include "chapters/00_abstract.typ",
  gratitude: "",
)

#include "chapters/01_einfuehrung-und-ziele.typ"
#include "chapters/02_randbedingungen.typ"
#include "chapters/03_kontextabgrenzung.typ"
#include "chapters/04_loesungsstrategie.typ"
#include "chapters/05_bausteinsicht.typ"
#include "chapters/06_laufzeitsicht.typ"
#include "chapters/07_verteilungssicht.typ"
#include "chapters/08_querschnittliche-konzepte.typ"
#include "chapters/09_architekturentscheidungen.typ"
#include "chapters/10_qualitaetsanforderungen.typ"
#include "chapters/11_risiken-und-technische-schulden.typ"
#include "chapters/12_glossar.typ"
#include "chapters/13_fazit-und-reflexion.typ"
#include "chapters/14_arbeitsjournal.typ"
#include "chapters/15_anhang.typ"
