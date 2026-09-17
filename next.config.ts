import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Creates a minimal self-contained Node.js server for the Docker image.
  output: "standalone",
};

export default nextConfig;
