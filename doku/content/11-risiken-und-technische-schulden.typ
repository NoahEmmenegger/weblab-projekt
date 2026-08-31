#import "../template/hslu.typ": placeholder

= Risiken und technische Schulden

#table(
  columns: (1fr, 18mm, 18mm, 1fr),
  inset: 5pt,
  table.header([*Risiko*], [*Eintritt*], [*Auswirkung*], [*Massnahme*]),
  [Unbekannte Technologie benötigt mehr Einarbeitungszeit.], [Mittel], [Hoch], [Früher Spike und Zeitbox für Evaluation.],
  [Performance-Ziel wird erst spät gemessen.], [Mittel], [Mittel], [Lighthouse ab dem ersten lauffähigen Inkrement in CI prüfen.],
  [Projektumfang übersteigt ca. 60 Stunden.], [Mittel], [Hoch], [Must-Stories zuerst; Could-Stories konsequent begrenzen.],
)

== Technische Schulden

#placeholder[Halte bewusst eingegangene Vereinfachungen mit Auswirkung, Rückzahlungsplan und Priorität fest.]
