= Verteilungssicht

== Container und Laufzeit

#figure(
  rect(width: 100%, inset: 18pt)[
    #align(center)[
      *Browser* → HTTPS / Reverse Proxy → *Service `web` (Next.js)* \
      #h(30%) ↓ internes Compose-Netzwerk \
      #h(30%) *Service `db` (PostgreSQL)* → *Volume `postgres_data`* \
      *Service `migrate`* → wartet auf `db` → führt Migrationen vor `web` aus
    ]
  ],
  caption: [Laufzeitdienste und Datenfluss der Compose-Umgebung],
)

#table(
  columns: (25%, 35%, 40%),
  table.header([*Knoten*], [*Artefakt*], [*Verantwortung*]),
  [Browser], [HTML und Client-JavaScript], [Zeigt serverseitig erzeugte Seiten und führt interaktive Client Components aus.],
  [Service `web`], [Next.js-Standalone-Bundle aus dem `Dockerfile`], [Server Components, Server Actions, Route Handlers, Authentisierung und Datenzugriff; intern auf Port 3000.],
  [Service `migrate`], [Eigenes Docker-Build-Target], [Wendet mit `npm run db:migrate` versionierte Drizzle-Migrationen an und beendet sich danach.],
  [Service `db`], [PostgreSQL 17], [Speichert relationale Daten; Healthcheck meldet die Bereitschaft. Der Port ist nur lokal an `127.0.0.1` gebunden.],
  [Docker-Volume], [`postgres_data`], [Erhält Daten bei einer Neuerstellung der Container.],
)

Das produktive Docker-Image wird mehrstufig gebaut. Nur das Standalone-Bundle, statische Dateien und öffentliche Assets gelangen in den laufenden Web-Container. Compose startet `migrate` nach erfolgreichem Datenbank-Healthcheck und `web` erst nach erfolgreicher Migration. So ist die Migrationsreihenfolge in der aktuellen Compose-Datei technisch festgelegt; fehlgeschlagene Migrationen verhindern den Start von `web`.

== Reproduzierbarer Start

Voraussetzung ist Docker Compose. Eine `.env`-Datei beziehungsweise sicher gesetzte Umgebungsvariablen liefern Datenbankname, -benutzer, -passwort und gegebenenfalls erlaubte Origins für Server Actions. Echte Zugangsdaten werden nicht in Git eingecheckt. Für den lokalen Browserzugriff ergänzt `docker-compose.local.yml` die Portfreigabe des Web-Services.

```sh
docker compose -f docker-compose.yml -f docker-compose.local.yml up --build
```

Die Anwendung ist lokal über Port 3000 erreichbar. `docker compose -f docker-compose.yml -f docker-compose.local.yml down` stoppt die Dienste und erhält das Datenbank-Volume. Schemaänderungen werden vorab mit `npm run db:generate` als SQL-Migration erzeugt und versioniert; der einmalige Service `migrate` wendet sie beim nächsten Compose-Start an.

== CI/CD und automatisches Deployment mit Dokploy

Als Zielprozess soll jeder Push beziehungsweise Pull Request durch GitHub Actions geprüft werden. Nach einem erfolgreichen Push auf `master` soll ein nachgelagerter Deploy-Job die Dokploy-Compose-API aufrufen. Dokploy bezieht dann den neuen Commit und stellt den Compose-Stack bereit. API-Token und Compose-ID liegen als GitHub-Secrets vor; produktive Datenbankzugänge bleiben in Dokploy. Die direkte Auto-Deploy-Auslösung der GitHub-Integration muss für diesen Ablauf deaktiviert sein, damit kein ungeprüfter Push die CI-Stufen umgeht. Die #link("https://docs.dokploy.com/docs/core/auto-deploy")[Dokploy-Dokumentation zu Auto Deploy] und die #link("https://docs.dokploy.com/docs/api/compose")[Compose-API-Referenz] beschreiben die verfügbaren Auslöser.

#figure(
  rect(width: 100%, inset: 16pt)[
    #align(center)[
      *Git Push / Pull Request* \
      ↓ \
      *GitHub Actions: `npm ci` → Typecheck → Lint → Build* \
      ↓ erfolgreicher Push auf `master` \
      *Deploy-Job → Dokploy-Compose-API → Compose-Build → `db` → `migrate` → `web`* \
      ↓ \
      *Anwendung über HTTPS erreichbar*
    ]
  ],
  caption: [Vorgesehene CI/CD- und Deployment-Kette],
)

Die Qualitätsstufen verwenden die bereits vorhandenen Skripte `npm run typecheck`, `npm run lint` und `npm run build`. Dokploy benötigt dazu das Git-Repository, den produktiven Branch, die Compose-Datei, eine Domain mit HTTPS sowie produktive Umgebungsvariablen. Vor dem Livebetrieb sind ausserdem Backup und Restore der PostgreSQL-Daten und ein überprüfbarer Umgang mit fehlgeschlagenen Deployments erforderlich.

*Umsetzungsstand:* Im Repository sind `Dockerfile`, Compose-Dateien und die Prüfbefehle vorhanden. Eine GitHub-Actions-Workflow-Datei ist derzeit nicht versioniert; eine Dokploy-Konfiguration ist im Repository nicht sichtbar. Die automatische Auslösung und ein erfolgreiches Live-Deployment sind daher mit dem vorliegenden Projektstand nicht nachgewiesen.
