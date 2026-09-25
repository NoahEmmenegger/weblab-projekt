import "server-only";

import { and, count, desc, eq, inArray } from "drizzle-orm";
import { getDb } from "@/db";
import { apartments, companies, listingApplications, listings } from "@/db/schema";
import type { ApplicationAnswer, ApplicationField, Listing, ListingDraft, SubmittedApplication } from "@/lib/listing-types";

export async function listListingsByOwner(ownerUserId: string): Promise<Listing[]> {
  const rows = await getDb().select({ listing: listings }).from(listings)
    .innerJoin(apartments, eq(listings.apartmentId, apartments.id))
    .innerJoin(companies, eq(apartments.companyId, companies.id))
    .where(eq(companies.ownerUserId, ownerUserId));
  if (!rows.length) return [];
  const counts = await getDb().select({ listingId: listingApplications.listingId, total: count() })
    .from(listingApplications).where(inArray(listingApplications.listingId, rows.map((row) => row.listing.id))).groupBy(listingApplications.listingId);
  const countById = new Map(counts.map((row) => [row.listingId, row.total]));
  return rows.map(({ listing }) => ({ ...listing, applicationCount: countById.get(listing.id) ?? 0 }));
}

export async function upsertListingForOwner(ownerUserId: string, apartmentId: string, draft: ListingDraft): Promise<Listing | null> {
  const [apartment] = await getDb().select({ id: apartments.id }).from(apartments)
    .innerJoin(companies, eq(apartments.companyId, companies.id))
    .where(and(eq(apartments.id, apartmentId), eq(companies.ownerUserId, ownerUserId)));
  if (!apartment) return null;
  const [listing] = await getDb().insert(listings).values({ apartmentId, ...draft })
    .onConflictDoUpdate({ target: listings.apartmentId, set: { ...draft, updatedAt: new Date() } }).returning();
  const [result] = await getDb().select({ total: count() }).from(listingApplications).where(eq(listingApplications.listingId, listing.id));
  return { ...listing, applicationCount: result.total };
}

export async function setListingPublicationForOwner(ownerUserId: string, listingId: string, isPublished: boolean): Promise<Listing | null> {
  if (!await findListingForOwner(ownerUserId, listingId)) return null;
  const [listing] = await getDb().update(listings).set({ isPublished, updatedAt: new Date() })
    .where(eq(listings.id, listingId)).returning();
  if (!listing) return null;
  const [result] = await getDb().select({ total: count() }).from(listingApplications).where(eq(listingApplications.listingId, listing.id));
  return { ...listing, applicationCount: result.total };
}

export async function findListingForOwner(ownerUserId: string, listingId: string) {
  const [row] = await getDb().select({ listing: listings }).from(listings)
    .innerJoin(apartments, eq(listings.apartmentId, apartments.id))
    .innerJoin(companies, eq(apartments.companyId, companies.id))
    .where(and(eq(listings.id, listingId), eq(companies.ownerUserId, ownerUserId)));
  return row?.listing ?? null;
}

export async function findPublishedListing(listingId: string) {
  const [row] = await getDb().select({ listing: listings, apartment: apartments }).from(listings)
    .innerJoin(apartments, eq(listings.apartmentId, apartments.id))
    .where(and(eq(listings.id, listingId), eq(listings.isPublished, true)));
  return row ?? null;
}

export async function insertApplication(listingId: string, answers: Record<string, ApplicationAnswer>, fields: ApplicationField[]) {
  const [application] = await getDb().insert(listingApplications).values({ listingId, answers, fields }).returning({ id: listingApplications.id });
  return application.id;
}

export async function listApplicationsForOwner(ownerUserId: string, listingId: string): Promise<SubmittedApplication[] | null> {
  if (!await findListingForOwner(ownerUserId, listingId)) return null;
  const rows = await getDb().select().from(listingApplications)
    .where(eq(listingApplications.listingId, listingId)).orderBy(desc(listingApplications.createdAt));
  return rows.map((row) => ({ ...row, createdAt: row.createdAt.toISOString() }));
}
