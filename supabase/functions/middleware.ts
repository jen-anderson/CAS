import { createClient } from "@supabase/supabase-js";
import { AppContext } from "./types/types.ts";

export function withSupabase(config: any, handler: Function) {
  return async (req: Request) => {
    const url = Deno.env.get("PROJECT_URL");
    const key = Deno.env.get("SERVICE_ROLE_KEY");

    if (!url || !key) {
      console.error("Missing environment variables!");
      return new Response("Server Configuration Error", { status: 500 });
    }

    const supabase = createClient(url, key)

    const ctx: AppContext = { supabase };

    return await handler(req, ctx);

  };
}