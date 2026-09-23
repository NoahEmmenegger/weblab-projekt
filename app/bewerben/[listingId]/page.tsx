import { notFound } from "next/navigation";
import { findPublishedListing } from "@/db/queries/listings";
import { ApplicationForm } from "@/components/application-form";
import { uuidPattern } from "@/lib/listing-types";

export default async function ApplyPage({ params }: PageProps<"/bewerben/[listingId]">) {
  const { listingId } = await params;
  if (!uuidPattern.test(listingId)) notFound();
  const result = await findPublishedListing(listingId);
  if (!result) notFound();
  return <main className="apply-page"><div className="apply-header"><span className="brand">WVT</span><span>Wohnungsbewerbung</span></div><section className="apply-card"><p className="eyebrow">JETZT BEWERBEN</p><h1>{result.listing.title}</h1><p className="preview-location">{result.apartment.rooms} Zimmer · {result.apartment.location}</p>{result.listing.description && <p className="preview-description">{result.listing.description}</p>}<ApplicationForm listingId={result.listing.id} fields={result.listing.fields} /></section></main>;
}
