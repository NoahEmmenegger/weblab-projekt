"use client";

import { useState } from "react";
import { PlusIcon, TrashIcon } from "@/components/icons";
import type { Apartment } from "@/db/queries/apartments";
import type { FieldType, ApplicationField, ListingDraft } from "@/lib/listing-types";
import { needsIdeal, preferenceOptions, validatePreference } from "@/lib/answer-preferences";
import { distributeWeights, ensureWeights, setWeightAndRebalance, weightsAreValid } from "@/lib/field-weights";


const fieldTypes: { value: FieldType; label: string }[] = [
  { value: "text", label: "Kurzer Text" },
  { value: "textarea", label: "Langer Text" },
  { value: "number", label: "Zahl" },
  { value: "email", label: "E-Mail" },
  { value: "date", label: "Datum" },
  { value: "checkbox", label: "Checkbox" },
];

function newField(label = "", type: FieldType = "text"): ApplicationField {
  return { id: crypto.randomUUID(), label, type, required: false };
}

export function ListingDialog({ apartment, draft, onClose, onSave }: {
  apartment: Apartment;
  draft?: ListingDraft;
  onClose: () => void;
  onSave: (draft: ListingDraft) => Promise<void>;
}) {
  const [title, setTitle] = useState(draft?.title ?? apartment.name);
  const [description, setDescription] = useState(draft?.description ?? "");
  const [fields, setFields] = useState<ApplicationField[]>(() => ensureWeights(draft?.fields ?? [
    { id: "first-name", label: "Vorname", type: "text", required: true },
    { id: "last-name", label: "Nachname", type: "text", required: true },
    { id: "email", label: "E-Mail", type: "email", required: true },
  ]));
  const [tab, setTab] = useState<"edit" | "preview">("edit");
  const [error, setError] = useState("");
  const [pending, setPending] = useState(false);
  const ratedCount = fields.filter((field) => field.preference).length;
  const totalWeight = fields.filter((field) => field.preference).reduce((sum, field) => sum + (field.weight ?? 0), 0);

  function updateField(id: string, changes: Partial<ApplicationField>) {
    setFields((current) => current.map((field) => field.id === id ? { ...field, ...changes } : field));
    setError("");
  }

  function updateWeight(id: string, weight: number) {
    setFields((current) => setWeightAndRebalance(current, id, weight));
    setError("");
  }

  function changeType(field: ApplicationField, type: FieldType) {
    setFields((current) => ensureWeights(current.map((item) => item.id === field.id ? { ...item, type, preference: undefined, weight: 0 } : item)));
    setError("");
  }

  function changePreference(id: string, mode: string) {
    setFields((current) => {
      const wasRated = current.some((field) => field.id === id && field.preference);
      const next = current.map((field) => field.id === id ? {
        ...field,
        preference: mode ? { mode, ...(needsIdeal(mode as NonNullable<ApplicationField["preference"]>["mode"]) ? { ideal: "" } : {}) } as ApplicationField["preference"] : undefined,
        weight: mode ? field.weight : 0,
      } : field);
      if (!mode) return ensureWeights(next);
      if (wasRated) return next;
      return setWeightAndRebalance(next, id, Math.round(100 / next.filter((field) => field.preference).length));
    });
    setError("");
  }

  async function save() {
    if (!title.trim()) { setError("Gib einen Titel für die Ausschreibung ein."); setTab("edit"); return; }
    if (fields.some((field) => !field.label.trim())) { setError("Jedes Formularfeld braucht eine Bezeichnung."); setTab("edit"); return; }
    if (!weightsAreValid(fields)) { setError("Die bewerteten Fragen müssen zusammen 100 % ergeben."); setTab("edit"); return; }
    try { fields.forEach((field) => validatePreference(field.type, field.preference)); }
    catch (caught) { setError(caught instanceof Error ? caught.message : "Ungültige Bewertungsregel."); setTab("edit"); return; }
    setPending(true);
    setError("");
    try {
      await onSave({ title: title.trim(), description: description.trim(), fields: fields.map((field) => ({ ...field, label: field.label.trim() })) });
      onClose();
    } catch (caught) {
      setError(caught instanceof Error ? caught.message : "Speichern fehlgeschlagen.");
    } finally { setPending(false); }
  }

  return <div className="modal-backdrop listing-backdrop" role="presentation" onMouseDown={onClose}>
    <section className="modal listing-modal" role="dialog" aria-modal="true" aria-labelledby="listing-dialog-title" onMouseDown={(event) => event.stopPropagation()}>
      <button type="button" className="close-button" onClick={onClose} aria-label="Schliessen">×</button>
      <p className="eyebrow">AUSSCHREIBUNG · {apartment.unitIdentifier}</p>
      <h2 id="listing-dialog-title">{draft ? "Ausschreibung bearbeiten" : "Ausschreibung erstellen"}</h2>
      <p className="modal-copy">Gestalte das Bewerbungsformular für {apartment.name}. Nach dem Speichern kannst du die Ausschreibung veröffentlichen.</p>

      <div className="listing-tabs" role="tablist" aria-label="Ausschreibungsansicht">
        <button type="button" role="tab" aria-selected={tab === "edit"} className={tab === "edit" ? "active" : ""} onClick={() => setTab("edit")}>Bearbeiten</button>
        <button type="button" role="tab" aria-selected={tab === "preview"} className={tab === "preview" ? "active" : ""} onClick={() => setTab("preview")}>Vorschau</button>
      </div>

      {tab === "edit" ? <div className="listing-editor" role="tabpanel">
        <div className="listing-field"><label htmlFor="listing-title">Titel der Ausschreibung</label><input id="listing-title" value={title} onChange={(event) => { setTitle(event.target.value); setError(""); }} placeholder="z. B. Helle 3.5-Zimmerwohnung" /></div>
        <div className="listing-field"><label htmlFor="listing-description">Beschreibung <span>(optional)</span></label><textarea id="listing-description" value={description} onChange={(event) => setDescription(event.target.value)} placeholder="Beschreibe die Wohnung und den Bewerbungsablauf …" rows={3} /></div>
        <div className="listing-fields-heading"><div><h3>Formularfelder</h3><p>Bestimme, welche Angaben Bewerbende machen sollen.</p></div><button type="button" className="button secondary add-field" onClick={() => { setFields((current) => [...current, { ...newField(), weight: 0 }]); setError(""); }}><PlusIcon /> Feld hinzufügen</button></div>
        {ratedCount > 0 ? <div className="weight-summary"><div><strong>Wichtigkeit verteilen</strong><p>Nur Fragen mit Bewertungsregel teilen sich 100 %. Änderst du einen Anteil, passen sich die anderen proportional an.</p></div><div className="weight-controls"><span className={totalWeight === 100 ? "weight-total valid" : "weight-total invalid"} aria-live="polite">{totalWeight} / 100 %</span><button type="button" className="button secondary" onClick={() => { setFields((current) => distributeWeights(current)); setError(""); }}>Gleichmässig verteilen</button></div></div> : <p className="preference-hint">Wähle bei einer Frage eine Bewertungsregel, um ihre Wichtigkeit festzulegen.</p>}
        <div className="listing-fields">
          {fields.map((field, index) => <div className="listing-field-card" key={field.id}>
            <div className="listing-field-top"><span>FELD {index + 1}</span><button type="button" className="row-icon-button danger" disabled={fields.length === 1} onClick={() => { setFields((current) => ensureWeights(current.filter((item) => item.id !== field.id))); setError(""); }} aria-label={`Feld ${index + 1} entfernen`} title={fields.length === 1 ? "Mindestens ein Feld ist erforderlich" : undefined}><TrashIcon /></button></div>
            <div className="listing-field-grid"><div className="listing-field"><label htmlFor={`field-label-${field.id}`}>Bezeichnung</label><input id={`field-label-${field.id}`} value={field.label} onChange={(event) => updateField(field.id, { label: event.target.value })} placeholder="z. B. Monatliches Einkommen" /></div>
              <div className="listing-field"><label htmlFor={`field-type-${field.id}`}>Antworttyp</label><select id={`field-type-${field.id}`} value={field.type} onChange={(event) => changeType(field, event.target.value as FieldType)}>{fieldTypes.map((type) => <option key={type.value} value={type.value}>{type.label}</option>)}</select></div></div>
            <div className="preference-editor"><div className="listing-field"><label htmlFor={`field-preference-${field.id}`}>Welche Antwort ist besser? <span>(optional)</span></label><select id={`field-preference-${field.id}`} value={field.preference?.mode ?? ""} onChange={(event) => {
              changePreference(field.id, event.target.value);
            }}><option value="">Keine Bewertung</option>{preferenceOptions[field.type].map((option) => <option key={option.mode} value={option.mode}>{option.label}</option>)}</select></div>
              {field.preference && needsIdeal(field.preference.mode) && <div className="listing-field"><label htmlFor={`field-ideal-${field.id}`}>{field.preference.mode === "regex" ? "Regex-Muster" : field.preference.mode.startsWith("email-domain") ? "Domain" : ["number-at-least", "number-at-most", "date-on-or-after", "date-on-or-before"].includes(field.preference.mode) ? "Grenzwert" : "Beste Antwort / Zielwert"}</label><input id={`field-ideal-${field.id}`} type={["number-closest", "number-at-least", "number-at-most"].includes(field.preference.mode) ? "number" : ["date-closest", "date-on-or-after", "date-on-or-before"].includes(field.preference.mode) ? "date" : field.preference.mode === "exact" && field.type === "email" ? "email" : "text"} step={["number-closest", "number-at-least", "number-at-most"].includes(field.preference.mode) ? "any" : undefined} value={"ideal" in field.preference ? field.preference.ideal : ""} onChange={(event) => updateField(field.id, { preference: { ...field.preference, ideal: event.target.value } as ApplicationField["preference"] })} placeholder={field.preference.mode.startsWith("email-domain") ? "beispiel.ch" : field.preference.mode === "regex" ? "z. B. ^[A-Z]{2}\\d{3}$" : undefined} />{field.preference.mode === "regex" && <p className="preference-hint">Ohne / am Anfang und Ende; Gross- und Kleinschreibung wird ignoriert.</p>}</div>}</div>
            {field.preference && <p className="preference-hint">Diese Regel ordnet Bewerbungen in der Übersicht. Bewerbende sehen sie nicht.</p>}
            {field.preference && <div className="field-weight"><label htmlFor={`field-weight-${field.id}`}>Wichtigkeit dieser Frage</label><div className="field-weight-controls"><input type="range" min="0" max="100" step="1" value={field.weight ?? 0} onChange={(event) => updateWeight(field.id, Number(event.target.value))} aria-label={`Wichtigkeit von ${field.label || `Frage ${index + 1}`} als Schieberegler`} /><input id={`field-weight-${field.id}`} type="number" min="0" max="100" step="1" value={field.weight ?? 0} onChange={(event) => updateWeight(field.id, Number(event.target.value))} /><span>%</span></div></div>}
            <label className="required-toggle"><input type="checkbox" checked={field.required} onChange={(event) => updateField(field.id, { required: event.target.checked })} /> Pflichtfeld</label>
          </div>)}
          {!fields.length && <p className="listing-no-fields">Noch keine Felder. Füge ein Feld hinzu, um Angaben abzufragen.</p>}
        </div>
      </div> : <div className="listing-preview" role="tabpanel">
        <div className="preview-banner"><span>VORSCHAU FÜR BEWERBENDE</span><span>Nur Ansicht · keine Übermittlung</span></div>
        <div className="preview-body"><p className="eyebrow">WOHNUNGSBEWERBUNG</p><h3>{title.trim() || "Titel der Ausschreibung"}</h3><p className="preview-location">{apartment.rooms} Zimmer · {apartment.location}</p>{description.trim() && <p className="preview-description">{description}</p>}
          <div className="preview-fields">{fields.map((field) => <div className="preview-field" key={field.id}>{field.type === "checkbox" ? <label className="preview-checkbox"><input type="checkbox" /> <span>{field.label || "Unbenanntes Feld"}{field.required && <span className="required-mark"> *</span>}</span></label> : <><label htmlFor={`preview-${field.id}`}>{field.label || "Unbenanntes Feld"}{field.required && <span className="required-mark"> *</span>}</label>{field.type === "textarea" ? <textarea id={`preview-${field.id}`} rows={3} placeholder="Deine Antwort" /> : <input id={`preview-${field.id}`} type={field.type} placeholder={field.type === "email" ? "name@beispiel.ch" : field.type === "date" ? undefined : "Deine Antwort"} />}</>}</div>)}
            {!fields.length && <p className="listing-no-fields">Dieses Formular enthält noch keine Fragen.</p>}</div>
          <button type="button" className="button primary preview-submit" disabled>Bewerbung absenden</button><p className="preview-note">Die Vorschau sendet keine Daten.</p>
        </div>
      </div>}

      {error && <p className="form-error" role="alert">{error}</p>}
      <div className="modal-actions listing-actions"><button type="button" className="button secondary" onClick={onClose}>Abbrechen</button><button type="button" className="button primary" onClick={save} disabled={pending}>{pending ? "Speichern …" : "Entwurf speichern"}</button></div>
    </section>
  </div>;
}
