import { asc } from "drizzle-orm";

import { db } from "@/db";
import { applications } from "@/db/schema";

// GET /api/applications
// PostgreSQL -> Drizzle ORM -> JSON HTTP response
export const runtime = "nodejs";

export async function GET() {
  try {
    const applicationRows = await db
      .select()
      .from(applications)
      .orderBy(asc(applications.id));

    return Response.json(
      { applications: applicationRows },
      { headers: { "Cache-Control": "no-store" } },
    );
  } catch (error) {
    console.error("Failed to load applications.", error);

    return Response.json(
      { error: "Applications could not be loaded." },
      {
        status: 500,
        headers: { "Cache-Control": "no-store" },
      },
    );
  }
}
