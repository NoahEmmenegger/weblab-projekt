import { boolean, index, integer, jsonb, pgTable, text, timestamp, unique, uuid } from "drizzle-orm/pg-core";
import type { ApplicationAnswer, ApplicationField } from "@/lib/listing-types";

// Keep one named export per table so drizzle-kit can generate migrations.
// This is a small end-to-end example for the application API.
export const applications = pgTable("applications", {
  id: integer().primaryKey().generatedAlwaysAsIdentity(),
  applicantName: text("applicant_name").notNull(),
  status: text().notNull().default("pending"),
  createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
});

export const users = pgTable("users", {
  id: uuid("id").primaryKey().defaultRandom(),
  name: text("name").notNull(),
  email: text("email").notNull().unique(),
  passwordHash: text("password_hash").notNull(),
  createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
});

export const sessions = pgTable("sessions", {
  tokenHash: text("token_hash").primaryKey(),
  userId: uuid("user_id").notNull().references(() => users.id, { onDelete: "cascade" }),
  expiresAt: timestamp("expires_at", { withTimezone: true }).notNull(),
  createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
}, (table) => [index("sessions_user_id_idx").on(table.userId)]);

export const companies = pgTable("companies", {
  id: uuid("id").primaryKey().defaultRandom(),
  ownerUserId: uuid("owner_user_id").notNull().references(() => users.id, { onDelete: "cascade" }),
  name: text("name").notNull(),
  location: text("location").notNull().default("Schweiz"),
  createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
  updatedAt: timestamp("updated_at", { withTimezone: true }).notNull().defaultNow(),
}, (table) => [index("companies_owner_user_id_idx").on(table.ownerUserId)]);

export const apartments = pgTable("apartments", {
  id: uuid("id").primaryKey().defaultRandom(),
  companyId: uuid("company_id").notNull().references(() => companies.id, { onDelete: "cascade" }),
  name: text("name").notNull(),
  unitIdentifier: text("unit_identifier").notNull(),
  rooms: integer("rooms").notNull(),
  location: text("location").notNull(),
  createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
  updatedAt: timestamp("updated_at", { withTimezone: true }).notNull().defaultNow(),
}, (table) => [
  index("apartments_company_id_idx").on(table.companyId),
  unique("apartments_company_unit_identifier_unique").on(table.companyId, table.unitIdentifier),
]);

export const listings = pgTable("listings", {
  id: uuid("id").primaryKey().defaultRandom(),
  apartmentId: uuid("apartment_id").notNull().references(() => apartments.id, { onDelete: "cascade" }).unique(),
  title: text("title").notNull(),
  description: text("description").notNull().default(""),
  fields: jsonb("fields").$type<ApplicationField[]>().notNull(),
  isPublished: boolean("is_published").notNull().default(false),
  createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
  updatedAt: timestamp("updated_at", { withTimezone: true }).notNull().defaultNow(),
});

export const listingApplications = pgTable("listing_applications", {
  id: uuid("id").primaryKey().defaultRandom(),
  listingId: uuid("listing_id").notNull().references(() => listings.id, { onDelete: "cascade" }),
  answers: jsonb("answers").$type<Record<string, ApplicationAnswer>>().notNull(),
  fields: jsonb("fields").$type<ApplicationField[]>().notNull(),
  createdAt: timestamp("created_at", { withTimezone: true }).notNull().defaultNow(),
}, (table) => [index("listing_applications_listing_id_idx").on(table.listingId)]);
