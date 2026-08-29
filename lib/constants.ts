// Centralized System Constants for LandGuard AI (Nagpur District Focus)

export const DEFAULT_DISTRICT = "Nagpur";
export const SUPPORTED_DISTRICTS = ["Nagpur"] as const;

export type SupportedDistrict = typeof SUPPORTED_DISTRICTS[number];

/**
 * Normalizes user/API district strings to eliminate free-text casing or whitespace discrepancies.
 */
export function normalizeDistrict(input?: string | null): string {
  if (!input) return DEFAULT_DISTRICT;
  const trimmed = input.trim();
  if (trimmed.toLowerCase() === "nagpur") {
    return "Nagpur";
  }
  return trimmed;
}

export const RFCTLARR_BENCHMARKS = {
  SEC_15_OBJECTION_DAYS: 60,
  SEC_19_DECLARATION_MAX_MONTHS: 12,
  MANDATORY_SOLATIUM_PERCENTAGE: 100,
  STATUTORY_ANNUAL_INTEREST_RATE: 0.12,
  SCHEDULE_V_UPFRONT_REHAB_SHARE: 0.333,
};
