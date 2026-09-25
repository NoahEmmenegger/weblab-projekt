import "server-only";

import { and, eq, gt } from "drizzle-orm";
import { getDb } from "@/db";
import { sessions, users } from "@/db/schema";

export async function createSessionRecord(tokenHash: string, userId: string, expiresAt: Date) {
  await getDb().insert(sessions).values({ tokenHash, userId, expiresAt });
}

export async function findSessionUser(tokenHash: string) {
  const [user] = await getDb().select({ id: users.id, name: users.name, email: users.email })
    .from(sessions)
    .innerJoin(users, eq(sessions.userId, users.id))
    .where(and(eq(sessions.tokenHash, tokenHash), gt(sessions.expiresAt, new Date())))
    .limit(1);

  return user ?? null;
}

export async function deleteSessionRecord(tokenHash: string) {
  await getDb().delete(sessions).where(eq(sessions.tokenHash, tokenHash));
}
