import { AppContext } from "~/index.ts";

// Returns raw { data, error } so the handler can decide the HTTP response.
async function getOne(id: string, ctx: AppContext) {
  return await ctx.supabase.from("pcode_group").select("*").eq("id", id).single();
}

async function search(query: string | null, ctx: AppContext) {
  let dbQuery = ctx.supabase.from("pcode_group").select("*");
  if (query) dbQuery = dbQuery.ilike("name", `%${query}%`);
  return await dbQuery;
}

async function add(body: any, ctx: AppContext) {
  return await ctx.supabase.from("pcode_group").insert(body);
}

async function update(id: string, body: any, ctx: AppContext) {
  return await ctx.supabase.from("pcode_group").update(body).eq("id", id);
}

async function remove(id: string, ctx: AppContext) {
  return await ctx.supabase.from("pcode_group").delete().eq("id", id);
}

// Main Handler (Traffic Controller) ---
export async function pcode_groupHandler(req: Request, method: string, ctx: AppContext) {
  const url = new URL(req.url);
  const id = url.searchParams.get('id') ?? "";

  try {
    switch (method) {
      case 'GET': {
        if (id) {
          const { data, error } = await getOne(id, ctx);
          return error ? new Response(JSON.stringify(error), { status: 404 }) : new Response(JSON.stringify(data), { status: 200 });
        }
        const q = url.searchParams.get('q');
        const { data, error } = await search(q, ctx);
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
  } catch (err) {
    return new Response(JSON.stringify({ error: "Internal Server Error" }), { status: 500 });
  }
}