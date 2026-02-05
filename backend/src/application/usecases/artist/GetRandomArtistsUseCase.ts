import { inject, injectable } from "inversify";
import { TYPES } from "../../../di/types";
import { IArtistRepository } from "../../../domain/repositories";
import {
  GetRandomArtistsInputDTO,
  GetRandomArtistsOutputDTO,
} from "../../dtos/artist.dto";

/**
 * Use case for getting random artists
 */
@injectable()
export class GetRandomArtistsUseCase {
  private readonly DEFAULT_LIMIT = 10;

  constructor(
    @inject(TYPES.ArtistRepository)
    private readonly artistRepository: IArtistRepository,
  ) {}

  async execute(
    input: GetRandomArtistsInputDTO,
  ): Promise<GetRandomArtistsOutputDTO> {
    const limit = input.limit || this.DEFAULT_LIMIT;
    const artists = await this.artistRepository.findRandom(limit);

    return {
      artists: artists.map((artist) => ({
        id: artist.id,
        name: artist.name,
        profile_url: artist.profileUrl,
      })),
    };
  }
}
