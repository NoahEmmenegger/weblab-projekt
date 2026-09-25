= Qualitätsanforderungen

== Qualitätsbaum

- Qualität
  - Nachvollziehbarkeit: deterministische Bewertung, erklärbare Teilbewertungen
  - Benutzbarkeit: responsive Bedienung, verständliche Rückmeldungen
  - Änderbarkeit: klare Verantwortlichkeiten, automatisierte Tests
  - Zuverlässigkeit: Datenintegrität, kontrollierte Fehlerbehandlung
  - Effizienz: Lighthouse-Durchschnitt mindestens 90 auf Mobile und Desktop

== Qualitätsszenarien

#table(
  columns: (10%, 18%, 32%, 25%, 15%),
  table.header([*ID*], [*Merkmal*], [*Szenario*], [*Messgrösse*], [*Nachweis*]),
  [QS-01], [Performance], [Eine typische Seite wird in der Produktionsversion aufgerufen.], [Lighthouse-Durchschnitt ≥ 90, Mobile und Desktop], [Lighthouse-Bericht],
  [QS-02], [Benutzbarkeit], [Eine Kernfunktion wird auf einem kleinen Bildschirm ausgeführt.], [Ohne horizontales Scrollen; alle Aktionen erreichbar], [E2E/Manuell],
  [QS-03], [Zuverlässigkeit], [Ungültige Daten werden übermittelt.], [Keine inkonsistenten Daten; verständliche Fehlermeldung], [Integration/E2E],
  [QS-04], [Änderbarkeit], [Ein neues Bewertungskriterium oder ein neuer Formulartyp wird ergänzt.], [Änderung bleibt auf klar abgegrenzte Bausteine beschränkt], [Review/Tests],
  [QS-05], [Nachvollziehbarkeit], [Eine gespeicherte Bewerbung wird automatisch bewertet.], [Gesamtwert ist aus Antworten, Kriterien und Gewichtungen reproduzierbar; alle Teilwerte werden ausgewiesen], [Unit-/E2E-Test],
)

== Evaluationsergebnisse

Am 25.09.2026 bestanden vier automatisierte Unit-Tests für Gewichtung, Validierung und Ranking (`npm test`). Ein PostgreSQL-Integrationstest für persistierte Ausschreibungen, Bewerbungen und ihre Auswertung bestand ebenfalls (`npm run test:integration`). Der Integrationstest lief nach Anwendung der Migrationen gegen eine separate lokale Testdatenbank. Die Testfälle liegen in `tests/`.

#pagebreak(weak: true)

== Lighthouse-Score

Der Screenshot zeigt 99 Punkte für Leistung, 95 für Barrierefreiheit, 82 für Best Practices und 100 für SEO. Eine separate Desktop-Messung von `/dashboard` ergab nahezu gleiche Werte (100/95/81/100).

#figure(
  image("../assets/images/lighthouse.png", width: 100%),
  caption: [Lighthouse-Ergebnis der Live-Anwendung],
)
