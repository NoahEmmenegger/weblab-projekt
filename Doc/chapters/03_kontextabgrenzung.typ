= Kontextabgrenzung

Dieses Kapitel grenzt die Wohnungsvergabe-Plattform von ihren Benutzergruppen und der technischen Umgebung ab. In der ersten Version bestehen keine Schnittstellen zu externen Fachsystemen oder Datenquellen.

== Fachlicher Kontext

#figure(
  grid(
    columns: (1fr, auto, 1.4fr),
    column-gutter: 12pt,
    row-gutter: 12pt,
    align(center + horizon, rect(width: 100%, inset: 10pt)[Mitarbeitende der Gesellschaft]),
    align(center + horizon)[→],
    align(center + horizon, rect(width: 100%, inset: 14pt)[*Wohnungsvergabe-Plattform*]),
    align(center + horizon, rect(width: 100%, inset: 10pt)[Bewerber/innen]),
    align(center + horizon)[↔],
    align(center + horizon, rect(width: 100%, inset: 14pt)[*Wohnungsvergabe-Plattform*]),
  ),
  caption: [Fachlicher Kontext der Wohnungsvergabe-Plattform],
)

#table(
  columns: (27%, 25%, 48%),
  table.header([*Akteur*], [*Schnittstelle*], [*Ausgetauschte Informationen*]),
  [Mitarbeitende der Gesellschaft], [Geschützte Weboberfläche], [Ausschreibungen, Formulare, Kriterien, Gewichtungen, Musterbewerbungen, Bewerbungen, Auswahlstatus und Exporte],
  [Bewerber/innen], [Öffentlich geteiltes Webformular, optional mit Zugangsschlüssel], [Formularfelder, Bewerbungsdaten und - je nach umgesetztem Umfang - Bewerbungsstatus],
)

Die Gesellschaft legt die Vergaberegeln fest und erhält die aufbereiteten Bewertungen. Bewerber/innen übermitteln ausschliesslich die im jeweiligen Formular verlangten Angaben. Die endgültige Vergabeentscheidung entsteht ausserhalb des Systems durch die verantwortliche Person; im System wird sie lediglich dokumentiert.

== Technischer Kontext

Die Benutzer/innen greifen mit einem aktuellen Webbrowser über HTTPS auf die Anwendung zu. Der Next.js App Router ordnet die eingehenden Anfragen den Seiten und serverseitigen Endpunkten zu. Benutzeroberfläche, serverseitige Validierung und Fachlogik werden als eine Next.js-Anwendung betrieben; es existiert kein separater Express-Server. Die Next.js-Anwendung persistiert die Daten über ein ORM in PostgreSQL. Datenexporte werden als Datei über die Weboberfläche bereitgestellt.

#table(
  columns: (25%, 27%, 48%),
  table.header([*Kommunikationspartner*], [*Kanal/Protokoll*], [*Bemerkung*]),
  [Browser der Mitarbeitenden], [HTTPS; HTML, CSS und JavaScript], [Zugriff auf den authentisierten Verwaltungsbereich],
  [Browser der Bewerber/innen], [HTTPS; HTML, CSS und JavaScript], [Zugriff über einen Freigabelink; optional durch einen Zugangsschlüssel geschützt],
  [Next.js-Anwendung], [Interne Modulaufrufe], [Routing, Rendering, serverseitige Endpunkte, Fachlogik und Datenzugriff in einem auslieferbaren Artefakt],
  [PostgreSQL-Datenbank], [Datenbankprotokoll über ORM], [Persistenz für Ausschreibungen, Formulare, Kriterien, Bewerbungen und Bewertungen],
  [Dateisystem des Browsers], [HTTPS-Download], [Export der Bewerbungen und ihrer Bewertungen],
)

Externe Datenquellen, soziale Netzwerke und KI-Dienste liegen ausserhalb der Systemgrenze und werden nicht angebunden.
