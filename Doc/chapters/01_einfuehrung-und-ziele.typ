= Einführung und Ziele

Dieses Kapitel beschreibt den fachlichen Anlass, den Umfang, die wichtigsten Qualitätsziele und die beteiligten Personen des Projekts.

== Aufgabenstellung

Immobiliengesellschaften und Genossenschaften möchten Wohnungsvergaben möglichst fair und nachvollziehbar durchführen. Heute müssen Ausschreibungen, Bewerbungsformulare und eingehende Bewerbungen häufig mit mehreren voneinander getrennten Hilfsmitteln verwaltet und manuell verglichen werden.

Im Rahmen des Projekts entstand eine webbasierte Plattform für die Vorbereitung und Durchführung von Wohnungsvergaben. Mitarbeitende einer Gesellschaft erstellen damit Wohnungsausschreibungen und individuelle Bewerbungsformulare. Sie definieren Antwortpräferenzen und deren Gewichtung. Eingehende Bewerbungen werden zentral gespeichert, anhand dieser Regeln miteinander verglichen und sortiert.

Die Plattform unterstützt die Entscheidungsfindung, trifft aber keine endgültige Vergabeentscheidung. Diese bleibt bei der zuständigen Person. Damit die Entscheidung überprüfbar bleibt, zeigt das System für jede Bewerbung transparent auf, wie die Gesamtbewertung zustande gekommen ist.

=== Fachlicher Umfang

Der ursprüngliche Projektvorschlag enthält die nach MoSCoW priorisierten User Stories. Die implementierte Anwendung deckt folgende Abläufe ab:

- Registrierung und Anmeldung von Mitarbeitenden sowie Verwaltung von Gesellschaften und Wohnungen.
- Erstellen, Bearbeiten, Veröffentlichen und Pausieren von Ausschreibungen mit individuellen Formularfeldern.
- Definition von Antwortpräferenzen und Gewichten für die Bewertung.
- Öffentliches Einreichen von Bewerbungen über einen Ausschreibungslink.
- Anzeige der Bewerbungen mit Rangfolge und Beiträgen der einzelnen Kriterien.
- Export der Bewerbungen und Bewertungen als CSV.

=== Abgrenzung

Die Systemgrenze umfasst keine automatische Vergabeentscheidung und keine externen Bewertungsdaten:

- Die Plattform trifft keine endgültige Vergabeentscheidung ohne menschliche Bestätigung.
- Es wird keine künstliche Intelligenz zur Bewertung oder Vorhersage der Eignung von Bewerber/innen eingesetzt.
- Es wird kein ausschreibungsübergreifender Score für Bewerber/innen erstellt.
- Es werden keine externen Datenquellen oder sozialen Netzwerke zur Bewertung verwendet.

== Qualitätsziele

#table(
  columns: (10%, 22%, 43%, 25%),
  table.header([*Prio*], [*Qualitätsziel*], [*Begründung*], [*Nachweis*]),
  [1], [Nachvollziehbarkeit], [Die Bewertung ergibt sich aus Antworten, Kriterien und Gewichtungen.], [Unit- und Integrationstests],
  [2], [Benutzbarkeit], [Die Kernaufgaben sind auf Desktop und Mobile verständlich bedienbar.], [Responsive Layouts und verständliche Rückmeldungen],
  [3], [Zuverlässigkeit], [Ausschreibungen und Bewerbungen werden persistent und konsistent gespeichert.], [Datenbank-Integrationstest],
  [4], [Änderbarkeit], [Die Anwendung ist in klar benannte Module gegliedert.], [Bausteinsicht und automatisierte Tests],
)

== Stakeholder

#table(
  columns: (26%, 38%, 36%),
  table.header([*Stakeholder*], [*Erwartung*], [*Bezug zum System*]),
  [Mitarbeitende einer Immobiliengesellschaft oder Genossenschaft], [Einfache Verwaltung von Ausschreibungen und Bewerbungen sowie nachvollziehbare Entscheidungsgrundlagen], [Hauptbenutzer/innen des geschützten Verwaltungsbereichs],
  [Bewerber/innen], [Ein verständliches, responsives und zuverlässig funktionierendes Bewerbungsformular], [Füllen ein öffentlich geteiltes Formular aus],
  [Verantwortliche der Gesellschaft], [Ein fairer, dokumentierbarer Vergabeprozess; die endgültige Entscheidung bleibt in ihrer Verantwortung], [Verantworten Kriterien und Vergabeentscheid],
  [Entwickler/in und Betreiber/in], [Verständliche Struktur, testbare Fachlogik und reproduzierbarer Betrieb], [Entwickelt, wartet und betreibt das System],
  [Dozent/in], [Nachvollziehbare Erfüllung der Projektanforderungen], [Bewertet Artefakt, Vorgehen und Dokumentation],
)
