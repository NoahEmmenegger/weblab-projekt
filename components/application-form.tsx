"use client";

import { useState, type FormEvent } from "react";
import { submitListingApplication } from "@/app/actions/listings";
import type { ApplicationField } from "@/lib/listing-types";

export function ApplicationForm({ listingId, fields }: { listingId: string; fields: ApplicationField[] }) {
  const [pending, setPending] = useState(false);
  const [error, setError] = useState("");
  const [submitted, setSubmitted] = useState(false);

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setPending(true); setError("");
    try {
      const result = await submitListingApplication(listingId, new FormData(event.currentTarget));
      if (result.ok) setSubmitted(true);
      else setError(result.error);
    } catch { setError("Die Bewerbung konnte nicht gesendet werden. Bitte versuche es erneut."); }
    finally { setPending(false); }
  }

  if (submitted) return <div className="apply-success" role="status"><h2>Vielen Dank für deine Bewerbung!</h2><p>Deine Angaben wurden übermittelt.</p></div>;
  return <form className="apply-form" onSubmit={handleSubmit}>
    {fields.map((field) => <div className="preview-field" key={field.id}>{field.type === "checkbox" ? <label className="preview-checkbox"><input type="checkbox" name={field.id} required={field.required} /><span>{field.label}{field.required && <span className="required-mark"> *</span>}</span></label> : <><label htmlFor={`answer-${field.id}`}>{field.label}{field.required && <span className="required-mark"> *</span>}</label>{field.type === "textarea" ? <textarea id={`answer-${field.id}`} name={field.id} rows={4} required={field.required} maxLength={5000} /> : <input id={`answer-${field.id}`} name={field.id} type={field.type} required={field.required} maxLength={field.type === "number" ? undefined : 500} step={field.type === "number" ? "any" : undefined} />}</>}</div>)}
    {error && <p className="form-error" role="alert">{error}</p>}
    <button className="button primary" type="submit" disabled={pending}>{pending ? "Wird gesendet …" : "Bewerbung absenden"}</button>
  </form>;
}
