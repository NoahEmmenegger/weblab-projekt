= Lösungsstrategie

Dieses Kapitel fasst die grundlegenden Entscheidungen zusammen, mit denen die fachlichen Ziele und Qualitätsziele erreicht werden. Detaillierte und später revidierbare Entscheidungen werden in Kapitel 9 als Architecture Decision Records festgehalten.

== Technologie-Stack

#table(
  columns: (22%, 28%, 50%),
  table.header([*Bereich*], [*Technologie*], [*Begründung und Zielbeitrag*]),
  [Web-Framework], [Next.js mit App Router und TypeScript], [Routing, Frontend und Backend können in einer Anwendung entwickelt und als gemeinsames Artefakt ausgeliefert werden. TypeScript unterstützt die konsistente Modellierung der fachlichen Daten.],
  [Benutzeroberfläche], [React und Tailwind CSS], [Komponentenbasierte Umsetzung der Verwaltungsoberfläche und der dynamischen, responsiven Bewerbungsformulare.],
  [Backend], [Next.js Route Handlers und/oder Server Actions auf Node.js], [Serverseitige Validierung, Fachlogik und Datenzugriff bleiben innerhalb des Monolithen gebündelt; ein separater Express-Service entfällt.],
  [Datenbank], [PostgreSQL], [Relationale und transaktionale Speicherung der miteinander verknüpften Ausschreibungen, Kriterien und Bewerbungen.],
  [Datenzugriff], [Drizzle ORM], [Typsicherer, SQL-naher Datenzugriff; Tabellen und Migrationen bleiben direkt bei den TypeScript-Modellen.],
  [Authentisierung], [Einfache Benutzeranmeldung für Gesellschaften], [Schützt den Verwaltungsbereich; öffentlich geteilte Formulare können zusätzlich einen Zugangsschlüssel verlangen.],
  [Tests], [Node.js-Test-Runner für Unit- und Datenbank-Integrationstests], [Gewichtung, Bewertungsregeln und Ranking werden automatisch geprüft; ein separater Integrationstest prüft Persistenz und Auswertung in PostgreSQL. Browser-E2E-Tests sind noch offen.],
  [Betrieb], [Docker Compose und Dokploy als Deployment-Ziel], [Compose startet Web-Anwendung, Migration und PostgreSQL in definierter Reihenfolge. Ein Volume persistiert die Datenbankdaten; Dokploy ist für das automatische Deployment vorgesehen.],
  [Versionsverwaltung], [Git und GitHub], [Nachvollziehbare Entwicklung und gemeinsame Ablage aller Artefakte.],
  [CI/CD], [GitHub Actions und Dokploy (geplant)], [Typecheck, Lint und Build sollen vor einem automatischen Deploy-Trigger erfolgreich durchlaufen.],
)

== Architekturansatz

Die Anwendung wird als modular strukturierter Monolith umgesetzt. Der Next.js App Router, React-Komponenten, serverseitige Endpunkte und Fachlogik befinden sich in derselben Next.js-Anwendung und werden gemeinsam ausgeliefert. Ein eigenständiges Express-Backend und die damit verbundene zweite Projekt-, Schnittstellen- und Deployment-Konfiguration entfallen. Innerhalb des Monolithen werden die fachlichen Verantwortlichkeiten - insbesondere Ausschreibungen, Formulare, Kriterien und Bewertung, Bewerbungen, Benutzerverwaltung und Export - klar voneinander getrennt. Dadurch bleibt der Betrieb einfach, ohne auf eine nachvollziehbare und erweiterbare Struktur zu verzichten.

Next.js Server Components sind der Standard für Layouts und nicht interaktive Darstellung. Navigation, Footer und datenlesende Seiten werden serverseitig gerendert. Client Components bilden nur die interaktiven Teilbäume, die Browserzustand, Ereignisbehandlung oder unmittelbare Aktualisierungen benötigen, beispielsweise dynamische Formularfelder, Filter und Sortierungen. Damit wird nur so viel JavaScript wie nötig an den Browser ausgeliefert, ohne auf eine reaktive Bedienung zu verzichten.

Die Bewertung einer Bewerbung erfolgt regelbasiert und deterministisch. Antworten werden mit den vor Beginn einer Ausschreibung festgelegten Kriterien verglichen und anhand der gespeicherten Gewichtungen zu einer Gesamtbewertung zusammengeführt. Kriterien und Gewichtungen werden mit dem Start der Ausschreibung gesperrt. Neben dem Gesamtwert speichert beziehungsweise liefert die Anwendung die Beiträge der einzelnen Kriterien, damit das Ranking jederzeit erklärt und mit Berechnungsbeispielen getestet werden kann.

PostgreSQL stellt die konsistente Persistenz der fachlichen Daten sicher. Schreiboperationen werden serverseitig validiert. Docker Compose beschreibt die Laufzeitservices `web`, `migrate` und `db`, ihr internes Netzwerk, die Datenbankkonfiguration und ein persistentes Volume. Der geplante CI/CD-Prozess prüft Änderungen automatisiert und stösst anschliessend ein Deployment auf Dokploy an.

Im aktuellen Stand sind Anmeldung, Gesellschaften, Wohnungen, Ausschreibungen, öffentliche Bewerbungsformulare und CSV-Export umgesetzt. Server Components laden geschützte beziehungsweise öffentliche Daten; Server Actions prüfen und speichern Änderungen über Drizzle in PostgreSQL. `GET /api/applications` bleibt als einfacher technischer Leseendpunkt vorhanden.

== Entwicklungsvorgehen

Die Entwicklung erfolgt iterativ entlang der priorisierten User Stories. Zuerst wird ein durchgängiger Kernablauf von der Ausschreibung bis zur bewerteten Bewerbung umgesetzt; weitere Must-, Should- und Could-Have-Stories werden anschliessend in dieser Reihenfolge ergänzt. Jede Iteration umfasst Implementierung, angemessene automatisierte Tests, eine kurze Überprüfung der Qualitätsziele und einen Eintrag im Arbeitsjournal. Technisch riskante oder noch offene Entscheide werden früh mit kleinen Versuchen geprüft und als ADR dokumentiert.
