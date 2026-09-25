import type { NextConfig } from "next";

const allowedOrigins = (process.env.SERVER_ACTION_ALLOWED_ORIGINS ?? "")
  .split(",")
  .map((origin) => origin.trim())
  .filter(Boolean);

const nextConfig: NextConfig = {
  // Creates a minimal self-contained Node.js server for the Docker image.
  output: "standalone",
  ...(allowedOrigins.length > 0 && {
    experimental: {
      serverActions: { allowedOrigins },
    },
  }),
};

export default nextConfig;
