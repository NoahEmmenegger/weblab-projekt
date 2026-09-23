"use client";

import { CompanySwitcher } from "@/components/dashboard/company-switcher";
import { DashboardProvider, useDashboard } from "@/components/dashboard/dashboard-provider";
import { LogoutIcon } from "@/components/icons";
import { logout } from "@/app/actions/auth";
import type { Company } from "@/app/actions/companies";
import type { ReactNode } from "react";

function DashboardHeader() {
  const { account } = useDashboard();
  return <header className="topbar">
    <div className="brand">WVT</div><CompanySwitcher />
    <div className="topbar-spacer" /><div className="user-name">{account.name}</div>
    <form action={logout}><button className="icon-button" type="submit" aria-label="Abmelden"><LogoutIcon /></button></form>
  </header>;
}

function DashboardContent({ children }: { children: ReactNode }) {
  return <main className="app-shell"><DashboardHeader />{children}</main>;
}

export function DashboardShell({ children, account, companies }: { children: ReactNode; account: { id: string; name: string; email: string }; companies: Company[] }) {
  return <DashboardProvider account={account} initialCompanies={companies}><DashboardContent>{children}</DashboardContent></DashboardProvider>;
}
