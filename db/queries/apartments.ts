import "server-only";

import { and, asc, eq } from "drizzle-orm";
import { db } from "@/db";
import { apartments, companies } from "@/db/schema";

const apartmentColumns = {
  id: apartments.id,
  companyId: apartments.companyId,
  name: apartments.name,
  unitIdentifier: apartments.unitIdentifier,
  rooms: apartments.rooms,
  location: apartments.location,
};

export type Apartment = { id: string; companyId: string; name: string; unitIdentifier: string; rooms: number; location: string };

export async function listApartmentsByOwner(ownerUserId: string): Promise<Apartment[]> {
  return db.select(apartmentColumns)
    .from(apartments)
    .innerJoin(companies, eq(apartments.companyId, companies.id))
    .where(eq(companies.ownerUserId, ownerUserId))
    .orderBy(asc(apartments.createdAt));
}

async function companyBelongsToOwner(ownerUserId: string, companyId: string) {
  const [company] = await db.select({ id: companies.id }).from(companies)
    .where(and(eq(companies.id, companyId), eq(companies.ownerUserId, ownerUserId)));
  return Boolean(company);
}

async function apartmentBelongsToOwner(ownerUserId: string, apartmentId: string) {
  const [apartment] = await db.select({ id: apartments.id }).from(apartments)
    .innerJoin(companies, eq(apartments.companyId, companies.id))
    .where(and(eq(apartments.id, apartmentId), eq(companies.ownerUserId, ownerUserId)));
  return Boolean(apartment);
}

export async function insertApartmentForOwner(ownerUserId: string, values: Omit<Apartment, "id">): Promise<Apartment | null> {
  if (!await companyBelongsToOwner(ownerUserId, values.companyId)) return null;
  const [apartment] = await db.insert(apartments).values(values).returning(apartmentColumns);
  return apartment ?? null;
}

export async function updateApartmentForOwner(ownerUserId: string, apartmentId: string, values: Omit<Apartment, "id" | "companyId">): Promise<Apartment | null> {
  if (!await apartmentBelongsToOwner(ownerUserId, apartmentId)) return null;
  const [apartment] = await db.update(apartments).set({ ...values, updatedAt: new Date() })
    .where(eq(apartments.id, apartmentId)).returning(apartmentColumns);
  return apartment ?? null;
}

export async function deleteApartmentForOwner(ownerUserId: string, apartmentId: string): Promise<boolean> {
  if (!await apartmentBelongsToOwner(ownerUserId, apartmentId)) return false;
  const [apartment] = await db.delete(apartments).where(eq(apartments.id, apartmentId)).returning({ id: apartments.id });
  return Boolean(apartment);
}
