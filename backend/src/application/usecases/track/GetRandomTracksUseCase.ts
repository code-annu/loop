import { inject, injectable } from "inversify";
import { TYPES } from "../../../di/types";
import { ITrackRepository } from "../../../domain/repositories";
import {
  GetRandomTracksInputDTO,
  GetRandomTracksOutputDTO,
} from "../../dtos/track.dto";

/**
 * Use case for getting random tracks
 */
@injectable()
export class GetRandomTracksUseCase {
  private readonly DEFAULT_LIMIT = 15;

  constructor(
    @inject(TYPES.TrackRepository)
    private readonly trackRepository: ITrackRepository,
  ) {}

  async execute(
    input: GetRandomTracksInputDTO,
  ): Promise<GetRandomTracksOutputDTO> {
    const limit = input.limit || this.DEFAULT_LIMIT;
    const tracks = await this.trackRepository.findRandom(limit);

    return {
      tracks: tracks.map((track) => ({
        id: track.id,
        title: track.title,
        cover_url: track.coverUrl,
        track_url: track.trackUrl,
        album: track.album
          ? {
              id: track.album.id,
              title: track.album.title,
            }
          : null,
        artists: (track.artists || []).map((artist) => ({
          id: artist.id,
          name: artist.name,
          profile_url: artist.profileUrl,
        })),
        duration: track.duration,
      })),
    };
  }
}
