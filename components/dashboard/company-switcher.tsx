"use client";

import { useState } from "react";
import { ChevronIcon, Icon, PencilIcon, PlusIcon } from "@/components/icons";
import { useDashboard } from "@/components/dashboard/dashboard-provider";
import { CompanyDialog } from "@/components/dashboard/company-dialog";
import type { Company } from "@/app/actions/companies";

export function CompanySwitcher() {
  const { companies, activeCompany, selectCompany, createCompany, updateCompany } = useDashboard();
  const [open, setOpen] = useState(false);
  const [editingCompany, setEditingCompany] = useState<Company | null | undefined>(undefined);
  const closeDialog = () => setEditingCompany(undefined);

  return <>
    <div className="company-switcher" onMouseEnter={() => setOpen(true)} onMouseLeave={() => setOpen(false)}>
      <button className="company-trigger" onClick={() => setOpen((isOpen) => !isOpen)} aria-expanded={open}>
        <span className="company-mark">{activeCompany?.name.charAt(0) ?? "+"}</span><span className="company-trigger-copy"><strong>{activeCompany?.name ?? "Gesellschaft erstellen"}</strong><small>{activeCompany?.location ?? "Noch keine Gesellschaft"}</small></span><Icon><ChevronIcon /></Icon>
      </button>
      {open && <div className="company-menu">
        <p className="menu-label">GESELLSCHAFTEN</p>
        <div className="company-list">{companies.map((company) => <div className={`company-option ${company.id === activeCompany?.id ? "is-active" : ""}`} key={company.id}>
          <button onClick={() => { selectCompany(company.id); setOpen(false); }}><span className="company-mark small">{company.name.charAt(0)}</span><span><strong>{company.name}</strong><small>{company.location}</small></span></button>
          <button className="edit-company" onClick={() => { setEditingCompany(company); setOpen(false); }} aria-label={`${company.name} bearbeiten`}><PencilIcon /></button>
        </div>)}</div>
        <div className="menu-divider" />
        <button className="new-company" onClick={() => { setEditingCompany(null); setOpen(false); }}><Icon><PlusIcon /></Icon> Neue Gesellschaft</button>
      </div>}
    </div>
    {editingCompany !== undefined && <CompanyDialog company={editingCompany ?? undefined} onClose={closeDialog} onSubmit={async (name, location) => { if (editingCompany) await updateCompany(editingCompany.id, name, location); else await createCompany(name, location); closeDialog(); }} />}
  </>;
}
