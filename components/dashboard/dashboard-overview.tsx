"use client";

import { useState } from "react";
import { ApartmentDialog } from "@/components/dashboard/apartment-dialog";
import { ListingDialog } from "@/components/dashboard/listing-dialog";
import { getListingApplications } from "@/app/actions/listings";
import { PencilIcon, PlusIcon, TrashIcon } from "@/components/icons";
import { useDashboard } from "@/components/dashboard/dashboard-provider";
import type { Apartment } from "@/db/queries/apartments";
import type { Listing, SubmittedApplication } from "@/lib/listing-types";
import { rankApplications } from "@/lib/answer-preferences";

export function DashboardOverview() {
  const { account, activeCompany, apartments, listings, createApartment, updateApartment, deleteApartment, saveListing, publishListing } = useDashboard();
  const [editingApartment, setEditingApartment] = useState<Apartment | null | undefined>(undefined);
  const [listingApartment, setListingApartment] = useState<Apartment | null>(null);
  const [viewingListing, setViewingListing] = useState<Listing | null>(null);
  const [submittedApplications, setSubmittedApplications] = useState<SubmittedApplication[]>([]);
  const [loadingApplications, setLoadingApplications] = useState(false);
  const [busyListingId, setBusyListingId] = useState<string | null>(null);
  const [error, setError] = useState("");
  async function removeApartment(apartment: Apartment) {
    if (!window.confirm(`„${apartment.name}“ wirklich löschen?`)) return;
    setError("");
    try { await deleteApartment(apartment.id); } catch (caught) { setError(caught instanceof Error ? caught.message : "Löschen fehlgeschlagen."); }
  }
  async function changePublication(listing: Listing) {
    setBusyListingId(listing.id); setError("");
    try { await publishListing(listing.id, !listing.isPublished); } catch (caught) { setError(caught instanceof Error ? caught.message : "Veröffentlichung fehlgeschlagen."); }
    finally { setBusyListingId(null); }
  }
  async function viewApplications(listing: Listing) {
    setViewingListing(listing); setSubmittedApplications([]); setLoadingApplications(true); setError("");
    try { setSubmittedApplications(await getListingApplications(listing.id)); } catch (caught) { setError(caught instanceof Error ? caught.message : "Bewerbungen konnten nicht geladen werden."); setViewingListing(null); }
    finally { setLoadingApplications(false); }
  }
  const applicationCount = listings.reduce((total, listing) => total + listing.applicationCount, 0);
  const publishedCount = listings.filter((listing) => listing.isPublished).length;
  const rankedApplications = viewingListing ? rankApplications(submittedApplications, viewingListing.fields) : [];
  const hasPreferences = viewingListing?.fields.some((field) => field.preference && (field.weight ?? 100 / viewingListing.fields.length) > 0) ?? false;
  return <section className="dashboard-content">
    <p className="eyebrow">ÜBERSICHT</p><h1>Guten Morgen, {account.name.split(" ")[0]}.</h1>
    <p className="intro">{activeCompany ? <>Hier siehst du auf einen Blick, was in <strong>{activeCompany.name}</strong> ansteht.</> : "Erstelle deine erste Gesellschaft über das Menü oben links."}</p>
    <div className="stats-grid">
      <article><span>BEWERBUNGEN</span><strong>{applicationCount}</strong><p>Für Wohnungen dieser Gesellschaft</p></article>
      <article><span>ERFASSTE WOHNUNGEN</span><strong>{activeCompany ? apartments.length : 0}</strong><p>In dieser Gesellschaft</p></article>
      <article><span>AKTIVE AUSSCHREIBUNGEN</span><strong>{publishedCount}</strong><p>Öffentlich zugängliche Formulare</p></article>
    </div>
    {activeCompany ? <section className="apartments-section">
      <div className="section-heading"><div><p className="eyebrow">BESTAND</p><h2>Wohnungen</h2><p>Alle einzeln erfassbaren Wohnungen von {activeCompany.name}.</p></div><button className="button primary add-apartment" onClick={() => setEditingApartment(null)}><PlusIcon /> Wohnung erfassen</button></div>
      {error && <p className="form-error" role="alert">{error}</p>}
      {apartments.length ? <div className="apartment-list">{apartments.map((apartment) => {
        const listing = listings.find((item) => item.apartmentId === apartment.id);
        return <article className="apartment-card" key={apartment.id}>
          <div><span className="unit-badge">{apartment.unitIdentifier}</span><h3>{apartment.name}</h3><p>{apartment.rooms} Zimmer · {apartment.location}</p>{listing && <span className="listing-draft-badge">{listing.isPublished ? "Veröffentlicht" : "Entwurf"} · {listing.fields.length} Felder · {listing.applicationCount} Bewerbungen</span>}</div>
          <div className="apartment-actions"><button className="button secondary listing-trigger" onClick={() => setListingApartment(apartment)}>{listing ? "Ausschreibung bearbeiten" : "Ausschreibung erstellen"}</button>{listing && <><button className="button secondary" onClick={() => changePublication(listing)} disabled={busyListingId === listing.id}>{listing.isPublished ? "Pausieren" : "Veröffentlichen"}</button><button className="button secondary" onClick={() => viewApplications(listing)}>Bewerbungen ({listing.applicationCount})</button>{listing.isPublished && <a className="button secondary listing-link" href={`/bewerben/${listing.id}`} target="_blank" rel="noopener noreferrer">Formular öffnen ↗</a>}</>}<button className="row-icon-button" onClick={() => setEditingApartment(apartment)} aria-label={`${apartment.name} bearbeiten`}><PencilIcon /></button><button className="row-icon-button danger" onClick={() => removeApartment(apartment)} aria-label={`${apartment.name} löschen`}><TrashIcon /></button></div>
        </article>;
      })}</div> : <div className="empty-state compact"><div className="empty-icon">⌂</div><h2>Noch keine Wohnungen</h2><p>Erfasse die erste Wohnung, um sie später separat mit Bewerbungen zu verwalten.</p><button className="button primary" onClick={() => setEditingApartment(null)}>Erste Wohnung erfassen</button></div>}
    </section> : <section className="empty-state"><div className="empty-icon">⌂</div><h2>Noch keine Gesellschaft</h2><p>Lege über das Plus im Gesellschaftsmenü deine erste Gesellschaft an.</p></section>}
    {editingApartment !== undefined && <ApartmentDialog apartment={editingApartment ?? undefined} onClose={() => setEditingApartment(undefined)} onSubmit={async (name, unitIdentifier, rooms, location) => { if (editingApartment) await updateApartment(editingApartment.id, name, unitIdentifier, rooms, location); else await createApartment(name, unitIdentifier, rooms, location); }} />}
    {listingApartment && <ListingDialog key={listingApartment.id} apartment={listingApartment} draft={listings.find((item) => item.apartmentId === listingApartment.id)} onClose={() => setListingApartment(null)} onSave={(draft) => saveListing(listingApartment.id, draft)} />}
    {viewingListing && <div className="modal-backdrop" role="presentation" onMouseDown={() => setViewingListing(null)}><section className="modal applications-modal" role="dialog" aria-modal="true" aria-labelledby="applications-title" onMouseDown={(event) => event.stopPropagation()}><button className="close-button" onClick={() => setViewingListing(null)} aria-label="Schliessen">×</button><p className="eyebrow">BEWERBUNGEN</p><h2 id="applications-title">{viewingListing.title}</h2>{hasPreferences && <p className="ranking-note">Nach deinen Bewertungsregeln und Prozentanteilen sortiert. Eine Frage mit 0 % zählt nicht mit; die Reihenfolge ist eine Orientierung.</p>}{loadingApplications ? <p>Lade Bewerbungen …</p> : submittedApplications.length ? <div className="submitted-list">{rankedApplications.map(({ application, points }) => <article key={application.id}><strong>{hasPreferences && <span className="application-rank">Rang {rankedApplications.findIndex((item) => item.points === points) + 1} · </span>}Eingegangen am {new Intl.DateTimeFormat("de-CH", { dateStyle: "medium", timeStyle: "short" }).format(new Date(application.createdAt))}</strong><dl>{application.fields.map((field) => <div key={field.id}><dt>{field.label}</dt><dd>{typeof application.answers[field.id] === "boolean" ? application.answers[field.id] ? "Ja" : "Nein" : String(application.answers[field.id] || "–")}</dd></div>)}</dl></article>)}</div> : <p className="modal-copy">Für diese Ausschreibung sind noch keine Bewerbungen eingegangen.</p>}</section></div>}
  </section>;
}
