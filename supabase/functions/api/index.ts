import { withSupabase } from "../lib/middleware.ts";
import { baseHandler } from "../lib/baseHandler.ts";
import { AppContext, HandlerFunction } from "../../../types/types.ts";
import { lookupHandler, mixLookupHandler } from "../lib/lookupHandlers.ts";

const corsHeaders = {
  'Access-Control-Allow-Origin': '*', // For now, '*' allows anyone. Change this to 'http://localhost:5173' later.
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};
console.log("--- WORKER BOOTED ---");

const routes: Record<string, HandlerFunction> = {
  "/reference": baseHandler("reference", "name"),
  "/property_type": baseHandler("property_type", "name"),
  "/solvent": baseHandler("solvent", "name"),
  "/alias": baseHandler("alias", "name"),
  "/observation": baseHandler("observation", "name"),
  "/formula": baseHandler("formula", "name"),
  "/solvent_formula": baseHandler("solvent_formula", "solvent_id"),
  "/hazard_code": baseHandler("hazard_code", "name"),
  "/p_code": baseHandler("p_code", "name"),
  "/alias_reference": baseHandler("alias_reference", "alias_id"),
  "/formula_hazard": baseHandler("formula_hazard", "formula_id"),
  "/hazard_pcode": baseHandler("hazard_pcode", "hazard_id"),
  "/pcode_group_map": baseHandler("pcode_group_map", "group_id"),
  "/solvent_hazard": baseHandler("solvent_hazard", "solvent_id"),
  "/solvent_reference": baseHandler("solvent_reference", "solvent_id"),
  "/chemical_lookup": lookupHandler("solvent", "solvent_id"),
  "/mix_lookup": mixLookupHandler
};


export default {
  fetch: withSupabase({ auth: ["publishable"] }, async (req: Request, ctx: AppContext) => {

    if (req.method === 'OPTIONS') {
      return new Response('ok', { headers: corsHeaders });
    }

    const url = new URL(req.url);
    const normalisedPathname = url.pathname.replace(/^\/api/, '') || '/';

    const tableName = url.searchParams.get('table');
    const path = tableName ? `/${tableName}` : normalisedPathname

    const method = req.method;

    console.log('index')
    console.log('Attempting to match route for path:', path);
    console.log('Detected table:', tableName);
    console.log('Full path:', path);

    // Sort the keys by length (longest first) so "/solvent_formula" is checked before "/solvent"
    const routeKeys = Object.keys(routes).sort((a, b) => b.length - a.length);
    const routeKey = routeKeys.find((key) => normalisedPathname.startsWith(key));


    if (routeKey) {
      console.log("Calling handler for:", routeKey);
      return await routes[routeKey](req, ctx, method);
    }

    return new Response("Not Found" + path, { status: 404, headers: corsHeaders });
  }),
};

