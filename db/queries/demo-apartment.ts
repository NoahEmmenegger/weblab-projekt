import "server-only";

import { eq, and } from "drizzle-orm";
import { getDb } from "@/db";
import { apartments, companies, listingApplications, listings } from "@/db/schema";
import type { Apartment } from "@/db/queries/apartments";
import type { ApplicationAnswer, ApplicationField, Listing } from "@/lib/listing-types";

const fields: ApplicationField[] = [
  { id: "name", label: "Vor- und Nachname", type: "text", required: true, weight: 0 },
  { id: "email", label: "E-Mail-Adresse", type: "email", required: true, weight: 0 },
  { id: "phone", label: "Telefonnummer", type: "text", required: true, weight: 0 },
  { id: "household", label: "Anzahl Personen im Haushalt", type: "number", required: true, preference: { mode: "number-closest", ideal: "3" }, weight: 60 },
  { id: "currentHome", label: "Aktuelle Wohnsituation", type: "textarea", required: true, weight: 0 },
  { id: "reason", label: "Warum möchtest du in einer Genossenschaft wohnen?", type: "textarea", required: true, weight: 0 },
  { id: "moveIn", label: "Gewünschter Einzugstermin", type: "date", required: true, preference: { mode: "date-closest", ideal: "2027-01-01" }, weight: 40 },
  { id: "membership", label: "Bist du bereits Mitglied einer Wohnbaugenossenschaft?", type: "checkbox", required: false, weight: 0 },
  { id: "agreement", label: "Ich bestätige, dass meine Angaben korrekt sind.", type: "checkbox", required: true, weight: 0 },
];

const exampleAnswers: Record<string, ApplicationAnswer>[] = [
  { name: "Mira Beispiel", email: "mira@example.invalid", phone: "079 000 00 01", household: "3", currentHome: "Wir wohnen zu dritt in einer kleinen Zweizimmerwohnung.", reason: "Wir möchten uns langfristig in der Hausgemeinschaft engagieren.", moveIn: "2027-01-01", membership: true, agreement: true },
  { name: "Jonas Muster", email: "jonas@example.invalid", phone: "079 000 00 02", household: "2", currentHome: "Unsere jetzige Wohnung wurde auf Ende Jahr gekündigt.", reason: "Ich schätze gemeinschaftlich genutzte Räume und eine langfristige Wohnperspektive.", moveIn: "2026-12-01", membership: false, agreement: true },
  { name: "Lea Demo", email: "lea@example.invalid", phone: "079 000 00 03", household: "4", currentHome: "Wir suchen für unsere Familie eine passendere Wohnung.", reason: "Wir möchten Teil einer nachbarschaftlichen Gemeinschaft werden.", moveIn: "2027-03-01", membership: false, agreement: true },
];

export async function insertDemoApartmentForOwner(ownerUserId: string, companyId: string): Promise<{ apartment: Apartment; listing: Listing } | null> {
  return getDb().transaction(async (tx) => {
    const [company] = await tx.select({ id: companies.id }).from(companies)
      .where(and(eq(companies.id, companyId), eq(companies.ownerUserId, ownerUserId)));
    if (!company) return null;

    const [apartment] = await tx.insert(apartments).values({
      companyId,
      name: "Beispielwohnung Genossenschaft",
      unitIdentifier: `BEISPIEL-${crypto.randomUUID().slice(0, 8).toUpperCase()}`,
      rooms: 3,
      location: "Zürich · Musterstrasse 12",
    }).returning({ id: apartments.id, companyId: apartments.companyId, name: apartments.name, unitIdentifier: apartments.unitIdentifier, rooms: apartments.rooms, location: apartments.location });
    const [listing] = await tx.insert(listings).values({
      apartmentId: apartment.id,
      title: "Beispiel: 3-Zimmer-Genossenschaftswohnung",
      description: "Fiktive Beispielwohnung zum Kennenlernen des Bewerbungsablaufs. Alle vorhandenen Bewerbungen sind erfunden. Die Gewichtungen illustrieren nur die Sortierfunktion und sind keine Vergaberegeln.",
      fields,
      isPublished: true,
    }).returning();
    await tx.insert(listingApplications).values(exampleAnswers.map((answers) => ({ listingId: listing.id, answers, fields })));
    return { apartment, listing: { ...listing, applicationCount: exampleAnswers.length } };
  });
}
