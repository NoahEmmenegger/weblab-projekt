import type { ReactNode } from "react";

export function Icon({ children }: { children: ReactNode }) {
  return <span className="icon">{children}</span>;
}

export function ChevronIcon() { return <svg viewBox="0 0 16 16" aria-hidden="true"><path d="m4 6 4 4 4-4" /></svg>; }
export function PlusIcon() { return <svg viewBox="0 0 16 16" aria-hidden="true"><path d="M8 3v10M3 8h10" /></svg>; }
export function PencilIcon() { return <svg viewBox="0 0 16 16" aria-hidden="true"><path d="m3 11.75.6-2.4L10.8 2.2a1.5 1.5 0 0 1 2.1 2.1L5.7 11.45l-2.7.3Z" /><path d="m9.5 3.5 3 3" /></svg>; }
export function LogoutIcon() { return <svg viewBox="0 0 16 16" aria-hidden="true"><path d="M9 3H5.5A1.5 1.5 0 0 0 4 4.5v7A1.5 1.5 0 0 0 5.5 13H9" /><path d="m10 5 3 3-3 3M13 8H7" /></svg>; }
export function ArrowIcon() { return <svg viewBox="0 0 16 16" aria-hidden="true"><path d="M3 8h10M9 4l4 4-4 4" /></svg>; }
