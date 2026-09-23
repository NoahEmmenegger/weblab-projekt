"use server";

import { findPublishedListing, insertApplication, listApplicationsForOwner, setListingPublicationForOwner, upsertListingForOwner } from "@/db/queries/listings";
import { getCurrentUser } from "@/lib/auth";
import { uuidPattern, type ApplicationAnswer, type ApplicationField, type ListingDraft } from "@/lib/listing-types";

const allowedTypes = new Set(["text", "number", "email", "date", "textarea", "checkbox"]);

async function requireOwner() {
  const user = await getCurrentUser();
  if (!user) throw new Error("Nicht angemeldet.");
  return user;
}

function validateDraft(value: ListingDraft): ListingDraft {
  if (!value || typeof value !== "object" || typeof value.title !== "string" || typeof value.description !== "string" || !Array.isArray(value.fields)) throw new Error("Ungültige Ausschreibung.");
  const title = value.title.trim();
  const description = value.description.trim();
  if (!title || title.length > 150 || description.length > 5000) throw new Error("Bitte gib einen Titel mit höchstens 150 Zeichen und eine kurze Beschreibung ein.");
  if (value.fields.length < 1 || value.fields.length > 40) throw new Error("Das Formular braucht 1 bis 40 Felder.");
  const ids = new Set<string>();
  const fields: ApplicationField[] = value.fields.map((field) => {
    if (!field || typeof field.id !== "string" || !/^[\w-]{1,80}$/.test(field.id) || typeof field.label !== "string" || !allowedTypes.has(field.type) || typeof field.required !== "boolean") throw new Error("Ungültiges Formularfeld.");
    const label = field.label.trim();
    if (!label || label.length > 120 || ids.has(field.id)) throw new Error("Feldnamen und Kennungen müssen eindeutig und gültig sein.");
    ids.add(field.id);
    return { id: field.id, label, type: field.type, required: field.required };
  });
  return { title, description, fields };
}

export async function saveListing(apartmentId: string, draft: ListingDraft) {
  const user = await requireOwner();
  const listing = await upsertListingForOwner(user.id, apartmentId, validateDraft(draft));
  if (!listing) throw new Error("Wohnung nicht gefunden.");
  return listing;
}

export async function publishListing(listingId: string, isPublished: boolean) {
  const user = await requireOwner();
  if (typeof isPublished !== "boolean") throw new Error("Ungültiger Veröffentlichungsstatus.");
  const listing = await setListingPublicationForOwner(user.id, listingId, isPublished);
  if (!listing) throw new Error("Ausschreibung nicht gefunden.");
  return listing;
}

export async function getListingApplications(listingId: string) {
  const user = await requireOwner();
  const applications = await listApplicationsForOwner(user.id, listingId);
  if (!applications) throw new Error("Ausschreibung nicht gefunden.");
  return applications;
}

export async function submitListingApplication(listingId: string, formData: FormData): Promise<{ ok: true } | { ok: false; error: string }> {
  if (!uuidPattern.test(listingId)) return { ok: false, error: "Ausschreibung nicht gefunden." };
  const result = await findPublishedListing(listingId);
  if (!result) return { ok: false, error: "Diese Ausschreibung ist nicht verfügbar." };
  const answers: Record<string, ApplicationAnswer> = {};
  for (const field of result.listing.fields) {
    const raw = formData.get(field.id);
    if (field.type === "checkbox") {
      const checked = raw === "on";
      if (field.required && !checked) return { ok: false, error: `„${field.label}“ ist erforderlich.` };
      answers[field.id] = checked;
      continue;
    }
    if (raw !== null && typeof raw !== "string") return { ok: false, error: `„${field.label}“ hat ein ungültiges Format.` };
    const answer = (raw ?? "").trim();
    if (field.required && !answer) return { ok: false, error: `„${field.label}“ ist erforderlich.` };
    if (answer.length > (field.type === "textarea" ? 5000 : 500)) return { ok: false, error: `„${field.label}“ ist zu lang.` };
    if (answer && field.type === "number" && (!Number.isFinite(Number(answer)) || !/^-?\d+(\.\d+)?$/.test(answer))) return { ok: false, error: `„${field.label}“ muss eine Zahl sein.` };
    if (answer && field.type === "email" && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(answer)) return { ok: false, error: `„${field.label}“ muss eine E-Mail-Adresse sein.` };
    if (answer && field.type === "date") {
      const date = new Date(`${answer}T00:00:00Z`);
      if (!/^\d{4}-\d{2}-\d{2}$/.test(answer) || Number.isNaN(date.getTime()) || date.toISOString().slice(0, 10) !== answer) return { ok: false, error: `„${field.label}“ muss ein Datum sein.` };
    }
    answers[field.id] = answer;
  }
  await insertApplication(result.listing.id, answers, result.listing.fields);
  return { ok: true };
}
