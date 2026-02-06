import { Request, Response, NextFunction } from "express";
import { inject, injectable } from "inversify";
import { TYPES } from "../../di/types";
import {
  GetAlbumByIdUseCase,
  GetRandomAlbumsUseCase,
  SearchAlbumsUseCase,
} from "../../application/usecases/album";
import { successResponse } from "../responses";
import {
  albumIdParamSchema,
  randomAlbumsQuerySchema,
  searchAlbumsQuerySchema,
} from "../schemas";
import { ValidationError } from "../../domain/errors";

/**
 * Album Controller
 * Handles HTTP requests for album endpoints
 */
@injectable()
export class AlbumController {
  constructor(
    @inject(TYPES.GetAlbumByIdUseCase)
    private readonly getAlbumByIdUseCase: GetAlbumByIdUseCase,
    @inject(TYPES.GetRandomAlbumsUseCase)
    private readonly getRandomAlbumsUseCase: GetRandomAlbumsUseCase,
    @inject(TYPES.SearchAlbumsUseCase)
    private readonly searchAlbumsUseCase: SearchAlbumsUseCase,
  ) {}

  /**
   * GET /albums/:id
   * Get a single album by ID
   */
  async getById(
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> {
    try {
      const parseResult = albumIdParamSchema.safeParse(req.params);

      if (!parseResult.success) {
        throw new ValidationError(parseResult.error.errors[0].message);
      }

      const album = await this.getAlbumByIdUseCase.execute({
        id: parseResult.data.id,
      });
      res.status(200).json(successResponse(album));
    } catch (error) {
      next(error);
    }
  }

  /**
   * GET /albums/random
   * Get random albums
   */
  async getRandom(
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> {
    try {
      const parseResult = randomAlbumsQuerySchema.safeParse(req.query);

      if (!parseResult.success) {
        throw new ValidationError(parseResult.error.errors[0].message);
      }

      const result = await this.getRandomAlbumsUseCase.execute({
        limit: parseResult.data.limit,
      });
      res.status(200).json(successResponse(result.albums));
    } catch (error) {
      next(error);
    }
  }

  /**
   * GET /albums/search
   * Search albums
   */
  async search(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const parseResult = searchAlbumsQuerySchema.safeParse(req.query);

      if (!parseResult.success) {
        throw new ValidationError(parseResult.error.errors[0].message);
      }

      const albums = await this.searchAlbumsUseCase.execute(
        parseResult.data.q,
        parseResult.data.limit,
      );
      res.status(200).json(successResponse(albums));
    } catch (error) {
      next(error);
    }
  }
}
