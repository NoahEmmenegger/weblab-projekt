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

Die Anwendung ist in Schichten mit gerichteten Abhängigkeiten gegliedert. Der App Router und die Komponenten bilden die Darstellung. Server Actions und Route Handlers nehmen Eingaben entgegen und koordinieren Anwendungsfälle. Datenbankfreie Funktionen in `lib/` enthalten Typen, Gewichtungs- und Bewertungsregeln. Die Abfragen in `db/queries/` kapseln Drizzle und PostgreSQL. Nur serverseitige Einstiegspunkte importieren den Datenzugriff; die Oberfläche erhält Daten als Props oder als Rückgabe einer Server Action.

#figure(
  table(
    columns: (27%, 73%),
    table.header([*Ausführungsort*], [*Schicht und Datenfluss*]),
    [Browser], [`components/` mit `"use client"`: Formulare, Dialoge, Dashboard-Zustand und Ereignisse],
    [Server], [`app/` mit Server Components: Routing, initiale Daten und Zugriffsschutz],
    [Server], [`app/actions/` und `app/api/`: Autorisierung, Eingabeprüfung und Anwendungsfälle],
    [Beide Seiten], [`lib/`: reine Typen, Gewichtungs- und Bewertungsfunktionen ohne Datenbankzugriff],
    [Nur Server], [`db/queries/` → `db/index.ts` → PostgreSQL: Abfragen und Persistenz],
  ),
  caption: [Schichten und Ausführungsorte der Next.js-Anwendung],
)

`app/dashboard/layout.tsx` prüft die Sitzung und lädt Gesellschaften, Wohnungen und Ausschreibungen auf dem Server. Die Daten gehen an `DashboardShell` und `DashboardProvider`, die als Client Components Auswahl, Dialoge und lokalen Zustand verwalten. Die öffentliche Route `app/bewerben/[listingId]/page.tsx` lädt eine veröffentlichte Ausschreibung serverseitig; `ApplicationForm` verarbeitet die Eingabe im Browser. Das Formular ruft `submitListingApplication` als Server Action auf, wo die Eingaben erneut geprüft und gespeichert werden. Der CSV-Export ist ein separater Route Handler unter `app/api/listings/[listingId]/applications/export/route.ts`.

Die Funktionen in `lib/answer-preferences.ts` und `lib/field-weights.ts` sind bewusst unabhängig von React und PostgreSQL. Sie werden sowohl für die Vorschau und Rangliste im Dashboard als auch bei serverseitiger Validierung und beim Export genutzt. Clientseitige Berechnungen dienen der unmittelbaren Anzeige; Berechtigungen und verbindliche Schreiboperationen bleiben auf dem Server. Damit ist die Schichtung eine Trennung der Verantwortlichkeiten innerhalb eines Monolithen, keine vollständig isolierte Domain-Schicht.

== Ebene 2: Persistenz

Das ORM bildet das relationale PostgreSQL-Schema auf TypeScript-Typen ab und verwaltet versionierte Migrationen. Nur serverseitiger Code erhält Zugriff auf die Datenbankverbindung. Bewerbungsantworten und die zum Einreichungszeitpunkt verwendeten Formularfelder werden in `listing_applications` gespeichert; die Rangfolge wird aus diesen Daten berechnet.

`db/schema.ts` ist die verbindliche Drizzle-Definition für Benutzer, Sitzungen, Gesellschaften, Wohnungen, Ausschreibungen und Bewerbungen. SQL-Migrationen liegen versioniert in `drizzle/`. Der Pool und der Drizzle-Client befinden sich in `db/index.ts` und werden nicht in Client Components importiert.
