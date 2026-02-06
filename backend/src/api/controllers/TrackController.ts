import { Request, Response, NextFunction } from "express";
import { inject, injectable } from "inversify";
import { TYPES } from "../../di/types";
import {
  GetTrackByIdUseCase,
  GetRandomTracksUseCase,
  SearchTracksUseCase,
} from "../../application/usecases/track";
import { successResponse } from "../responses";
import {
  trackIdParamSchema,
  randomTracksQuerySchema,
  searchTracksQuerySchema,
} from "../schemas";
import { ValidationError } from "../../domain/errors";

/**
 * Track Controller
 * Handles HTTP requests for track endpoints
 */
@injectable()
export class TrackController {
  constructor(
    @inject(TYPES.GetTrackByIdUseCase)
    private readonly getTrackByIdUseCase: GetTrackByIdUseCase,
    @inject(TYPES.GetRandomTracksUseCase)
    private readonly getRandomTracksUseCase: GetRandomTracksUseCase,
    @inject(TYPES.SearchTracksUseCase)
    private readonly searchTracksUseCase: SearchTracksUseCase,
  ) {}

  /**
   * GET /tracks/:id
   * Get a single track by ID
   */
  async getById(
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> {
    try {
      const parseResult = trackIdParamSchema.safeParse(req.params);

      if (!parseResult.success) {
        throw new ValidationError(parseResult.error.errors[0].message);
      }

      const track = await this.getTrackByIdUseCase.execute({
        id: parseResult.data.id,
      });
      res.status(200).json(successResponse(track));
    } catch (error) {
      next(error);
    }
  }

  /**
   * GET /tracks/random
   * Get random tracks
   */
  async getRandom(
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> {
    try {
      const parseResult = randomTracksQuerySchema.safeParse(req.query);

      if (!parseResult.success) {
        throw new ValidationError(parseResult.error.errors[0].message);
      }

      const result = await this.getRandomTracksUseCase.execute({
        limit: parseResult.data.limit,
      });
      res.status(200).json(successResponse(result.tracks));
    } catch (error) {
      next(error);
    }
  }

  /**
   * GET /tracks/search
   * Search tracks
   */
  async search(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const parseResult = searchTracksQuerySchema.safeParse(req.query);

      if (!parseResult.success) {
        throw new ValidationError(parseResult.error.errors[0].message);
      }

      const tracks = await this.searchTracksUseCase.execute(
        parseResult.data.q,
        parseResult.data.limit,
      );
      res.status(200).json(successResponse(tracks));
    } catch (error) {
      next(error);
    }
  }
}
