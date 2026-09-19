= Laufzeitsicht

== Bewerbung absenden

1. Eine Bewerberin oder ein Bewerber öffnet die durch den Next.js App Router bereitgestellte Formularroute. Navigation, Footer und Formularrahmen werden serverseitig gerendert.
2. Interaktive Formularteile werden als Client Components aktiviert. Sie prüfen unmittelbar erkennbare Eingabefehler und senden die Bewerbung an einen serverseitigen Endpunkt der Next.js-Anwendung.
3. Der Endpunkt prüft Zugangsschlüssel, Ausschreibungsstatus und Eingaben erneut auf dem Server und ruft das Fachmodul auf.
4. Das Fachmodul speichert Bewerbung und Antworten über das ORM in einer PostgreSQL-Transaktion und berechnet die deterministische Bewertung.
5. Bei Erfolg liefert Next.js eine Bestätigung. Bei einem erwarteten Fehler bleiben die Eingaben erhalten und die Oberfläche zeigt eine verständliche Meldung; bei einem Datenbankfehler wird die Transaktion zurückgerollt.

== Bewertete Bewerbungen laden

1. Eine angemeldete Mitarbeiterin oder ein angemeldeter Mitarbeiter ruft im Verwaltungsbereich eine Ausschreibung auf.
2. Der App Router prüft die Sitzung und Berechtigung auf dem Server. Das Fachmodul liest Bewerbungen, Gesamtwerte und Einzelbeiträge über das ORM aus PostgreSQL.
3. Next.js rendert Navigation, Footer und die initiale sortierte Ansicht serverseitig.
4. Danach aktualisieren kleine Client Components Filter und Sortierung unmittelbar im Browser, sofern dafür keine neue Serverabfrage nötig ist.

== Datenbank beim gemeinsamen Start noch nicht bereit

1. `docker compose up --build` startet die Services `db` und `app`.
2. PostgreSQL initialisiert das Datenverzeichnis und meldet seinen Zustand über einen Healthcheck.
3. Die Next.js-Anwendung startet nach erfolgreichem Healthcheck und verbindet sich über den Servicenamen `db`. Schlägt dies fehl, beendet sie sich mit einem sichtbaren Fehler, statt Anfragen in einem unvollständigen Zustand zu verarbeiten.

== Aktueller API-Datenfluss

1. Ein Client ruft `GET /api/applications` auf.
2. Der Route Handler verwendet den serverseitigen Drizzle-Client und führt eine sortierte `SELECT`-Abfrage auf `applications` aus.
3. Bei Erfolg antwortet die Route mit `{ applications: [...] }` und `Cache-Control: no-store`.
4. Bei einem unerwarteten Datenbankfehler wird der technische Fehler serverseitig protokolliert; der Client erhält eine allgemeine HTTP-500-Antwort ohne Verbindungsdetails.
