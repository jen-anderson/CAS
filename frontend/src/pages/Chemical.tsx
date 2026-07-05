import { useEffect, useState } from "react";
import { useRDKit } from './../hooks/useRDKit.ts'
import { useParams } from "react-router-dom";
import type { Observation, GroupedObservations, ChemicalData } from './../../../types/types.ts'
import { getCanonicalObservation } from "../services/dataHelpers.ts";
import { fetchChemicalDetails } from "../services/fetchChemicalDetails.ts";
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

export const Chemical = () => {

  const { id } = useParams()
  const [data, setData] = useState<ChemicalData | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    
    const loadData = async () => {
      setLoading(true)
      try{
      const data = await fetchChemicalDetails(id)
      setData(data);
      } catch (error){
      console.error('Fetch failed:', error)
      } finally {
      setLoading(false);
      };
    }
    loadData();
  }, [id]);

  if (loading) return <div>Loading...</div>
  if(!data) return <div>Chemical not found.</div>
console.log(data)

const groupedObservations: GroupedObservations = data.observation?.reduce((acc: GroupedObservations, obs: Observation) => {
  const refId = obs.reference_id || "Uncategorized";
  if (!acc[refId]) {
    acc[refId] = [];
  }
  acc[refId].push(obs);
  return acc;
}, {} as GroupedObservations);


const hansenD = getCanonicalObservation(data.observation, 'HANSEN_D') as Observation | undefined;
const hansenP = getCanonicalObservation(data.observation, 'HANSEN_P') as Observation | undefined;
const hansenH = getCanonicalObservation(data.observation, 'HANSEN_H') as Observation | undefined;

return (
    <div className="page-layout">
      <aside className="sidebar">
        <h3>Formula Details</h3>
        {data.solvent_formula?.length > 0 ? (
          data.solvent_formula.map((item) => (
        <div key={item.formula.formula_id} className="component-container">
          {data.refchem_id && (
            <div className="structure-preview">
              <h4>Chemical Structure</h4>
              <a 
                href={`https://pubchem.ncbi.nlm.nih.gov/compound/${data.refchem_id}#section=3D-Conformer`} 
                target="_blank" 
                rel="noopener noreferrer"
                className="chemical-link"
                title="View interactive 3D model on PubChem"
              >
                <ChemicalStructure smiles={item.formula.smiles} />
              </a>
              </div>
            )}

            <div key={item.formula.formula_id} className="formula-card">
              <p><strong>Concentration:</strong> {item.fraction * 100}%</p>
              <div className="property-grid">
                <p><strong>MW:</strong> {item.formula.molecular_weight}</p>
                <p><strong>Flash Point:</strong> {item.formula.flash_point}</p>
                <p><strong>LogP:</strong> {item.formula.logp_min} - {item.formula.logp_max}</p>
              </div>
              <details>
                <summary>More Info</summary>
                <p><small><strong>InChI:</strong> {item.formula.inchi}</small></p>
                <p><small><strong>SMILES:</strong> {item.formula.smiles}</small></p>
              </details>
            </div>
            </div>
          ))
        ) : (
          <div className="empty-state">
            <p>No formula information available.</p>
          </div>
        )}

      {data.alias && data.alias.length > 0 && (
        <div className="synonyms-section">
          <h4>Synonyms & Aliases</h4>
          <ul className="synonym-list">
            {data.alias.map((a) => (
              <li key={a.alias_id}>
                <span className="alias-type">[{a.alias_type}]</span> {a.alias_name}
              </li>
            ))}
          </ul>
        </div>
      )}
</aside>


  <main className="content">
    <header className="main-header">
      <h1>{data.canonical_name}</h1>
    </header>
    <div className="grid-body">
    <section className="summary-box">
      <h2>Hansen Parameters</h2>
      <div className="hansen-triplet">
        <p><strong>Dispersion (δD):</strong> {hansenD.value ?? 'N/A'}{hansenD.unit}</p>
        <p><strong>Polar (δP):</strong> {hansenP.value ?? 'N/A'}{hansenP.unit}</p>
        <p><strong>Hydrogen bonds (δH):</strong> {hansenH.value ?? 'N/A'}{hansenH.unit}</p>
      </div>
      <p>
        <small>
    Based on Priority Source: {hansenD?.reference?.title   || 'None'}<span>    </span>   
    {hansenD?.reference?.url && ( 
      <span>
          <a href={hansenD.reference.url} target="_blank" rel="noreferrer">
          link
        </a>
      </span>
    )}
  </small>
      </p>
    </section>

  </div>
  </main>
<div className="chart-sidebar">
  {hansenD && hansenP && hansenH && (
    <TeasChart 
      d={hansenD.value} 
      p={hansenP.value} 
      h={hansenH.value} 
    />
  )}
  <div className="hansen-section">
  {groupedObservations && Object.entries(groupedObservations).map(([refId, obsArray ]) => (
    <div key={refId} className="reference-group">
      <h3>Source: {refId} --  {obsArray[0].reference.title}</h3>
  
        <div className="hansen-grid">
            {obsArray.map((obs) => (
              <div key={obs.observation_id} className="hansen-card">
                <strong>{obs.property_code}</strong>
                <p>{obs.value}{obs.unit}</p>
              </div>
            ))}
        </div>
      </div>
    ))}
  </div>
</div>

</div>
  )
}

