#import "../template/hslu.typ": placeholder

= Kontextabgrenzung

== Fachlicher Kontext

#placeholder[Füge ein Systemkontextdiagramm ein. Zeige das System als Blackbox, alle Nutzergruppen sowie angebundene Fremdsysteme. Beschreibe die ein- und ausgehenden Informationen.]

```text
Nutzer:in ── Interaktion ──> Webanwendung ── Daten ──> Externes System
```

== Technischer Kontext

#table(
  columns: (34mm, 34mm, 1fr),
  inset: 6pt,
  table.header([*Schnittstelle*], [*Technologie*], [*Zweck / Daten*]),
  [Browser ↔ Anwendung], [HTTPS], [Benutzeroberfläche und fachliche Interaktionen],
  [Anwendung ↔ Datenbank], [Zu definieren], [Persistente Speicherung der Kernressource],
)

== Abgrenzung

#placeholder[Halte explizit fest, welche Funktionen, Nutzergruppen und Integrationen nicht Teil des Projekts sind.]
