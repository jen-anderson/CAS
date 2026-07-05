import fs from 'fs'
import path from 'path'

const models = [
  'references',
  'property_type',
  'solvent',
  'alias',
  'observation',
  'formula',
  'solvent_formula',
  'hazard_code',
  'p_code',
  'hazard_classification',
  'pcode_group',
  'alias_reference',
  'formula_hazard',
  'hazard_pcode',
  'pcode_group_map',
  'solvent_hazard',
  'solvent_reference',
]

const template = tableName => `
import { supabase } from '../supabaseClient'; 

export async function ${tableName}Handler(req: Request, method: string, ctx: any) {
  const { supabase } = ctx;
  const url = new URL(req.url);
  const id = url.searchParams.get('id');

  switch (method) {
    case 'GET':
      return id ? await getOne(supabase, '${tableName}', id) : await getAll(supabase, '${tableName}');
    case 'POST': return await create(supabase, '${tableName}', req);
    case 'PATCH': return await update(supabase, '${tableName}', id, req);
    case 'DELETE': return await remove(supabase, '${tableName}', id);
    default: return new Response("Method Not Allowed", { status: 405 });
  }
}

async function getAll(supabase: any, table: string) {
  const { data, error } = await supabase.from(table).select("*");
  if (error) return new Response(JSON.stringify(error), { status: 500 });
  return new Response(JSON.stringify(data), { status: 200 });
}

async function getOne(supabase: any, table: string, id: string) {
  const { data, error } = await supabase.from(table).select("*").eq("id", id).single();
  if (error) return new Response(JSON.stringify(error), { status: 500 });
  return new Response(JSON.stringify(data), { status: 200 });
}

async function create(supabase: any, table: string, req: Request) {
  const body = await req.json();
  const { data, error } = await supabase.from(table).insert(body);
  if (error) return new Response(JSON.stringify(error), { status: 500 });
  return new Response(JSON.stringify(data), { status: 201 });
}

async function update(supabase: any, table: string, id: string | null, req: Request) {
  if (!id) return new Response("Missing ID", { status: 400 });
  const body = await req.json();
  const { data, error } = await supabase.from(table).update(body).eq("id", id);
  if (error) return new Response(JSON.stringify(error), { status: 500 });
  return new Response(JSON.stringify(data), { status: 200 });
}

async function remove(supabase: any, table: string, id: string | null) {
  if (!id) return new Response("Missing ID", { status: 400 });
  const { error } = await supabase.from(table).delete().eq("id", id);
  if (error) return new Response(JSON.stringify(error), { status: 500 });
  return new Response(null, { status: 204 });
}
`

const dir = './lib/handlers'
if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true })

models.forEach(model => {
  const filePath = path.join(dir, `${model}.ts`)
  console.log(`Generated ${filePath}`)
})
