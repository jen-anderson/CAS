import { createClient } from "jsr:@supabase/supabase-js@2";
import { AppContext } from "./types/types.ts";

export function withSupabase(config: any, handler: Function) {
  return async (req: Request) => {
    // USE THE URL FROM YOUR LOGS
    const url = Deno.env.get("SUPABASE_URL") || "http://kong:8000";

    // USE THE SERVICE ROLE KEY FROM YOUR LOGS
    const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

    if (!serviceKey) {
      console.error("CRITICAL: Service role key not found in env!");
    }

    // Initialize with the Service Role key
    const supabase = createClient(url, serviceKey!);

    const ctx: AppContext = { supabase };
    return await handler(req, ctx);
  };


}