import { withSupabase } from "../middleware.ts"; // Assuming you have a local middleware file
import { baseHandler } from "../lib/baseHandler.ts";
import { AppContext } from "../types/types.ts";

console.log("--- WORKER BOOTED ---");

const routes: Record<string, any> = {
  "/references": baseHandler("references", "name"),
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
};

export default {
  fetch: withSupabase({ auth: ["publishable", "secret"] }, async (req: Request, ctx: AppContext) => {
    const url = new URL(req.url);
    const tableName = url.searchParams.get('table');
    const path = tableName ? `/${tableName}` : url.pathname;

    const method = req.method;

    console.log('index')
    console.log('Attempting to match route for path:', path);
    console.log('Detected table:', tableName);
    console.log('Full path:', path);

    // Sort the keys by length (longest first) so "/solvent_formula" is checked before "/solvent"
    const routeKeys = Object.keys(routes).sort((a, b) => b.length - a.length);
    const routeKey = routeKeys.find((key) => path.startsWith(key));

    if (routeKey) {
      return await routes[routeKey](req, method, ctx);
    }

    return new Response("Not Found" + path, { status: 404 });
  }),
};

