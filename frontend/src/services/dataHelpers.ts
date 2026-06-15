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


export const getTeasCoordinates = (d: number, p: number, h: number) => {
  const total = d + p + h;
  if (total === 0) return { x: 50, y: 43.3 };

  const fd = d / total;
  const fp = p / total;
  const fh = h / total;

  const x = (0 * fp) + (100 * fh) + (50 * fd);
  const y = (86.6 * fp) + (86.6 * fh) + (0 * fd);

  return { x, y };
};