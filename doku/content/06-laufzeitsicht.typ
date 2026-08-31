#import "../template/hslu.typ": placeholder

= Laufzeitsicht

== Kernablauf: Ressource erstellen

#placeholder[Ersetze den Ablauf durch ein Sequenzdiagramm und beschreibe nur architektonisch relevante Schritte, Fehlerfälle und Transaktionsgrenzen.]

1. Nutzer:in erfasst Daten im Frontend.
2. Das Frontend validiert offensichtliche Eingabefehler und sendet die Anfrage.
3. Das Backend validiert fachliche Regeln.
4. Die Datenbank speichert die Ressource atomar.
5. Das Backend liefert das Ergebnis; das Frontend aktualisiert die Darstellung.

== Weitere relevante Szenarien

- Ressource lesen, ändern und löschen
- Alternative Darstellungsform laden
- Fehlerfall bei ungültigen Daten
- Fehlerfall bei nicht verfügbarem Backend oder Datenspeicher
