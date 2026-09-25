= Laufzeitsicht

== Bewerbung absenden

1. Eine Bewerberin oder ein Bewerber öffnet die durch den Next.js App Router bereitgestellte Formularroute. Navigation, Footer und Formularrahmen werden serverseitig gerendert.
2. Interaktive Formularteile werden als Client Components aktiviert. Sie prüfen unmittelbar erkennbare Eingabefehler und senden die Bewerbung an einen serverseitigen Endpunkt der Next.js-Anwendung.
3. Die Server Action prüft den Veröffentlichungsstatus der Ausschreibung und validiert die Eingaben erneut.
4. Die Server Action speichert die Antworten und eine Kopie der verwendeten Formularfelder über Drizzle in PostgreSQL. Die Rangfolge wird beim Anzeigen der Bewerbungen aus den gespeicherten Daten berechnet.
5. Bei Erfolg zeigt die Client Component eine Bestätigung. Bei einem erwarteten Fehler bleiben die Eingaben erhalten und die Oberfläche zeigt eine verständliche Meldung.

== Bewertete Bewerbungen laden

1. Eine angemeldete Mitarbeiterin oder ein angemeldeter Mitarbeiter ruft im Verwaltungsbereich eine Ausschreibung auf.
2. Das Dashboard-Layout prüft die Sitzung auf dem Server und lädt die eigenen Gesellschaften, Wohnungen und Ausschreibungen.
3. Für eine ausgewählte Ausschreibung ruft die Client Component eine Server Action auf. Diese prüft die Berechtigung und lädt die Bewerbungen aus PostgreSQL.
4. Die datenbankfreie Bewertungsfunktion berechnet im Browser die Rangfolge für die Anzeige. Der CSV-Export berechnet dieselbe Rangfolge separat auf dem Server.

== Startreihenfolge der Datenbankdienste

1. Docker Compose startet die Services `db`, `migrate` und `web`.
2. PostgreSQL initialisiert das Datenverzeichnis und meldet seinen Zustand über einen Healthcheck.
3. Nach erfolgreichem Healthcheck führt `migrate` die versionierten SQL-Migrationen aus. Erst nach dessen erfolgreichem Abschluss startet `web`. Schlägt ein Schritt fehl, startet der Web-Service nicht.

== Aktueller API-Datenfluss

1. Ein Client ruft `GET /api/applications` auf.
2. Der Route Handler verwendet den serverseitigen Drizzle-Client und führt eine sortierte `SELECT`-Abfrage auf `applications` aus.
3. Bei Erfolg antwortet die Route mit `{ applications: [...] }` und `Cache-Control: no-store`.
4. Bei einem unerwarteten Datenbankfehler wird der technische Fehler serverseitig protokolliert; der Client erhält eine allgemeine HTTP-500-Antwort ohne Verbindungsdetails.
