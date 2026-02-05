import { Artist as PrismaArtist } from "@prisma/client";
import { Artist, ArtistEntity } from "../../domain/entities";

/**
 * Map Prisma Artist model to domain Artist entity
 */
export function mapPrismaArtistToEntity(prismaArtist: PrismaArtist): Artist {
  return ArtistEntity.create({
    id: prismaArtist.id,
    name: prismaArtist.name,
    profileUrl: prismaArtist.profile_url,
  });
}

/**
 * Map array of Prisma Artists to domain entities
 */
export function mapPrismaArtistsToEntities(
  prismaArtists: PrismaArtist[],
): Artist[] {
  return prismaArtists.map(mapPrismaArtistToEntity);
}
