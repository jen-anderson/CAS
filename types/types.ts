export interface BaseRow {
  id?: string;
  [key: string]: unknown
}

export interface MinimalSupabaseClient {
  from: (table: string) => any;
}

export interface AppContext {
  supabase: any;
  // logger: Logger;
  // cache: RedisClient;
}

export interface BaseRecord {
  id: string;
  name?: string;
  created_at?: string;
  updated_at?: string;
}

export interface Solvent extends BaseRecord {
  formula: string;
  cas_number: string;
  refChem_id: string;
}

export type HandlerFunction = (
  req: Request,
  ctx: AppContext,
  ...args: string[]
) => Promise<Response>;

export interface Formula {
  formula_id: string
  canonical_name: string
  smiles: string
  inchi: string
  molecular_weight: number
  flash_point: number
  logp_min: number
  logp_max: number
}

export interface Observation {
  observation_id: string;
  solvent_id: string;
  property_code: string;
  value: number;
  unit: string | null;
  conditions: string | null;
  reference_id: string | null;
  notes: string | null;
  priority_score: number | null;
  reference?: {
    reference_id: string;
    title: string;
    reference_type: string;
    url: string;
  };
}

export interface GroupedObservations {
  [referenceId: string]: Observation[];
}

export interface SolventFormula {
  fraction: number
  formula: Formula
  solvent: Solvent
}

export interface ChemicalData {
  canonical_name: string
  solvent_id: string
  refchem_id: string
  solvent_formula: SolventFormula[]
  observation: Observation[]
  alias: Alias[]
}


export interface Alias {
  alias_id: string
  solvent_id: string
  alias_name: string
  alias_type: string
}