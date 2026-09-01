= Querschnittliche Konzepte

== Domänenmodell und Persistenz

// Wichtigste Entitäten, Beziehungen, Regeln, Migrationen und Transaktionsgrenzen.

[Domänen-/Datenmodell mit kurzer Erklärung]

== API- und Schnittstellendesign

[Routen/Operationen, Datenformate, Validierung, Versionierung und Fehlerantworten]

== Benutzeroberfläche und Responsive Design

[Layoutprinzipien, Breakpoints, Barrierefreiheit und die zwei Darstellungsformen]

== Fehlerbehandlung und Logging

[Fehlerkategorien, Meldungen für Benutzer/innen, technische Logs und Datenschutz]

== Sicherheit

[Eingabevalidierung, Geheimnisse, Abhängigkeiten, Authentisierung/Autorisierung – soweit relevant]

== Testkonzept

#table(
  columns: (22%, 38%, 40%),
  table.header([*Teststufe*], [*Zweck*], [*Beispiele/Werkzeuge*]),
  [Unit], [Fachlogik isoliert prüfen], [[Werkzeug und zentrale Fälle]],
  [Integration], [Datenbank und Schnittstellen prüfen], [[Werkzeug und zentrale Fälle]],
  [E2E], [Kritische User Journeys prüfen], [[Werkzeug und zentrale Fälle]],
  [Qualität], [Performance, Accessibility und Best Practices], [Lighthouse Mobile und Desktop],
)
