"use client";

import { type FormEvent, useState } from "react";
import type { Apartment } from "@/db/queries/apartments";

type ApartmentDialogProps = { apartment?: Apartment; onClose: () => void; onSubmit: (name: string, unitIdentifier: string, rooms: number, location: string) => Promise<void> };

export function ApartmentDialog({ apartment, onClose, onSubmit }: ApartmentDialogProps) {
  const isNew = !apartment;
  const [error, setError] = useState("");
  const [pending, setPending] = useState(false);
  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const values = new FormData(event.currentTarget);
    setPending(true); setError("");
    try {
      await onSubmit(String(values.get("name") ?? ""), String(values.get("unitIdentifier") ?? ""), Number(values.get("rooms")), String(values.get("location") ?? ""));
      onClose();
    } catch (caught) {
      setError(caught instanceof Error ? caught.message : "Speichern fehlgeschlagen.");
    } finally { setPending(false); }
  }
  return <div className="modal-backdrop" role="presentation" onMouseDown={onClose}>
    <section className="modal" role="dialog" aria-modal="true" aria-labelledby="apartment-dialog-title" onMouseDown={(event) => event.stopPropagation()}>
      <button className="close-button" onClick={onClose} aria-label="Schliessen">×</button>
      <p className="eyebrow">WOHNUNG</p><h2 id="apartment-dialog-title">{isNew ? "Wohnung erfassen" : "Wohnung bearbeiten"}</h2>
      <p className="modal-copy">Die Wohnungsnummer unterscheidet einzelne Wohnungen im gleichen Gebäude eindeutig.</p>
      <form onSubmit={handleSubmit}>
        <label htmlFor="name">Name</label><input id="name" name="name" defaultValue={apartment?.name} placeholder="z. B. 3.5-Zimmerwohnung Seeblick" autoFocus required />
        <label htmlFor="unitIdentifier">Wohnungsnummer / Einheit</label><input id="unitIdentifier" name="unitIdentifier" defaultValue={apartment?.unitIdentifier} placeholder="z. B. Haus A · Wohnung 12" required />
        <label htmlFor="rooms">Anzahl Zimmer</label><input id="rooms" name="rooms" type="number" min="1" max="100" step="1" defaultValue={apartment?.rooms} placeholder="z. B. 3" required />
        <label htmlFor="location">Standort</label><input id="location" name="location" defaultValue={apartment?.location} placeholder="z. B. Seestrasse 12, 8002 Zürich" required />
        {error && <p className="form-error" role="alert">{error}</p>}
        <div className="modal-actions"><button type="button" className="button secondary" onClick={onClose}>Abbrechen</button><button type="submit" className="button primary" disabled={pending}>{pending ? "Speichern …" : isNew ? "Wohnung erfassen" : "Änderungen speichern"}</button></div>
      </form>
    </section>
  </div>;
}
