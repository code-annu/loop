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
    const randomIds = await this.db.$queryRaw<Array<{ id: string }>>`
      SELECT id FROM albums 
      ORDER BY RANDOM() 
      LIMIT ${limit}
    `;

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

  async search(query: string, limit: number): Promise<Album[]> {
    const albums = await this.db.album.findMany({
      where: {
        title: {
          contains: query,
          mode: "insensitive",
        },
      },
      take: limit,
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
