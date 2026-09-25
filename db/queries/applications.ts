import "server-only";

import { asc } from "drizzle-orm";
import { getDb } from "@/db";
import { applications } from "@/db/schema";

export async function listApplications() {
  return getDb().select().from(applications).orderBy(asc(applications.id));
}
