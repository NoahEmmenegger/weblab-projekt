"use server";

import { insertCompanyForOwner, updateCompanyForOwner } from "@/db/queries/companies";
import { getCurrentUser } from "@/lib/auth";

export type Company = { id: string; name: string; location: string };

async function requireUser() {
  const user = await getCurrentUser();
  if (!user) throw new Error("Nicht angemeldet.");
  return user;
}

function validateCompany(name: string, location: string) {
  const cleanName = name.trim();
  const cleanLocation = location.trim() || "Schweiz";
  if (!cleanName || cleanName.length > 150 || cleanLocation.length > 150) throw new Error("Bitte gib einen gültigen Namen und Ort ein.");
  return { name: cleanName, location: cleanLocation };
}

export async function createCompany(name: string, location: string): Promise<Company> {
  const user = await requireUser();
  const values = validateCompany(name, location);
  return insertCompanyForOwner(user.id, values.name, values.location);
}

export async function updateCompany(companyId: string, name: string, location: string): Promise<Company> {
  const user = await requireUser();
  const values = validateCompany(name, location);
  const company = await updateCompanyForOwner(user.id, companyId, values.name, values.location);
  if (!company) throw new Error("Gesellschaft nicht gefunden.");
  return company;
}
