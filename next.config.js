/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  webpack: (config, { dev }) => {
    if (dev) {
      // Use in-memory cache on Windows to prevent EPERM file-locking warnings from Antivirus / OS indexer
      config.cache = {
        type: "memory",
      };
    }
    return config;
  },
};

module.exports = nextConfig;
