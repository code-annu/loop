import { injectable, inject } from "inversify";
import { TYPES } from "../../../di/types";
import { ITrackRepository } from "../../../domain/repositories";
import { Track } from "../../../domain/entities";

@injectable()
export class SearchTracksUseCase {
  private readonly DEFAULT_LIMIT = 20;

  constructor(
    @inject(TYPES.TrackRepository)
    private trackRepository: ITrackRepository,
  ) {}

  async execute(query: string, limit?: number): Promise<Track[]> {
    if (!query || query.trim().length === 0) {
      return [];
    }

    const searchLimit = limit || this.DEFAULT_LIMIT;
    return this.trackRepository.search(query, searchLimit);
  }
}
