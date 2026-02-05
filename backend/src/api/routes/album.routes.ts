import { Router } from "express";
import { container, TYPES } from "../../di";
import { AlbumController } from "../controllers/AlbumController";

const router = Router();
const albumController = container.get<AlbumController>(TYPES.AlbumController);

/**
 * GET /albums/random
 * Get random albums
 */
router.get("/random", (req, res, next) =>
  albumController.getRandom(req, res, next),
);

/**
 * GET /albums/:id
 * Get a single album by ID
 */
router.get("/:id", (req, res, next) => albumController.getById(req, res, next));

export default router;
