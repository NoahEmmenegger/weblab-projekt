= Einführung und Ziele

Dieses Kapitel beschreibt den fachlichen Anlass, den Umfang, die wichtigsten Qualitätsziele und die beteiligten Personen des Projekts.

== Aufgabenstellung

Immobiliengesellschaften und Genossenschaften möchten Wohnungsvergaben möglichst fair und nachvollziehbar durchführen. Heute müssen Ausschreibungen, Bewerbungsformulare und eingehende Bewerbungen häufig mit mehreren voneinander getrennten Hilfsmitteln verwaltet und manuell verglichen werden.

Im Rahmen des Projekts wird deshalb eine webbasierte Plattform für die Vorbereitung und Durchführung von Wohnungsvergaben entwickelt. Mitarbeitende einer Gesellschaft erstellen damit Wohnungsausschreibungen und individuelle Bewerbungsformulare. Vor Beginn einer Ausschreibung definieren sie Bewertungskriterien und deren Gewichtung. Eingehende Bewerbungen werden anschliessend zentral verwaltet, anhand dieser Regeln automatisch bewertet und nach ihrer Übereinstimmung mit den Vergabekriterien sortiert.

Die Plattform unterstützt die Entscheidungsfindung, trifft aber keine endgültige Vergabeentscheidung. Diese bleibt bei der zuständigen Person. Damit die Entscheidung überprüfbar bleibt, zeigt das System für jede Bewerbung transparent auf, wie die Gesamtbewertung zustande gekommen ist.

=== Fachlicher Umfang

Die Anforderungen sind nach der MoSCoW-Methode priorisiert. Die Must-Have-Stories bilden den geplanten Mindestumfang der ersten Version.

*Must Have*

- Als Gesellschaft kann ich eine neue Wohnungsausschreibung erstellen.
- Als Gesellschaft kann ich für eine Ausschreibung ein individuelles Bewerbungsformular erstellen.
- Als Gesellschaft kann ich Bewertungskriterien für eine Ausschreibung definieren.
- Als Gesellschaft kann ich festlegen, wie stark die einzelnen Kriterien gewichtet werden.
- Als Gesellschaft kann ich eine Musterbewerbung ausfüllen, um die definierten Kriterien und Gewichtungen zu testen.
- Als Gesellschaft kann ich die Kriterien und Gewichtungen vor Beginn der Ausschreibung festlegen und sperren.
- Als Gesellschaft kann ich das Bewerbungsformular über einen Link teilen.
- Als Gesellschaft kann ich das Bewerbungsformular optional mit einem Zugangsschlüssel schützen.
- Als Bewerber/in kann ich das Bewerbungsformular ausfüllen und absenden.
- Als Gesellschaft kann ich alle eingegangenen Bewerbungen zentral einsehen.
- Als Gesellschaft kann ich die Bewerbungen anhand der definierten Kriterien automatisch bewerten lassen.
- Als Gesellschaft kann ich die Bewerbungen nach ihrer Übereinstimmung mit den Vergabekriterien sortieren.
- Als Gesellschaft kann ich bei einer Bewerbung einsehen, wie sich die einzelnen Kriterien auf die Gesamtbewertung ausgewirkt haben.
- Als Gesellschaft kann ich eine Bewerbung als ausgewählt markieren.
- Als Gesellschaft kann ich Bewerbungen und deren Bewertungen exportieren.

*Should Have*

- Als Gesellschaft kann ich bestehende Ausschreibungen duplizieren und als Vorlage verwenden.
- Als Gesellschaft kann ich bestehende Bewerbungsformulare wiederverwenden.
- Als Gesellschaft kann ich Mindestanforderungen definieren, die eine Bewerbung erfüllen muss.
- Als Gesellschaft kann ich Bewerbungen filtern und durchsuchen.
- Als Gesellschaft kann ich mehrere Mitarbeitende verwalten.
- Als Gesellschaft kann ich abgeschlossene Ausschreibungen archivieren.
- Als Gesellschaft kann ich einen zusammenfassenden Bericht über eine abgeschlossene Vergabe erstellen.

*Could Have*

- Als Bewerber/in kann ich den aktuellen Status meiner Bewerbung einsehen.
- Als Gesellschaft kann ich Bewerber/innen direkt über den Status ihrer Bewerbung informieren.
- Als Gesellschaft kann ich Statistiken zu vergangenen Ausschreibungen anzeigen.
- Als Gesellschaft kann ich unterschiedliche Bewertungsmodelle als Vorlagen speichern.
- Als Gesellschaft kann ich einzelne Bewerbungen kommentieren oder intern markieren.

=== Abgrenzung

Folgende Funktionen sind für den Projektzeitraum ausdrücklich nicht vorgesehen:

- Die Plattform trifft keine endgültige Vergabeentscheidung ohne menschliche Bestätigung.
- Es wird keine künstliche Intelligenz zur Bewertung oder Vorhersage der Eignung von Bewerber/innen eingesetzt.
- Es wird kein ausschreibungsübergreifender Score für Bewerber/innen erstellt.
- Es werden keine externen Datenquellen oder sozialen Netzwerke zur Bewertung verwendet.

== Qualitätsziele

#table(
  columns: (10%, 22%, 43%, 25%),
  table.header([*Prio*], [*Qualitätsziel*], [*Begründung*], [*Nachweis*]),
  [1], [Nachvollziehbarkeit], [Eine Bewertung muss aus den vorab festgelegten Kriterien, Antworten und Gewichtungen vollständig erklärbar sein.], [Berechnungsbeispiele, Unit- und E2E-Tests],
  [2], [Benutzbarkeit], [Die Kernaufgaben sind auf Desktop und Mobile verständlich und effizient ausführbar.], [E2E-Test, manuelle Prüfung, Lighthouse],
  [3], [Zuverlässigkeit], [Ausschreibungen, Kriterien und Bewerbungen bleiben konsistent und dauerhaft verfügbar.], [Integrations- und E2E-Tests],
  [4], [Änderbarkeit], [Die Anwendung bleibt trotz des begrenzten Projektumfangs nachvollziehbar strukturiert und erweiterbar.], [Code-Review, automatisierte Tests],
)

== Stakeholder

#table(
  columns: (26%, 38%, 36%),
  table.header([*Stakeholder*], [*Erwartung*], [*Bezug zum System*]),
  [Mitarbeitende einer Immobiliengesellschaft oder Genossenschaft], [Einfache Verwaltung von Ausschreibungen und Bewerbungen sowie nachvollziehbare Entscheidungsgrundlagen], [Hauptbenutzer/innen des geschützten Verwaltungsbereichs],
  [Bewerber/innen], [Ein verständliches, responsives und zuverlässig funktionierendes Bewerbungsformular], [Füllen ein öffentlich geteiltes und optional geschütztes Formular aus],
  [Verantwortliche der Gesellschaft], [Ein fairer, dokumentierbarer Vergabeprozess; die endgültige Entscheidung bleibt in ihrer Verantwortung], [Verantworten Kriterien und Vergabeentscheid],
  [Entwickler/in und Betreiber/in], [Verständliche Struktur, testbare Fachlogik und reproduzierbarer Betrieb], [Entwickelt, wartet und betreibt das System],
  [Dozent/in], [Nachvollziehbare Erfüllung der Projektanforderungen], [Bewertet Artefakt, Vorgehen und Dokumentation],
)
