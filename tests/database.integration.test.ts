import assert from "node:assert/strict";
import test from "node:test";

import { eq } from "drizzle-orm";
import { rankApplications } from "../lib/answer-preferences";
import type { ApplicationField, SubmittedApplication } from "../lib/listing-types";

const testDatabaseUrl = process.env.TEST_DATABASE_URL;

test("Ausschreibung und Bewerbungen bleiben gespeichert und auswertbar", async () => {
  if (!testDatabaseUrl) {
    throw new Error("TEST_DATABASE_URL ist nicht gesetzt. Siehe README: Tests.");
  }
  if (testDatabaseUrl === process.env.DATABASE_URL) {
    throw new Error("TEST_DATABASE_URL muss eine separate Testdatenbank bezeichnen.");
  }
  if (!decodeURIComponent(new URL(testDatabaseUrl).pathname).endsWith("_test")) {
    throw new Error("Der Name der Testdatenbank muss auf _test enden.");
  }

  process.env.DATABASE_URL = testDatabaseUrl;
  const [{ getDb }, schema, queries] = await Promise.all([
    import("../db/index"),
    import("../db/schema"),
    import("../db/queries/listings"),
  ]);
  const db = getDb();
  const fields: ApplicationField[] = [
    { id: "household", label: "Haushaltsgrösse", type: "number", required: true, preference: { mode: "number-closest", ideal: "3" }, weight: 100 },
  ];
  const email = `test-${crypto.randomUUID()}@example.invalid`;
  const [user] = await db.insert(schema.users).values({ name: "Integrationstest", email, passwordHash: "test-only" }).returning({ id: schema.users.id });

  try {
    const [company] = await db.insert(schema.companies).values({ ownerUserId: user.id, name: "Testgesellschaft" }).returning({ id: schema.companies.id });
    const [apartment] = await db.insert(schema.apartments).values({ companyId: company.id, name: "Testwohnung", unitIdentifier: crypto.randomUUID(), rooms: 3, location: "Luzern" }).returning({ id: schema.apartments.id });
    const listing = await queries.upsertListingForOwner(user.id, apartment.id, { title: "Testausschreibung", description: "", fields });
    assert.ok(listing);
    await queries.insertApplication(listing.id, { household: "3" }, fields);
    await queries.insertApplication(listing.id, { household: "5" }, fields);

    const stored = await queries.listApplicationsForOwner(user.id, listing.id);
    assert.ok(stored);
    assert.equal(stored.length, 2);
    assert.deepEqual(stored[0].fields, fields);
    const outsider = await db.insert(schema.users).values({ name: "Andere Person", email: `outsider-${crypto.randomUUID()}@example.invalid`, passwordHash: "test-only" }).returning({ id: schema.users.id });
    try {
      assert.equal(await queries.listApplicationsForOwner(outsider[0].id, listing.id), null);
    } finally {
      await db.delete(schema.users).where(eq(schema.users.id, outsider[0].id));
    }
    const ranked = rankApplications(stored as SubmittedApplication[], fields);
    assert.equal(ranked[0].application.answers.household, "3");
    assert.equal(ranked[0].points, 100);
    assert.equal(ranked[1].points, 0);
  } finally {
    await db.delete(schema.users).where(eq(schema.users.id, user.id));
  }
});
