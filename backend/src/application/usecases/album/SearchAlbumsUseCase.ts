import { injectable, inject } from "inversify";
import { TYPES } from "../../../di/types";
import { IAlbumRepository } from "../../../domain/repositories";
import { Album } from "../../../domain/entities";

@injectable()
export class SearchAlbumsUseCase {
  private readonly DEFAULT_LIMIT = 20;

  constructor(
    @inject(TYPES.AlbumRepository)
    private albumRepository: IAlbumRepository,
  ) {}

  async execute(query: string, limit?: number): Promise<Album[]> {
    if (!query || query.trim().length === 0) {
      return [];
    }

    const searchLimit = limit || this.DEFAULT_LIMIT;
    return this.albumRepository.search(query, searchLimit);
  }
}
