#import "../template/hslu.typ": placeholder

= Verteilungssicht

#placeholder[Dokumentiere Entwicklungs-, Test- und Produktionsumgebung. Zeige Laufzeitknoten, deployte Artefakte, Netzwerkgrenzen und externe Dienste.]

#table(
  columns: (30mm, 35mm, 1fr),
  inset: 6pt,
  table.header([*Umgebung*], [*Knoten*], [*Artefakte / Betrieb*]),
  [Entwicklung], [Lokaler Rechner], [Dev-Server, Datenbank, Testwerkzeuge],
  [CI], [CI-Runner], [Linting, Build und automatisierte Tests],
  [Produktion], [Zu definieren], [Produktions-Bundle und persistenter Datenspeicher],
)
