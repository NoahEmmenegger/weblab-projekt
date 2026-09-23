CREATE TABLE "apartments" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"company_id" uuid NOT NULL,
	"name" text NOT NULL,
	"unit_identifier" text NOT NULL,
	"rooms" integer NOT NULL,
	"location" text NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "apartments_company_unit_identifier_unique" UNIQUE("company_id", "unit_identifier")
);
--> statement-breakpoint
ALTER TABLE "apartments" ADD CONSTRAINT "apartments_company_id_companies_id_fk" FOREIGN KEY ("company_id") REFERENCES "public"."companies"("id") ON DELETE cascade ON UPDATE no action;
--> statement-breakpoint
CREATE INDEX "apartments_company_id_idx" ON "apartments" USING btree ("company_id");
