import { asc } from "drizzle-orm";

import { db } from "@/db";
import { applications } from "@/db/schema";

// GET /api/applications
// PostgreSQL -> Drizzle ORM -> JSON HTTP response
export async function GET() {
  const applicationRows = await db
    .select()
    .from(applications)
    .orderBy(asc(applications.id));

  return Response.json({ applications: applicationRows });
}
