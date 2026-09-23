import { DashboardShell } from "@/components/dashboard/dashboard-shell";
import { listCompaniesByOwner } from "@/db/queries/companies";
import { getCurrentUser } from "@/lib/auth";
import { redirect } from "next/navigation";

export default async function DashboardLayout({ children }: LayoutProps<"/dashboard">) {
  const account = await getCurrentUser();
  if (!account) redirect("/login");
  const ownedCompanies = await listCompaniesByOwner(account.id);
  return <DashboardShell account={account} companies={ownedCompanies}>{children}</DashboardShell>;
}
