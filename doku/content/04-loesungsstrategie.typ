#import "../template/hslu.typ": placeholder

= Lösungsstrategie

#placeholder[Beschreibe die wenigen zentralen Architekturentscheidungen, mit denen die Qualitätsziele und Randbedingungen erreicht werden. Eine Seite genügt meist.]

#table(
  columns: (36mm, 1fr, 1fr),
  inset: 6pt,
  table.header([*Treiber*], [*Lösungsansatz*], [*Begründung*]),
  [Responsive Nutzung], [Mobile-first UI], [Kleine Ansichten werden früh berücksichtigt.],
  [Nachweisbare Qualität], [Automatisierte Testpyramide], [Fehler werden früh und reproduzierbar erkannt.],
  [Reproduzierbarer Betrieb], [Container oder Managed Deployment], [Die Abgabe kann eindeutig gestartet werden.],
)
