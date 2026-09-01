= Kontextabgrenzung

== Fachlicher Kontext

// Ein Kontextdiagramm einfügen: System in der Mitte, Benutzer und Nachbarsysteme aussen.
// Alle ein- und ausgehenden Informationen kurz beschreiben.

#figure(
  rect(width: 100%, inset: 18pt)[
    *Platzhalter: fachliches Kontextdiagramm* \
    Benutzer ↔ Webapplikation ↔ externe Systeme
  ],
  caption: [Fachlicher Kontext],
)

#table(
  columns: (25%, 30%, 45%),
  table.header([*Nachbar/Akteur*], [*Schnittstelle*], [*Ausgetauschte Information*]),
  [Anwender/in], [Web-UI], [Erfasst und konsumiert fachliche Daten],
  [[Nachbarsystem]], [[Protokoll/API]], [[Ein- und Ausgaben]],
)

== Technischer Kontext

// Protokolle, Datenformate, Authentisierung und technische Kanäle präzisieren.

[Beschreibung der technischen Schnittstellen und Systemgrenzen]
