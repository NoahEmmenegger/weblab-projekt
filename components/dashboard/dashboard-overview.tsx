"use client";

import { useState } from "react";
import { ApartmentDialog } from "@/components/dashboard/apartment-dialog";
import { PencilIcon, PlusIcon, TrashIcon } from "@/components/icons";
import { useDashboard } from "@/components/dashboard/dashboard-provider";
import type { Apartment } from "@/db/queries/apartments";

export function DashboardOverview() {
  const { account, activeCompany, apartments, createApartment, updateApartment, deleteApartment } = useDashboard();
  const [editingApartment, setEditingApartment] = useState<Apartment | null | undefined>(undefined);
  const [error, setError] = useState("");
  async function removeApartment(apartment: Apartment) {
    if (!window.confirm(`„${apartment.name}“ wirklich löschen?`)) return;
    setError("");
    try { await deleteApartment(apartment.id); } catch (caught) { setError(caught instanceof Error ? caught.message : "Löschen fehlgeschlagen."); }
  }
  return <section className="dashboard-content">
    <p className="eyebrow">ÜBERSICHT</p><h1>Guten Morgen, {account.name.split(" ")[0]}.</h1>
    <p className="intro">{activeCompany ? <>Hier siehst du auf einen Blick, was in <strong>{activeCompany.name}</strong> ansteht.</> : "Erstelle deine erste Gesellschaft über das Menü oben links."}</p>
    <div className="stats-grid">
      <article><span>OFFENE BEWERBUNGEN</span><strong>0</strong><p>Noch keine neuen Bewerbungen</p></article>
      <article><span>ERFASSTE WOHNUNGEN</span><strong>{activeCompany ? apartments.length : 0}</strong><p>In dieser Gesellschaft</p></article>
      <article><span>BEWERBUNGEN</span><strong>–</strong><p>Folgt pro Wohnung</p></article>
    </div>
    {activeCompany ? <section className="apartments-section">
      <div className="section-heading"><div><p className="eyebrow">BESTAND</p><h2>Wohnungen</h2><p>Alle einzeln erfassbaren Wohnungen von {activeCompany.name}.</p></div><button className="button primary add-apartment" onClick={() => setEditingApartment(null)}><PlusIcon /> Wohnung erfassen</button></div>
      {error && <p className="form-error" role="alert">{error}</p>}
      {apartments.length ? <div className="apartment-list">{apartments.map((apartment) => <article className="apartment-card" key={apartment.id}>
        <div><span className="unit-badge">{apartment.unitIdentifier}</span><h3>{apartment.name}</h3><p>{apartment.rooms} Zimmer · {apartment.location}</p></div>
        <div className="apartment-actions"><button className="row-icon-button" onClick={() => setEditingApartment(apartment)} aria-label={`${apartment.name} bearbeiten`}><PencilIcon /></button><button className="row-icon-button danger" onClick={() => removeApartment(apartment)} aria-label={`${apartment.name} löschen`}><TrashIcon /></button></div>
      </article>)}</div> : <div className="empty-state compact"><div className="empty-icon">⌂</div><h2>Noch keine Wohnungen</h2><p>Erfasse die erste Wohnung, um sie später separat mit Bewerbungen zu verwalten.</p><button className="button primary" onClick={() => setEditingApartment(null)}>Erste Wohnung erfassen</button></div>}
    </section> : <section className="empty-state"><div className="empty-icon">⌂</div><h2>Noch keine Gesellschaft</h2><p>Lege über das Plus im Gesellschaftsmenü deine erste Gesellschaft an.</p></section>}
    {editingApartment !== undefined && <ApartmentDialog apartment={editingApartment ?? undefined} onClose={() => setEditingApartment(undefined)} onSubmit={async (name, unitIdentifier, rooms, location) => { if (editingApartment) await updateApartment(editingApartment.id, name, unitIdentifier, rooms, location); else await createApartment(name, unitIdentifier, rooms, location); }} />}
  </section>;
}
