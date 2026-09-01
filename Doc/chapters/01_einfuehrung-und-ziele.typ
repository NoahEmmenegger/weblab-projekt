= Einführung und Ziele

Dieses Kapitel beschreibt den fachlichen Anlass, die wichtigsten Anforderungen und die beteiligten Personen. Es bildet zugleich den Projektvorschlag.

== Projektvorschlag

=== Kontext

Gewisse Immobiliengesellschaften und Genossenschaften möchten Wohnungsvergaben möglichst fair und nachvollziehbar durchführen. Über die geplante Plattform können sie Wohnungsausschreibungen und dazugehörige Bewerbungsformulare erstellen sowie alle eingehenden Bewerbungen zentral verwalten. Vor Beginn der Ausschreibung werden Kriterien und deren Gewichtung definiert, anhand welcher die Bewerbungen anschliessend automatisch bewertet und sortiert werden. Die endgültige Entscheidung wird weiterhin durch die zuständige Person getroffen, wobei die Plattform transparent aufzeigt, wie die jeweilige Bewertung zustande gekommen ist.

=== Fachlichkeit als User Stories

==== Must Have

- Als Gesellschaft kann ich eine neue Wohnungsausschreibung erstellen.
- Als Gesellschaft kann ich für eine Ausschreibung ein individuelles Bewerbungsformular erstellen.
- Als Gesellschaft kann ich Bewertungskriterien für eine Ausschreibung definieren.
- Als Gesellschaft kann ich festlegen, wie stark die einzelnen Kriterien gewichtet werden.
- Als Gesellschaft kann ich eine Musterbewerbung ausfüllen, um die definierten Kriterien und Gewichtungen zu testen.
- Als Gesellschaft kann ich die Kriterien und Gewichtungen vor Beginn der Ausschreibung festlegen und sperren.
- Als Gesellschaft kann ich das Bewerbungsformular über einen Link teilen.
- Als Gesellschaft kann ich das Bewerbungsformular optional mit einem Zugangsschlüssel schützen.
- Als Bewerber kann ich das Bewerbungsformular ausfüllen und absenden.
- Als Gesellschaft kann ich alle eingegangenen Bewerbungen zentral einsehen.
- Als Gesellschaft kann ich die Bewerbungen anhand der definierten Kriterien automatisch bewerten lassen.
- Als Gesellschaft kann ich die Bewerbungen nach ihrer Übereinstimmung mit den Vergabekriterien sortieren.
- Als Gesellschaft kann ich bei einer Bewerbung einsehen, wie sich die einzelnen Kriterien auf die Gesamtbewertung ausgewirkt haben.
- Als Gesellschaft kann ich eine Bewerbung als ausgewählt markieren.
- Als Gesellschaft kann ich Bewerbungen und deren Bewertungen exportieren.

==== Should Have

- Als Gesellschaft kann ich bestehende Ausschreibungen duplizieren und als Vorlage verwenden.
- Als Gesellschaft kann ich bestehende Bewerbungsformulare wiederverwenden.
- Als Gesellschaft kann ich Mindestanforderungen definieren, welche eine Bewerbung erfüllen muss.
- Als Gesellschaft kann ich Bewerbungen filtern und durchsuchen.
- Als Gesellschaft kann ich mehrere Mitarbeitende verwalten.
- Als Gesellschaft kann ich abgeschlossene Ausschreibungen archivieren.
- Als Gesellschaft kann ich einen zusammenfassenden Bericht über eine abgeschlossene Vergabe erstellen.

==== Could Have

- Als Bewerber kann ich den aktuellen Status meiner Bewerbung einsehen.
- Als Gesellschaft kann ich Bewerber direkt über den Status ihrer Bewerbung informieren.
- Als Gesellschaft kann ich Statistiken zu vergangenen Ausschreibungen anzeigen.
- Als Gesellschaft kann ich unterschiedliche Bewertungsmodelle als Vorlagen speichern.
- Als Gesellschaft kann ich einzelne Bewerbungen kommentieren oder intern markieren.

==== Won't Have

- Die Plattform trifft keine endgültige Vergabeentscheidung ohne menschliche Bestätigung.
- Es wird keine KI zur Bewertung oder Vorhersage der Eignung eines Bewerbers eingesetzt.
- Es wird kein ausschreibungsübergreifender Score für Bewerber erstellt.
- Es werden keine externen Datenquellen oder sozialen Netzwerke zur Bewertung verwendet.

=== Angedachter Technologie-Stack

Die Anwendung wird als webbasierter Monolith umgesetzt. Frontend und Backend befinden sich innerhalb derselben Next.js-Anwendung.

- *Framework:* Next.js
- *Programmiersprache:* TypeScript
- *Frontend:* React und Tailwind CSS
- *Backend:* Next.js mit Node.js
- *Datenbank:* PostgreSQL
- *ORM:* Prisma oder Drizzle ORM
- *Architektur:* Monolith
- *Authentifizierung:* einfache Benutzeranmeldung für Gesellschaften
- *Deployment:* Docker
- *Versionsverwaltung:* Git / GitHub

Die Bewertung der Bewerbungen wird regelbasiert und deterministisch umgesetzt. Die definierten Antworten einer Bewerbung werden mit den Kriterien der Ausschreibung verglichen und anhand der festgelegten Gewichtungen zu einer Gesamtbewertung zusammengeführt. Dadurch kann für jede Bewerbung nachvollzogen werden, weshalb sie im Ranking eine bestimmte Position erreicht.

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
