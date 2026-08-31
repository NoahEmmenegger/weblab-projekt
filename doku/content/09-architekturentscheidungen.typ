#import "../template/hslu.typ": placeholder, decision

= Architekturentscheidungen

Architekturentscheidungen werden als kurze ADRs (Architecture Decision Records) gepflegt. Statuswerte sind beispielsweise _Vorgeschlagen_, _Akzeptiert_, _Ersetzt_ oder _Verworfen_.

#decision("ADR-001", "Technologie-Stack", [
  *Kontext:* #placeholder[Welche Anforderungen und Einschränkungen treiben die Wahl?]

  *Entscheidung:* #placeholder[Welche Technologien werden eingesetzt?]

  *Alternativen:* #placeholder[Welche realistischen Optionen wurden verglichen?]

  *Konsequenzen:* #placeholder[Welche positiven und negativen Folgen entstehen?]
])

#v(10pt)

#decision("ADR-002", "Deployment-Modell", [
  *Kontext:* Öffentliche URL und Docker Compose sind zulässige Abgabeformen.

  *Entscheidung:* #placeholder[Gewählte Variante und konkrete Plattform festhalten.]

  *Konsequenzen:* #placeholder[Betrieb, Kosten, Secrets, Datenpersistenz und Reproduzierbarkeit erläutern.]
])
