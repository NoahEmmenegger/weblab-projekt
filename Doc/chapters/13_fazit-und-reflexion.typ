= Fazit und Reflexion

== Was ist gut gelaufen?

Ich konnte auf meine Erfahrung aus mehreren Next.js-Anwendungen und mit PostgreSQL zurückgreifen. Dadurch gelang der durchgängige Ablauf zügig. Die Trennung zwischen Oberfläche, Server Actions, Bewertungsfunktionen und Datenbankabfragen macht die Verantwortlichkeiten im Code nachvollziehbar.

Besonders bereichernd fand ich, mich im Unterricht wieder mit den Grundlagen und Eigenheiten von JavaScript auseinanderzusetzen. Nach der Arbeit mit vielen Frameworks fühlte sich dieser Blick zurück auf die Basics für mich fast nostalgisch an und machte zugleich Spass.

== Wo lagen die Herausforderungen?

Am schwierigsten war für mich zunächst die Wahl einer passenden Architektur. Während des Projekts bewarb ich mich auf eine Stelle, bei der Next.js, PostgreSQL und Docker eingesetzt werden. Ich entschied mich bewusst für diesen Stack: Er passte zum Projekt und gab mir Gelegenheit, mein Wissen für das anstehende technische Interview aufzufrischen und zu vertiefen.

Interessant war für mich dabei besonders Drizzle ORM. In früheren Projekten hatte ich Datenbankzugriffe stärker getrennt und teils direkt mit SQL gearbeitet. Mit Drizzle konnte ich nun Schema, typsichere Abfragen und versionierte Migrationen in einem für mich neuen Ansatz verbinden. Die dynamischen Formularfelder, Antwortpräferenzen und Gewichte verlangten ausserdem eine eindeutige serverseitige Validierung. Auch Migrationen und die Startreihenfolge der Docker-Container mussten aufeinander abgestimmt werden.

== Einsatz von KI

Ich habe KI während der Entwicklung als Unterstützung eingesetzt. Die Verantwortung für das Ergebnis blieb aber bei mir: Vorschläge und erzeugter Code mussten geprüft und an meine Architektur angepasst werden. Mehrfach schlug die KI etwas anderes vor, als ich beabsichtigt hatte. Gerade deshalb war es wichtig, ihre Antworten kritisch zu hinterfragen und technische Entscheidungen selbst zu treffen.

== Was würde ich beim nächsten Mal anders machen?

Rückblickend hätte ich konkrete Akzeptanzkriterien für die priorisierten User Stories früher festgelegt. Auch die Testfälle für Gewichtung und Ranking hätte ich parallel zur ersten Implementierung der Bewertungslogik schreiben können. So wären Abweichungen zwischen Projektvorschlag, Anwendung und Dokumentation früher sichtbar geworden.

== Zielerreichung

Umgesetzt wurden die Verwaltung von Gesellschaften und Wohnungen, individuelle Ausschreibungen, öffentliche Bewerbungsformulare, die gewichtete Auswertung eingegangener Bewerbungen und ein CSV-Export. Die Anwendung speichert ihre Daten in PostgreSQL und kann mit Docker Compose gestartet werden. Vier Unit-Tests und ein Datenbank-Integrationstest bestanden am 25.09.2026; Typecheck, Lint und Produktions-Build liefen ebenfalls erfolgreich. Die Bewertungsbeiträge sind für jede Bewerbung im Dashboard und im Export nachvollziehbar.

Einige im ursprünglichen Projektvorschlag als Must Have priorisierte Funktionen wurden im verfügbaren Zeitrahmen nicht mehr umgesetzt: eine auswertbare Musterbewerbung, das Sperren der Kriterien und Gewichtungen vor Beginn der Ausschreibung, ein optionaler Zugangsschlüssel für das öffentliche Formular und das Markieren einer ausgewählten Bewerbung. Ich priorisierte stattdessen den durchgängigen Ablauf von der Ausschreibung über die Bewerbung bis zur nachvollziehbaren Auswertung und zum Export sowie dessen stabilen Betrieb.
