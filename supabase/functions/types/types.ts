import { SupabaseClient } from "jsr:@supabase/supabase-js@2";

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
}

export type HandlerFunction = (
  req: Request,
  ctx: AppContext,
  ...args: string[]
) => Promise<Response>;