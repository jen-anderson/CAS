import { createClient } from "jsr:@supabase/supabase-js@2";
import { AppContext, HandlerFunction } from "../../../types/types.ts";

export function withSupabase(config: Record<string, unknown>, handler: HandlerFunction) {
  return async (req: Request): Promise<Response> => {
    const url = Deno.env.get("SUPABASE_URL") || "http://127.0.0.1:54321";

    const anonKey = Deno.env.get("SUPABASE_ANON_KEY") || "YOUR_ANON_KEY";

    const authHeader = req.headers.get("Authorization") || "";
    const token = authHeader.replace("Bearer ", "");

    const supabase = createClient(url, anonKey, {
      global: {
        headers: {
          Authorization: `Bearer ${authHeader.replace("Bearer ", "")}`,
        },
      },
    });

    const ctx: AppContext = { supabase };
    return await handler(req, ctx, req.method);
  };
}

export const protect = (handler: HandlerFunction) => {
  return async (req: Request, ctx: AppContext) => {

    const { data: { user }, error } = await ctx.supabase.auth.getUser();

    if (error || !user) {
      return new Response("Unauthorized", { status: 401 });
    }

    return await handler(req, ctx);
  };
};