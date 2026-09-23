"use client";

import { createContext, useContext, useMemo, useState, type ReactNode } from "react";
import { createCompany as createCompanyAction, updateCompany as updateCompanyAction, type Company } from "@/app/actions/companies";

type Account = { id: string; name: string; email: string };
type DashboardContextValue = {
  account: Account;
  companies: Company[];
  activeCompany: Company | null;
  selectCompany: (companyId: string) => void;
  createCompany: (name: string, location: string) => Promise<void>;
  updateCompany: (companyId: string, name: string, location: string) => Promise<void>;
};

const DashboardContext = createContext<DashboardContextValue | null>(null);

export function DashboardProvider({ children, account, initialCompanies }: { children: ReactNode; account: Account; initialCompanies: Company[] }) {
  const [companies, setCompanies] = useState(initialCompanies);
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
  }), [account, companies, activeCompany]);

  return <DashboardContext.Provider value={value}>{children}</DashboardContext.Provider>;
}

export function useDashboard() {
  const context = useContext(DashboardContext);
  if (!context) throw new Error("useDashboard must be used inside DashboardProvider.");
  return context;
}
