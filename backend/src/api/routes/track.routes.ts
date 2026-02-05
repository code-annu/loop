import { Router } from "express";
import { container, TYPES } from "../../di";
import { TrackController } from "../controllers/TrackController";

const router = Router();
const trackController = container.get<TrackController>(TYPES.TrackController);

/**
 * GET /tracks/random
 * Get random tracks
 */
router.get("/random", (req, res, next) =>
  trackController.getRandom(req, res, next),
);

/**
 * GET /tracks/:id
 * Get a single track by ID
 */
router.get("/:id", (req, res, next) => trackController.getById(req, res, next));

export default router;
