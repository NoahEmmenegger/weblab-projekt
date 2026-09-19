= Architekturentscheidungen

Entscheidungen werden als kurze Architecture Decision Records (ADR) festgehalten. Eine Entscheidung beschreibt Kontext und Folgen, nicht nur das gewählte Werkzeug.

== ADR-001: Next.js statt getrenntem React-Frontend und Express-Backend

#table(
  columns: (25%, 75%),
  [*Status*], [Akzeptiert am 2. September 2026],
  [*Kontext*], [Ursprünglich waren ein React-Frontend und ein separates Express-Backend vorgesehen. Für die Einzelarbeit sollen Routing, Typen, Betrieb und Deployment mit wenig Doppelkonfiguration beherrschbar bleiben. Serverseitige Validierung und geschützter Datenzugriff sind erforderlich.],
  [*Betrachtete Optionen*], [1. React-SPA mit Express-API; 2. Next.js als Full-Stack-Framework; 3. getrennte Frontend- und Backend-Anwendungen in einem Monorepo.],
  [*Entscheidung*], [Next.js mit App Router und TypeScript wird als modularer Monolith eingesetzt. Server Components rendern Navigation, Footer, Layouts und datenlesende Seiten. Client Components übernehmen interaktive Teilbereiche. Route Handlers und/oder Server Actions bilden serverseitige Endpunkte; ein Express-Service entfällt.],
  [*Begründung*], [Next.js bündelt Routing, Rendering und Backend-Funktionen. Gemeinsame Typen und ein Artefakt reduzieren Schnittstellen- und Betriebsaufwand. Serverorientiertes Rendering begrenzt das Browser-JavaScript und passt zum Projektumfang.],
  [*Konsequenzen*], [Weniger Konfiguration und kein separates API-Deployment stehen einer Bindung an Next.js-Konventionen gegenüber. Klare Modulgrenzen, kleine Client-Inseln, ausschliesslich serverseitiger Datenbankzugriff und automatisierte Tests verhindern eine Vermischung der Verantwortlichkeiten.],
)

#pagebreak(weak: true)

== ADR-002: PostgreSQL und gemeinsamer Start mit Docker Compose

#table(
  columns: (25%, 75%),
  [*Status*], [Akzeptiert am 2. September 2026],
  [*Kontext*], [Ausschreibungen, dynamische Formulare, Kriterien, Gewichtungen, Bewerbungen und Bewertungen stehen in engen Beziehungen und müssen konsistent gespeichert werden. Die lokale Laufzeitumgebung soll auf verschiedenen Rechnern mit einem Befehl reproduzierbar sein.],
  [*Betrachtete Optionen*], [1. Eingebettete Datenbank; 2. lokal manuell installierte PostgreSQL-Datenbank; 3. PostgreSQL als Docker-Service zusammen mit der containerisierten Next.js-Anwendung.],
  [*Entscheidung*], [PostgreSQL wird als Service `db` betrieben. Die Next.js-Anwendung läuft als Service `app`. Docker Compose definiert Build, Netzwerk, Healthcheck, Umgebungsvariablen und ein persistentes Datenbank-Volume. Der gesamte Stack startet mit `docker compose up --build`.],
  [*Begründung*], [PostgreSQL unterstützt relationale Integrität und Transaktionen für das verknüpfte Fachmodell. Docker Compose vereinheitlicht Versionen und Startablauf, ohne eine lokal installierte Datenbank vorauszusetzen.],
  [*Konsequenzen*], [Docker ist für die lokale Ausführung erforderlich und benötigt zusätzliche Ressourcen. Datenbankmigrationen, Secrets sowie Backup und Restore bleiben explizite Betriebsaufgaben. Der Datenbankport wird standardmässig nicht nach aussen veröffentlicht; ein Volume verhindert Datenverlust bei einer Neuerstellung des Containers.],
)

#pagebreak(weak: true)

== ADR-003: Drizzle ORM statt Prisma

#table(
  columns: (25%, 75%),
  [*Status*], [Akzeptiert am 18. September 2026],
  [*Kontext*], [Die Next.js-Anwendung benötigt einen typsicheren Zugriff auf PostgreSQL sowie versionierte Migrationen. Der technische Kern soll klein bleiben und SQL-Abfragen nachvollziehbar machen.],
  [*Betrachtete Optionen*], [1. Direkter Zugriff mit `pg`; 2. Prisma; 3. Drizzle ORM.],
  [*Entscheidung*], [Drizzle ORM wird mit dem `node-postgres`-Treiber eingesetzt. Tabellen werden in `db/schema.ts` definiert; Drizzle Kit erzeugt und wendet Migrationen im Verzeichnis `drizzle/` an.],
  [*Begründung*], [Drizzle verbindet aus dem TypeScript-Schema abgeleitete Typen mit SQL-nahen Abfragen. Gegenüber Prisma benötigt es keinen zusätzlichen Generierungsschritt für einen Client und hält die Abfragen für das kleine Projekt direkt lesbar. Gegenüber reinem `pg` reduziert es wiederholte Typdefinitionen und strukturiert Schema-Migrationen.],
  [*Konsequenzen*], [Datenbankzugriff bleibt auf Node.js-Routen beschränkt. Schemaänderungen benötigen weiterhin eine erzeugte und kontrolliert angewendete Migration. Teammitglieder müssen die Drizzle-Abfrage- und Migrationskonventionen kennen.],
)
