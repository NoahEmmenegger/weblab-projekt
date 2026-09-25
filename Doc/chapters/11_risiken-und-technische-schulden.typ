= Risiken und technische Schulden

Die folgenden technischen Risiken wurden im lokalen Betrieb berücksichtigt:

#table(
  columns: (35%, 65%),
  table.header([*Risiko*], [*Umgesetzte Behandlung*]),
  [Datenbank ist beim Start des Web-Services nicht bereit], [PostgreSQL-Healthcheck und Abhängigkeit des Web-Services vom erfolgreichen Migrationslauf],
  [Fehlerhafte Migration beeinträchtigt den Start], [Der Service `migrate` führt versionierte Migrationen aus; `web` startet erst nach dessen erfolgreichem Abschluss.],
  [Datenbankzugriff aus Browser-Code], [Datenbankabfragen liegen in serverseitigen Modulen; Berechtigungen werden bei Server Actions und Exporten geprüft.],
)
