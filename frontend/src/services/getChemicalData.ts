import { getCanonicalObservation } from "./dataHelpers.ts";
import { fetchChemicalDetails } from "./fetchChemicalDetails.ts";

export const getChemicalCanonicalData = async (id: string) => {
  const details = await fetchChemicalDetails(id); // Your existing fetcher

  // Pivot observations 
  const d = String(getCanonicalObservation(details.observation, 'HSP_D')?.value ?? 0);
  const p = String(getCanonicalObservation(details.observation, 'HSP_P')?.value ?? 0);
  const h = String(getCanonicalObservation(details.observation, 'HSP_H')?.value ?? 0);

  return {
    ...details,
    hsp: {
      d: parseFloat(d || '0'),
      p: parseFloat(p || '0'),
      h: parseFloat(h || '0')
    }
  };
};