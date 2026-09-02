= Verteilungssicht

== Produktionsnahe Umgebung

#figure(
  rect(width: 100%, inset: 18pt)[
    #align(center)[
      *Browser* → `localhost:3000` / HTTPS → *Container `app` (Next.js)* \
      #h(37%) ↓ internes Compose-Netzwerk \
      #h(37%) *Container `db` (PostgreSQL)* → *persistentes Volume*
    ]
  ],
  kind: image,
  caption: [Verteilung der Anwendung mit Docker Compose],
)

#table(
  columns: (25%, 35%, 40%),
  table.header([*Knoten*], [*Artefakt*], [*Konfiguration/Verantwortung*]),
  [Client], [Aktueller Webbrowser], [Greift über den veröffentlichten Port der Next.js-Anwendung zu.],
  [Service `app`], [Next.js-Produktions-Bundle], [Enthält App Router, UI und Backend; erhält die Datenbank-URL und veröffentlicht Port 3000.],
  [Service `db`], [PostgreSQL-Image, Schema und Daten], [Nur intern erreichbar; Konfiguration über Umgebungsvariablen; Healthcheck meldet Bereitschaft.],
  [Docker-Volume], [PostgreSQL-Datenverzeichnis], [Persistiert Daten bei einer Container-Neuerstellung. Backup und Restore sind vor dem Produktivbetrieb zu ergänzen.],
)

== Reproduzierbarer Start

Voraussetzung ist Docker Compose. Eine `.env`-Datei beziehungsweise sicher gesetzte Umgebungsvariablen liefern Datenbankname, -benutzer, -passwort und Verbindungs-URL. Echte Zugangsdaten werden nicht in Git eingecheckt.

```sh
docker compose up --build
```

Der Befehl baut die Next.js-Anwendung und startet sowohl `app` als auch `db`. Die Anwendung ist anschliessend über den veröffentlichten Web-Port erreichbar. Gestoppt wird der Stack mit `docker compose down`; das Datenbank-Volume bleibt dabei erhalten.
