#import "config.typ": project
#import "template/hslu.typ": hslu-document, placeholder, decision

#show: body => hslu-document(project, body)

#include "content/00-projektauftrag.typ"
#include "content/01-einfuehrung-und-ziele.typ"
#include "content/02-randbedingungen.typ"
#include "content/03-kontextabgrenzung.typ"
#include "content/04-loesungsstrategie.typ"
#include "content/05-bausteinsicht.typ"
#include "content/06-laufzeitsicht.typ"
#include "content/07-verteilungssicht.typ"
#include "content/08-querschnittliche-konzepte.typ"
#include "content/09-architekturentscheidungen.typ"
#include "content/10-qualitaetsanforderungen.typ"
#include "content/11-risiken-und-technische-schulden.typ"
#include "content/12-glossar.typ"
#include "content/90-fazit-und-reflexion.typ"
#include "content/91-arbeitsjournal.typ"
