import { SupabaseClient } from '@supabase/supabase-js';

export interface AppContext {
  supabase: SupabaseClient;
  // logger: Logger;
  // cache: RedisClient;
}