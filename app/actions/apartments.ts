"use server";

import { insertApartmentForOwner, updateApartmentForOwner, deleteApartmentForOwner, type Apartment } from "@/db/queries/apartments";
import { getCurrentUser } from "@/lib/auth";

async function requireUser() {
  const user = await getCurrentUser();
  if (!user) throw new Error("Nicht angemeldet.");
  return user;
}

function validateApartment(name: string, unitIdentifier: string, rooms: number, location: string) {
  const cleaned = { name: name.trim(), unitIdentifier: unitIdentifier.trim(), location: location.trim() };
  if (!cleaned.name || !cleaned.unitIdentifier || !cleaned.location || cleaned.name.length > 150 || cleaned.unitIdentifier.length > 80 || cleaned.location.length > 250) {
    throw new Error("Bitte fülle Name, Wohnungsnummer und Standort gültig aus.");
  }
  if (!Number.isInteger(rooms) || rooms < 1 || rooms > 100) throw new Error("Bitte gib eine Zimmerzahl zwischen 1 und 100 an.");
  return { ...cleaned, rooms };
}

function uniqueUnitError(error: unknown) {
  return typeof error === "object" && error !== null && "code" in error && error.code === "23505";
}

export async function createApartment(companyId: string, name: string, unitIdentifier: string, rooms: number, location: string): Promise<Apartment> {
  const user = await requireUser();
  const values = validateApartment(name, unitIdentifier, rooms, location);
  try {
    const apartment = await insertApartmentForOwner(user.id, { companyId, ...values });
    if (!apartment) throw new Error("Gesellschaft nicht gefunden.");
    return apartment;
  } catch (error) {
    if (uniqueUnitError(error)) throw new Error("Diese Wohnungsnummer gibt es in der Gesellschaft bereits.");
    throw error;
  }
}

export async function updateApartment(apartmentId: string, name: string, unitIdentifier: string, rooms: number, location: string): Promise<Apartment> {
  const user = await requireUser();
  const values = validateApartment(name, unitIdentifier, rooms, location);
  try {
    const apartment = await updateApartmentForOwner(user.id, apartmentId, values);
    if (!apartment) throw new Error("Wohnung nicht gefunden.");
    return apartment;
  } catch (error) {
    if (uniqueUnitError(error)) throw new Error("Diese Wohnungsnummer gibt es in der Gesellschaft bereits.");
    throw error;
  }
}

export async function deleteApartment(apartmentId: string): Promise<void> {
  const user = await requireUser();
  if (!await deleteApartmentForOwner(user.id, apartmentId)) throw new Error("Wohnung nicht gefunden.");
}
