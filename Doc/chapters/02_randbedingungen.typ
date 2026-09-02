= Randbedingungen

Dieses Kapitel enthält Vorgaben, die den Lösungsraum des Projekts einschränken. Gewählte Technologien und Architekturansätze werden dagegen in Kapitel 4 beschrieben.

== Technische Randbedingungen

- Die Anwendung muss Daten persistent in einer Datenbank speichern.
- Die Benutzeroberfläche muss auf Desktop, Tablet und Mobile responsiv nutzbar sein.
- Automatisierte Unit-, Integrations- und/oder E2E-Tests müssen passend zu den Projektrisiken eingesetzt werden.
- Ein Produktions-Build muss über eine öffentliche URL oder mit `docker compose up` reproduzierbar startbar sein.
- Der durchschnittliche Lighthouse-Score muss für Mobile und Desktop mindestens 90 betragen.
- Sämtliche Artefakte werden in einem Git-Repository abgegeben.

== Organisatorische Randbedingungen

- Das Projekt wird als Einzelarbeit mit einem vorgesehenen persönlichen Arbeitsaufwand von rund 60 Stunden durchgeführt.
- Die Entwicklung erfolgt strukturiert und systematisch.
- Wesentliche Architekturentscheidungen müssen nachvollziehbar begründet werden.
- Die Dokumentation richtet sich an Software Engineers und bleibt kurz, präzise und diagrammorientiert.

== Konventionen

- Quellcode und Dokumentation werden gemeinsam mit Git versioniert.
- Die Architekturdokumentation orientiert sich an der Kapitelstruktur von arc42.
- Fachbegriffe werden im gesamten System und in der Dokumentation einheitlich verwendet; projektspezifische Begriffe werden im Glossar erläutert.
- Eine User Story gilt erst als abgeschlossen, wenn sie umgesetzt, angemessen getestet und in der Dokumentation beziehungsweise im Arbeitsjournal berücksichtigt ist.
