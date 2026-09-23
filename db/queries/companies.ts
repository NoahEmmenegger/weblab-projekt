import "server-only";

import { and, eq } from "drizzle-orm";
import { db } from "@/db";
import { companies } from "@/db/schema";

const companyColumns = { id: companies.id, name: companies.name, location: companies.location };

export type Company = { id: string; name: string; location: string };

export async function listCompaniesByOwner(ownerUserId: string): Promise<Company[]> {
  return db.select(companyColumns)
    .from(companies)
    .where(eq(companies.ownerUserId, ownerUserId))
    .orderBy(companies.createdAt);
}

export async function insertCompanyForOwner(ownerUserId: string, name: string, location: string): Promise<Company> {
  const [company] = await db.insert(companies)
    .values({ ownerUserId, name, location })
    .returning(companyColumns);

  return company;
}

export async function updateCompanyForOwner(ownerUserId: string, companyId: string, name: string, location: string): Promise<Company | null> {
  const [company] = await db.update(companies)
    .set({ name, location, updatedAt: new Date() })
    .where(and(eq(companies.id, companyId), eq(companies.ownerUserId, ownerUserId)))
    .returning(companyColumns);

  return company ?? null;
}
