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
  [Mitarbeitende der Gesellschaft], [Geschützte Weboberfläche], [Wohnungen, Ausschreibungen, Formulare, Kriterien, Gewichtungen, Bewerbungen und Exporte],
  [Bewerber/innen], [Öffentlich geteiltes Webformular], [Formularfelder und Bewerbungsdaten],
)

Die Gesellschaft legt die Bewertungsregeln fest und erhält die aufbereiteten Bewertungen. Bewerber/innen übermitteln die im jeweiligen Formular verlangten Angaben. Die endgültige Vergabeentscheidung erfolgt ausserhalb des Systems durch die verantwortliche Person.

== Technischer Kontext

Die Benutzer/innen greifen mit einem aktuellen Webbrowser auf die Anwendung zu. Lokal ist sie über HTTP auf Port 3000 erreichbar. Der Next.js App Router ordnet die Anfragen den Seiten und serverseitigen Endpunkten zu. Benutzeroberfläche, serverseitige Validierung und Fachlogik laufen in einer Next.js-Anwendung; es gibt keinen separaten Express-Server. Die Anwendung persistiert die Daten über ein ORM in PostgreSQL. Datenexporte werden als Datei über die Weboberfläche bereitgestellt.

#table(
  columns: (25%, 27%, 48%),
  table.header([*Kommunikationspartner*], [*Kanal/Protokoll*], [*Bemerkung*]),
  [Browser der Mitarbeitenden], [HTTP lokal; HTML, CSS und JavaScript], [Zugriff auf den authentisierten Verwaltungsbereich],
  [Browser der Bewerber/innen], [HTTP lokal; HTML, CSS und JavaScript], [Zugriff über einen öffentlichen Ausschreibungslink],
  [Next.js-Anwendung], [Interne Modulaufrufe], [Routing, Rendering, serverseitige Endpunkte, Fachlogik und Datenzugriff in einem auslieferbaren Artefakt],
  [PostgreSQL-Datenbank], [Datenbankprotokoll über ORM], [Persistenz für Ausschreibungen, Formulare, Kriterien, Bewerbungen und Bewertungen],
  [Dateisystem des Browsers], [Dateidownload], [Export der Bewerbungen und ihrer Bewertungen],
)

Externe Datenquellen, soziale Netzwerke und KI-Dienste liegen ausserhalb der Systemgrenze und werden nicht angebunden.
