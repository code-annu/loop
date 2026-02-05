import { inject, injectable } from "inversify";
import { TYPES } from "../../../di/types";
import { IArtistRepository } from "../../../domain/repositories";
import { NotFoundError } from "../../../domain/errors";
import { GetArtistByIdInputDTO, ArtistOutputDTO } from "../../dtos/artist.dto";

/**
 * Use case for getting an artist by ID
 */
@injectable()
export class GetArtistByIdUseCase {
  constructor(
    @inject(TYPES.ArtistRepository)
    private readonly artistRepository: IArtistRepository,
  ) {}

  async execute(input: GetArtistByIdInputDTO): Promise<ArtistOutputDTO> {
    const artist = await this.artistRepository.findById(input.id);

    if (!artist) {
      throw new NotFoundError(`Artist with id ${input.id} not found`);
    }

    return {
      id: artist.id,
      name: artist.name,
      profile_url: artist.profileUrl,
    };
  }
}
