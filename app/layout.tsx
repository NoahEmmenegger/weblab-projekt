import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: {
    default: "Wohnungsvergabe",
    template: "%s | Wohnungsvergabe",
  },
  description: "Tool zur Verwaltung von Wohnungsbewerbungen.",
};

export default function RootLayout({ children }: LayoutProps<"/">) {
  return (
    <html lang="de" className="h-full antialiased">
      <body className="min-h-full flex flex-col">{children}</body>
    </html>
  );
}
