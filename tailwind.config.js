/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        critical: "#dc2626",
        high: "#f97316",
        moderate: "#eab308",
        low: "#16a34a",
      },
    },
  },
  plugins: [],
};
