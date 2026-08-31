# Projektdokumentation

Diese Dokumentation ist als Typst-Projekt aufgebaut und folgt der arc42-Struktur. Die für das Web Programming Lab zusätzlich verlangten Ergebnisse Projektauftrag, Fazit/Reflexion und Arbeitsjournal sind im selben Dokument enthalten.

## Schnellstart

1. Persönliche Angaben und Metadaten in `config.typ` anpassen.
2. Inhalte in `content/` laufend ergänzen.
3. Diagramme in `assets/diagrams/` ablegen und mit `#image(...)` einbinden.
4. PDF erzeugen:

   ```sh
   typst compile main.typ build/projektdokumentation.pdf
   ```

5. Während der Bearbeitung automatisch neu kompilieren:

   ```sh
   typst watch main.typ build/projektdokumentation.pdf
   ```

## Struktur

- `main.typ`: Einstiegspunkt und Reihenfolge der Kapitel
- `config.typ`: zentrale Projektmetadaten
- `template/hslu.typ`: HSLU-orientiertes Layout
- `content/`: Projektauftrag, arc42-Kapitel, Reflexion und Arbeitsjournal
- `assets/diagrams/`: Architekturdiagramme und Abbildungen
- `build/`: generierte PDF-Dateien (nicht manuell bearbeiten)

Das Layout ist HSLU-orientiert, aber keine offizielle Corporate-Design-Vorlage der Hochschule. Für eine formell verbindliche Abgabevorlage sind die aktuellen Vorgaben des Moduls bzw. der Hochschule massgebend.
