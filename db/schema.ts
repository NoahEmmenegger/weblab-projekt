import { integer, pgTable, text, timestamp } from "drizzle-orm/pg-core";

// Keep one named export per table so drizzle-kit can generate migrations.
// This is a small end-to-end example for the application API.
export const applications = pgTable("applications", {
  id: integer().primaryKey().generatedAlwaysAsIdentity(),
  applicantName: text("applicant_name").notNull(),
  status: text().notNull().default("pending"),
  createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
});
