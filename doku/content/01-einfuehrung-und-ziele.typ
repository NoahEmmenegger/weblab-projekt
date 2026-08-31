#import "../template/hslu.typ": placeholder

= Einführung und Ziele

== Aufgabenstellung

#placeholder[Fasse die Kernaufgabe und den erwarteten Nutzen in einem kurzen Absatz zusammen. Verweise für Details auf den Projektauftrag.]

== Qualitätsziele

#table(
  columns: (10mm, 32mm, 1fr, 34mm),
  inset: 6pt,
  table.header([*Nr.*], [*Ziel*], [*Begründung*], [*Messung*]),
  [1], [Benutzbarkeit], [Die Kernabläufe sollen ohne Einführung verständlich sein.], [E2E-Test und Usability-Review],
  [2], [Performance], [Die Anwendung soll auch mobil schnell reagieren.], [Lighthouse ≥ 90],
  [3], [Änderbarkeit], [Neue Funktionen sollen innerhalb des Projektumfangs sicher ergänzt werden können.], [Modularität, Tests, Review],
)

== Stakeholder

#table(
  columns: (34mm, 1fr, 1fr),
  inset: 6pt,
  table.header([*Stakeholder*], [*Interesse*], [*Erwartung*]),
  [Projektverfasser:in], [Lernerfolg und funktionierendes Produkt], [Beherrschbare Komplexität, nachvollziehbare Entscheidungen],
  [Dozierende], [Bewertung der Zielerreichung], [Prüfbare Anforderungen und prägnante Dokumentation],
  [Endnutzer:innen], [Lösung eines fachlichen Problems], [Zuverlässige und zugängliche Anwendung],
)
