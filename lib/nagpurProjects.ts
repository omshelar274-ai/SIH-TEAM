/**
 * Known Nagpur Infrastructure Project Registry
 * Used for auto-fill when Collector types a project name.
 * Data sourced from NMRDA, MIDC, NMC, and MoRTH public records.
 *
 * Population density basis (Census 2011, per km²):
 *   Hingna: 311, Kamptee: 593, Saoner: 355, Ramtek: 136,
 *   Kalmeshwar: 241, Umred: 156, Kuhi: 152, Katol: 181,
 *   Parseoni: 178, Nagpur Urban: ~11,000
 */

export interface KnownProject {
  name: string;
  type: string;
  district: string;
  villages: string;
  landAreaHectares: number;
  estFamilies: number;
  forestClearance: "Yes" | "No";
  center: [number, number]; // [lat, lng]
  startDate: string;
  targetHandoverDate: string;
  avgDeptResponseDays: number;
}

export const NAGPUR_PROJECTS: KnownProject[] = [
  {
    name: "New Nagpur IBFC (International Business & Finance Centre)",
    type: "Smart City",
    district: "Nagpur",
    villages: "Godhani (Rithi), Ladgaon (Rithi/Khurd) — Hingna Taluka",
    landAreaHectares: 692,
    estFamilies: 215,
    forestClearance: "No",
    center: [21.1095, 78.9850],
    startDate: "2023-09-15",
    targetHandoverDate: "2027-06-30",
    avgDeptResponseDays: 22,
  },
  {
    name: "Third Outer Ring Road — 148 km Corridor (Phase 1)",
    type: "Highway",
    district: "Nagpur",
    villages: "Turagondi, Shirkal, Fetri, Wadi, Besa, Tarsa (Hingna, Kalmeshwar, Kamptee talukas — 99 villages)",
    landAreaHectares: 1840,
    estFamilies: 548,
    forestClearance: "Yes",
    center: [21.1750, 79.0200],
    startDate: "2024-01-10",
    targetHandoverDate: "2028-12-31",
    avgDeptResponseDays: 28,
  },
  {
    name: "Nagpur Metro Phase 2 — Kamptee-Kanhan Extension",
    type: "Metro",
    district: "Nagpur",
    villages: "Kamptee Town, Kanhan, Koradi",
    landAreaHectares: 28,
    estFamilies: 17,
    forestClearance: "No",
    center: [21.2280, 79.0510],
    startDate: "2024-06-01",
    targetHandoverDate: "2027-03-31",
    avgDeptResponseDays: 8,
  },
  {
    name: "MIHAN SEZ — Remaining PAP Land Distribution & Monetization",
    type: "Airport",
    district: "Nagpur",
    villages: "Khapri, Mahurzari, Wadgaon (South Nagpur)",
    landAreaHectares: 480,
    estFamilies: 320,
    forestClearance: "Yes",
    center: [21.0840, 79.0470],
    startDate: "2023-04-01",
    targetHandoverDate: "2026-12-31",
    avgDeptResponseDays: 18,
  },
  {
    name: "Nag River Pollution Abatement & STP Land Acquisition",
    type: "Dam",
    district: "Nagpur",
    villages: "Maharajbagh (PDKV Campus), VNIT Area, Bidipeth, Nari, Kachimet",
    landAreaHectares: 85,
    estFamilies: 52,
    forestClearance: "No",
    center: [21.1400, 79.0750],
    startDate: "2024-02-15",
    targetHandoverDate: "2027-08-31",
    avgDeptResponseDays: 24,
  },
  {
    name: "Butibori MIDC Phase 5 Expansion",
    type: "Industrial Corridor",
    district: "Nagpur",
    villages: "Sawangi, Asola, Ghogli, Butibori",
    landAreaHectares: 520,
    estFamilies: 95,
    forestClearance: "No",
    center: [20.9760, 79.0380],
    startDate: "2024-04-01",
    targetHandoverDate: "2027-01-31",
    avgDeptResponseDays: 11,
  },
  {
    name: "Saoner DNA (Defence, Nuclear & Aerospace) Corridor",
    type: "Industrial Corridor",
    district: "Nagpur",
    villages: "Saoner Taluka — 2,730 Ha notified across 12 villages",
    landAreaHectares: 2730,
    estFamilies: 385,
    forestClearance: "Yes",
    center: [21.3850, 78.9200],
    startDate: "2024-03-01",
    targetHandoverDate: "2028-06-30",
    avgDeptResponseDays: 26,
  },
  {
    name: "Nagpur-Mumbai Samruddhi Expressway — Nagpur Spur Connector",
    type: "Highway",
    district: "Nagpur",
    villages: "Kalmeshwar, Wadi, Fetri, Mankapur",
    landAreaHectares: 340,
    estFamilies: 78,
    forestClearance: "No",
    center: [21.2130, 78.9650],
    startDate: "2024-05-10",
    targetHandoverDate: "2026-11-30",
    avgDeptResponseDays: 9,
  },
  {
    name: "Kamptee Military Station Bypass & Grade Separator",
    type: "Railway",
    district: "Nagpur",
    villages: "Kamptee, Koradi, Pili Nadi area",
    landAreaHectares: 120,
    estFamilies: 71,
    forestClearance: "No",
    center: [21.2320, 79.0690],
    startDate: "2024-02-01",
    targetHandoverDate: "2027-04-30",
    avgDeptResponseDays: 16,
  },
  {
    name: "Gorewada International Zoo & Bio-Park Expansion",
    type: "Smart City",
    district: "Nagpur",
    villages: "Gorewada, Seminary Hills Buffer Zone",
    landAreaHectares: 160,
    estFamilies: 38,
    forestClearance: "Yes",
    center: [21.1870, 79.0300],
    startDate: "2024-07-01",
    targetHandoverDate: "2026-09-30",
    avgDeptResponseDays: 7,
  },
];

/**
 * Fuzzy match: returns projects whose name contains the query (case-insensitive)
 */
export function searchProjects(query: string): KnownProject[] {
  if (!query || query.length < 2) return NAGPUR_PROJECTS;
  const q = query.toLowerCase();
  return NAGPUR_PROJECTS.filter((p) =>
    p.name.toLowerCase().includes(q) ||
    p.type.toLowerCase().includes(q) ||
    p.villages.toLowerCase().includes(q)
  );
}
