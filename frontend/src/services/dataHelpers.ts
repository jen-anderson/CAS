import type { Observation } from "../../../types/types.ts";

export const getCanonicalObservation = (
  observations: Observation[] | undefined,
  propertyCode: string
): Observation | undefined => {
  if (!observations) return undefined;
  return observations
    .filter((obs) => obs.property_code === propertyCode)
    .sort((a, b) => (b.priority_score || 0) - (a.priority_score || 0))[0]
}