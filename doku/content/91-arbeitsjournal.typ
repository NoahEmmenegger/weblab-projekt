#import "../template/hslu.typ": placeholder

= Arbeitsjournal

Das Arbeitsjournal wird laufend geführt. Einträge sollen die tatsächlich selbst geleistete Arbeit nachvollziehbar machen.

#table(
  columns: (25mm, 18mm, 1fr, 30mm),
  inset: 5pt,
  table.header([*Datum*], [*Stunden*], [*Tätigkeiten / Ergebnis*], [*Commit / Referenz*]),
  [TT.MM.JJJJ], [0.0], [Projektauftrag und erste Architekturüberlegungen], [-],
  [TT.MM.JJJJ], [0.0], [ ], [-],
  [TT.MM.JJJJ], [0.0], [ ], [-],
)

== Total

#placeholder[Aktueller Aufwand: 0.0 Stunden. Den Totalwert nach jedem Eintrag aktualisieren. Richtwert des Moduls: ca. 60 Stunden.]
