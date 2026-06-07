import { AppContext } from "./../types/types.ts"


async function add(tableName: string, body: any, ctx: AppContext) {
  return await ctx.supabase.from(tableName).insert(body);
}

async function update(tableName: string, id: string, body: any, ctx: AppContext) {
  return await ctx.supabase.from(tableName).update(body).eq("id", id);
}

async function remove(tableName: string, id: string, ctx: AppContext) {
  return await ctx.supabase.from(tableName).delete().eq("id", id);
}

export const baseHandler = (
  tableName: string,
  searchField: string = "name" // Default to 'name', but override for join tables
) => async (req: Request, method: string, ctx: AppContext) => {
  const url = new URL(req.url);
  const id = url.searchParams.get('id') ?? "";
  console.log('index')

  try {
    switch (method) {
      case 'GET': {
        if (id) {
          const { data, error } = await ctx.supabase
            .from(tableName)
            .select("*")
            .eq("id", id)
            .single();
          return error ? new Response(JSON.stringify(error), { status: 404 }) : new Response(JSON.stringify(data), { status: 200 });
        }

        const selectQuery = url.searchParams.get('select') ?? "*";
        const q = url.searchParams.get('q');

        // Use Supabase 'count: exact' instead of Prisma
        let query = ctx.supabase
          .from(tableName)
          .select(selectQuery, { count: 'exact' });

        if (q) {
          if (q.includes('-')) query = query.eq(searchField, q);
          else query = query.ilike(searchField, `%${q}%`);
        }

        const { data, error, count } = await query;

        // You can now access 'count' directly from the Supabase response
        console.log('Total items:', count);

        return error ? new Response(JSON.stringify(error), { status: 500 }) : new Response(JSON.stringify(data), { status: 200 });
      }

      case 'POST': {
        const body = await req.json();
        const { data, error } = await add(tableName, body, ctx);
        return error ? new Response(JSON.stringify(error), { status: 500 }) : new Response(JSON.stringify(data), { status: 201 });
      }

      case 'PATCH': {
        if (!id) return new Response("Missing ID", { status: 400 });
        const body = await req.json();
        const { data, error } = await update(tableName, id, body, ctx);
        return error ? new Response(JSON.stringify(error), { status: 500 }) : new Response(JSON.stringify(data), { status: 200 });
      }

      case 'DELETE': {
        if (!id) return new Response("Missing ID", { status: 400 });
        const { error } = await remove(tableName, id, ctx);
        return error ? new Response(JSON.stringify(error), { status: 500 }) : new Response(null, { status: 204 });
      }
      default:
        return new Response("Method Not Allowed", { status: 405 });
    }
  } catch (err) {
    return new Response(JSON.stringify({ error: "Internal Server Error" }), { status: 500 });
  }
};
