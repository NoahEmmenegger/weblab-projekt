import "server-only";

import { eq } from "drizzle-orm";
import { db } from "@/db";
import { users } from "@/db/schema";

export async function findUserByEmail(email: string) {
  const [user] = await db.select({
    id: users.id,
    passwordHash: users.passwordHash,
  }).from(users).where(eq(users.email, email)).limit(1);

  return user ?? null;
}

export async function createUser(name: string, email: string, passwordHash: string) {
  const [user] = await db.insert(users)
    .values({ name, email, passwordHash })
    .onConflictDoNothing({ target: users.email })
    .returning({ id: users.id });

  return user ?? null;
}
