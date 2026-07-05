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

export const calculateHSPPercentages = (d: number, p: number, h: number) => {
  const sum = d + p + h
  return {
    d: d.toFixed(2),
    p: p.toFixed(2),
    h: h.toFixed(2),
    dPct: sum > 0 ? ((d / sum) * 100).toFixed(2) : "0.00",
    pPct: sum > 0 ? ((p / sum) * 100).toFixed(2) : "0.00",
    hPct: sum > 0 ? ((h / sum) * 100).toFixed(2) : "0.00",
  }
}

export const getVal = (obs: any): number => {
  if (typeof obs === 'number') return obs
  return obs?.value ?? 0
}