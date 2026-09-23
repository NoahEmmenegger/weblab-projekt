export type FieldType = "text" | "number" | "email" | "date" | "textarea" | "checkbox";
export type ApplicationField = { id: string; label: string; type: FieldType; required: boolean };
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
