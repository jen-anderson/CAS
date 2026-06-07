import { PrismaClient } from "../../../generated/prisma/client.ts";

const dummyAdapter = {
  provider: "postgres" as const,
  performIO: async (args: any) => {
    // This await satisfies the TypeScript requirement for async functions
    await new Promise((resolve) => setTimeout(resolve, 0));

    console.log("Prisma attempted to run query:", args);
    return {
      rows: [],
      rowCount: 0,
    };
  },
  // The interface requires a close method
  close: async () => { },
};

const globalForPrisma = globalThis as unknown as { prisma: PrismaClient };

// We pass the adapter to satisfy the generated client's strict requirements
export const prisma = globalForPrisma.prisma || new PrismaClient({
  adapter: dummyAdapter as any
});

if (Deno.env.get("NODE_ENV") !== "production") {
  globalForPrisma.prisma = prisma;
}