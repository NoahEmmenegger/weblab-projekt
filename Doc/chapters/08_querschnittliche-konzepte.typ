= Querschnittliche Konzepte

== Domänenmodell und Persistenz

Der aktuelle technische Kern umfasst `applications` mit `id`, `applicantName`, `status` und `createdAt`. Drizzle definiert das Schema in TypeScript und erzeugt prüfbare SQL-Migrationen. Komplexere Domänenbeziehungen und Transaktionen werden ergänzt, sobald Ausschreibungen und Antworten implementiert sind.

== API- und Schnittstellendesign

Die vorhandenen Leseendpunkte sind `GET /api/hello` und `GET /api/applications`. Sie liefern JSON. Die Bewerbungsroute ist bewusst nicht zwischengespeichert und gibt bei unerwarteten Fehlern eine allgemeine HTTP-500-Antwort aus; technische Details bleiben im Server-Log. Eine API-Versionierung ist bei den zwei lokalen Entwicklungsendpunkten noch nicht nötig.

== Benutzeroberfläche und Responsive Design

Die Anwendung verwendet das Next.js-App-Layout mit deutscher Dokumentensprache und Metadaten. Die fachliche Benutzeroberfläche, Responsive-Design und Accessibility-Tests sind noch nicht umgesetzt und bleiben Teil der nächsten Iterationen.

== Fehlerbehandlung und Logging

Konfigurationsfehler wie eine fehlende `DATABASE_URL` verhindern den Start des Datenbank-Clients. Datenbankfehler der API werden serverseitig mit Kontext geloggt, während der Client keine Zugangsdaten oder SQL-Details erhält.

== Sicherheit

Zugangsdaten liegen in `.env` und sind von Git ausgeschlossen. Docker Compose verlangt ein explizites PostgreSQL-Passwort; der Datenbankport ist nur an `127.0.0.1` gebunden. Authentisierung, Autorisierung und fachliche Eingabevalidierung sind noch nicht implementiert und vor produktivem Einsatz erforderlich.

== Testkonzept

#table(
  columns: (22%, 38%, 40%),
  table.header([*Teststufe*], [*Zweck*], [*Beispiele/Werkzeuge*]),
  [Statisch], [Typen und Stilregeln prüfen], [`npm run typecheck` und `npm run lint`],
  [Build], [Produktionsbundle und Route-Typen prüfen], [`npm run build`],
  [Integration], [Datenbank und Schnittstellen prüfen], [Manuelle Prüfung von `GET /api/applications`; automatisierte Tests noch offen],
  [E2E/Qualität], [Kritische Journeys, Performance und Accessibility prüfen], [Noch offen; vor fachlicher Fertigstellung ergänzen],
)
