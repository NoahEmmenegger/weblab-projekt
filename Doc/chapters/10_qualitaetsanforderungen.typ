= Qualitätsanforderungen

== Qualitätsbaum

// Qualitätsziele aus Kapitel 1 in Teilmerkmale zerlegen, z. B. Benutzbarkeit → responsiv, zugänglich.

- Qualität
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
  [QS-04], [Änderbarkeit], [Eine neue Eigenschaft der Ressource wird ergänzt.], [Änderung bleibt auf klar abgegrenzte Bausteine beschränkt], [Review/Tests],
)

== Evaluationsergebnisse

// Am Projektende Ist-Werte und Links/Verweise auf Test- und Lighthouse-Berichte ergänzen.

[Ergebnisse, Abweichungen und getroffene Verbesserungsmassnahmen]
