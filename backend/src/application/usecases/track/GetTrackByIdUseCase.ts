import { inject, injectable } from "inversify";
import { TYPES } from "../../../di/types";
import { ITrackRepository } from "../../../domain/repositories";
import { NotFoundError } from "../../../domain/errors";
import { GetTrackByIdInputDTO, TrackOutputDTO } from "../../dtos/track.dto";

/**
 * Use case for getting a track by ID
 */
@injectable()
export class GetTrackByIdUseCase {
  constructor(
    @inject(TYPES.TrackRepository)
    private readonly trackRepository: ITrackRepository,
  ) {}

  async execute(input: GetTrackByIdInputDTO): Promise<TrackOutputDTO> {
    const track = await this.trackRepository.findById(input.id);

    if (!track) {
      throw new NotFoundError(`Track with id ${input.id} not found`);
    }

    return {
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
    };
  }
}
