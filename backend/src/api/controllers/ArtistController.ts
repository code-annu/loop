import { Request, Response, NextFunction } from "express";
import { inject, injectable } from "inversify";
import { TYPES } from "../../di/types";
import {
  GetArtistByIdUseCase,
  GetRandomArtistsUseCase,
} from "../../application/usecases/artist";
import { successResponse } from "../responses";
import { artistIdParamSchema, randomArtistsQuerySchema } from "../schemas";
import { ValidationError } from "../../domain/errors";

/**
 * Artist Controller
 * Handles HTTP requests for artist endpoints
 */
@injectable()
export class ArtistController {
  constructor(
    @inject(TYPES.GetArtistByIdUseCase)
    private readonly getArtistByIdUseCase: GetArtistByIdUseCase,
    @inject(TYPES.GetRandomArtistsUseCase)
    private readonly getRandomArtistsUseCase: GetRandomArtistsUseCase,
  ) {}

  /**
   * GET /artists/:id
   * Get a single artist by ID
   */
  async getById(
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> {
    try {
      const parseResult = artistIdParamSchema.safeParse(req.params);

      if (!parseResult.success) {
        throw new ValidationError(parseResult.error.errors[0].message);
      }

      const artist = await this.getArtistByIdUseCase.execute({
        id: parseResult.data.id,
      });
      res.status(200).json(successResponse(artist));
    } catch (error) {
      next(error);
    }
  }

  /**
   * GET /artists/random
   * Get random artists
   */
  async getRandom(
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> {
    try {
      const parseResult = randomArtistsQuerySchema.safeParse(req.query);

      if (!parseResult.success) {
        throw new ValidationError(parseResult.error.errors[0].message);
      }

      const result = await this.getRandomArtistsUseCase.execute({
        limit: parseResult.data.limit,
      });
      res.status(200).json(successResponse(result.artists));
    } catch (error) {
      next(error);
    }
  }
}
