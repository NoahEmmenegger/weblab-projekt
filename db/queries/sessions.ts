import "server-only";

import { and, eq, gt } from "drizzle-orm";
import { db } from "@/db";
import { sessions, users } from "@/db/schema";

export async function createSessionRecord(tokenHash: string, userId: string, expiresAt: Date) {
  await db.insert(sessions).values({ tokenHash, userId, expiresAt });
}

export async function findSessionUser(tokenHash: string) {
  const [user] = await db.select({ id: users.id, name: users.name, email: users.email })
    .from(sessions)
    .innerJoin(users, eq(sessions.userId, users.id))
    .where(and(eq(sessions.tokenHash, tokenHash), gt(sessions.expiresAt, new Date())))
    .limit(1);

  return user ?? null;
}

export async function deleteSessionRecord(tokenHash: string) {
  await db.delete(sessions).where(eq(sessions.tokenHash, tokenHash));
}
