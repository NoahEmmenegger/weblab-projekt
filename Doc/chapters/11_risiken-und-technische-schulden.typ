= Risiken und technische Schulden

#table(
  columns: (22%, 12%, 12%, 32%, 22%),
  table.header([*Risiko/Schuld*], [*Eintritt*], [*Auswirkung*], [*Gegenmassnahme*], [*Status/Owner*]),
  [Next.js-Server- und Clientgrenzen werden vermischt], [Mittel], [Hoch], [Fachlogik in serverseitigen Modulen kapseln; Datenbankzugriff nie in Client Components; Architekturtests und Reviews], [Offen / Noah Emmenegger],
  [Docker-Start schlägt wegen nicht bereiter Datenbank fehl], [Mittel], [Mittel], [PostgreSQL-Healthcheck und davon abhängiger Start des App-Service; Fehler sichtbar protokollieren], [Offen / Noah Emmenegger],
  [Geändertes Datenbankpasswort passt nicht zum persistierten Volume], [Mittel], [Mittel], [Bei bestehendem Volume das ursprüngliche Passwort verwenden; für einen Neuaufbau bewusst `docker compose down -v` einsetzen], [Dokumentiert / Noah Emmenegger],
  [Migration fehlt vor einem API-Deployment], [Mittel], [Hoch], [Migration vor dem Deployment kontrolliert mit `npm run db:migrate` anwenden; nicht im Web-Container starten], [Offen / Noah Emmenegger],
  [[Lighthouse-Ziel wird spät verfehlt]], [Mittel], [Mittel], [Regelmässige Messung mit Produktions-Build], [[Offen / Name]],
  [Backup und Restore noch nicht automatisiert], [Mittel], [Hoch], [Vor einem Produktivbetrieb Backup- und Restore-Ablauf definieren und testen], [Akzeptiert für lokale Entwicklung / Noah Emmenegger],
)

// Liste während des Projekts pflegen. Erledigte Risiken nicht löschen, sondern Status aktualisieren.
