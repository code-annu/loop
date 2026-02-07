import {
  Track as PrismaTrack,
  Album as PrismaAlbum,
  Artist as PrismaArtist,
} from "@prisma/client";
import { Track, TrackEntity, Artist } from "../../domain/entities";
import { mapPrismaArtistToEntity } from "./artist.mapper";

/**
 * Prisma Track with relations
 */
type PrismaTrackWithRelations = PrismaTrack & {
  album?: PrismaAlbum | null;
  artists?: Array<{
    artist: PrismaArtist;
  }>;
};

/**
 * Map Prisma Track model to domain Track entity
 */
export function mapPrismaTrackToEntity(
  prismaTrack: PrismaTrackWithRelations,
): Track {
  const album = prismaTrack.album
    ? {
        id: prismaTrack.album.id,
        title: prismaTrack.album.title,
      }
    : null;

  const artists: Artist[] = (prismaTrack.artists || []).map((trackArtist) =>
    mapPrismaArtistToEntity(trackArtist.artist),
  );

  return TrackEntity.create({
    id: prismaTrack.id,
    title: prismaTrack.title,
    coverUrl: prismaTrack.cover_url || prismaTrack.album?.cover_url || null,
    trackUrl: prismaTrack.track_url,
    duration: prismaTrack.duration,
    album,
    artists,
  });
}

/**
 * Map array of Prisma Tracks to domain entities
 */
export function mapPrismaTracksToEntities(
  prismaTracks: PrismaTrackWithRelations[],
): Track[] {
  return prismaTracks.map(mapPrismaTrackToEntity);
}
