= Bausteinsicht

== Ebene 1: Gesamtsystem

// Diagramm der wichtigsten Bausteine. Verantwortlichkeiten statt Technologien hervorheben.

#figure(
  rect(width: 100%, inset: 18pt)[
    *Platzhalter: Bausteindiagramm* \
    Präsentation → Anwendungslogik → Persistenz
  ],
  caption: [Bausteinsicht des Gesamtsystems],
)

#table(
  columns: (25%, 45%, 30%),
  table.header([*Baustein*], [*Verantwortung*], [*Schnittstellen*]),
  [[Frontend]], [[Darstellung und Benutzerinteraktion]], [[HTTP/API]],
  [[Backend]], [[Fachlogik und Datenzugriff]], [[REST/GraphQL/...]],
  [[Datenbank]], [[Persistente Datenhaltung]], [[DB-Protokoll/ORM]],
)

== Ebene 2: Frontend

// Nur fachlich oder architektonisch relevante Komponenten dokumentieren.

[Komponenten, Verantwortlichkeiten, Abhängigkeiten und bewusste Abweichungen]

== Ebene 2: Backend

[Module/Schichten, Verantwortlichkeiten, Abhängigkeiten und bewusste Abweichungen]
