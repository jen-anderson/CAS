import { useEffect, useState } from "react";
import { apiClient } from "../services/api.ts";
import { useParams } from "react-router-dom";
import type { Observation, GroupedObservations, ChemicalData } from './../../../types/types.ts'
import { getCanonicalObservation } from "../services/dataHelpers.ts";

export const Chemical = () => {

  const { id } = useParams()
  console.log("Current Params:", id); // Check your console!
  const [data, setData] = useState<ChemicalData | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    
    const fetchChemicalDetails = async () => {
      setLoading(true)
      try{
      const data = await apiClient(`chemical_lookup?id=${id}`);
      setData(data);
      } catch (error){
      console.error('Fetch failed:', error)
      } finally {
      setLoading(false);
      };
    }
    fetchChemicalDetails();
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
    <div>
      <h1>{data.canonical_name}</h1>

      {/* Summary Header */}
    <section className="summary-box">
      <h2>Canonical Hansen Parameters</h2>
      <div className="hansen-triplet">
        <p><strong>Dispersion (δD):</strong> {hansenD.value ?? 'N/A'}{hansenD.unit}</p>
        <p><strong>Polar (δP):</strong> {hansenP.value ?? 'N/A'}{hansenP.unit}</p>
        <p><strong>Hydrogen bonds (δH):</strong> {hansenH.value ?? 'N/A'}{hansenH.unit}</p>
      </div>
      <p>
        <small>
    Based on Priority Source: {hansenD?.reference?.title || 'None'}
    {hansenD?.reference?.url && (
      <span>
        : <a href={hansenD.reference.url} target="_blank" rel="noreferrer">
          {hansenD.reference.title}
        </a>
      </span>
    )}
  </small>
      </p>
    </section>


      {data.solvent_formula?.length > 0 ? (
        data.solvent_formula.map((item) => (
          <div key={item.formula.formula_id}>
            {item.formula.canonical_name}(Fraction: {item.fraction})
            <p>
            {item.formula.inchi}
            </p><p>
            <span>SMILES: </span>{item.formula.smiles}
            </p><p>
            <span>Flash point: </span>{item.formula.flash_point}
            </p><p>
            <span>Formula id: </span>{item.formula.formula_id}
            </p><p>
            <span>LogP max: </span>{item.formula.logp_max} 
            </p><p>
            <span>LogP min: </span>{item.formula.logp_min}
            </p><p>
            <span>Molecular weight: </span>{item.formula.molecular_weight}
            </p>
            </div>
        ))
      ) : (
        <p>No formula information available.</p>
      )}
{groupedObservations && Object.entries(groupedObservations).map(([refId, obsArray ]) => (
  <div key={refId} className="reference-group">
    <h3>Source: {refId}</h3>
    <table>
      <thead>
        <tr>
          <th>Property</th>
          <th>Value</th>
          <th>Unit</th>
        </tr>
      </thead>
      <tbody>
        {obsArray.map((obs) => (
          <tr key={obs.observation_id}>
            <td>{obs.property_code}</td>
            <td>{obs.value}</td>
            <td>{obs.unit}</td>
          </tr>
        ))}
      </tbody>
    </table>
  </div>
))}
        </div>

  )
}