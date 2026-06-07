import { SupabaseClient } from "npm:@supabase/supabase-js@2";

export interface AppContext {
  supabase: SupabaseClient;
  // logger: Logger;
  // cache: RedisClient;
}