= Querschnittliche Konzepte

== Domänenmodell und Persistenz

Drizzle definiert in `db/schema.ts` Benutzer, Sitzungen, Gesellschaften, Wohnungen, Ausschreibungen und Bewerbungen. `listing_applications` speichert Antworten zusammen mit den zum Einreichungszeitpunkt verwendeten Formularfeldern. SQL-Migrationen werden versioniert und beim Compose-Start vor dem Web-Service ausgeführt.

== API- und Schnittstellendesign

`GET /api/hello` und `GET /api/applications` liefern JSON. Der geschützte Route Handler für den Bewerbungs-Export liefert CSV. Fachliche Schreiboperationen laufen über Server Actions. Die Bewerbungsroute ist bewusst nicht zwischengespeichert und gibt bei unerwarteten Fehlern eine allgemeine HTTP-500-Antwort aus; technische Details bleiben im Server-Log.

== Benutzeroberfläche und Responsive Design

Die Anwendung verwendet das Next.js-App-Layout mit deutscher Dokumentensprache und Metadaten. Dashboard, Dialoge und öffentliches Bewerbungsformular sind umgesetzt. Interaktive Bereiche sind Client Components; geschützte Daten werden serverseitig geladen und geprüft. Formale Accessibility-Tests sind noch offen.

== Fehlerbehandlung und Logging

Konfigurationsfehler wie eine fehlende `DATABASE_URL` verhindern den Start des Datenbank-Clients. Datenbankfehler der API werden serverseitig mit Kontext geloggt, während der Client keine Zugangsdaten oder SQL-Details erhält.

== Sicherheit

Zugangsdaten liegen in `.env` und sind von Git ausgeschlossen. Docker Compose verlangt ein explizites PostgreSQL-Passwort; der Datenbankport ist nur an `127.0.0.1` gebunden. Die Sitzung wird über ein HTTP-only-Cookie verwaltet. Das Dashboard prüft die Anmeldung, und serverseitige Aktionen und Exporte prüfen die Berechtigung für die jeweilige Ausschreibung. Eingaben werden serverseitig erneut validiert.

== Testkonzept

#table(
  columns: (22%, 38%, 40%),
  table.header([*Teststufe*], [*Zweck*], [*Beispiele/Werkzeuge*]),
  [Statisch], [Typen und Stilregeln prüfen], [`npm run typecheck` und `npm run lint`],
  [Build], [Produktionsbundle und Route-Typen prüfen], [`npm run build`],
  [Unit], [Gewichtung, Eingabeprüfung und Ranking prüfen], [`npm test`: automatisierte Tests mit dem Node.js-Test-Runner],
  [Integration], [Persistenz und Auswertung mit PostgreSQL prüfen], [`npm run test:integration` mit separater `TEST_DATABASE_URL`; Ausführung benötigt eine migrierte Testdatenbank],
  [E2E/Qualität], [Kritische Browser-Journeys, Performance und Accessibility prüfen], [Noch offen; vor fachlicher Fertigstellung ergänzen],
)
