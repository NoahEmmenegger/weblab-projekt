= Qualitätsanforderungen

== Qualitätsbaum

- Qualität
  - Benutzbarkeit
    - Responsive Bedienung
    - Verständliche Rückmeldungen
  - Effizienz
    - Lighthouse-Durchschnitt ≥ 90
  - Zuverlässigkeit
    - Automatisiert geprüfte Kernabläufe
  - Wartbarkeit
    - Lesbare, modular erweiterbare Struktur

== Qualitätsszenarien

#table(
  columns: (10mm, 25mm, 1fr, 42mm),
  inset: 5pt,
  table.header([*ID*], [*Merkmal*], [*Szenario*], [*Messkriterium*]),
  [Q1], [Performance], [Eine mobile Nutzerin öffnet eine repräsentative Seite unter üblichen Netzwerkbedingungen.], [Lighthouse-Durchschnitt ≥ 90.],
  [Q2], [Benutzbarkeit], [Ein Nutzer führt einen CRUD-Kernablauf auf einem kleinen Bildschirm aus.], [Ohne horizontales Scrollen; E2E-Test erfolgreich.],
  [Q3], [Änderbarkeit], [Eine zusätzliche Eigenschaft wird an der Kernressource ergänzt.], [Änderung bleibt lokal; Tests zeigen keine Regression.],
)
