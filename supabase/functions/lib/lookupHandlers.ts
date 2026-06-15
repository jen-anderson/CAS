import { AppContext, HandlerFunction } from "../../../types/types.ts"


export const lookupHandler = (tableName: string, primaryKey: string): HandlerFunction => {
  return async (req: Request, ctx: AppContext, method: string) => {
    const { supabase } = ctx;


    if (!supabase) {
      console.error("CRITICAL: supabase client missing in ctx");
      return new Response("Internal Server Error", { status: 500 });
    }

    if (!req || !req.url) {
      console.error("CRITICAL: 'req' is undefined or missing a URL!");
      return new Response("Bad Request", { status: 400 });
    }

    const url = new URL(req.url)
    const id = url.searchParams.get('id') //Solvent id
    console.log("DEBUG: Supabase URL is:", Deno.env.get("SUPABASE_URL"));
    console.log("Fetching chemical for ID:", id);

    const { data, error } = await supabase
      .from(tableName)
      .select(`
      solvent_id,
      canonical_name,
      refchem_id,
      solvent_formula (
        fraction,
        formula (
          formula_id,
          canonical_name,
          molecular_weight,
          smiles,
          inchi,
          boiling_point,
          flash_point,
          logp_min,
          logp_max
        )
      ),
      observation (
        observation_id,
        property_code,
        value,
        unit,
        conditions,
        notes,
        priority_score,
        reference_id,
        reference (
          reference_id,
          title,
          reference_type,
          url
        )
      ),
      alias (
        alias_id,
        alias_name,
        alias_type
        )
      )
    `)

      .eq(primaryKey, id)
      .maybeSingle()


    if (error) {
      console.error("DB Error:", error);
      return new Response(JSON.stringify({ error: error.message }), { status: 500 });
    };


    if (!data) {
      return new Response(JSON.stringify({ error: "Chemical not found" }), { status: 404 });
    };

    if (data?.observation) {
      data.observation.sort((a: any, b: any) => (b.priority_score || 0) - (a.priority_score || 0));
    }

    return new Response(JSON.stringify(data), {
      headers: { 'Content-Type': 'application/json' }
    });
  };
};

export const mixLookupHandler: HandlerFunction = async (req: Request, ctx: AppContext) => {
  const { supabase } = ctx;
  const url = new URL(req.url)
  const id = url.searchParams.get('id') //Solvent id

  const { data, error } = await supabase


  if (error) return new Response(JSON.stringify(error), { status: 500 });
  return new Response(JSON.stringify(data), { headers: { 'Content-Type': 'application/json' } });
}