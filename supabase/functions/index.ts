import { withSupabase } from "./middleware.ts"; // Assuming you have a local middleware file
import { SupabaseClient } from '@supabase/supabase-js'

//Define context
export interface AppContext {
  supabase: SupabaseClient;
  // Add other properties you use in ctx here
}

//Handlers
import { referenceHandler } from "./lib/_handlers/references.ts";
import { property_typeHandler } from "./lib/_handlers/property_type.ts";
import { solventHandler } from "./lib/_handlers/solvent.ts";
import { aliasHandler } from "./lib/_handlers/alias.ts";
import { observationHandler } from "./lib/_handlers/observation.ts";
import { formulaHandler } from "./lib/_handlers/formula.ts";
import { solvent_formulaHandler } from "./lib/_handlers/solvent_formula.ts";
import { hazard_codeHandler } from "./lib/_handlers/hazard_code.ts";
import { p_codeHandler } from "./lib/_handlers/p_code.ts";
import { alias_referenceHandler } from "./lib/_handlers/alias_reference.ts";
import { pcode_group_mapHandler } from "./lib/_handlers/pcode_group_map.ts";
import { formula_hazardHandler } from "./lib/_handlers/formula_hazard.ts";
import { hazard_pcodeHandler } from "./lib/_handlers/hazard_pcode.ts";
import { solvent_hazardHandler } from "./lib/_handlers/solvent_hazard.ts";
import { solvent_referenceHandler } from "./lib/_handlers/solvent_reference.ts";


const routes: Record<string, any> = {
  "/references": referenceHandler,
  "/property_type": property_typeHandler,
  "/solvent": solventHandler,
  "/alias": aliasHandler,
  "/observation": observationHandler,
  "/formula": formulaHandler,
  "/solvent_formula": solvent_formulaHandler,
  "/hazard_code": hazard_codeHandler,
  "/p_code": p_codeHandler,
  "/alias_reference": alias_referenceHandler,
  "/formula_hazard": formula_hazardHandler,
  "/hazard_pcode": hazard_pcodeHandler,
  "/pcode_group_map": pcode_group_mapHandler,
  "/solvent_hazard": solvent_hazardHandler,
  "/solvent_reference": solvent_referenceHandler,
};

export default {
  fetch: withSupabase({ auth: ["publishable", "secret"] }, async (req: Request, ctx: AppContext) => {
    const url = new URL(req.url);
    const path = url.pathname;
    const method = req.method;

    // Sort the keys by length (longest first) so "/solvent_formula" is checked before "/solvent"
    const routeKeys = Object.keys(routes).sort((a, b) => b.length - a.length);
    const routeKey = routeKeys.find((key) => path.startsWith(key));

    if (routeKey) {
      return await routes[routeKey](req, method, ctx);
    }

    return new Response("Not Found", { status: 404 });
  }),
};

