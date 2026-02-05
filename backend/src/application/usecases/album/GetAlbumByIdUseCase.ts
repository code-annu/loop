import { inject, injectable } from "inversify";
import { TYPES } from "../../../di/types";
import { IAlbumRepository } from "../../../domain/repositories";
import { NotFoundError } from "../../../domain/errors";
import { GetAlbumByIdInputDTO, AlbumOutputDTO } from "../../dtos/album.dto";

/**
 * Use case for getting an album by ID
 */
@injectable()
export class GetAlbumByIdUseCase {
  constructor(
    @inject(TYPES.AlbumRepository)
    private readonly albumRepository: IAlbumRepository,
  ) {}

  async execute(input: GetAlbumByIdInputDTO): Promise<AlbumOutputDTO> {
    const album = await this.albumRepository.findById(input.id);

    if (!album) {
      throw new NotFoundError(`Album with id ${input.id} not found`);
    }

    return {
      id: album.id,
      title: album.title,
      cover_url: album.coverUrl,
      tracks: (album.tracks || []).map((track) => ({
        id: track.id,
        title: track.title,
        cover_url: track.coverUrl,
        track_url: track.trackUrl,
        duration: track.duration,
      })),
      artists: (album.artists || []).map((artist) => ({
        id: artist.id,
        name: artist.name,
        profile_url: artist.profileUrl,
      })),
    };
  }
}
