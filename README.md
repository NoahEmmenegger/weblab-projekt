# Live-Anwendung online ansehen
https://wohnungsvergabetool.dokploy.codelance.ch




# Faire Wohnungsvergabe

Webanwendung zur Verwaltung von Gesellschaften, Wohnungen, Ausschreibungen und Bewerbungen. Mitarbeitende gestalten Bewerbungsformulare mit gewichteten Antwortpräferenzen, sehen die Rangfolge eingegangener Bewerbungen und exportieren die Ergebnisse als CSV. Die endgültige Vergabeentscheidung erfolgt ausserhalb der Anwendung.

## Technologie

Next.js 16, React 19, TypeScript, PostgreSQL 17 und Drizzle ORM. Die Anwendung und die Datenbank laufen lokal mit Docker Compose.

## Start mit Docker Compose

Die Konfiguration liegt in `.env`. Für eine neue lokale Einrichtung kann `.env.example` kopiert und das Datenbankpasswort angepasst werden:

```powershell
Copy-Item .env.example .env
docker compose -f docker-compose.yml -f docker-compose.local.yml up --build
```

Die Weboberfläche ist unter <http://localhost:3000> erreichbar. PostgreSQL ist lokal an Port 5432 gebunden. Compose startet zuerst die Datenbank, führt dann die versionierten Migrationen aus und startet anschliessend den Web-Service. Das Volume `postgres_data` erhält die Daten beim Stoppen und Neuerstellen der Container.

```powershell
docker compose -f docker-compose.yml -f docker-compose.local.yml down
```

## Entwicklung

Mit `npm run devDB` wird nur die lokale Datenbank gestartet. `npm run dev` startet den Next.js-Entwicklungsserver. Drizzle verwendet `DATABASE_URL` aus `.env` oder `.env.local`.

```powershell
npm run devDB
npm run db:migrate
npm run dev
```

Tabellen sind in `db/schema.ts` definiert; SQL-Migrationen liegen in `drizzle/`. Datenbankabfragen befinden sich in `db/queries/`. Die Skripte `npm run db:generate` und `npm run db:migrate` erzeugen beziehungsweise übernehmen Schemaänderungen. `npm run db:studio` öffnet die Datenbankansicht.

## Tests

`npm test` führt vier Unit-Tests für Gewichtung, Antwortvalidierung und Ranking aus. `npm run test:integration` prüft das Speichern und Laden einer Ausschreibung und ihrer Bewerbungen sowie den Zugriffsschutz und die Bewertung. Der Integrationstest verwendet eine separate PostgreSQL-Datenbank mit einem Namen, der auf `_test` endet; seine Testdaten werden anschliessend entfernt.

Beispiel für die lokale Einrichtung der Testdatenbank in PowerShell (Benutzer, Passwort und Port entsprechend `.env` einsetzen):

```powershell
docker compose exec -T db createdb -U wohnungsvergabe wohnungsvergabe_test
$env:TEST_DATABASE_URL = "postgresql://wohnungsvergabe:<password>@localhost:5432/wohnungsvergabe_test"
$env:DATABASE_URL = $env:TEST_DATABASE_URL
npm run db:migrate
Remove-Item Env:DATABASE_URL
npm run test:integration
```

Die übrigen Prüfungen sind `npm run typecheck`, `npm run lint` und `npm run build`.

## Dokumentation

Die Architekturdokumentation liegt unter `Doc/dokumentation.typ`. Der ursprüngliche Projektvorschlag liegt separat unter `Doc/projektvorschlag.typ`.
