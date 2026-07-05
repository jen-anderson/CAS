import { useEffect, useState } from "react";
import { useRDKit } from './../hooks/useRDKit.ts'
import { getCanonicalObservation, calculateHSPPercentages, getVal } from "../services/dataHelpers.ts";
import { useChemicalMix } from "../hooks/useChemicalMix.ts";
import { TeasChart } from "../components/TeasChart.tsx";

export const ChemicalStructure = ({smiles}: {smiles: string}) => {
  const {rdkit, loading } = useRDKit()
  const [svg, setSVG ] = useState<string>("");

  useEffect(() => {
    if(rdkit && smiles) {
      const mol = rdkit.get_mol(smiles)
      setSVG(mol.get_svg())
      mol.delete()
    }
  }, [rdkit, smiles])
  if (loading) return <div>Loading renderer...</div>
  return <div className="chemical-svg-container" dangerouslySetInnerHTML={{__html:svg}} />
}

export const ChemicalMix = () => {
  const [mixSlots, _setMixSlots] = useState<{id: string, ratio: number}[]>([{id: 'SOLV-00001', ratio: 0.5}, {id: 'SOLV-00002', ratio: 0.5}])

  const solventIds = mixSlots.map(s => s.id);
  const ratios = mixSlots.map(s => s.ratio);

  const { data, mixHSP, loading } = useChemicalMix(solventIds, ratios);
  console.log(mixHSP)

  if (loading) return <div>Simulating mixture...</div>;
  if (!data || !mixHSP) return <div>Error calculating mixture.</div>;
  
  const mixViewModel = mixHSP ? calculateHSPPercentages(mixHSP.d, mixHSP.p, mixHSP.h) : null;

  const componentViewModel = data.map((chem) => {
    const d = getVal(getCanonicalObservation(chem.observation, 'HANSEN_D'))
    const p = getVal(getCanonicalObservation(chem.observation, 'HANSEN_P'))
    const h = getVal(getCanonicalObservation(chem.observation, 'HANSEN_H'))
    return {...chem, ...calculateHSPPercentages(d, p, h) };
  })


  return (
    <div className="page-layout">
      <aside className="sidebar">
        <h3>Constituent Solvents</h3>
        {componentViewModel.map((chem, index) => {
          const formulaItem = chem.solvent_formula?.[0]; 
          const smiles = formulaItem?.formula?.smiles || "";
          console.log (chem, chem.d, chem.p, chem.h)
  
          return (
            <div key={chem.solvent_id} className="component-container">
              <h4>{chem.canonical_name} ({ratios[index] * 100}%)</h4>
              <ChemicalStructure smiles={smiles} />
              <p>δD: {chem.d} ({chem.dPct}%)</p>
              <p>δP: {chem.p} ({chem.pPct}%)</p>
              <p>δH: {chem.h} ({chem.hPct}%)</p>
            </div>
          );
        })} 
      </aside>

      <main className="content">
        <h2>Mixture Simulation</h2>
        <h2>{data.map(c => c.canonical_name).join(' + ')}</h2>
        
        {mixHSP && (
          <section className="summary-box">
            <h2>Calculated Blend</h2>
            <p><strong>Dispersion (δD):</strong> {mixViewModel.d} ({mixViewModel.dPct}%)</p>
            <p><strong>Polar (δP):</strong> {mixViewModel.p} ({mixViewModel.pPct}%)</p>
            <p><strong>Hydrogen bonds (δH):</strong> {mixViewModel.h} ({mixViewModel.hPct}%)</p>
          </section>
        )}
      </main>

      <div className="chart-sidebar">
        {mixViewModel && <TeasChart d={Number(mixViewModel.dPct)} p={Number(mixViewModel.pPct)} h={Number(mixViewModel.hPct)} />}
      </div>
    </div>
  );
};