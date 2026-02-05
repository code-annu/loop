import { injectable } from "inversify";
import { PrismaClient } from "@prisma/client";
import { IArtistRepository } from "../../domain/repositories";
import { Artist } from "../../domain/entities";
import { prisma } from "../database/prisma-client";
import {
  mapPrismaArtistToEntity,
  mapPrismaArtistsToEntities,
} from "../mappers";

/**
 * Prisma implementation of Artist Repository
 */
@injectable()
export class PrismaArtistRepository implements IArtistRepository {
  private readonly db: PrismaClient;

  constructor() {
    this.db = prisma;
  }

  async findById(id: string): Promise<Artist | null> {
    const artist = await this.db.artist.findUnique({
      where: { id },
    });

    if (!artist) {
      return null;
    }

    return mapPrismaArtistToEntity(artist);
  }

  async findRandom(limit: number): Promise<Artist[]> {
    // PostgreSQL random ordering
    // Using $queryRawUnsafe to avoid prepared statement issues with PgBouncer
    const artists = await this.db.$queryRawUnsafe<
      Array<{
        id: string;
        name: string;
        profile_url: string | null;
        created_at: Date;
      }>
    >(`SELECT * FROM artists ORDER BY RANDOM() LIMIT $1`, limit);

    return artists.map((artist) => mapPrismaArtistToEntity(artist as any));
  }

  async findAll(): Promise<Artist[]> {
    const artists = await this.db.artist.findMany({
      orderBy: { name: "asc" },
    });

    return mapPrismaArtistsToEntities(artists);
  }
}
