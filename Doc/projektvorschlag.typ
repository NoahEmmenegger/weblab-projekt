#set page(
  paper: "a4",
  margin: 2.5cm,
)

#set text(
  size: 11pt,
)

#set heading(numbering: none)

= Projektvorschlag

== Kontext

Gewisse Immobiliengesellschaften und Genossenschaften möchten Wohnungsvergaben möglichst fair und nachvollziehbar durchführen. Über die geplante Plattform können sie Wohnungsausschreibungen und dazugehörige Bewerbungsformulare erstellen sowie alle eingehenden Bewerbungen zentral verwalten. Vor Beginn der Ausschreibung werden Kriterien und deren Gewichtung definiert, anhand welcher die Bewerbungen anschliessend automatisch bewertet und sortiert werden. Die endgültige Entscheidung wird weiterhin durch die zuständige Person getroffen, wobei die Plattform transparent aufzeigt, wie die jeweilige Bewertung zustande gekommen ist.

== Fachlichkeit als User Stories

=== Must Have

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

=== Should Have

- Als Gesellschaft kann ich bestehende Ausschreibungen duplizieren und als Vorlage verwenden.
- Als Gesellschaft kann ich bestehende Bewerbungsformulare wiederverwenden.
- Als Gesellschaft kann ich Mindestanforderungen definieren, welche eine Bewerbung erfüllen muss.
- Als Gesellschaft kann ich Bewerbungen filtern und durchsuchen.
- Als Gesellschaft kann ich mehrere Mitarbeitende verwalten.
- Als Gesellschaft kann ich abgeschlossene Ausschreibungen archivieren.
- Als Gesellschaft kann ich einen zusammenfassenden Bericht über eine abgeschlossene Vergabe erstellen.

=== Could Have

- Als Bewerber kann ich den aktuellen Status meiner Bewerbung einsehen.
- Als Gesellschaft kann ich Bewerber direkt über den Status ihrer Bewerbung informieren.
- Als Gesellschaft kann ich Statistiken zu vergangenen Ausschreibungen anzeigen.
- Als Gesellschaft kann ich unterschiedliche Bewertungsmodelle als Vorlagen speichern.
- Als Gesellschaft kann ich einzelne Bewerbungen kommentieren oder intern markieren.

=== Won't Have

- Die Plattform trifft keine endgültige Vergabeentscheidung ohne menschliche Bestätigung.
- Es wird keine KI zur Bewertung oder Vorhersage der Eignung eines Bewerbers eingesetzt.
- Es wird kein ausschreibungsübergreifender Score für Bewerber erstellt.
- Es werden keine externen Datenquellen oder sozialen Netzwerke zur Bewertung verwendet.

== Angedachter Technologie-Stack

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
