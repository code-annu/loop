import { Router } from "express";
import { container, TYPES } from "../../di";
import { ArtistController } from "../controllers/ArtistController";

const router = Router();
const artistController = container.get<ArtistController>(
  TYPES.ArtistController,
);

/**
 * GET /artists/random
 * Get random artists
 */
router.get("/random", (req, res, next) =>
  artistController.getRandom(req, res, next),
);

/**
 * GET /artists/:id
 * Get a single artist by ID
 */
router.get("/:id", (req, res, next) =>
  artistController.getById(req, res, next),
);

export default router;
