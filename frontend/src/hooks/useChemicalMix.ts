import { useState, useEffect, useMemo } from "react"
import type { ChemicalData } from "../../../types/types.ts"
import { fetchChemicalDetails } from "../services/fetchChemicalDetails.ts"
import { getCanonicalObservation } from "../services/dataHelpers.ts"


export const useChemicalMix = (solventIds: string[], ratios: number[]) => {
  const [data, setData] = useState<ChemicalData[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    if (!solventIds.length) return

    let isMounted = true //Cleanup

    const loadData = async () => {
      setLoading(true);
      try {
        const results = await Promise.all(solventIds.map(id => fetchChemicalDetails(id)));
        if (isMounted) {
          setData(results);
          setLoading(false);
        }
      } catch (err) {
        console.error("Failed to fetch mix:", err)
        setLoading(false)
      }
    }
    loadData();

    return () => { isMounted = false } //Cancel state updates
  }, [JSON.stringify(solventIds)]);

  const mixHSP = useMemo(() => {
    if (data.length !== ratios.length) return null;
    return data.reduce((acc, chem, idx) => {
      const getVal = (code: string) => {
        const obs = getCanonicalObservation(chem.observation, code);
        return parseFloat(obs?.value ? String(obs.value) : '0');
      };

      const d = getVal('HANSEN_D');
      const p = getVal('HANSEN_P');
      const h = getVal('HANSEN_H');

      return {
        d: acc.d + (d * ratios[idx]),
        p: acc.p + (p * ratios[idx]),
        h: acc.h + (h * ratios[idx]),
      }
    }, { d: 0, p: 0, h: 0 })
  }, [data, ratios])
  return { data, mixHSP, loading, solventIds, ratios }
}