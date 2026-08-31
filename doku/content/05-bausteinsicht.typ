#import "../template/hslu.typ": placeholder

= Bausteinsicht

== Ebene 1 - Gesamtsystem

#placeholder[Füge ein Container- oder Bausteindiagramm ein. Zeige nur fachlich bzw. technisch relevante Hauptbausteine und ihre Verantwortungen.]

== Bausteine

#table(
  columns: (34mm, 1fr, 1fr),
  inset: 6pt,
  table.header([*Baustein*], [*Verantwortung*], [*Schnittstellen*]),
  [Frontend], [Darstellung, Interaktion und clientseitiger Zustand], [HTTP/API],
  [Backend], [Fachlogik, Validierung und Zugriffskontrolle], [API, Persistenz],
  [Datenbank], [Dauerhafte Speicherung und Datenintegrität], [Datenbankprotokoll],
)

== Ebene 2 - Detailansicht

#placeholder[Vertiefe nur jene Bausteine, deren innere Struktur für das Verständnis oder eine wichtige Entscheidung relevant ist.]
