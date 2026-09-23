"use server";

import { redirect } from "next/navigation";
import { createUser, findUserByEmail } from "@/db/queries/users";
import { createSession, deleteSession, hashPassword, verifyPassword } from "@/lib/auth";

export type AuthResult = { error?: string };

export async function authenticate(mode: "login" | "register", formData: FormData): Promise<AuthResult> {
  const name = String(formData.get("name") ?? "").trim();
  const email = String(formData.get("email") ?? "").trim().toLowerCase();
  const password = String(formData.get("password") ?? "");
  if (!email || !email.includes("@") || !password) return { error: "Bitte gib eine gültige E-Mail und ein Passwort ein." };

  if (mode === "register") {
    if (!name || password.length < 8) return { error: "Bitte gib einen Namen und ein Passwort mit mindestens 8 Zeichen ein." };
    const existing = await findUserByEmail(email);
    if (existing) return { error: "Diese E-Mail ist bereits registriert." };
    const user = await createUser(name, email, await hashPassword(password));
    if (!user) return { error: "Diese E-Mail ist bereits registriert." };
    await createSession(user.id);
  } else {
    const user = await findUserByEmail(email);
    if (!user || !(await verifyPassword(password, user.passwordHash))) return { error: "E-Mail oder Passwort stimmen nicht." };
    await createSession(user.id);
  }

  redirect("/dashboard");
}

export async function logout() {
  await deleteSession();
  redirect("/login");
}
