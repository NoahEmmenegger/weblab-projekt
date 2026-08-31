#import "../template/hslu.typ": placeholder

= Projektauftrag

== Kontext

#placeholder[Beschreibe in 3-5 Sätzen das fachliche Problem, die Zielgruppe und den Nutzen der Anwendung. Erkläre auch, weshalb sich das Vorhaben für das Web Programming Lab eignet.]

== User Stories

Die Anforderungen werden nach MoSCoW priorisiert. Jede Story sollte klein, prüfbar und aus Sicht einer Nutzerrolle formuliert sein.

#table(
  columns: (18mm, 1fr, 22mm),
  inset: 6pt,
  table.header([*Priorität*], [*User Story*], [*Status*]),
  [Must], [Als Benutzer:in möchte ich …, damit …], [Offen],
  [Should], [Als Benutzer:in möchte ich …, damit …], [Offen],
  [Could], [Als Benutzer:in möchte ich …, damit …], [Offen],
  [Won't], [Als Benutzer:in möchte ich …; dies ist in dieser Iteration bewusst nicht enthalten.], [Abgegrenzt],
)

== Angedachter Technologie-Stack

#placeholder[Dokumentiere Frontend, Backend, Datenbank, Testwerkzeuge, Deployment und zentrale Bibliotheken. Begründe insbesondere neue oder im Unterricht noch nicht behandelte Technologien.]

== Abnahmekriterien des Moduls

- CRUD für eine selbst definierte Ressource
- Persistenz in einer Datenbank
- Mindestens zwei inhaltlich unterschiedliche Darstellungsformen
- Responsive Darstellung für Desktop, Tablet und Mobile
- Sinnvolle automatisierte Unit-, Integrations- und E2E-Tests
- Lighthouse-Durchschnitt von mindestens 90 für Mobile und Desktop
- Reproduzierbar startbares Produktions-Bundle (öffentliche URL oder `docker compose up`)
- Lesbarer, erweiterbarer und sinnvoll strukturierter Code
