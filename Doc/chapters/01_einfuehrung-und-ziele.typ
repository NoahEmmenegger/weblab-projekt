= Einführung und Ziele

Dieses Kapitel beschreibt den fachlichen Anlass, die wichtigsten Anforderungen und die beteiligten Personen. Es bildet zugleich den Projektvorschlag.

== Aufgabenstellung

// Kontext in 3–5 Sätzen: Welches Problem wird für wen gelöst? Wie wird es heute gelöst?
// Welchen messbaren Nutzen soll die Applikation bieten? Was gehört bewusst nicht zum Projekt?

[Projektkontext und Aufgabenstellung]

== Qualitätsziele

// Höchstens 3–5 priorisierte Qualitätsziele. Konkrete Prüfmethode in Kapitel 10 ergänzen.

#table(
  columns: (10%, 25%, 45%, 20%),
  table.header([*Prio*], [*Qualitätsziel*], [*Begründung*], [*Nachweis*]),
  [1], [Benutzbarkeit], [Die Kernaufgaben sind auf Desktop und Mobile effizient ausführbar.], [E2E-Test, Lighthouse],
  [2], [Änderbarkeit], [Die Applikation bleibt trotz des begrenzten Projektumfangs gut erweiterbar.], [Code-Review, Tests],
  [3], [Zuverlässigkeit], [Gespeicherte Daten bleiben konsistent und dauerhaft verfügbar.], [Integrations- und E2E-Tests],
)

== Stakeholder

#table(
  columns: (25%, 35%, 40%),
  table.header([*Stakeholder*], [*Erwartung*], [*Bezug zum System*]),
  [Anwender/in], [Einfache und zuverlässige Bearbeitung der fachlichen Ressource], [Nutzt die Webapplikation],
  [Entwickler/in], [Verständliche Struktur und reproduzierbarer Betrieb], [Entwickelt und betreibt das System],
  [Dozent/in], [Nachvollziehbare Erfüllung der Projektanforderungen], [Bewertet Artefakt und Dokumentation],
)

== Fachliche Anforderungen und User Stories

// Jede Story erhält eine eindeutige ID, MoSCoW-Priorität und überprüfbare Akzeptanzkriterien.
// Die selbst definierte Ressource konkret benennen; "Ressource" ist nur ein Platzhalter.

#table(
  columns: (9%, 13%, 48%, 30%),
  table.header([*ID*], [*MoSCoW*], [*User Story*], [*Akzeptanzkriterien*]),
  [US-01], [Must], [Als Anwender/in möchte ich eine Ressource erstellen, damit ich neue Daten erfassen kann.], [Pflichtfelder werden validiert; Datensatz wird persistent gespeichert.],
  [US-02], [Must], [Als Anwender/in möchte ich Ressourcen anzeigen, ändern und löschen.], [CRUD-Aktionen funktionieren; Löschen erfordert Bestätigung.],
  [US-03], [Must], [Als Anwender/in möchte ich die Daten in zwei inhaltlich unterschiedlichen Formen sehen.], [Beide Sichten verwenden dieselben persistenten Daten.],
  [US-04], [Should], [[Eigene priorisierte Story]], [[Akzeptanzkriterien]],
  [US-05], [Could], [[Eigene optionale Story]], [[Akzeptanzkriterien]],
)

=== Abgrenzung

// Won't-have-Anforderungen für diesen Projektzeitraum explizit nennen.

- [Nicht Bestandteil dieser Version]
