import { AppContext } from "~/index.ts";

// Database Helper Functions 
async function getOne(id: string, ctx: AppContext) {
  return await ctx.supabase.from("solvent_reference").select("*, solvent(*), reference(*)").eq("id", id).single();
}

async function search(ctx: AppContext, filters: { solvent_id?: string, reference_id?: string }) {
  let dbQuery = ctx.supabase.from("solvent_reference").select("*, solvent(*), reference(*)");
  if (filters.solvent_id) dbQuery = dbQuery.eq("solvent_id", filters.solvent_id);
  if (filters.reference_id) dbQuery = dbQuery.eq("reference_id", filters.reference_id);
  return await dbQuery;
}

async function add(body: any, ctx: AppContext) {
  return await ctx.supabase.from("solvent_reference").insert(body);
}

async function update(id: string, body: any, ctx: AppContext) {
  return await ctx.supabase.from("solvent_reference").update(body).eq("id", id);
}

async function remove(id: string, ctx: AppContext) {
  return await ctx.supabase.from("solvent_reference").delete().eq("id", id);
}

// Main Handler 
export async function solvent_referenceHandler(req: Request, method: string, ctx: AppContext) {
  const url = new URL(req.url);
  const id = url.searchParams.get('id');

  switch (method) {
    case 'GET': {
      const sId = url.searchParams.get('solvent_id');
      const rId = url.searchParams.get('reference_id');

      const filters: { solvent_id?: string; reference_id?: string } = {};
      if (sId) filters.solvent_id = sId;
      if (rId) filters.reference_id = rId;

      const { data, error } = await search(ctx, filters);
      return error ? new Response(JSON.stringify(error), { status: 500 }) : new Response(JSON.stringify(data), { status: 200 });
    }

    case 'POST': {
      const body = await req.json();
      const { data, error } = await add(body, ctx);
      return error ? new Response(JSON.stringify(error), { status: 500 }) : new Response(JSON.stringify(data), { status: 201 });
    }

    case 'PATCH': {
      if (!id) return new Response("Missing ID", { status: 400 });
      const body = await req.json();
      const { data, error } = await update(id, body, ctx);
      return error ? new Response(JSON.stringify(error), { status: 500 }) : new Response(JSON.stringify(data), { status: 200 });
    }

    case 'DELETE': {
      if (!id) return new Response("Missing ID", { status: 400 });
      const { error } = await remove(id, ctx);
      return error ? new Response(JSON.stringify(error), { status: 500 }) : new Response(null, { status: 204 });
    }

    default:
      return new Response("Method Not Allowed", { status: 405 });
  }
}