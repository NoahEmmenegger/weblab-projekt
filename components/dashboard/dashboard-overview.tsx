"use client";

import { useDashboard } from "@/components/dashboard/dashboard-provider";

export function DashboardOverview() {
  const { account, activeCompany } = useDashboard();
  return <section className="dashboard-content">
    <p className="eyebrow">ÜBERSICHT</p><h1>Guten Morgen, {account.name.split(" ")[0]}.</h1>
    <p className="intro">{activeCompany ? <>Hier siehst du auf einen Blick, was in <strong>{activeCompany.name}</strong> ansteht.</> : "Erstelle deine erste Gesellschaft über das Menü oben links."}</p>
    <div className="stats-grid">
      <article><span>OFFENE BEWERBUNGEN</span><strong>0</strong><p>Noch keine neuen Bewerbungen</p></article>
      <article><span>VERMIETETE WOHNUNGEN</span><strong>0</strong><p>In dieser Gesellschaft</p></article>
      <article><span>AUSLASTUNG</span><strong>–</strong><p>Daten folgen mit den ersten Objekten</p></article>
    </div>
    <section className="empty-state"><div className="empty-icon">⌂</div><h2>{activeCompany ? `Willkommen bei ${activeCompany.name}` : "Noch keine Gesellschaft"}</h2><p>{activeCompany ? "Das Dashboard ist bereit. Sobald du Objekte und Bewerbungen erfasst, erscheinen sie hier." : "Lege über das Plus im Gesellschaftsmenü deine erste Gesellschaft an."}</p></section>
  </section>;
}
