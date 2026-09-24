import type { AnswerPreference, ApplicationAnswer, ApplicationField, FieldType, SubmittedApplication } from "@/lib/listing-types";

export const preferenceOptions: Record<FieldType, { mode: AnswerPreference["mode"]; label: string }[]> = {
  text: [{ mode: "exact", label: "Genau diese Antwort" }, { mode: "contains", label: "Enthält diesen Text" }],
  textarea: [{ mode: "exact", label: "Genau diese Antwort" }, { mode: "contains", label: "Enthält diesen Text" }],
  email: [{ mode: "exact", label: "Genau diese E-Mail" }, { mode: "email-domain", label: "E-Mail von dieser Domain" }],
  number: [{ mode: "higher", label: "Je grösser, desto besser" }, { mode: "lower", label: "Je kleiner, desto besser" }, { mode: "number-closest", label: "Möglichst nahe an einer Zahl" }],
  date: [{ mode: "newer", label: "Je neuer, desto besser" }, { mode: "older", label: "Je länger her, desto besser" }, { mode: "date-closest", label: "Möglichst nahe an einem Datum" }],
  checkbox: [{ mode: "checked", label: "Ja ist besser" }, { mode: "unchecked", label: "Nein ist besser" }],
};

export function needsIdeal(mode: AnswerPreference["mode"]) {
  return ["exact", "contains", "email-domain", "number-closest", "date-closest"].includes(mode);
}

export function validDate(value: string) {
  if (!/^\d{4}-\d{2}-\d{2}$/.test(value)) return false;
  const date = new Date(`${value}T00:00:00Z`);
  return !Number.isNaN(date.getTime()) && date.toISOString().slice(0, 10) === value;
}

export function validatePreference(type: FieldType, value: unknown): AnswerPreference | undefined {
  if (value === undefined || value === null) return undefined;
  if (typeof value !== "object" || !("mode" in value) || typeof value.mode !== "string") throw new Error("Ungültige Bewertungsregel.");
  const mode = value.mode as AnswerPreference["mode"];
  if (!preferenceOptions[type].some((option) => option.mode === mode)) throw new Error("Die Bewertungsregel passt nicht zum Antworttyp.");
  if (!needsIdeal(mode)) return { mode } as AnswerPreference;
  const ideal = "ideal" in value && typeof value.ideal === "string" ? value.ideal.trim() : "";
  if (!ideal || ideal.length > 500) throw new Error("Gib eine gültige beste Antwort ein.");
  if (mode === "number-closest" && (!/^-?\d+(\.\d+)?$/.test(ideal) || !Number.isFinite(Number(ideal)))) throw new Error("Die beste Antwort muss eine Zahl sein.");
  if (mode === "date-closest" && !validDate(ideal)) throw new Error("Die beste Antwort muss ein gültiges Datum sein.");
  if (mode === "email-domain" && !/^[a-z0-9-]+(\.[a-z0-9-]+)+$/i.test(ideal.replace(/^@/, ""))) throw new Error("Gib eine gültige E-Mail-Domain ein.");
  if (mode === "exact" && type === "email" && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(ideal)) throw new Error("Gib eine gültige E-Mail-Adresse ein.");
  return { mode, ideal } as AnswerPreference;
}

// A lower value is better. Missing answers are always behind answered ones.
export function answerRank(field: ApplicationField, answer: ApplicationAnswer | undefined): number {
  const preference = field.preference;
  if (!preference || answer === undefined || answer === "") return Number.POSITIVE_INFINITY;
  if (preference.mode === "checked") return answer === true ? 0 : 1;
  if (preference.mode === "unchecked") return answer === false ? 0 : 1;
  if (typeof answer !== "string") return Number.POSITIVE_INFINITY;
  const normalized = answer.trim().toLocaleLowerCase("de-CH");
  if (preference.mode === "exact") return normalized === preference.ideal.toLocaleLowerCase("de-CH") ? 0 : 1;
  if (preference.mode === "contains") return normalized.includes(preference.ideal.toLocaleLowerCase("de-CH")) ? 0 : 1;
  if (preference.mode === "email-domain") return normalized.endsWith(`@${preference.ideal.replace(/^@/, "").toLowerCase()}`) ? 0 : 1;
  if (preference.mode === "higher" || preference.mode === "lower" || preference.mode === "number-closest") {
    const number = Number(answer);
    if (!Number.isFinite(number)) return Number.POSITIVE_INFINITY;
    return preference.mode === "higher" ? -number : preference.mode === "lower" ? number : Math.abs(number - Number(preference.ideal));
  }
  if (!validDate(answer)) return Number.POSITIVE_INFINITY;
  const date = Date.parse(`${answer}T00:00:00Z`);
  return preference.mode === "newer" ? -date : preference.mode === "older" ? date : Math.abs(date - Date.parse(`${preference.ideal}T00:00:00Z`));
}

export function rankApplications(applications: SubmittedApplication[], fields: ApplicationField[]) {
  const criteria = fields.filter((field) => field.preference);
  if (!criteria.length) return applications.map((application) => ({ application, points: 0 }));
  const ranked = applications.map((application) => ({
    application,
    // One point per other application beaten on each criterion; ties share half a point.
    points: criteria.reduce((total, field) => {
      const own = answerRank(field, application.answers[field.id]);
      return total + applications.reduce((score, other) => {
        if (other.id === application.id) return score;
        const theirs = answerRank(field, other.answers[field.id]);
        return score + (own < theirs ? 1 : own === theirs ? 0.5 : 0);
      }, 0);
    }, 0),
  }));
  return ranked.sort((a, b) => b.points - a.points || b.application.createdAt.localeCompare(a.application.createdAt));
}
