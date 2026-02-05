import { PrismaClient } from "@prisma/client";

/**
 * Singleton Prisma Client instance
 */
class PrismaClientSingleton {
  private static instance: PrismaClient;

  private constructor() {}

  public static getInstance(): PrismaClient {
    if (!PrismaClientSingleton.instance) {
      PrismaClientSingleton.instance = new PrismaClient({
        log:
          process.env.NODE_ENV === "development"
            ? ["query", "info", "warn", "error"]
            : ["error"],
      });
    }
    return PrismaClientSingleton.instance;
  }
}

export const prisma = PrismaClientSingleton.getInstance();

/**
 * Graceful shutdown handler
 */
export async function disconnectPrisma(): Promise<void> {
  await prisma.$disconnect();
}
