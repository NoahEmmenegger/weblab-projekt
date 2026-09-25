import { findListingForOwner, listApplicationsForOwner } from "@/db/queries/listings";
import { getCurrentUser } from "@/lib/auth";
import { rankApplications } from "@/lib/answer-preferences";
import { ensureWeights } from "@/lib/field-weights";
import { uuidPattern, type ApplicationField } from "@/lib/listing-types";

export const runtime = "nodejs";

function csvCell(value: string | number | boolean | undefined) {
  const text = value === undefined ? "" : String(value);
  // Spreadsheet programs may execute formulas in imported, user supplied answers or labels.
  const safe = /^[\s\uFEFF]*[=+\-@]/u.test(text) ? `'${text}` : text;
  return `"${safe.replaceAll('"', '""')}"`;
}

export async function GET(_request: Request, context: RouteContext<"/api/listings/[listingId]/applications/export">) {
  const user = await getCurrentUser();
  if (!user) return new Response("Nicht angemeldet.", { status: 401 });

  const { listingId } = await context.params;
  if (!uuidPattern.test(listingId)) return new Response("Ausschreibung nicht gefunden.", { status: 404 });
  const listing = await findListingForOwner(user.id, listingId);
  if (!listing) return new Response("Ausschreibung nicht gefunden.", { status: 404 });

  const applications = await listApplicationsForOwner(user.id, listingId);
  if (!applications) return new Response("Ausschreibung nicht gefunden.", { status: 404 });
  const ranked = rankApplications(applications, listing.fields);
  const scoringFields = new Map(ensureWeights(listing.fields).map((field) => [field.id, field]));
  const fields = new Map<string, ApplicationField>();
  for (const field of listing.fields) fields.set(field.id, field);
  for (const application of applications) {
    for (const field of application.fields) if (!fields.has(field.id)) fields.set(field.id, field);
  }
  const columns = [...fields.values()];
  const hasPreferences = listing.fields.some((field) => field.preference);
  const maximum = (applications.length - 1) * 100;
  const rows: (string | number | boolean | undefined)[][] = [
    ["Bewerbungs-ID", "Eingegangen (UTC)", "Rang", "Gesamtpunkte", "Maximale Punkte", ...columns.flatMap((field) => [`${field.label} (${field.id}) – Antwort`, `${field.label} (${field.id}) – Punkte`, `${field.label} (${field.id}) – Gewichtung (%)`])],
    ...ranked.map(({ application, points, contributions }) => [
      application.id,
      application.createdAt,
      hasPreferences ? ranked.findIndex((item) => item.points === points) + 1 : undefined,
      hasPreferences ? points : undefined,
      hasPreferences ? maximum : undefined,
      ...columns.flatMap((field) => {
        const originalField = application.fields.find((item) => item.id === field.id);
        const scoringField = scoringFields.get(field.id);
        return [
          originalField ? application.answers[field.id] : undefined,
          scoringField?.preference ? contributions[field.id] ?? 0 : undefined,
          scoringField?.preference ? scoringField.weight : undefined,
        ];
      }),
    ]),
  ];
  const csv = `\uFEFF${rows.map((row) => row.map(csvCell).join(";")).join("\r\n")}\r\n`;
  return new Response(csv, {
    headers: {
      "Content-Type": "text/csv; charset=utf-8",
      "Content-Disposition": `attachment; filename="bewerbungen-${listingId}.csv"`,
      "Cache-Control": "private, no-store",
      "X-Content-Type-Options": "nosniff",
    },
  });
}
