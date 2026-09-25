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
  [Authentisierung], [Benutzeranmeldung für Gesellschaften], [Schützt den Verwaltungsbereich und die Bewerbungsdaten.],
  [Tests], [Node.js-Test-Runner für Unit- und Datenbank-Integrationstests], [Gewichtung, Bewertungsregeln, Ranking, Persistenz und Berechtigungen werden automatisch geprüft.],
  [Betrieb], [Docker Compose], [Compose startet Web-Anwendung, Migration und PostgreSQL in definierter Reihenfolge. Ein Volume persistiert die Datenbankdaten.],
  [Versionsverwaltung], [Git und GitHub], [Nachvollziehbare Entwicklung und gemeinsame Ablage aller Artefakte.],
)

== Architekturansatz

Die Anwendung ist als modular strukturierter Monolith umgesetzt. Der Next.js App Router, React-Komponenten, serverseitige Endpunkte und Fachlogik befinden sich in derselben Next.js-Anwendung und werden gemeinsam ausgeliefert. Ein eigenständiges Express-Backend entfällt. Innerhalb des Monolithen sind Ausschreibungen, Formulare, Bewertung, Bewerbungen, Benutzerverwaltung und Export in eigenen Modulen gegliedert.

Next.js Server Components sind der Standard für Layouts und nicht interaktive Darstellung. Navigation, Footer und datenlesende Seiten werden serverseitig gerendert. Client Components bilden nur die interaktiven Teilbäume, die Browserzustand, Ereignisbehandlung oder unmittelbare Aktualisierungen benötigen, beispielsweise dynamische Formularfelder, Filter und Sortierungen. Damit wird nur so viel JavaScript wie nötig an den Browser ausgeliefert, ohne auf eine reaktive Bedienung zu verzichten.

Die Bewertung erfolgt regelbasiert. Für jedes gewichtete Feld werden die Antworten der Bewerbungen paarweise verglichen: Eine bessere Antwort erhält die Gewichtung als Punkte, ein Gleichstand die Hälfte. Die Summe der Beiträge ergibt den Gesamtwert. Die Rangfolge hängt damit auch von den übrigen Bewerbungen ab. Das Dashboard und der CSV-Export weisen die Beiträge der einzelnen Kriterien aus.

PostgreSQL speichert die fachlichen Daten. Schreiboperationen werden serverseitig validiert. Docker Compose beschreibt die Laufzeitservices `web`, `migrate` und `db`, ihr internes Netzwerk, die Datenbankkonfiguration und ein persistentes Volume.

Im aktuellen Stand sind Anmeldung, Gesellschaften, Wohnungen, Ausschreibungen, öffentliche Bewerbungsformulare und CSV-Export umgesetzt. Server Components laden geschützte beziehungsweise öffentliche Daten; Server Actions prüfen und speichern Änderungen über Drizzle in PostgreSQL. `GET /api/applications` bleibt als einfacher technischer Leseendpunkt vorhanden.

== Entwicklungsvorgehen

Die Umsetzung begann mit Datenbankanbindung und einem einfachen API-Endpunkt. Anschliessend wurden Anmeldung, Gesellschaften, Wohnungen und der Ablauf von der Ausschreibung bis zur Bewerbung integriert. Antwortpräferenzen, Gewichtung, Rangliste und Export ergänzten diesen Kernablauf. Architekturentscheidungen sind als ADR festgehalten; das Arbeitsjournal dokumentiert die zeitliche Entwicklung.
