= Bausteinsicht

== Ebene 1: Gesamtsystem

#figure(
  rect(width: 100%, inset: 18pt)[
    #align(center)[
      *Browser* \
      ↓ HTTPS \
      *Next.js-Anwendung* \
      App Router · React UI · serverseitige Endpunkte · Fachmodule · Datenzugriff \
      ↓ ORM / PostgreSQL-Protokoll \
      *PostgreSQL-Datenbank*
    ]
  ],
  caption: [Bausteinsicht des Gesamtsystems],
)

#table(
  columns: (25%, 45%, 30%),
  table.header([*Baustein*], [*Verantwortung*], [*Schnittstellen*]),
  [App Router und UI], [Ordnet URLs zu, rendert Seiten und verarbeitet Benutzerinteraktionen.], [HTTPS sowie interne Aufrufe],
  [Serverseitige Endpunkte], [Authentisierung, Validierung und Orchestrierung der Anwendungsfälle mit Route Handlers und/oder Server Actions.], [HTTP oder interne Server-Aufrufe],
  [Fachmodule], [Regeln für Ausschreibungen, Formulare, Kriterien, Bewerbungen, Bewertungen und Export.], [Typsichere Modulgrenzen],
  [Datenzugriff], [Kapselt Abfragen, Transaktionen und Schema-Migrationen.], [ORM],
  [PostgreSQL], [Persistente, relationale und transaktionale Datenhaltung.], [PostgreSQL-Protokoll],
)

== Ebene 2: Next.js-Anwendung

Der App Router bildet öffentliche Bewerbungsseiten und den geschützten Verwaltungsbereich auf Routen ab. React-Komponenten stellen die Oberfläche dar. Navigation, Footer, Layouts und datenlesende Seiten werden als Server Components serverseitig gerendert. Client Components werden nur für interaktive Teilbäume verwendet, die Browserzustand oder Ereignisbehandlung benötigen, etwa dynamische Formularfelder, Filter und Sortierung.

Schreibende Aktionen werden ausschliesslich serverseitig autorisiert und validiert. Route Handlers werden für explizite HTTP-Endpunkte wie Exporte eingesetzt; eng an eine Seite gebundene Mutationen können als Server Actions umgesetzt werden. Beide Varianten rufen dieselben Fachmodule auf.

Die Fachmodule kennen weder React-Komponenten noch HTTP-Details. Sie enthalten die Anwendungsregeln und verwenden den gekapselten Datenzugriff. Dadurch bleibt der Monolith intern modular und die Bewertungslogik kann unabhängig von der Darstellung getestet werden.

== Ebene 2: Persistenz

Das ORM bildet das relationale PostgreSQL-Schema auf TypeScript-Typen ab und verwaltet Migrationen. Zusammengehörige Änderungen, etwa das Speichern einer Bewerbung mit ihren Antworten und Bewertungsergebnissen, werden in einer Transaktion ausgeführt. Nur serverseitiger Code erhält Zugriff auf die Datenbankverbindung.

Der aktuelle Schema-Ausschnitt enthält die Tabelle `applications` mit Identifikator, Bewerbername, Status und Erstellzeitpunkt. `db/schema.ts` ist die verbindliche Drizzle-Definition; die erzeugte SQL-Migration liegt versioniert im Verzeichnis `drizzle/`. Der Pool und Drizzle-Client befinden sich in `db/index.ts` und werden nicht in Client Components importiert.
