import { injectable } from "inversify";
import { PrismaClient } from "@prisma/client";
import { IAlbumRepository } from "../../domain/repositories";
import { Album } from "../../domain/entities";
import { prisma } from "../database/prisma-client";
import { mapPrismaAlbumToEntity, mapPrismaAlbumsToEntities } from "../mappers";

/**
 * Prisma implementation of Album Repository
 */
@injectable()
export class PrismaAlbumRepository implements IAlbumRepository {
  private readonly db: PrismaClient;

  constructor() {
    this.db = prisma;
  }

  async findById(id: string): Promise<Album | null> {
    const album = await this.db.album.findUnique({
      where: { id },
      include: {
        tracks: {
          orderBy: { title: "asc" },
        },
        artists: {
          include: {
            artist: true,
          },
        },
      },
    });

    if (!album) {
      return null;
    }

    return mapPrismaAlbumToEntity(album);
  }

  async findRandom(limit: number): Promise<Album[]> {
    // Get random album IDs using raw query
    // Using $queryRawUnsafe to avoid prepared statement issues with PgBouncer
    const randomIds = await this.db.$queryRawUnsafe<Array<{ id: string }>>(
      `SELECT id FROM albums ORDER BY RANDOM() LIMIT $1`,
      limit,
    );

    if (randomIds.length === 0) {
      return [];
    }

    // Fetch full album data with relations
    const albums = await this.db.album.findMany({
      where: {
        id: { in: randomIds.map((r) => r.id) },
      },
      include: {
        tracks: {
          orderBy: { title: "asc" },
        },
        artists: {
          include: {
            artist: true,
          },
        },
      },
    });

    return mapPrismaAlbumsToEntities(albums);
  }

  async findAll(): Promise<Album[]> {
    const albums = await this.db.album.findMany({
      orderBy: { title: "asc" },
      include: {
        tracks: true,
        artists: {
          include: {
            artist: true,
          },
        },
      },
    });

    return mapPrismaAlbumsToEntities(albums);
  }
}
