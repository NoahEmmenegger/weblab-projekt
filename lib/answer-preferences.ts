import type { AnswerPreference, ApplicationAnswer, ApplicationField, FieldType, SubmittedApplication } from "@/lib/listing-types";
import { ensureWeights } from "@/lib/field-weights";

export const preferenceOptions: Record<FieldType, { mode: AnswerPreference["mode"]; label: string }[]> = {
  text: [{ mode: "exact", label: "Genau diese Antwort" }, { mode: "contains", label: "Enthält diesen Text" }, { mode: "not-contains", label: "Enthält diesen Text nicht" }, { mode: "starts-with", label: "Beginnt mit diesem Text" }, { mode: "ends-with", label: "Endet mit diesem Text" }, { mode: "regex", label: "Passt zu einem Regex-Muster" }, { mode: "text-longer", label: "Je länger, desto besser" }, { mode: "text-shorter", label: "Je kürzer, desto besser" }],
  textarea: [{ mode: "exact", label: "Genau diese Antwort" }, { mode: "contains", label: "Enthält diesen Text" }, { mode: "not-contains", label: "Enthält diesen Text nicht" }, { mode: "starts-with", label: "Beginnt mit diesem Text" }, { mode: "ends-with", label: "Endet mit diesem Text" }, { mode: "regex", label: "Passt zu einem Regex-Muster" }, { mode: "text-longer", label: "Je länger, desto besser" }, { mode: "text-shorter", label: "Je kürzer, desto besser" }],
  email: [{ mode: "exact", label: "Genau diese E-Mail" }, { mode: "email-domain", label: "E-Mail von dieser Domain" }, { mode: "email-domain-not", label: "E-Mail nicht von dieser Domain" }],
  number: [{ mode: "higher", label: "Je grösser, desto besser" }, { mode: "lower", label: "Je kleiner, desto besser" }, { mode: "number-closest", label: "Möglichst nahe an einer Zahl" }, { mode: "number-at-least", label: "Mindestens dieser Wert" }, { mode: "number-at-most", label: "Höchstens dieser Wert" }],
  date: [{ mode: "newer", label: "Je neuer, desto besser" }, { mode: "older", label: "Je älter, desto besser" }, { mode: "date-closest", label: "Möglichst nahe an einem Datum" }, { mode: "date-on-or-after", label: "An oder nach diesem Datum" }, { mode: "date-on-or-before", label: "An oder vor diesem Datum" }],
  checkbox: [{ mode: "checked", label: "Ja ist besser" }, { mode: "unchecked", label: "Nein ist besser" }],
};

export function needsIdeal(mode: AnswerPreference["mode"]) {
  return ["exact", "contains", "not-contains", "starts-with", "ends-with", "regex", "email-domain", "email-domain-not", "number-closest", "number-at-least", "number-at-most", "date-closest", "date-on-or-after", "date-on-or-before"].includes(mode);
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
  if (["number-closest", "number-at-least", "number-at-most"].includes(mode) && (!/^-?\d+(\.\d+)?$/.test(ideal) || !Number.isFinite(Number(ideal)))) throw new Error("Der Zielwert muss eine Zahl sein.");
  if (["date-closest", "date-on-or-after", "date-on-or-before"].includes(mode) && !validDate(ideal)) throw new Error("Der Zielwert muss ein gültiges Datum sein.");
  if (["email-domain", "email-domain-not"].includes(mode) && !/^[a-z0-9-]+(\.[a-z0-9-]+)+$/i.test(ideal.replace(/^@/, ""))) throw new Error("Gib eine gültige E-Mail-Domain ein.");
  if (mode === "exact" && type === "email" && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(ideal)) throw new Error("Gib eine gültige E-Mail-Adresse ein.");
  if (mode === "regex") {
    if (ideal.length > 200) throw new Error("Das Regex-Muster darf höchstens 200 Zeichen lang sein.");
    try { new RegExp(ideal, "iu"); }
    catch { throw new Error("Gib ein gültiges Regex-Muster ein (ohne / am Anfang und Ende)."); }
  }
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
  if (preference.mode === "not-contains") return normalized.includes(preference.ideal.toLocaleLowerCase("de-CH")) ? 1 : 0;
  if (preference.mode === "starts-with") return normalized.startsWith(preference.ideal.toLocaleLowerCase("de-CH")) ? 0 : 1;
  if (preference.mode === "ends-with") return normalized.endsWith(preference.ideal.toLocaleLowerCase("de-CH")) ? 0 : 1;
  if (preference.mode === "regex") {
    try { return new RegExp(preference.ideal, "iu").test(answer) ? 0 : 1; }
    catch { return Number.POSITIVE_INFINITY; }
  }
  if (preference.mode === "text-longer") return -Array.from(answer.trim()).length;
  if (preference.mode === "text-shorter") return Array.from(answer.trim()).length;
  if (preference.mode === "email-domain" || preference.mode === "email-domain-not") {
    const matches = normalized.endsWith(`@${preference.ideal.replace(/^@/, "").toLowerCase()}`);
    return preference.mode === "email-domain" ? (matches ? 0 : 1) : (matches ? 1 : 0);
  }
  if (preference.mode === "higher" || preference.mode === "lower" || preference.mode === "number-closest" || preference.mode === "number-at-least" || preference.mode === "number-at-most") {
    const number = Number(answer);
    if (!Number.isFinite(number)) return Number.POSITIVE_INFINITY;
    if (preference.mode === "higher") return -number;
    if (preference.mode === "lower") return number;
    if (preference.mode === "number-at-least") return number >= Number(preference.ideal) ? 0 : 1;
    if (preference.mode === "number-at-most") return number <= Number(preference.ideal) ? 0 : 1;
    if (preference.mode === "number-closest") return Math.abs(number - Number(preference.ideal));
  }
  if (!validDate(answer)) return Number.POSITIVE_INFINITY;
  const date = Date.parse(`${answer}T00:00:00Z`);
  if (preference.mode === "newer") return -date;
  if (preference.mode === "older") return date;
  if (preference.mode === "date-on-or-after") return answer >= preference.ideal ? 0 : 1;
  if (preference.mode === "date-on-or-before") return answer <= preference.ideal ? 0 : 1;
  return Math.abs(date - Date.parse(`${preference.ideal}T00:00:00Z`));
}

export function rankApplications(applications: SubmittedApplication[], fields: ApplicationField[]) {
  const criteria = ensureWeights(fields).filter((field) => field.preference && field.weight! > 0);
  if (!criteria.length) return applications.map((application) => ({ application, points: 0, contributions: {} as Record<string, number> }));
  const ranked = applications.map((application) => ({
    application,
    // Each field awards its weight for a win and half for a tie against each other application.
    contributions: Object.fromEntries(criteria.map((field) => {
      const own = answerRank(field, application.answers[field.id]);
      const points = applications.reduce((score, other) => {
        if (other.id === application.id) return score;
        const theirs = answerRank(field, other.answers[field.id]);
        return score + (own < theirs ? 1 : own === theirs ? 0.5 : 0) * field.weight!;
      }, 0);
      return [field.id, points];
    })) as Record<string, number>,
  }));
  return ranked.map((item) => ({
    ...item,
    points: Object.values(item.contributions).reduce((total, points) => total + points, 0),
  })).sort((a, b) => b.points - a.points || b.application.createdAt.localeCompare(a.application.createdAt));
}
