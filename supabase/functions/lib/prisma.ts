import { PrismaClient } from "https://esm.sh/@prisma/client@7.8.0?bundle";
import { PrismaPg } from "@prisma/adapter-pg";
import * as pg from "pg";

const pool = new pg.Pool({ connectionString: Deno.env.get("DATABASE_URL") });

const adapter = new PrismaPg(pool);

// Instantiate the client with the adapter
const prisma = new PrismaClient({ adapter });

const count = await prisma.solvent.count();
console.log(count);