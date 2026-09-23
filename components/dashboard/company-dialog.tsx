"use client";

import { type FormEvent, useState } from "react";
import type { Company } from "@/app/actions/companies";

type CompanyDialogProps = { company?: Company; onClose: () => void; onSubmit: (name: string, location: string) => Promise<void> };

export function CompanyDialog({ company, onClose, onSubmit }: CompanyDialogProps) {
  const isNew = !company;
  const [error, setError] = useState("");
  const [pending, setPending] = useState(false);
  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const values = new FormData(event.currentTarget);
    setPending(true);
    setError("");
    try {
      await onSubmit(String(values.get("companyName") ?? "").trim(), String(values.get("location") ?? "").trim());
    } catch (caught) {
      setError(caught instanceof Error ? caught.message : "Speichern fehlgeschlagen.");
    } finally {
      setPending(false);
    }
  }
  return <div className="modal-backdrop" role="presentation" onMouseDown={onClose}>
    <section className="modal" role="dialog" aria-modal="true" aria-labelledby="company-dialog-title" onMouseDown={(event) => event.stopPropagation()}>
      <button className="close-button" onClick={onClose} aria-label="Schliessen">×</button>
      <p className="eyebrow">GESELLSCHAFT</p><h2 id="company-dialog-title">{isNew ? "Neue Gesellschaft" : "Gesellschaft bearbeiten"}</h2>
      <p className="modal-copy">{isNew ? "Lege eine weitere Gesellschaft an, um sie separat zu verwalten." : "Aktualisiere die Angaben deiner Gesellschaft."}</p>
      <form onSubmit={handleSubmit}>
        <label htmlFor="companyName">Name der Gesellschaft</label><input id="companyName" name="companyName" defaultValue={company?.name} placeholder="z. B. Muster Immobilien AG" autoFocus required />
        <label htmlFor="location">Ort</label><input id="location" name="location" defaultValue={company?.location} placeholder="z. B. Zürich" />
        {error && <p className="form-error" role="alert">{error}</p>}
        <div className="modal-actions"><button type="button" className="button secondary" onClick={onClose}>Abbrechen</button><button type="submit" className="button primary" disabled={pending}>{pending ? "Speichern …" : isNew ? "Gesellschaft erstellen" : "Änderungen speichern"}</button></div>
      </form>
    </section>
  </div>;
}
