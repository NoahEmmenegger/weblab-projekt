"use client";

import { createContext, useContext, useMemo, useState, type ReactNode } from "react";
import { createCompany as createCompanyAction, updateCompany as updateCompanyAction, type Company } from "@/app/actions/companies";
import { createApartment as createApartmentAction, updateApartment as updateApartmentAction, deleteApartment as deleteApartmentAction, importDemoApartment as importDemoApartmentAction } from "@/app/actions/apartments";
import { publishListing as publishListingAction, saveListing as saveListingAction } from "@/app/actions/listings";
import type { Apartment } from "@/db/queries/apartments";
import type { Listing, ListingDraft } from "@/lib/listing-types";

type Account = { id: string; name: string; email: string };
type DashboardContextValue = {
  account: Account;
  companies: Company[];
  activeCompany: Company | null;
  selectCompany: (companyId: string) => void;
  createCompany: (name: string, location: string) => Promise<void>;
  updateCompany: (companyId: string, name: string, location: string) => Promise<void>;
  apartments: Apartment[];
  createApartment: (name: string, unitIdentifier: string, rooms: number, location: string) => Promise<void>;
  importDemoApartment: () => Promise<void>;
  updateApartment: (apartmentId: string, name: string, unitIdentifier: string, rooms: number, location: string) => Promise<void>;
  deleteApartment: (apartmentId: string) => Promise<void>;
  listings: Listing[];
  saveListing: (apartmentId: string, draft: ListingDraft) => Promise<void>;
  publishListing: (listingId: string, isPublished: boolean) => Promise<void>;
};

const DashboardContext = createContext<DashboardContextValue | null>(null);

export function DashboardProvider({ children, account, initialCompanies, initialApartments, initialListings }: { children: ReactNode; account: Account; initialCompanies: Company[]; initialApartments: Apartment[]; initialListings: Listing[] }) {
  const [companies, setCompanies] = useState(initialCompanies);
  const [apartments, setApartments] = useState(initialApartments);
  const [listings, setListings] = useState(initialListings);
  const [activeCompanyId, setActiveCompanyId] = useState(initialCompanies[0]?.id ?? "");
  const activeCompany = companies.find((company) => company.id === activeCompanyId) ?? companies[0] ?? null;

  const value = useMemo<DashboardContextValue>(() => ({
    account, companies, activeCompany,
    selectCompany(companyId) {
      if (companies.some((company) => company.id === companyId)) setActiveCompanyId(companyId);
    },
    async createCompany(name, location) {
      const company = await createCompanyAction(name, location);
      setCompanies((current) => [...current, company]);
      setActiveCompanyId(company.id);
    },
    async updateCompany(companyId, name, location) {
      const updated = await updateCompanyAction(companyId, name, location);
      setCompanies((current) => current.map((company) => company.id === companyId ? updated : company));
    },
    apartments: apartments.filter((apartment) => apartment.companyId === activeCompany?.id),
    async createApartment(name, unitIdentifier, rooms, location) {
      if (!activeCompany) throw new Error("Erstelle zuerst eine Gesellschaft.");
      const apartment = await createApartmentAction(activeCompany.id, name, unitIdentifier, rooms, location);
      setApartments((current) => [...current, apartment]);
    },
    async importDemoApartment() {
      if (!activeCompany) throw new Error("Erstelle zuerst eine Gesellschaft.");
      const { apartment, listing } = await importDemoApartmentAction(activeCompany.id);
      setApartments((current) => [...current, apartment]);
      setListings((current) => [...current, listing]);
    },
    async updateApartment(apartmentId, name, unitIdentifier, rooms, location) {
      const apartment = await updateApartmentAction(apartmentId, name, unitIdentifier, rooms, location);
      setApartments((current) => current.map((item) => item.id === apartmentId ? apartment : item));
    },
    async deleteApartment(apartmentId) {
      await deleteApartmentAction(apartmentId);
      setApartments((current) => current.filter((apartment) => apartment.id !== apartmentId));
      setListings((current) => current.filter((listing) => listing.apartmentId !== apartmentId));
    },
    listings: listings.filter((listing) => apartments.some((apartment) => apartment.id === listing.apartmentId && apartment.companyId === activeCompany?.id)),
    async saveListing(apartmentId, draft) {
      const listing = await saveListingAction(apartmentId, draft);
      setListings((current) => [...current.filter((item) => item.id !== listing.id), listing]);
    },
    async publishListing(listingId, isPublished) {
      const listing = await publishListingAction(listingId, isPublished);
      setListings((current) => current.map((item) => item.id === listing.id ? listing : item));
    },
  }), [account, companies, apartments, listings, activeCompany]);

  return <DashboardContext.Provider value={value}>{children}</DashboardContext.Provider>;
}

export function useDashboard() {
  const context = useContext(DashboardContext);
  if (!context) throw new Error("useDashboard must be used inside DashboardProvider.");
  return context;
}
