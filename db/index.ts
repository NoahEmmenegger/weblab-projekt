import { drizzle } from "drizzle-orm/node-postgres";
import { Pool } from "pg";

import * as schema from "./schema";

const globalForDatabase = globalThis as unknown as { pool?: Pool };

function createDatabase() {
  const connectionString = process.env.DATABASE_URL;

  if (!connectionString) {
    throw new Error("DATABASE_URL must be set to connect to PostgreSQL.");
  }

  const pool = globalForDatabase.pool ?? new Pool({ connectionString });

  if (process.env.NODE_ENV !== "production") {
    globalForDatabase.pool = pool;
  }

  return drizzle({ client: pool, schema });
}

let database: ReturnType<typeof createDatabase> | undefined;

export function getDb() {
  return (database ??= createDatabase());
}
