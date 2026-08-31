#import "../template/hslu.typ": placeholder

= Querschnittliche Konzepte

== Persistenz und Datenmodell

#placeholder[Beschreibe das zentrale Datenmodell, Identitäten, Beziehungen, Migrationen und Regeln zur Datenintegrität.]

== Validierung und Fehlerbehandlung

#placeholder[Definiere, wo syntaktische und fachliche Validierung erfolgt und wie Fehler über Schichten hinweg dargestellt werden.]

== Sicherheit und Datenschutz

#placeholder[Dokumentiere Authentisierung, Autorisierung, Secret-Management, Eingabebereinigung, Datenschutz und relevante Bedrohungen. Falls nicht relevant, begründe die Abgrenzung.]

== Teststrategie

#table(
  columns: (28mm, 1fr, 1fr),
  inset: 6pt,
  table.header([*Ebene*], [*Zweck*], [*Beispiele*]),
  [Unit], [Fachlogik schnell und isoliert prüfen], [Validierung, Berechnungen, Mapper],
  [Integration], [Zusammenspiel technischer Bausteine prüfen], [API und Datenbank],
  [E2E], [Wichtigste Nutzerabläufe im Browser prüfen], [CRUD und Darstellungswechsel],
)

== Beobachtbarkeit und Betrieb

#placeholder[Beschreibe Logging, Health Checks, Fehleranalyse, Metriken und den Umgang mit personenbezogenen Daten in Logs.]

#block(breakable: false)[
  == User Experience und Barrierefreiheit

  #placeholder[Definiere Breakpoints, Tastaturbedienung, Semantik, Kontrast sowie Lade- und Fehlerzustände.]
]
