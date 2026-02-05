import { injectable } from "inversify";
import { PrismaClient } from "@prisma/client";
import { ITrackRepository } from "../../domain/repositories";
import { Track } from "../../domain/entities";
import { prisma } from "../database/prisma-client";
import { mapPrismaTrackToEntity, mapPrismaTracksToEntities } from "../mappers";

/**
 * Prisma implementation of Track Repository
 */
@injectable()
export class PrismaTrackRepository implements ITrackRepository {
  private readonly db: PrismaClient;

  constructor() {
    this.db = prisma;
  }

  async findById(id: string): Promise<Track | null> {
    const track = await this.db.track.findUnique({
      where: { id },
      include: {
        album: true,
        artists: {
          include: {
            artist: true,
          },
        },
      },
    });

    if (!track) {
      return null;
    }

    return mapPrismaTrackToEntity(track);
  }

  async findRandom(limit: number): Promise<Track[]> {
    // Get random track IDs using raw query
    // Using $queryRawUnsafe to avoid prepared statement issues with PgBouncer
    const randomIds = await this.db.$queryRawUnsafe<Array<{ id: string }>>(
      `SELECT id FROM tracks ORDER BY RANDOM() LIMIT $1`,
      limit,
    );

    if (randomIds.length === 0) {
      return [];
    }

    // Fetch full track data with relations
    const tracks = await this.db.track.findMany({
      where: {
        id: { in: randomIds.map((r) => r.id) },
      },
      include: {
        album: true,
        artists: {
          include: {
            artist: true,
          },
        },
      },
    });

    return mapPrismaTracksToEntities(tracks);
  }

  async findAll(): Promise<Track[]> {
    const tracks = await this.db.track.findMany({
      orderBy: { title: "asc" },
      include: {
        album: true,
        artists: {
          include: {
            artist: true,
          },
        },
      },
    });

    return mapPrismaTracksToEntities(tracks);
  }

  async findByAlbumId(albumId: string): Promise<Track[]> {
    const tracks = await this.db.track.findMany({
      where: { album_id: albumId },
      orderBy: { title: "asc" },
      include: {
        album: true,
        artists: {
          include: {
            artist: true,
          },
        },
      },
    });

    return mapPrismaTracksToEntities(tracks);
  }
}
