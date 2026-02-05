import { inject, injectable } from "inversify";
import { TYPES } from "../../../di/types";
import { IAlbumRepository } from "../../../domain/repositories";
import {
  GetRandomAlbumsInputDTO,
  GetRandomAlbumsOutputDTO,
} from "../../dtos/album.dto";

/**
 * Use case for getting random albums
 */
@injectable()
export class GetRandomAlbumsUseCase {
  private readonly DEFAULT_LIMIT = 10;

  constructor(
    @inject(TYPES.AlbumRepository)
    private readonly albumRepository: IAlbumRepository,
  ) {}

  async execute(
    input: GetRandomAlbumsInputDTO,
  ): Promise<GetRandomAlbumsOutputDTO> {
    const limit = input.limit || this.DEFAULT_LIMIT;
    const albums = await this.albumRepository.findRandom(limit);

    return {
      albums: albums.map((album) => ({
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
      })),
    };
  }
}
