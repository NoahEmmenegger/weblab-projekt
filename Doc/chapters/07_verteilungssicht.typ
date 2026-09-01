= Verteilungssicht

== Produktionsumgebung

// Deploymentdiagramm mit Laufzeitknoten, Artefakten, Netzen und externen Diensten ergänzen.

#figure(
  rect(width: 100%, inset: 18pt)[
    *Platzhalter: Deploymentdiagramm* \
    Browser → Web-/App-Server → Datenbank
  ],
  caption: [Verteilung der Anwendung in Produktion],
)

#table(
  columns: (25%, 35%, 40%),
  table.header([*Knoten*], [*Artefakt*], [*Konfiguration/Verantwortung*]),
  [Client], [Browser-Anwendung], [Auslieferung und unterstützte Browser],
  [[Server/Plattform]], [[Produktions-Bundle]], [[Start, Umgebungsvariablen, Skalierung]],
  [[Datenbank]], [[Schema und Daten]], [[Migration, Persistenz, Backup]],
)

== Reproduzierbarer Start

// Exakten Befehl bzw. öffentliche URL sowie erforderliche Variablen dokumentieren.

```sh
docker compose up
```

[Falls öffentlich deployed: URL und Deployment-Ablauf]
