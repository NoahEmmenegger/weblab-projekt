import "server-only";

import { asc } from "drizzle-orm";
import { db } from "@/db";
import { applications } from "@/db/schema";

export async function listApplications() {
  return db.select().from(applications).orderBy(asc(applications.id));
}
