import {
  Album as PrismaAlbum,
  Track as PrismaTrack,
  Artist as PrismaArtist,
} from "@prisma/client";
import { Album, AlbumEntity, Track, Artist } from "../../domain/entities";
import { mapPrismaArtistToEntity } from "./artist.mapper";

/**
 * Prisma Album with relations
 */
type PrismaAlbumWithRelations = PrismaAlbum & {
  tracks?: PrismaTrack[];
  artists?: Array<{
    artist: PrismaArtist;
  }>;
};

/**
 * Map Prisma Album model to domain Album entity
 */
export function mapPrismaAlbumToEntity(
  prismaAlbum: PrismaAlbumWithRelations,
): Album {
  const tracks: Track[] = (prismaAlbum.tracks || []).map((track) => ({
    id: track.id,
    title: track.title,
    coverUrl: track.cover_url || prismaAlbum.cover_url,
    trackUrl: track.track_url,
    duration: track.duration,
  }));

  const artists: Artist[] = (prismaAlbum.artists || []).map((albumArtist) =>
    mapPrismaArtistToEntity(albumArtist.artist),
  );

  return AlbumEntity.create({
    id: prismaAlbum.id,
    title: prismaAlbum.title,
    coverUrl: prismaAlbum.cover_url,
    tracks,
    artists,
  });
}

/**
 * Map array of Prisma Albums to domain entities
 */
export function mapPrismaAlbumsToEntities(
  prismaAlbums: PrismaAlbumWithRelations[],
): Album[] {
  return prismaAlbums.map(mapPrismaAlbumToEntity);
}
