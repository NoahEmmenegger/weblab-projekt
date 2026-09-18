This is a [Next.js](https://nextjs.org) project bootstrapped with [`create-next-app`](https://nextjs.org/docs/app/api-reference/cli/create-next-app).

## Getting Started

First, run the development server:

```bash
npm run dev

npm run devDB (um DB zu starten)
# or
yarn dev
# or
pnpm dev
# or
bun dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

You can start editing the page by modifying `app/page.tsx`. The page auto-updates as you edit the file.

## Docker Compose

The Compose setup starts the Next.js application and a PostgreSQL 17 database. The
database persists its data in the named `postgres_data` volume. Create a local
configuration and choose a secure password before using it outside development:

```bash
cp .env.example .env
docker compose up --build
```

In PowerShell, use `Copy-Item .env.example .env` instead of `cp`.

The application is available at [http://localhost:3000](http://localhost:3000)
and PostgreSQL at `localhost:5432` by default. Inside the `web` container, the
database is available through the `DATABASE_URL` environment variable. Stop the
stack with `docker compose down`; use `docker compose down -v` only when you
also want to delete the database data.

## Database development

Drizzle ORM uses `DATABASE_URL` from `.env` (or `.env.local`). Start PostgreSQL
with `npm run devDB`, then manage committed migrations with:

```bash
npm run db:generate
npm run db:migrate
```

Add tables as named exports in `db/schema.ts`; import `db` from `db/index.ts`
only in server-side code. Run `npm run db:studio` to inspect the local database.

## Example: database to API response

`GET /api/applications` is a minimal end-to-end example:

```text
PostgreSQL table "applications"
  -> db/schema.ts (Drizzle table definition)
  -> db/index.ts (PostgreSQL connection + Drizzle client)
  -> app/api/applications/route.ts (db.select().from(applications))
  -> JSON response: { "applications": [...] }
```

Generate and apply the migration before calling the endpoint:

```bash
npm run db:generate
npm run db:migrate
```

After creating one or more rows in Drizzle Studio, open
[http://localhost:3000/api/applications](http://localhost:3000/api/applications)
to see the records as JSON.

This project uses [`next/font`](https://nextjs.org/docs/app/building-your-application/optimizing/fonts) to automatically optimize and load [Geist](https://vercel.com/font), a new font family for Vercel.

## Learn More

To learn more about Next.js, take a look at the following resources:

- [Next.js Documentation](https://nextjs.org/docs) - learn about Next.js features and API.
- [Learn Next.js](https://nextjs.org/learn) - an interactive Next.js tutorial.

You can check out [the Next.js GitHub repository](https://github.com/vercel/next.js) - your feedback and contributions are welcome!

## Deploy on Vercel

The easiest way to deploy your Next.js app is to use the [Vercel Platform](https://vercel.com/new?utm_medium=default-template&filter=next.js&utm_source=create-next-app&utm_campaign=create-next-app-readme) from the creators of Next.js.

Check out our [Next.js deployment documentation](https://nextjs.org/docs/app/building-your-application/deploying) for more details.
