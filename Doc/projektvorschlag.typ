#set page(
  paper: "a4",
  margin: 2.2cm,
)

#set text(
  size: 10.5pt,
)

#set heading(numbering: none)

= Projektvorschlag - Faire Wohnungsvergabe Tool

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

Die Anwendung wird als webbasierter, modular strukturierter Monolith umgesetzt. Die ursprünglich vorgesehene Trennung in ein React-Frontend und ein separates Express-Backend wird nicht weiterverfolgt. Stattdessen bündelt Next.js Routing, Benutzeroberfläche und serverseitige Backend-Funktionalität in einer Anwendung. Die Daten werden in einer separaten PostgreSQL-Datenbank gespeichert.

- *Framework:* Next.js mit App Router
- *Programmiersprache:* TypeScript
- *Frontend:* React und Tailwind CSS
- *Backend:* Next.js Route Handlers und/oder Server Actions auf Node.js
- *Datenbank:* PostgreSQL
- *ORM:* Drizzle ORM
- *Architektur:* modular strukturierter Monolith mit separater Datenbank
- *Authentifizierung:* einfache Benutzeranmeldung für Gesellschaften
- *Betrieb:* Docker Compose mit den Services `app` und `db`
- *Versionsverwaltung:* Git / GitHub

Next.js und PostgreSQL werden jeweils in einem Docker-Container betrieben und über Docker Compose verbunden. Ein persistentes Docker-Volume schützt die Datenbankdaten bei einem Neustart der Container. Die gesamte Anwendung soll aus dem Projektverzeichnis mit einem einzigen Befehl reproduzierbar gestartet werden können:

```sh
docker compose up --build
```