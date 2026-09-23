"use client";

import { authenticate } from "@/app/actions/auth";
import { ArrowIcon, Icon } from "@/components/icons";
import Link from "next/link";
import { type FormEvent, useState } from "react";

type AuthFormProps = { mode: "login" | "register" };

export function AuthForm({ mode }: AuthFormProps) {
  const [error, setError] = useState("");
  const [pending, setPending] = useState(false);

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setPending(true);
    setError("");
    try {
      const result = await authenticate(mode, new FormData(event.currentTarget));
      if (result.error) setError(result.error);
    } catch {
      setError("Anmeldung derzeit nicht möglich. Bitte versuche es erneut.");
    } finally {
      setPending(false);
    }
  }

  const isLogin = mode === "login";
  return (
    <main className="auth-page">
      <section className="auth-card">
        <div className="auth-brand">WohnungsvergabeTool</div>
        <div className="auth-heading">
          <p className="eyebrow">WOHNUNGSVERWALTUNG</p>
          <h1>{isLogin ? "Willkommen zurück" : "Konto erstellen"}</h1>
          <p>{isLogin ? "Melde dich an, um deine Gesellschaften zu verwalten." : "Starte mit deiner ersten Gesellschaft in wenigen Sekunden."}</p>
        </div>
        <form className="auth-form" onSubmit={handleSubmit}>
          {!isLogin && <><label htmlFor="name">Name</label><input id="name" name="name" placeholder="Vor- und Nachname" autoComplete="name" required /></>}
          <label htmlFor="email">E-Mail</label><input id="email" name="email" type="email" placeholder="name@beispiel.ch" autoComplete="email" required />
          <label htmlFor="password">Passwort</label><input id="password" name="password" type="password" placeholder="••••••••" autoComplete={isLogin ? "current-password" : "new-password"} required />
          {error && <p className="form-error" role="alert">{error}</p>}
          <button className="button primary auth-submit" type="submit" disabled={pending}>{pending ? "Bitte warten …" : isLogin ? <>Anmelden <Icon><ArrowIcon /></Icon></> : "Konto erstellen"}</button>
        </form>
        <p className="auth-toggle">{isLogin ? "Noch kein Konto?" : "Du hast bereits ein Konto?"} <Link href={isLogin ? "/register" : "/login"}>{isLogin ? "Jetzt registrieren" : "Anmelden"}</Link></p>
      </section>
    </main>
  );
}
