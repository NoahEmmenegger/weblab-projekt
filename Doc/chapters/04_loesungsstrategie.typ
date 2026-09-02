= Lösungsstrategie

Dieses Kapitel fasst die grundlegenden Entscheidungen zusammen, mit denen die fachlichen Ziele und Qualitätsziele erreicht werden. Detaillierte und später revidierbare Entscheidungen werden in Kapitel 9 als Architecture Decision Records festgehalten.

== Technologie-Stack

#table(
  columns: (22%, 28%, 50%),
  table.header([*Bereich*], [*Technologie*], [*Begründung und Zielbeitrag*]),
  [Web-Framework], [Next.js mit TypeScript], [Frontend und Backend können in einer Anwendung entwickelt und als gemeinsames Artefakt ausgeliefert werden. TypeScript unterstützt die konsistente Modellierung der fachlichen Daten.],
  [Benutzeroberfläche], [React und Tailwind CSS], [Komponentenbasierte Umsetzung der Verwaltungsoberfläche und der dynamischen, responsiven Bewerbungsformulare.],
  [Backend], [Next.js auf Node.js], [Serverseitige Validierung, Fachlogik und Datenzugriff bleiben innerhalb des Monolithen gebündelt.],
  [Datenbank], [PostgreSQL], [Relationale und transaktionale Speicherung der miteinander verknüpften Ausschreibungen, Kriterien und Bewerbungen.],
  [Datenzugriff], [Prisma oder Drizzle ORM; Entscheid offen], [Typsicherer Datenzugriff und nachvollziehbare Schema-Migrationen; die konkrete Bibliothek wird in einem ADR entschieden.],
  [Authentisierung], [Einfache Benutzeranmeldung für Gesellschaften], [Schützt den Verwaltungsbereich; öffentlich geteilte Formulare können zusätzlich einen Zugangsschlüssel verlangen.],
  [Tests], [Unit-, Integrations- und E2E-Tests; Werkzeuge noch offen], [Die deterministische Bewertungslogik, Datenintegrität und zentralen Benutzerabläufe werden automatisiert abgesichert.],
  [Betrieb], [Docker], [Ermöglicht einen reproduzierbaren Produktionsbetrieb und erfüllt die Abgabeanforderungen.],
  [Versionsverwaltung], [Git und GitHub], [Nachvollziehbare Entwicklung und gemeinsame Ablage aller Artefakte.],
)

== Architekturansatz

Die Anwendung wird als modular strukturierter Monolith umgesetzt. Frontend, Backend und Fachlogik befinden sich in derselben Next.js-Anwendung und werden gemeinsam ausgeliefert. Innerhalb des Monolithen werden die fachlichen Verantwortlichkeiten - insbesondere Ausschreibungen, Formulare, Kriterien und Bewertung, Bewerbungen, Benutzerverwaltung und Export - klar voneinander getrennt. Dadurch bleibt der Betrieb einfach, ohne auf eine nachvollziehbare und erweiterbare Struktur zu verzichten.

Die Bewertung einer Bewerbung erfolgt regelbasiert und deterministisch. Antworten werden mit den vor Beginn einer Ausschreibung festgelegten Kriterien verglichen und anhand der gespeicherten Gewichtungen zu einer Gesamtbewertung zusammengeführt. Kriterien und Gewichtungen werden mit dem Start der Ausschreibung gesperrt. Neben dem Gesamtwert speichert beziehungsweise liefert die Anwendung die Beiträge der einzelnen Kriterien, damit das Ranking jederzeit erklärt und mit Berechnungsbeispielen getestet werden kann.

PostgreSQL stellt die konsistente Persistenz der fachlichen Daten sicher. Schreiboperationen werden serverseitig validiert und für zusammengehörige Änderungen transaktional ausgeführt. Responsive Komponenten, automatisierte Tests der risikoreichen Abläufe und regelmässige Lighthouse-Messungen unterstützen die Qualitätsziele Benutzbarkeit, Zuverlässigkeit und Änderbarkeit.

== Entwicklungsvorgehen

Die Entwicklung erfolgt iterativ entlang der priorisierten User Stories. Zuerst wird ein durchgängiger Kernablauf von der Ausschreibung bis zur bewerteten Bewerbung umgesetzt; weitere Must-, Should- und Could-Have-Stories werden anschliessend in dieser Reihenfolge ergänzt. Jede Iteration umfasst Implementierung, angemessene automatisierte Tests, eine kurze Überprüfung der Qualitätsziele und einen Eintrag im Arbeitsjournal. Technisch riskante oder noch offene Entscheide werden früh mit kleinen Versuchen geprüft und als ADR dokumentiert.
