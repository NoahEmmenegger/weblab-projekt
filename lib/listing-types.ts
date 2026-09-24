export type FieldType = "text" | "number" | "email" | "date" | "textarea" | "checkbox";
export type AnswerPreference =
  | { mode: "exact"; ideal: string }
  | { mode: "contains"; ideal: string }
  | { mode: "not-contains"; ideal: string }
  | { mode: "starts-with"; ideal: string }
  | { mode: "ends-with"; ideal: string }
  | { mode: "regex"; ideal: string }
  | { mode: "text-longer" }
  | { mode: "text-shorter" }
  | { mode: "email-domain"; ideal: string }
  | { mode: "email-domain-not"; ideal: string }
  | { mode: "higher" }
  | { mode: "lower" }
  | { mode: "number-at-least"; ideal: string }
  | { mode: "number-at-most"; ideal: string }
  | { mode: "newer" }
  | { mode: "older" }
  | { mode: "date-on-or-after"; ideal: string }
  | { mode: "date-on-or-before"; ideal: string }
  | { mode: "number-closest"; ideal: string }
  | { mode: "date-closest"; ideal: string }
  | { mode: "checked" }
  | { mode: "unchecked" };
export type ApplicationField = { id: string; label: string; type: FieldType; required: boolean; preference?: AnswerPreference; weight?: number };
export type ListingDraft = { title: string; description: string; fields: ApplicationField[] };
export type Listing = ListingDraft & { id: string; apartmentId: string; isPublished: boolean; applicationCount: number };
export type ApplicationAnswer = string | boolean;
export type SubmittedApplication = {
  id: string;
  listingId: string;
  answers: Record<string, ApplicationAnswer>;
  fields: ApplicationField[];
  createdAt: string;
};
export const uuidPattern = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
